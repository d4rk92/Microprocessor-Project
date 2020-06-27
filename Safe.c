/* 
   Digital Safe Lock
   Mohammad Solki 
   Student ID: 9411412054
   Email: d4rk@cyberservices.com
*/

#include <mega32.h>
#include <alcd.h>
#include <delay.h>
#include <string.h>
#include <stdio.h>

// Config Initial Valuse
#define DEFULT_PASS "1234"
#define LOCKDOWN_TIME 10
#define COUNTDOWN_TIME 15

flash unsigned char Key_Pattern[4]={0xFE, 0xFD, 0xFB, 0xF7};
flash unsigned char key_number[4][3] ={'*', '0', '#',
                              '7', '8', '9', 
                              '4', '5', '6',
                              '1', '2', '3'};
                                           
unsigned char pass[16] = DEFULT_PASS;  
unsigned char pass_temp[16];
unsigned char new_pass[16];
unsigned char msg[32];
unsigned char sync = 0;
int lockdown = LOCKDOWN_TIME;
int countdown = COUNTDOWN_TIME;
int attempts = 0;
int status = 4;

void clear_one(char *);
void my_clear(char *);
void change_pass(char []);
void display_msg();
void set_msg(char *);
void display_lockdown(void);

// Timer 0 for lockdown                   
interrupt [TIM0_COMP] void timer0_comp_isr(void){
    if (status != 100 && status != 0) return; // just make sure that we are in lockdown or countdown mode
      
    if (status == 100){
        sync = 1;
        lockdown--;
        
        // exit from lockdown when time is zero
        if (lockdown == 0) {
            lockdown = LOCKDOWN_TIME + LOCKDOWN_TIME * (attempts / 3);
            TIMSK = (0<<OCIE0); // turn off timer 0 interrupt flag 
            status = 0;
        }
    } else if (status == 0){
        countdown--;
        
        // exit from countdown when time is zero
        if (countdown == 0) {
            countdown = COUNTDOWN_TIME;
            TIMSK = (0<<OCIE0); // turn off timer 0 interrupt flag
            status = 5;
        }
    }
}


// Interrupt 0 for back button
interrupt [EXT_INT0] void ext_int0_isr(void){

    switch (status){
        case -1:
            my_clear(pass_temp);
            status = 0;
            break;
        case -2:
            status = 1;
            break;
        case -3:
            my_clear(pass_temp);
            my_clear(new_pass);
            status = 2; 
            break;
            
        case 1:
            my_clear(pass_temp);
            status = 0;
            break;
        case 2:
            status = 1;
            break;
        case 3:
            my_clear(pass_temp);
            my_clear(new_pass);
            status = 2;
            break;
    }

}

// Interrupt 1 for PIR sensor
interrupt [EXT_INT1] void ext_int1_isr(void){
    if (status == 5) return ;
    
    if (PIND.3 == 1) {
        TIMSK = (1<<OCIE0);
        status = 0;
    } else {
        my_clear(pass_temp);
        my_clear(new_pass);
        TIMSK = (0<<OCIE0);
        countdown = COUNTDOWN_TIME;
        status = 4;
    }    

}

// Interrupt 2 for key pad                              
interrupt [EXT_INT2] void ext_int2_isr(void){        
   char row, column = -1, temp;
   char message[32];
       
   for (row=0; row<4; row++){
       PORTA = Key_Pattern[row];
      
       temp = PINA;
       temp = temp & 0xF0; 
             
       if (temp != 0xF0){
     
           if (PINA.5 == 0)
              column=0;      
           if (PINA.6 == 0)
              column=1;      
           if (PINA.7 == 0)
              column=2;  

           if (column != -1){                            
               break;
           }     
       }    
    }
    
   switch (status){
       case -1:
            if (key_number[row][column] == '#' || key_number[row][column] == '*'){
                 my_clear(pass_temp);
                 status = 0;                   
            } 
       case -2:                                  
            if (key_number[row][column] == '#' || key_number[row][column] == '*'){
                status = 1;                    
            }
       case -3:                   
             if (key_number[row][column] == '#' || key_number[row][column] == '*'){
                my_clear(pass_temp);
                my_clear(new_pass);                                                
                status = 2;
            } 
       case 0:
            if (key_number[row][column] == '*'){
                // If password matched:
                if (strcmp(pass,pass_temp) == 0){
                    attempts = 0;
                    TIMSK = (0<<OCIE0);
                    countdown = COUNTDOWN_TIME;
                    status = 1;
                } else {
                    attempts++;
                    if (attempts % 3 == 0){
                        TIMSK = (1<<OCIE0);
                        status = 100;
                    } else {
                        snprintf(message,32,"Wrong Pass!     %d Attempts!",3 - attempts);
                        set_msg(message);
                        status = -1;
                    }
                }      
            } else if (key_number[row][column] == '#'){
                clear_one(pass_temp);        
            } else {
                pass_temp[strlen(pass_temp)] = key_number[row][column];        
            }
            break;
      case 1:
            if (key_number[row][column] == '*'){
                my_clear(pass_temp);
                my_clear(new_pass);             
                status = 2;
            }
            break;
      case 2:
            if (key_number[row][column] == '*'){
               status = 3;         
            } else if (key_number[row][column] == '#'){
                clear_one(pass_temp);        
            } else {
                pass_temp[strlen(pass_temp)] = key_number[row][column]; 
            }
            break;
      case 3:
            if (key_number[row][column] == '*'){
                if (strcmp(new_pass,pass_temp) == 0){
                    set_msg("Pass Changed."); 
                    change_pass(new_pass);           
                    status = -2;
                } else {
                    set_msg("Not Match!      Try Again!");
                    status = -3;
                }         
            } else if (key_number[row][column] == '#'){
                clear_one(new_pass);                        
            } else {
                new_pass[strlen(new_pass)] = key_number[row][column];         
            }
            break;
       case 5:
           if (key_number[row][column] == '*'){
                if (strcmp(pass,pass_temp) == 0){
                    status = 1;
                } else {
                    status = -4;
                    set_msg("Wrong Pass!     Try Again!");         
                }      
            } else if (key_number[row][column] == '#'){
                clear_one(pass_temp);        
            } else {
                pass_temp[strlen(pass_temp)] = key_number[row][column];        
            }
            break;
    } 
 
    PORTA = 0xF0;
}

