	AREA RESET, DATA, READONLY
    EXPORT __Vectors
__Vectors
    DCD 0X10001000
    DCD Reset_Handler
    ALIGN

    AREA mycode, CODE, READONLY
    ENTRY
    EXPORT Reset_Handler
Reset_Handler
	LDR R0,=0X0
	LDR R1,=0X1
	LDR R2,=DST
	MOV R4,R2
	
	STR R0,[R2],#4
	STR R1,[R2],#4
	;R4 IS POINTING TO THE FIRST ELEMENT
	;R5 IS POINTING TO THE SECOND ELEMENT
	;R6 WILL STORE THE RESULT IN THE NEXT LOCATION
	;R10 IS STORING HOW MANY TO STORE
	MOV R10,#8
	BL FIBONACI
STOP
	B STOP

FIBONACI
LP
	MOV R5,R4
	ADD R5,#4
	LDR R8,[R4]
	LDR R9,[R5]
	;R7 WILL STORE THE SUM OF R4 AND R5
	MOV R7,#0
	ADD R7,R8,R9
	STR R7,[R2],#4
	ADD R4,#4
	SUBS R10,#1
	BNE LP
	BX LR
	

    AREA mydata, DATA, READWRITE
DST DCD 0                    ; Allocate memory for the result in DST
    END
