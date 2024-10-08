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
	LDR R0,=VALUE1			;LOAD THE VALUE1
	LDR R1,=VALUE2			;LOAD THE VALUE2
	LDR R3,=DST				;INITIALIZED THE DST
	LDR R4,[R0]
	LDR R5,[R1]
	MOV R2,#0
BACK SUBS R4,R4,R5			;SUBTRACT R4-R5 AND STORE IT IN R4
	ADD R2,#1
	CMP R4,R5
	BCS BACK
	STR R2,[R3,#4]			;STORE THE QUOTIENT
	STR R4,[R3]				;STORE THE REMAINDER 
VALUE1 DCD 0X14
VALUE2 DCD 0X3
	AREA mydata,DATA,READWRITE
DST DCD 0,0
	END
