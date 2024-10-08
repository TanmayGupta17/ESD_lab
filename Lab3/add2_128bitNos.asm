	AREA RESET,DATA,READONLY
	EXPORT __Vectors
__Vectors
	DCD 0X10001000
	DCD Reset_Handler
	ALIGN
	AREA mycode,CODE,READONLY
	ENTRY
	EXPORT Reset_Handler
Reset_Handler
	LDR R0,=VAL1
	LDR R1,=VAL2
	MOV R2,#4
	LDR R5,=DST
	ADD R5,#4
BACK LDR R3,[R0],#4
	LDR R4,[R1],#4
	ADCS R6,R3,R4
	STR R6,[R5],#4
	SUBS R2,#1        ;THIS WILL UPDATE THE ZERO FLAG
	BNE BACK          ;IF ZERO FLAG IS NOT SET GO TO BACK
	ADC R8,#0
	STR R8,[R5,#-20]!
VAL1 DCD 0X11111111,0X22222222,0X33333333,0X44444444
VAL2 DCD 0X55555555,0X66666666,0X77777777,0X88888888
	AREA mydata,DATA,READWRITE
DST DCD 0
	END
