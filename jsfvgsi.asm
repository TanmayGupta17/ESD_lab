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
    LDR R0, =VAL1       ; Load address of VAL1 into R0
    LDR R1, =VAL2       ; Load address of VAL2 into R1
    LDR R2, =DST        ; Load address of DST into R2
    ; R3 will contain the subtraction result
    ; R4 will contain the borrow
    MOV R9, #4          ; 4 words (128-bit)
	LDR R10,=0X20000000
	MSR XPSR ,R10

BACK
    LDR R5, [R0], #4    ; Load next word from VAL1, advance pointer
    LDR R6, [R1], #4    ; Load next word from VAL2, advance pointer
    SBCS R7, R6, R5     ; Subtract with carry (R7 = R6 - R5 - borrow)
    STR R7, [R2], #4    ; Store result into DST, advance pointer
    SUBS R9, R9, #1     ; Decrement loop counter
    BNE BACK            ; Loop until all 4 words are processed

    SBC R4, R4, #0      ; Capture any final carry/borrow into R4
    STR R4, [R2] ; Store the carry/borrow as the most significant word of the result

STOP
    B STOP              ; Infinite loop to stop the program

VAL1 DCD 0X11111111,0X22222222,0X33333333,0X44444444
VAL2 DCD 0X55555555,0X66666666,0X77777777,0X88888888

    AREA mydata, DATA, READWRITE
DST DCD 0,0,0,0

    END