void main(void) {

    // Keypad
    DDRA = 0x0F;
    PORTA = 0xF0;
    
    // LCD
    DDRC = 0x00;
    PORTC = 0x00;
    
    // Push button
    DDRD = 0x00; // input 
    PORTD.2 = 1; // pull-up for button
    
    // Interrupts
    GICR |= (1<<INT1) | (1<<INT0) | (1<<INT2);
    MCUCR = (0<<ISC11) | (1<<ISC10) | (1<<ISC01) | (0<<ISC00); // falling edge for int 0 & any change for int 1
    MCUCSR = (0<<ISC2); // falling edge for int 2
    GIFR = (1<<INTF1) | (1<<INTF0) | (1<<INTF2); 
    
    // Timers
    TCCR0 = (0<<WGM00) | (0<<COM01) | (0<<COM00) | (1<<WGM01) | (1<<CS02) | (1<<CS01) | (1<<CS00);
    TCNT0 = 0x00;
    OCR0 = 0x3B;
    TIMSK = 0x00; // turn off all timers flags

    lcd_init(16);
    #asm("sei")
    while (1){
        
        if (status == 100){
            display_lockdown();
            continue;    
        }
      
        lcd_clear();
        switch (status){
            case -1:
            case -2:
            case -3:
            case -4:
                 display_msg();
                 break;
            case 0:
                lcd_puts("Enter Password:");
                lcd_gotoxy(0,1);
                lcd_puts(pass_temp);  
                break;
            case 1:
              lcd_puts("Safe Unlocked");  
              break;
            case 2:
              lcd_puts("Enter New Pass:");
              lcd_gotoxy(0,1);
              lcd_puts(pass_temp);  
              break;
            case 3:
              lcd_puts("Pass Again:");
              lcd_gotoxy(0,1);
              lcd_puts(new_pass);  
              break;
            case 4:
                lcd_puts("Safe is Locked.");
                break;
            case 5:
                lcd_puts("ALERT!!!"); 
                lcd_gotoxy(0,1);
                lcd_puts(pass_temp); 
                break;                         
        }
        delay_ms(500);
    }
}


void clear_one(char *arr){
    arr[strlen(arr) - 1] = '';
}

void my_clear(char *arr){
    int i;
    for(i = 0;i<16;i++)
        arr[i] = '';    
}

void change_pass(char new_pass[]){
    int i;
    my_clear(pass);
    for(i=0;i<16;i++)
        pass[i] = new_pass[i];
}

void display_msg(){
    lcd_puts(msg);
    delay_ms(1000);
    
    switch (status){
        case -1:
            my_clear(pass_temp);
            status = 0;
            break;
        case -2:
            status = 1;
            break;
        case -3:
            my_clear(pass_temp);
            my_clear(new_pass); 
            status = 2;
            break; 
        case -4:
            my_clear(pass_temp);
            status = 5;
            break;            
    }
}


void set_msg(char *message){
    strncpy(msg, message, 32);
} 

void display_lockdown(){
    int min,sec;
    unsigned char time[16];
    if (!sync) return ;
    min = lockdown / 60;
    sec = lockdown % 60;
    
    lcd_clear();
    lcd_puts("Lock Down for:");
    lcd_gotoxy(0,1);           
    snprintf(time, 9, "%02d:%02d", min, sec);
    lcd_puts(time);
    sync = 0;
}      