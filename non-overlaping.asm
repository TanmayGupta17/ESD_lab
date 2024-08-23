	AREA RESET,DATA,READONLY
	EXPORT __Vectors
__Vectors
	DCD 0x10001000 ;stack pointer when stack is empty
	DCD Reset_Handler
	ALIGN
	AREA mycode,CODE,READONLY
	ENTRY
	EXPORT Reset_Handler
Reset_Handler
	LDR R0,=SRC
	LDR R1,=DST
	MOV R2,#10
BACK LDR R3,[R0],#4		; load word from the source to register
	STR R3,[R1],#4		; store the value from the register to dst register
	SUBS R2,#1
	BNE BACK
STOP
  	B STOP
SRC DCD 0x1,0x2,0x3,0x4,0x5,0x6,0x7,0x8,0x9,0x10
	AREA mydata, DATA, READWRITE
DST DCD 0,0,0,0,0,0,0,0,0,0
	END
