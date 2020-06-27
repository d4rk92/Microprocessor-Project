
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _sync=R5
	.DEF _lockdown=R6
	.DEF _lockdown_msb=R7
	.DEF _countdown=R8
	.DEF _countdown_msb=R9
	.DEF _attempts=R10
	.DEF _attempts_msb=R11
	.DEF _status=R12
	.DEF _status_msb=R13
	.DEF __lcd_x=R4

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_comp_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_Key_Pattern:
	.DB  0xFE,0xFD,0xFB,0xF7
_key_number:
	.DB  0x2A,0x30,0x23,0x37,0x38,0x39,0x34,0x35
	.DB  0x36,0x31,0x32,0x33
_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0xA,0x0,0xF
	.DB  0x0,0x0,0x0,0x4
	.DB  0x0

_0x3:
	.DB  0x31,0x32,0x33,0x34
_0x0:
	.DB  0x57,0x72,0x6F,0x6E,0x67,0x20,0x50,0x61
	.DB  0x73,0x73,0x21,0x20,0x20,0x20,0x20,0x20
	.DB  0x25,0x64,0x20,0x41,0x74,0x74,0x65,0x6D
	.DB  0x70,0x74,0x73,0x21,0x0,0x50,0x61,0x73
	.DB  0x73,0x20,0x43,0x68,0x61,0x6E,0x67,0x65
	.DB  0x64,0x2E,0x0,0x4E,0x6F,0x74,0x20,0x4D
	.DB  0x61,0x74,0x63,0x68,0x21,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x54,0x72,0x79,0x20,0x41
	.DB  0x67,0x61,0x69,0x6E,0x21,0x0,0x57,0x72
	.DB  0x6F,0x6E,0x67,0x20,0x50,0x61,0x73,0x73
	.DB  0x21,0x20,0x20,0x20,0x20,0x20,0x54,0x72
	.DB  0x79,0x20,0x41,0x67,0x61,0x69,0x6E,0x21
	.DB  0x0,0x45,0x6E,0x74,0x65,0x72,0x20,0x50
	.DB  0x61,0x73,0x73,0x77,0x6F,0x72,0x64,0x3A
	.DB  0x0,0x53,0x61,0x66,0x65,0x20,0x55,0x6E
	.DB  0x6C,0x6F,0x63,0x6B,0x65,0x64,0x0,0x45
	.DB  0x6E,0x74,0x65,0x72,0x20,0x4E,0x65,0x77
	.DB  0x20,0x50,0x61,0x73,0x73,0x3A,0x0,0x50
	.DB  0x61,0x73,0x73,0x20,0x41,0x67,0x61,0x69
	.DB  0x6E,0x3A,0x0,0x53,0x61,0x66,0x65,0x20
	.DB  0x69,0x73,0x20,0x4C,0x6F,0x63,0x6B,0x65
	.DB  0x64,0x2E,0x0,0x41,0x4C,0x45,0x52,0x54
	.DB  0x21,0x21,0x21,0x0,0x4C,0x6F,0x63,0x6B
	.DB  0x20,0x44,0x6F,0x77,0x6E,0x20,0x66,0x6F
	.DB  0x72,0x3A,0x0,0x25,0x30,0x32,0x64,0x3A
	.DB  0x25,0x30,0x32,0x64,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x09
	.DW  0x05
	.DW  __REG_VARS*2

	.DW  0x04
	.DW  _pass
	.DW  _0x3*2

	.DW  0x0E
	.DW  _0x45
	.DW  _0x0*2+29

	.DW  0x1B
	.DW  _0x45+14
	.DW  _0x0*2+43

	.DW  0x1B
	.DW  _0x45+41
	.DW  _0x0*2+70

	.DW  0x10
	.DW  _0x62
	.DW  _0x0*2+97

	.DW  0x0E
	.DW  _0x62+16
	.DW  _0x0*2+113

	.DW  0x10
	.DW  _0x62+30
	.DW  _0x0*2+127

	.DW  0x0C
	.DW  _0x62+46
	.DW  _0x0*2+143

	.DW  0x10
	.DW  _0x62+58
	.DW  _0x0*2+155

	.DW  0x09
	.DW  _0x62+74
	.DW  _0x0*2+171

	.DW  0x0F
	.DW  _0x77
	.DW  _0x0*2+180

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*
;   Digital Safe Lock
;   Mohammad Solki
;   Student ID: 9411412054
;   Email: d4rk@cyberservices.com
;*/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <delay.h>
;#include <string.h>
;#include <stdio.h>
;
;// Config Initial Valuse
;#define DEFULT_PASS "1234"
;#define LOCKDOWN_TIME 10
;#define COUNTDOWN_TIME 15
;
;flash unsigned char Key_Pattern[4]={0xFE, 0xFD, 0xFB, 0xF7};
;flash unsigned char key_number[4][3] ={'*', '0', '#',
;                              '7', '8', '9',
;                              '4', '5', '6',
;                              '1', '2', '3'};
;
;unsigned char pass[16] = DEFULT_PASS;

	.DSEG
