	AREA RESET, DATA, READONLY
        EXPORT __Vectors
__Vectors 
        DCD 0x10001000  ; Stack pointer initial value
        DCD Reset_Handler  ; Reset vector

        ALIGN
        
    AREA mycode, CODE, READONLY
        ENTRY
        EXPORT Reset_Handler
        
Reset_Handler
        ; Main program starts here
        LDR R0, =N  ; Load address of N
        LDR R0, [R0]  ; Load value of N into R0
        BL fibonacci  ; Call fibonacci function
        LDR R1, =Result
        STR R0, [R1]  ; Store result
        
STOP    B STOP  ; Infinite loop to stop execution

fibonacci
        PUSH {R4, LR}  ; Save registers
        CMP R0, #2  ; Compare N with 2
        BLT base_case  ; If N < 2, go to base case
        
        ; Recursive case
        SUB R4, R0, #1  ; R4 = N - 1
        MOV R0, R4  ; Set argument for fibonacci(N-1)
        BL fibonacci  ; Call fibonacci(N-1)
        PUSH {R0}  ; Save result of fibonacci(N-1)
        
        SUB R0, R4, #1  ; R0 = N - 2
        BL fibonacci  ; Call fibonacci(N-2)
        
        POP {R4}  ; Retrieve result of fibonacci(N-1)
        ADD R0, R0, R4  ; R0 = fibonacci(N-1) + fibonacci(N-2)
        
        POP {R4, PC}  ; Restore registers and return
        
base_case
        MOV R0, #1  ; Return 1 for N < 2
        POP {R4, PC}  ; Restore registers and return

    AREA mydata, DATA, READONLY
N       DCD 7  ; Example input value

    AREA mydata2, DATA, READWRITE
Result  DCD 0  ; Variable to store the result

        END
