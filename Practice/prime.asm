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
    LDR R0, =SRC          ; Load the address of SRC
    LDR R1, [R0]          ; Load the value from SRC into R1
    LDR R2, =DST          ; Load the address of DST
    MOV R3, #1            ; Initialize count variable R3 to 0
    MOV R7, #3            ; Start checking from the first prime number 2

LP
    MOV R4, #2            ; Initialize R4 to 2 for each new number R7
    MOV R6, #1            ; Assume the number is prime initially
    MOV R5, R7            ; Backup R7 to R5 for restoring later
    BL DIV                ; Call the DIV subroutine
    CMP R6, #1            ; Check if the number is prime
    ADDEQ R3, #1          ; If prime, increment the prime counter R3
    CMP R7, R1            ; Compare R7 with the upper limit R1
    BEQ STOP              ; If equal, stop the loop
    ADD R7, #1            ; Increment R7 to check the next number
    B LP                  ; Loop back to check the next number

    STR R3, [R2]          ; Store the count of primes in DST


STOP
    B STOP                ; Infinite loop to stop execution

DIV 
    MOV R7, R5            ; Restore the original value of R7 from R5
LP3
	CMP R5,R4
	BEQ EXIT3
    CMP R7, R4            ; Compare R7 with R4
    BLO LP1               ; If R7 < R4, skip the subtraction
    SUB R7, R4           ; Subtract R4 from R7
    B LP3                 ; Repeat until R7 < R4 or divisible

LP1
    CMP R7, #0            ; Check if the result of subtraction is 0
    BEQ EXIT2             ; If 0, the number is not prime
    BHI EXIT1             ; If greater, check the next possible divisor
EXIT2
    MOV R6, #0            ; Mark the number as not prime
	MOV R7,R5
    BX LR                 ; Return from the DIV subroutine

EXIT1
    ADD R4, #1            ; Increment R4 to check the next divisor
    MOV R7, R5            ; Restore original R7 value
    B DIV                ; Continue the loop with the next divisor

EXIT3
    BX LR                 ; Return from the DIV subroutine

SRC DCD 0XE              ; Initialize SRC with the value to check primes up to 14 (0xE)
	AREA mydata, DATA, READWRITE
DST DCD 0                ; Allocate memory for the result in DST
	END
