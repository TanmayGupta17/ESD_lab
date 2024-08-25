	AREA RESET, DATA, READONLY
	EXPORT __Vectors
	
__Vectors
	DCD 0x10001000
	DCD Reset_Handler
	
	ALIGN
	
	AREA mycode, CODE, READONLY
	ENTRY
	EXPORT Reset_Handler
	
Reset_Handler
	LDR R0,=N
	LDR R1,=ARR
	MOV R2,#10
	MOV R5,#4
LOOP
	LDR R3,[R0],#4
	STR R3,[R1],#4
	SUBS R2,#1
	BNE LOOP
	
	MOV R9,#0
LOOP1
	CMP R9,#10
	BEQ STOP
	
	LDR R0,=ARR
	MLA R0,R9,R5,R0
	MOV R4,#10
	SUB R4,R9
	LDR R7,[R0]
	MOV R8,R0
SMALLEST
	LDR R6,[R0],#4
	CMP R6,R7
	MOVLO R7,R6
	SUBLO R8,R0,#4
	SUBS R4,#1
	BNE SMALLEST

	LDR R0,=ARR
	MLA R0,R9,R5,R0
	LDR R10,[R0]
	LDR R11,[R8]
	STR R10,[R8]
	STR R11,[R0]
	ADD R9,#1
	B LOOP1	
	
STOP
	B STOP

N DCD 0xA, 0x5, 0x2, 0x8, 0x3, 0x4, 0x9, 0x7, 0x6, 0x1

	AREA mydata, DATA, READWRITE

ARR DCD 0,0,0,0,0,0,0,0,0,0
	
	END