;unsigned char pass_temp[16];
;unsigned char new_pass[16];
;unsigned char msg[32];
;unsigned char sync = 0;
;int lockdown = LOCKDOWN_TIME;
;int countdown = COUNTDOWN_TIME;
;int attempts = 0;
;int status = 4;
;
;void clear_one(char *);
;void my_clear(char *);
;void change_pass(char []);
;void display_msg();
;void set_msg(char *);
;void display_lockdown(void);
;
;// Timer 0 for lockdown
;interrupt [TIM0_COMP] void timer0_comp_isr(void){
; 0000 002B interrupt [11] void timer0_comp_isr(void){

	.CSEG
_timer0_comp_isr:
; .FSTART _timer0_comp_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 002C     if (status != 100 && status != 0) return; // just make sure that we are in lockdown or countdown mode
	CALL SUBOPT_0x0
	BREQ _0x5
	CLR  R0
	CP   R0,R12
	CPC  R0,R13
	BRNE _0x6
_0x5:
	RJMP _0x4
_0x6:
	RJMP _0x80
; 0000 002D 
; 0000 002E     if (status == 100){
_0x4:
	CALL SUBOPT_0x0
	BRNE _0x7
; 0000 002F         sync = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0030         lockdown--;
	MOVW R30,R6
	SBIW R30,1
	MOVW R6,R30
; 0000 0031 
; 0000 0032         // exit from lockdown when time is zero
; 0000 0033         if (lockdown == 0) {
	MOV  R0,R6
	OR   R0,R7
	BRNE _0x8
; 0000 0034             lockdown = LOCKDOWN_TIME + LOCKDOWN_TIME * (attempts / 3);
	MOVW R26,R10
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __DIVW21
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	ADIW R30,10
	MOVW R6,R30
; 0000 0035             TIMSK = (0<<OCIE0); // turn off timer 0 interrupt flag
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 0036             status = 0;
	CLR  R12
	CLR  R13
; 0000 0037         }
; 0000 0038     } else if (status == 0){
_0x8:
	RJMP _0x9
_0x7:
	MOV  R0,R12
	OR   R0,R13
	BRNE _0xA
; 0000 0039         countdown--;
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
; 0000 003A 
; 0000 003B         // exit from countdown when time is zero
; 0000 003C         if (countdown == 0) {
	MOV  R0,R8
	OR   R0,R9
	BRNE _0xB
; 0000 003D             countdown = COUNTDOWN_TIME;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	MOVW R8,R30
; 0000 003E             TIMSK = (0<<OCIE0); // turn off timer 0 interrupt flag
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 003F             status = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	MOVW R12,R30
; 0000 0040         }
; 0000 0041     }
_0xB:
; 0000 0042 }
_0xA:
_0x9:
_0x80:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;// Interrupt 0 for back button
;interrupt [EXT_INT0] void ext_int0_isr(void){
; 0000 0046 interrupt [2] void ext_int0_isr(void){
_ext_int0_isr:
; .FSTART _ext_int0_isr
	CALL SUBOPT_0x1
; 0000 0047 
; 0000 0048     switch (status){
	CALL SUBOPT_0x2
; 0000 0049         case -1:
	BRNE _0xF
; 0000 004A             my_clear(pass_temp);
	CALL SUBOPT_0x3
; 0000 004B             status = 0;
; 0000 004C             break;
	RJMP _0xE
; 0000 004D         case -2:
_0xF:
	CPI  R30,LOW(0xFFFFFFFE)
	LDI  R26,HIGH(0xFFFFFFFE)
	CPC  R31,R26
	BRNE _0x10
; 0000 004E             status = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x78
; 0000 004F             break;
; 0000 0050         case -3:
_0x10:
	CPI  R30,LOW(0xFFFFFFFD)
	LDI  R26,HIGH(0xFFFFFFFD)
	CPC  R31,R26
	BREQ _0x79
; 0000 0051             my_clear(pass_temp);
; 0000 0052             my_clear(new_pass);
; 0000 0053             status = 2;
; 0000 0054             break;
; 0000 0055 
; 0000 0056         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x12
; 0000 0057             my_clear(pass_temp);
	CALL SUBOPT_0x3
; 0000 0058             status = 0;
; 0000 0059             break;
	RJMP _0xE
; 0000 005A         case 2:
_0x12:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x13
; 0000 005B             status = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x78
; 0000 005C             break;
; 0000 005D         case 3:
_0x13:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xE
; 0000 005E             my_clear(pass_temp);
_0x79:
	LDI  R26,LOW(_pass_temp)
	LDI  R27,HIGH(_pass_temp)
	CALL SUBOPT_0x4
; 0000 005F             my_clear(new_pass);
; 0000 0060             status = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0x78:
	MOVW R12,R30
; 0000 0061             break;
; 0000 0062     }
_0xE:
; 0000 0063 
; 0000 0064 }
	RJMP _0x7F
; .FEND
;
;// Interrupt 1 for PIR sensor
;interrupt [EXT_INT1] void ext_int1_isr(void){
; 0000 0067 interrupt [3] void ext_int1_isr(void){
_ext_int1_isr:
; .FSTART _ext_int1_isr
	CALL SUBOPT_0x1
; 0000 0068     if (status == 5) return ;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x15
	RJMP _0x7F
; 0000 0069 
; 0000 006A     if (PIND.3 == 1) {
_0x15:
	SBIS 0x10,3
	RJMP _0x16
; 0000 006B         TIMSK = (1<<OCIE0);
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 006C         status = 0;
	CLR  R12
	CLR  R13
; 0000 006D     } else {
	RJMP _0x17
_0x16:
; 0000 006E         my_clear(pass_temp);
	CALL SUBOPT_0x5
; 0000 006F         my_clear(new_pass);
; 0000 0070         TIMSK = (0<<OCIE0);
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 0071         countdown = COUNTDOWN_TIME;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	MOVW R8,R30
; 0000 0072         status = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R12,R30
; 0000 0073     }
_0x17:
; 0000 0074 
; 0000 0075 }
	RJMP _0x7F
; .FEND
;
;// Interrupt 2 for key pad
;interrupt [EXT_INT2] void ext_int2_isr(void){
; 0000 0078 interrupt [4] void ext_int2_isr(void){
_ext_int2_isr:
; .FSTART _ext_int2_isr
	CALL SUBOPT_0x1
; 0000 0079    char row, column = -1, temp;
; 0000 007A    char message[32];
; 0000 007B 
; 0000 007C    for (row=0; row<4; row++){
	SBIW R28,32
	CALL __SAVELOCR4
;	row -> R17
;	column -> R16
;	temp -> R19
;	message -> Y+4
	LDI  R16,255
	LDI  R17,LOW(0)
_0x19:
	CPI  R17,4
	BRSH _0x1A
; 0000 007D        PORTA = Key_Pattern[row];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_Key_Pattern*2)
	SBCI R31,HIGH(-_Key_Pattern*2)
	LPM  R0,Z
	OUT  0x1B,R0
; 0000 007E 
; 0000 007F        temp = PINA;
	IN   R19,25
; 0000 0080        temp = temp & 0xF0;
	ANDI R19,LOW(240)
; 0000 0081 
; 0000 0082        if (temp != 0xF0){
	CPI  R19,240
	BREQ _0x1B
; 0000 0083 
; 0000 0084            if (PINA.5 == 0)
	SBIS 0x19,5
; 0000 0085               column=0;
	LDI  R16,LOW(0)
; 0000 0086            if (PINA.6 == 0)
	SBIS 0x19,6
; 0000 0087               column=1;
	LDI  R16,LOW(1)
; 0000 0088            if (PINA.7 == 0)
	SBIS 0x19,7
; 0000 0089               column=2;
	LDI  R16,LOW(2)
; 0000 008A 
; 0000 008B            if (column != -1){
	MOV  R26,R16
	LDI  R30,LOW(255)
	LDI  R27,0
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x1A
; 0000 008C                break;
; 0000 008D            }
; 0000 008E        }
; 0000 008F     }
_0x1B:
	SUBI R17,-1
	RJMP _0x19
_0x1A:
; 0000 0090 
; 0000 0091    switch (status){
	CALL SUBOPT_0x2
; 0000 0092        case -1:
	BRNE _0x23
; 0000 0093             if (key_number[row][column] == '#' || key_number[row][column] == '*'){
	CALL SUBOPT_0x6
	BREQ _0x25
	LPM  R26,Z
	CPI  R26,LOW(0x2A)
	BRNE _0x24
_0x25:
; 0000 0094                  my_clear(pass_temp);
	CALL SUBOPT_0x3
; 0000 0095                  status = 0;
; 0000 0096             }
; 0000 0097        case -2:
_0x24:
	RJMP _0x27
_0x23:
	CPI  R30,LOW(0xFFFFFFFE)
	LDI  R26,HIGH(0xFFFFFFFE)
	CPC  R31,R26
	BRNE _0x28
_0x27:
; 0000 0098             if (key_number[row][column] == '#' || key_number[row][column] == '*'){
	CALL SUBOPT_0x6
	BREQ _0x2A
	LPM  R26,Z
	CPI  R26,LOW(0x2A)
	BRNE _0x29
_0x2A:
; 0000 0099                 status = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 009A             }
; 0000 009B        case -3:
_0x29:
	RJMP _0x2C
_0x28:
	CPI  R30,LOW(0xFFFFFFFD)
	LDI  R26,HIGH(0xFFFFFFFD)
	CPC  R31,R26
	BRNE _0x2D
_0x2C:
; 0000 009C              if (key_number[row][column] == '#' || key_number[row][column] == '*'){
	CALL SUBOPT_0x6
	BREQ _0x2F
	LPM  R26,Z
	CPI  R26,LOW(0x2A)
	BRNE _0x2E
_0x2F:
; 0000 009D                 my_clear(pass_temp);
	CALL SUBOPT_0x5
; 0000 009E                 my_clear(new_pass);
; 0000 009F                 status = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R12,R30
; 0000 00A0             }
; 0000 00A1        case 0:
_0x2E:
	RJMP _0x31
_0x2D:
	SBIW R30,0
	BREQ PC+2
	RJMP _0x32
_0x31:
; 0000 00A2             if (key_number[row][column] == '*'){
	CALL SUBOPT_0x7
	LPM  R26,Z
	CPI  R26,LOW(0x2A)
	BRNE _0x33
; 0000 00A3                 // If password matched:
; 0000 00A4                 if (strcmp(pass,pass_temp) == 0){
	CALL SUBOPT_0x8
	BRNE _0x34
; 0000 00A5                     attempts = 0;
	CLR  R10
	CLR  R11
; 0000 00A6                     TIMSK = (0<<OCIE0);
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 00A7                     countdown = COUNTDOWN_TIME;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	MOVW R8,R30
; 0000 00A8                     status = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x7A
; 0000 00A9                 } else {
_0x34:
; 0000 00AA                     attempts++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 00AB                     if (attempts % 3 == 0){
	MOVW R26,R10
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __MODW21
	SBIW R30,0
	BRNE _0x36
; 0000 00AC                         TIMSK = (1<<OCIE0);
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 00AD                         status = 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP _0x7A
; 0000 00AE                     } else {
_0x36:
; 0000 00AF                         snprintf(message,32,"Wrong Pass!     %d Attempts!",3 - attempts);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	SUB  R30,R10
	SBC  R31,R11
	CALL SUBOPT_0x9
	LDI  R24,4
	CALL _snprintf
	ADIW R28,10
; 0000 00B0                         set_msg(message);
	MOVW R26,R28
	ADIW R26,4
	RCALL _set_msg
; 0000 00B1                         status = -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x7A:
	MOVW R12,R30
; 0000 00B2                     }
; 0000 00B3                 }
; 0000 00B4             } else if (key_number[row][column] == '#'){
	RJMP _0x38
_0x33:
	CALL SUBOPT_0x6
	BRNE _0x39
; 0000 00B5                 clear_one(pass_temp);
	CALL SUBOPT_0xA
; 0000 00B6             } else {
	RJMP _0x3A
_0x39:
; 0000 00B7                 pass_temp[strlen(pass_temp)] = key_number[row][column];
	CALL SUBOPT_0xB
	LPM  R30,Z
	MOVW R26,R22
	ST   X,R30
; 0000 00B8             }
_0x3A:
_0x38:
; 0000 00B9             break;
	RJMP _0x22
; 0000 00BA       case 1:
_0x32:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x3B
; 0000 00BB             if (key_number[row][column] == '*'){
	CALL SUBOPT_0x7
	LPM  R26,Z
	CPI  R26,LOW(0x2A)
	BRNE _0x3C
; 0000 00BC                 my_clear(pass_temp);
	CALL SUBOPT_0x5
; 0000 00BD                 my_clear(new_pass);
; 0000 00BE                 status = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R12,R30
; 0000 00BF             }
; 0000 00C0             break;
_0x3C:
	RJMP _0x22
; 0000 00C1       case 2:
_0x3B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3D
; 0000 00C2             if (key_number[row][column] == '*'){
	CALL SUBOPT_0x7
	LPM  R26,Z
	CPI  R26,LOW(0x2A)
	BRNE _0x3E
; 0000 00C3                status = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R12,R30
; 0000 00C4             } else if (key_number[row][column] == '#'){
	RJMP _0x3F
_0x3E:
	CALL SUBOPT_0x6
	BRNE _0x40
; 0000 00C5                 clear_one(pass_temp);
	CALL SUBOPT_0xA
; 0000 00C6             } else {
	RJMP _0x41
_0x40:
; 0000 00C7                 pass_temp[strlen(pass_temp)] = key_number[row][column];
	CALL SUBOPT_0xB
	LPM  R30,Z
	MOVW R26,R22
	ST   X,R30
; 0000 00C8             }
_0x41:
_0x3F:
; 0000 00C9             break;
	RJMP _0x22
; 0000 00CA       case 3:
_0x3D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x42
; 0000 00CB             if (key_number[row][column] == '*'){
	CALL SUBOPT_0x7
	LPM  R26,Z
	CPI  R26,LOW(0x2A)
	BRNE _0x43
; 0000 00CC                 if (strcmp(new_pass,pass_temp) == 0){
	LDI  R30,LOW(_new_pass)
	LDI  R31,HIGH(_new_pass)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_pass_temp)
	LDI  R27,HIGH(_pass_temp)
	CALL _strcmp
	CPI  R30,0
	BRNE _0x44
; 0000 00CD                     set_msg("Pass Changed.");
	__POINTW2MN _0x45,0
	RCALL _set_msg
; 0000 00CE                     change_pass(new_pass);
	LDI  R26,LOW(_new_pass)
	LDI  R27,HIGH(_new_pass)
	RCALL _change_pass
; 0000 00CF                     status = -2;
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x7B
; 0000 00D0                 } else {
_0x44:
; 0000 00D1                     set_msg("Not Match!      Try Again!");
	__POINTW2MN _0x45,14
	RCALL _set_msg
; 0000 00D2                     status = -3;
	LDI  R30,LOW(65533)
	LDI  R31,HIGH(65533)
_0x7B:
	MOVW R12,R30
; 0000 00D3                 }
; 0000 00D4             } else if (key_number[row][column] == '#'){
	RJMP _0x47
_0x43:
	CALL SUBOPT_0x6
	BRNE _0x48
; 0000 00D5                 clear_one(new_pass);
	LDI  R26,LOW(_new_pass)
	LDI  R27,HIGH(_new_pass)
	RCALL _clear_one
; 0000 00D6             } else {
	RJMP _0x49
_0x48:
; 0000 00D7                 new_pass[strlen(new_pass)] = key_number[row][column];
	LDI  R26,LOW(_new_pass)
	LDI  R27,HIGH(_new_pass)
	CALL _strlen
	SUBI R30,LOW(-_new_pass)
	SBCI R31,HIGH(-_new_pass)
	MOVW R22,R30
	CALL SUBOPT_0x7
	LPM  R30,Z
	MOVW R26,R22
	ST   X,R30
; 0000 00D8             }
_0x49:
_0x47:
; 0000 00D9             break;
	RJMP _0x22
; 0000 00DA        case 5:
_0x42:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x22
; 0000 00DB            if (key_number[row][column] == '*'){
	CALL SUBOPT_0x7
	LPM  R26,Z
	CPI  R26,LOW(0x2A)
	BRNE _0x4B
; 0000 00DC                 if (strcmp(pass,pass_temp) == 0){
	CALL SUBOPT_0x8
	BRNE _0x4C
; 0000 00DD                     status = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 00DE                 } else {
	RJMP _0x4D
_0x4C:
; 0000 00DF                     status = -4;
	LDI  R30,LOW(65532)
	LDI  R31,HIGH(65532)
	MOVW R12,R30
; 0000 00E0                     set_msg("Wrong Pass!     Try Again!");
	__POINTW2MN _0x45,41
	RCALL _set_msg
; 0000 00E1                 }
_0x4D:
; 0000 00E2             } else if (key_number[row][column] == '#'){
	RJMP _0x4E
_0x4B:
	CALL SUBOPT_0x6
	BRNE _0x4F
; 0000 00E3                 clear_one(pass_temp);
	CALL SUBOPT_0xA
; 0000 00E4             } else {
	RJMP _0x50
_0x4F:
; 0000 00E5                 pass_temp[strlen(pass_temp)] = key_number[row][column];
	CALL SUBOPT_0xB
	LPM  R30,Z
	MOVW R26,R22
	ST   X,R30
; 0000 00E6             }
_0x50:
_0x4E:
; 0000 00E7             break;
; 0000 00E8     }
_0x22:
; 0000 00E9 
; 0000 00EA     PORTA = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x1B,R30
; 0000 00EB }
	CALL __LOADLOCR4
	ADIW R28,36
_0x7F:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.DSEG
_0x45:
	.BYTE 0x44
;
;void main(void) {
; 0000 00ED void main(void) {

	.CSEG
_main:
; .FSTART _main
; 0000 00EE 
; 0000 00EF     // Keypad
; 0000 00F0     DDRA = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x1A,R30
; 0000 00F1     PORTA = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x1B,R30
; 0000 00F2 
; 0000 00F3     // LCD
; 0000 00F4     DDRC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 00F5     PORTC = 0x00;
	OUT  0x15,R30
; 0000 00F6 
; 0000 00F7     // Push button
; 0000 00F8     DDRD = 0x00; // input
	OUT  0x11,R30
; 0000 00F9     PORTD.2 = 1; // pull-up for button
	SBI  0x12,2
; 0000 00FA 
; 0000 00FB     // Interrupts
; 0000 00FC     GICR |= (1<<INT1) | (1<<INT0) | (1<<INT2);
	IN   R30,0x3B
	ORI  R30,LOW(0xE0)
	OUT  0x3B,R30
; 0000 00FD     MCUCR = (0<<ISC11) | (1<<ISC10) | (1<<ISC01) | (0<<ISC00); // falling edge for int 0 & any change for int 1
	LDI  R30,LOW(6)
	OUT  0x35,R30
; 0000 00FE     MCUCSR = (0<<ISC2); // falling edge for int 2
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 00FF     GIFR = (1<<INTF1) | (1<<INTF0) | (1<<INTF2);
	LDI  R30,LOW(224)
	OUT  0x3A,R30
; 0000 0100 
; 0000 0101     // Timers
; 0000 0102     TCCR0 = (0<<WGM00) | (0<<COM01) | (0<<COM00) | (1<<WGM01) | (1<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(15)
	OUT  0x33,R30
; 0000 0103     TCNT0 = 0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0104     OCR0 = 0x3B;
	LDI  R30,LOW(59)
	OUT  0x3C,R30
; 0000 0105     TIMSK = 0x00; // turn off all timers flags
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 0106 
; 0000 0107     lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0108     #asm("sei")
	sei
; 0000 0109     while (1){
_0x53:
; 0000 010A 
; 0000 010B         if (status == 100){
	CALL SUBOPT_0x0
	BRNE _0x56
; 0000 010C             display_lockdown();
	RCALL _display_lockdown
; 0000 010D             continue;
	RJMP _0x53
; 0000 010E         }
; 0000 010F 
; 0000 0110         lcd_clear();
_0x56:
	RCALL _lcd_clear
; 0000 0111         switch (status){
	CALL SUBOPT_0x2
; 0000 0112             case -1:
	BREQ _0x5B
; 0000 0113             case -2:
	CPI  R30,LOW(0xFFFFFFFE)
	LDI  R26,HIGH(0xFFFFFFFE)
	CPC  R31,R26
	BRNE _0x5C
_0x5B:
; 0000 0114             case -3:
	RJMP _0x5D
_0x5C:
	CPI  R30,LOW(0xFFFFFFFD)
	LDI  R26,HIGH(0xFFFFFFFD)
	CPC  R31,R26
	BRNE _0x5E
_0x5D:
; 0000 0115             case -4:
	RJMP _0x5F
_0x5E:
	CPI  R30,LOW(0xFFFFFFFC)
	LDI  R26,HIGH(0xFFFFFFFC)
	CPC  R31,R26
	BRNE _0x60
_0x5F:
; 0000 0116                  display_msg();
	RCALL _display_msg
; 0000 0117                  break;
	RJMP _0x59
; 0000 0118             case 0:
_0x60:
	SBIW R30,0
	BRNE _0x61
; 0000 0119                 lcd_puts("Enter Password:");
	__POINTW2MN _0x62,0
	RJMP _0x7C
; 0000 011A                 lcd_gotoxy(0,1);
; 0000 011B                 lcd_puts(pass_temp);
; 0000 011C                 break;
; 0000 011D             case 1:
_0x61:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x63
; 0000 011E               lcd_puts("Safe Unlocked");
	__POINTW2MN _0x62,16
	RJMP _0x7D
; 0000 011F               break;
; 0000 0120             case 2:
_0x63:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x64
; 0000 0121               lcd_puts("Enter New Pass:");
	__POINTW2MN _0x62,30
	RJMP _0x7C
; 0000 0122               lcd_gotoxy(0,1);
; 0000 0123               lcd_puts(pass_temp);
; 0000 0124               break;
; 0000 0125             case 3:
_0x64:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x65
; 0000 0126               lcd_puts("Pass Again:");
	__POINTW2MN _0x62,46
	CALL SUBOPT_0xC
; 0000 0127               lcd_gotoxy(0,1);
; 0000 0128               lcd_puts(new_pass);
	LDI  R26,LOW(_new_pass)
	LDI  R27,HIGH(_new_pass)
	RJMP _0x7D
; 0000 0129               break;
; 0000 012A             case 4:
_0x65:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x66
; 0000 012B                 lcd_puts("Safe is Locked.");
	__POINTW2MN _0x62,58
	RJMP _0x7D
; 0000 012C                 break;
; 0000 012D             case 5:
_0x66:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x59
; 0000 012E                 lcd_puts("ALERT!!!");
	__POINTW2MN _0x62,74
_0x7C:
	RCALL _lcd_puts
; 0000 012F                 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0130                 lcd_puts(pass_temp);
	LDI  R26,LOW(_pass_temp)
	LDI  R27,HIGH(_pass_temp)
_0x7D:
	RCALL _lcd_puts
; 0000 0131                 break;
; 0000 0132         }
_0x59:
; 0000 0133         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0134     }
	RJMP _0x53
; 0000 0135 }
_0x68:
	RJMP _0x68
; .FEND

	.DSEG
_0x62:
	.BYTE 0x53
;
;
;void clear_one(char *arr){
; 0000 0138 void clear_one(char *arr){

	.CSEG
_clear_one:
; .FSTART _clear_one
; 0000 0139     arr[strlen(arr) - 1] = '';
	ST   -Y,R27
	ST   -Y,R26
;	*arr -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	CALL _strlen
	SBIW R30,1
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 013A }
	RJMP _0x2080004
; .FEND
;
;void my_clear(char *arr){
; 0000 013C void my_clear(char *arr){
_my_clear:
; .FSTART _my_clear
; 0000 013D     int i;
; 0000 013E     for(i = 0;i<16;i++)
	CALL SUBOPT_0xD
;	*arr -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x6A:
	__CPWRN 16,17,16
	BRGE _0x6B
; 0000 013F         arr[i] = '';
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
	__ADDWRN 16,17,1
	RJMP _0x6A
_0x6B:
; 0000 0140 }
	RJMP _0x2080005
; .FEND
;
;void change_pass(char new_pass[]){
; 0000 0142 void change_pass(char new_pass[]){
_change_pass:
; .FSTART _change_pass
; 0000 0143     int i;
; 0000 0144     my_clear(pass);
	CALL SUBOPT_0xD
;	new_pass -> Y+2
;	i -> R16,R17
	LDI  R26,LOW(_pass)
	LDI  R27,HIGH(_pass)
	RCALL _my_clear
; 0000 0145     for(i=0;i<16;i++)
	__GETWRN 16,17,0
_0x6D:
	__CPWRN 16,17,16
	BRGE _0x6E
; 0000 0146         pass[i] = new_pass[i];
	MOVW R30,R16
	SUBI R30,LOW(-_pass)
	SBCI R31,HIGH(-_pass)
	MOVW R0,R30
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	__ADDWRN 16,17,1
	RJMP _0x6D
_0x6E:
; 0000 0147 }
_0x2080005:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
;
;void display_msg(){
; 0000 0149 void display_msg(){
_display_msg:
; .FSTART _display_msg
; 0000 014A     lcd_puts(msg);
	LDI  R26,LOW(_msg)
	LDI  R27,HIGH(_msg)
	RCALL _lcd_puts
; 0000 014B     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 014C 
; 0000 014D     switch (status){
	CALL SUBOPT_0x2
; 0000 014E         case -1:
	BRNE _0x72
; 0000 014F             my_clear(pass_temp);
	CALL SUBOPT_0x3
; 0000 0150             status = 0;
; 0000 0151             break;
	RJMP _0x71
; 0000 0152         case -2:
_0x72:
	CPI  R30,LOW(0xFFFFFFFE)
	LDI  R26,HIGH(0xFFFFFFFE)
	CPC  R31,R26
	BRNE _0x73
; 0000 0153             status = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x7E
; 0000 0154             break;
; 0000 0155         case -3:
_0x73:
	CPI  R30,LOW(0xFFFFFFFD)
	LDI  R26,HIGH(0xFFFFFFFD)
	CPC  R31,R26
	BRNE _0x74
; 0000 0156             my_clear(pass_temp);
	CALL SUBOPT_0x5
; 0000 0157             my_clear(new_pass);
; 0000 0158             status = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x7E
; 0000 0159             break;
; 0000 015A         case -4:
_0x74:
	CPI  R30,LOW(0xFFFFFFFC)
	LDI  R26,HIGH(0xFFFFFFFC)
	CPC  R31,R26
	BRNE _0x71
; 0000 015B             my_clear(pass_temp);
	LDI  R26,LOW(_pass_temp)
	LDI  R27,HIGH(_pass_temp)
	RCALL _my_clear
; 0000 015C             status = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x7E:
	MOVW R12,R30
; 0000 015D             break;
; 0000 015E     }
_0x71:
; 0000 015F }
	RET
; .FEND
;
;
;void set_msg(char *message){
; 0000 0162 void set_msg(char *message){
_set_msg:
; .FSTART _set_msg
; 0000 0163     strncpy(msg, message, 32);
	ST   -Y,R27
	ST   -Y,R26
;	*message -> Y+0
	LDI  R30,LOW(_msg)
	LDI  R31,HIGH(_msg)
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(32)
	CALL _strncpy
; 0000 0164 }
	RJMP _0x2080004
; .FEND
;
;void display_lockdown(){
; 0000 0166 void display_lockdown(){
_display_lockdown:
; .FSTART _display_lockdown
; 0000 0167     int min,sec;
; 0000 0168     unsigned char time[16];
; 0000 0169     if (!sync) return ;
	SBIW R28,16
	CALL __SAVELOCR4
;	min -> R16,R17
;	sec -> R18,R19
;	time -> Y+4
	TST  R5
	BRNE _0x76
	CALL __LOADLOCR4
	JMP  _0x2080002
; 0000 016A     min = lockdown / 60;
_0x76:
	MOVW R26,R6
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __DIVW21
	MOVW R16,R30
; 0000 016B     sec = lockdown % 60;
	MOVW R26,R6
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __MODW21
	MOVW R18,R30
; 0000 016C 
; 0000 016D     lcd_clear();
	RCALL _lcd_clear
; 0000 016E     lcd_puts("Lock Down for:");
	__POINTW2MN _0x77,0
	CALL SUBOPT_0xC
; 0000 016F     lcd_gotoxy(0,1);
; 0000 0170     snprintf(time, 9, "%02d:%02d", min, sec);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,195
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CALL SUBOPT_0x9
	MOVW R30,R18
	CALL SUBOPT_0x9
	LDI  R24,8
	CALL _snprintf
	ADIW R28,14
; 0000 0171     lcd_puts(time);
	MOVW R26,R28
	ADIW R26,4
	RCALL _lcd_puts
; 0000 0172     sync = 0;
	CLR  R5
; 0000 0173 }
	CALL __LOADLOCR4
	JMP  _0x2080002
; .FEND

	.DSEG
_0x77:
	.BYTE 0xF
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 2
	SBI  0x15,2
	__DELAY_USB 2
	CBI  0x15,2
	__DELAY_USB 2
	RJMP _0x2080003
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 17
	RJMP _0x2080003
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R4,Y+1
	LD   R30,Y
	STS  __lcd_y,R30
_0x2080004:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0xE
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0xE
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	MOV  R4,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	CP   R4,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2080003
_0x2000007:
_0x2000004:
	INC  R4
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x2080003
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0xF
	CALL SUBOPT_0xF
	CALL SUBOPT_0xF
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 33
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080003:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_strcmp:
; .FSTART _strcmp
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
_strncpy:
; .FSTART _strncpy
	ST   -Y,R26
    ld   r23,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strncpy0:
    tst  r23
    breq strncpy1
    dec  r23
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strncpy0
strncpy2:
    tst  r23
    breq strncpy1
    dec  r23
    st   x+,r22
    rjmp strncpy2
strncpy1:
    movw r30,r24
    ret
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G102:
; .FSTART _put_buff_G102
	CALL SUBOPT_0xD
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2040013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2040014:
	RJMP _0x2040015
_0x2040010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	CALL SUBOPT_0x10
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	CALL SUBOPT_0x10
	RJMP _0x20400CC
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BRNE _0x2040022
	LDI  R20,LOW(43)
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BRNE _0x2040023
	LDI  R20,LOW(32)
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x204001B
_0x2040027:
	CPI  R18,48
	BRLO _0x204002A
	CPI  R18,58
	BRLO _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x204002F
	CALL SUBOPT_0x11
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x12
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	CALL SUBOPT_0x11
	CALL SUBOPT_0x13
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	CALL SUBOPT_0x11
	CALL SUBOPT_0x13
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040036
_0x2040035:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(4)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x204003D
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(8)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040043:
	CPI  R20,0
	BREQ _0x2040044
	SUBI R17,-LOW(1)
	RJMP _0x2040045
_0x2040044:
	ANDI R16,LOW(251)
_0x2040045:
	RJMP _0x2040046
_0x2040042:
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
_0x2040046:
_0x2040036:
	SBRC R16,0
	RJMP _0x2040047
_0x2040048:
	CP   R17,R21
	BRSH _0x204004A
	SBRS R16,7
	RJMP _0x204004B
	SBRS R16,2
	RJMP _0x204004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004C:
	LDI  R18,LOW(48)
_0x204004D:
	RJMP _0x204004E
_0x204004B:
	LDI  R18,LOW(32)
_0x204004E:
	CALL SUBOPT_0x10
	SUBI R21,LOW(1)
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004F
_0x2040050:
	CPI  R19,0
	BREQ _0x2040052
	SBRS R16,3
	RJMP _0x2040053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2040054
_0x2040053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040054:
	CALL SUBOPT_0x10
	CPI  R21,0
	BREQ _0x2040055
	SUBI R21,LOW(1)
_0x2040055:
	SUBI R19,LOW(1)
	RJMP _0x2040050
_0x2040052:
	RJMP _0x2040056
_0x204004F:
_0x2040058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x204005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x204005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x204005A
_0x204005C:
	CPI  R18,58
	BRLO _0x204005D
	SBRS R16,3
	RJMP _0x204005E
	SUBI R18,-LOW(7)
	RJMP _0x204005F
_0x204005E:
	SUBI R18,-LOW(39)
_0x204005F:
_0x204005D:
	SBRC R16,4
	RJMP _0x2040061
	CPI  R18,49
	BRSH _0x2040063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040062
_0x2040063:
	RJMP _0x20400CD
_0x2040062:
	CP   R21,R19
	BRLO _0x2040067
	SBRS R16,0
	RJMP _0x2040068
_0x2040067:
	RJMP _0x2040066
_0x2040068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040069
	LDI  R18,LOW(48)
_0x20400CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x12
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	CALL SUBOPT_0x10
	CPI  R21,0
	BREQ _0x204006C
	SUBI R21,LOW(1)
_0x204006C:
_0x2040066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2040059
	RJMP _0x2040058
_0x2040059:
_0x2040056:
	SBRS R16,0
	RJMP _0x204006D
_0x204006E:
	CPI  R21,0
	BREQ _0x2040070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x12
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
_0x20400CC:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
_0x2080002:
	ADIW R28,20
	RET
; .FEND
_snprintf:
; .FSTART _snprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	__GETWRN 18,19,0
	CALL SUBOPT_0x15
	SBIW R30,0
	BRNE _0x2040073
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080001
_0x2040073:
	CALL SUBOPT_0x16
	SBIW R30,0
	BREQ _0x2040074
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x15
	STD  Y+6,R30
	STD  Y+6+1,R31
	CALL SUBOPT_0x16
	STD  Y+8,R30
	STD  Y+8+1,R31
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2040074:
	MOVW R30,R18
_0x2080001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.DSEG
_pass:
	.BYTE 0x10
_pass_temp:
	.BYTE 0x10
_new_pass:
	.BYTE 0x10
_msg:
	.BYTE 0x20
__base_y_G100:
	.BYTE 0x4
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R12
	CPC  R31,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	MOVW R30,R12
	CPI  R30,LOW(0xFFFFFFFF)
	LDI  R26,HIGH(0xFFFFFFFF)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_pass_temp)
	LDI  R27,HIGH(_pass_temp)
	CALL _my_clear
	CLR  R12
	CLR  R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4:
	CALL _my_clear
	LDI  R26,LOW(_new_pass)
	LDI  R27,HIGH(_new_pass)
	JMP  _my_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(_pass_temp)
	LDI  R27,HIGH(_pass_temp)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(3)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_key_number*2)
	SBCI R31,HIGH(-_key_number*2)
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R26,Z
	CPI  R26,LOW(0x23)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(3)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_key_number*2)
	SBCI R31,HIGH(-_key_number*2)
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(_pass)
	LDI  R31,HIGH(_pass)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_pass_temp)
	LDI  R27,HIGH(_pass_temp)
	CALL _strcmp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(_pass_temp)
	LDI  R27,HIGH(_pass_temp)
	JMP  _clear_one

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(_pass_temp)
	LDI  R27,HIGH(_pass_temp)
	CALL _strlen
	SUBI R30,LOW(-_pass_temp)
	SBCI R31,HIGH(-_pass_temp)
	MOVW R22,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USB 33
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x10:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	MOVW R26,R28
	ADIW R26,14
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
