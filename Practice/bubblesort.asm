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
	LDR R0,=SRC
	MOV R1,#4
	LDR R3,=ARR
	MOV R10,#5
LP1
	LDR R2,[R0],#4
	STR R2,[R3],#4
	SUBS R10,#1
	BNE LP1

	; Bubble Sort Implementation
	; R0 will point to the start of the array
	; R4 will be used as a flag to check if any swaps occurred
	; R5, R6 for array elements, and R7, R8 for their addresses
	; R10 stores the size of the array, initially 5

MAIN
	MOV R10,#5
	
	MOV R11,R10         ; Set loop counter to the number of elements
	SUB R11,#1          ; We only need to make (n-1) passes
SORT_PASS
	LDR R0,=ARR         ; Point R0 to the start of the array
	MOV R4,#0           ; Reset the swap flag to 0 at the start of each pass
	MOV R1,R11          ; Inner loop counter set to (n-i-1)

LP2
	
	LDR R2,[R0]         ; Load the current element into R2
	MOV R7,R0           ; Store the address of the current element in R7
	ADD R0,#4           ; Move to the next element
	LDR R3,[R0]         ; Load the next element into R3
	MOV R8,R0           ; Store the address of the next element in R8

	CMP R2,R3           ; Compare the current element with the next
	BLE NOSWAP          ; If current <= next, no swap is needed

	; Swap the elements if R2 > R3
	STR R2,[R8]         ; Move the current element to the next position
	STR R3,[R7]         ; Move the next element to the current position
	MOV R4,#1           ; Set the swap flag to 1

NOSWAP
	SUBS R1,#1          ; Decrement the inner loop counter
	BNE LP2             ; If the inner loop counter isn't zero, repeat

	SUBS R11,#1         ; Decrement the outer loop counter
	CMP R4,#0           ; If no swaps were made, the array is sorted
	CMP R11,#0
	BEQ STOP            ; If sorted, exit the loop
	BNE SORT_PASS       ; If not sorted, repeat the outer loop

STOP 
	B STOP              ; Stop the program

SRC DCD 0X5,0X4,0X3,0X2,0X1  ; The unsorted array
	AREA mydata, DATA, READWRITE
ARR DCD 0,0,0,0,0              ; Array to hold the sorted values
	END
