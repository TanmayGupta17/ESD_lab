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
    LDR R0,=SRC          ; Load the address of SRC array
    LDR R2,=VAL          ; Load the address of VAL
	LDR R8,=DST
    LDR R3,[R2]          ; Load the value in VAL into R3
    MOV R9,#8            ; Initialize the loop counter for 8 elements
    LDR R10,=0XFFFFFFFF  ; Load R10 with the value 0xFFFFFFFF
LP1
	LDR R4,[R0],#4
	STR R4,[R8],#4
	SUBS R9,#1
	BNE LP1
	
	MOV R6,#8
	LDR R0,=DST
LP2	
	CMP R6,#0
	BEQ EXIT2
	LDR R5,[R0],#4
	CMP R3,R5
	BEQ EXIT1
	SUBS R6,#1
	BNE LP2

EXIT1
	SUB R7,R0,#4
	STR R10,[R7]
	B STOP
EXIT2
	STR R3,[R0]
	B STOP
	

STOP 
    B STOP

SRC DCD 0X5,0X2,0X7,0X9,0XB,0X1,0X3,0X4
VAL DCD 0X3
    AREA mydata,DATA,READWRITE
DST DCD 0
    END
