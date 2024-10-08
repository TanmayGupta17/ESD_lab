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
	LDR R10,=SRC
	LDR R1,[R10]
UP2 CMP R1,#0
	BEQ EXIT2
	MOV R3,#0
UP1 CMP R1,#0XA
	BLO EXIT1
	SUB R1,#0XA
	ADD R3,#1
	B UP1
EXIT1 LSL R1,R2
	ADD R0,R1
	ADD R2,#4
	MOV R1,R3
	B UP2
EXIT2 LDR R4,=DST
	STR R0,[R4]
STOP B STOP 
SRC DCD 0XC
	AREA mydata,DATA,READWRITE
DST DCD 0
	END
