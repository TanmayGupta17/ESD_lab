AREA RESET, DATA, READONLY
	EXPORT __Vectors
__Vectors
	DCD 0X10001000
	DCD Reset_Handler
	ALIGN
	AREA mycode,CODE,READONLY
	ENTRY
	EXPORT Reset_Handler
Reset_Handler
	LDR R0,=SRC
	MOV R2,#SIZE/2
	LDR R1,=SRC+(SIZE-1)*4							;LOAD THE LAST ELEMENT ADDRESS FROM THE ARRAY
BACK LDR R3,[R0]									    ;LOAD THE FIRST POSITION FROM THE DST
	LDR R4,[R1]										      ;LOAD THE LAST ELEMENT FROM THE ARRAY
	STR R4,[R0]										      ;STORE THE LAST ELEMENT IN THE FIRST POSITION
	STR R3,[R1]										      ;STORE THE FIRST ELEMENT IN THE LAST POSITION
	ADD R0,#4										        ;MOVE TO THE NEXT ELEMENT
	SUB R1,#4										
	SUBS R2,#1										
	BNE BACK
STOP B STOP
SIZE EQU 10
SRC DCD 0x1,0x2,0x3,0x4,0x5,0x6,0x7,0x8,0x9,0x10
	AREA mydata, DATA, READWRITE
DST DCD 0,0,0,0,0,0,0,0,0
	END
