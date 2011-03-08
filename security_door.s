.global main

.equ PS2, 0xff1150
.equ ADDR_7SEG, 0xff1100
.equ TIMER, 0xff1020
.equ LCD_DISPLAY, 0xff1060
.equ ADDR_RNG, 0xff11a0
.equ ADDR_PUSHBUTTON, 0xff1090
.equ IRQ_PUSHBUTTON, 0x20

/*
	global variables
	r8  - make key
	r16 - count LCD
	r18 - ignore (active low) 
	r19 - password buffer pointer
	r20 - set password buffer 1 pointer
	r21 - set password buffer 2 pointer
	r22 - state(1-set password first time, 3-set password second time, 4-promting password)
	r23 - overflow
*/

main:

	movui r18, 1
	movia r19, password_buffer
	movia r20, password_input1
	movia r21, password_input2
	movui r22, 1
	movui r23, 0


	addi  sp,sp,4
	stw   ra,0(sp)

	call sensor_init
	
	movui r17, 1				/* Enable interrupts	*/
	wrctl ctl0, r17
	movia r7, PS2
	stwio r17, 4(r7)
	movui r17, 0x8800
	wrctl ctl3, r17

	movui r17, 0xff				/* Reset keyboard	*/
	stwio r17, 0(r7) 			/* Send the reset signal */

	call  LCD_INIT
	call  LCD_PROMPT
	
	
forever:
	br   forever
	ldw  ra,0(sp)
	addi sp,sp,-4
	ret
	

LCD_INIT:
	addi  sp,sp,-8
	stw   r3,0(sp)
	stw   r7,4(sp)
	movia r7, LCD_DISPLAY		/* Initializing LCD display */
	movui r3, 0x38
	stwio r3, 0(r7)			/* Set Function: 8-bit data length, 2-lines, 5x8 characters */
	movui r3, 0x0c
	stwio r3, 0(r7)			/* Set display 1, no cursor, no blink */
	movui r3, 0x01
	stwio r3, 0(r7)			/* Clear screen */
	movui r3, 0x06
	stwio r3, 0(r7)			/* Cursor direction, no shifting */
	movui r3, 0x80
	stwio r3, 0(r7)			/* Set DDRAM address to 0 */
	movui r16, 0			/* counter */
	ldw   r7,4(sp)
	ldw   r3,0(sp)
	addi  sp,sp,8
	ret

LCD_PROMPT:
	addi  sp,sp,-8
	stw   r3,0(sp)
	stw   r7,4(sp)
	movia r7, LCD_DISPLAY		
	movui r3, 1
	beq   r3, r22, STATE1
	movui r3, 2
	beq   r3, r22, STATE2
	movui r3, 3
	beq   r3, r22, STATE3
STATE1:
	movui r3, 80			/* P */
	stwio r3, 4(r7)	
	movui r3, 76			/* L */
	stwio r3, 4(r7)
	movui r3, 69			/* E */
	stwio r3, 4(r7)	
	movui r3, 65			/* A */
	stwio r3, 4(r7)
	movui r3, 83			/* S */
	stwio r3, 4(r7)
	movui r3, 69			/* E */
	stwio r3, 4(r7)	
	movui r3, 32			/*   */
	stwio r3, 4(r7)
	movui r3, 83			/* S */
	stwio r3, 4(r7)
	movui r3, 69			/* E */
	stwio r3, 4(r7)
	movui r3, 84			/* T */	
	stwio r3, 4(r7)	
	movui r3, 0xc0			/* Move to next line */
	stwio r3, 0(r7)		
	movui r3, 80			/* P */
	stwio r3, 4(r7)	
	movui r3, 65			/* A */
	stwio r3, 4(r7)	
	movui r3, 83			/* SS */
	stwio r3, 4(r7)
	stwio r3, 4(r7)
	movui r3, 87			/* W */
	stwio r3, 4(r7)	
	movui r3, 79			/* O */
	stwio r3, 4(r7)	
	movui r3, 82			/* R */
	stwio r3, 4(r7)
	movui r3, 68			/* D */
	stwio r3, 4(r7)
	br PROMPT_EPI
	
STATE2:
	movui r3, 80			/* P */
	stwio r3, 4(r7)	
	movui r3, 76			/* L */
	stwio r3, 4(r7)
	movui r3, 69			/* E */
	stwio r3, 4(r7)	
	movui r3, 65			/* A */
	stwio r3, 4(r7)
	movui r3, 83			/* S */
	stwio r3, 4(r7)
	movui r3, 69			/* E */
	stwio r3, 4(r7)	
	movui r3, 32			/*   */
	stwio r3, 4(r7)	
	movui r3, 82			/* R */
	stwio r3, 4(r7)	
	movui r3, 69			/* EE */
	stwio r3, 4(r7)	
	stwio r3, 4(r7)	
	movui r3, 78			/* N */
	stwio r3, 4(r7)
	movui r3, 84			/* T */	
	stwio r3, 4(r7)	
	movui r3, 69			/* E */
	stwio r3, 4(r7)	
	movui r3, 82			/* R */
	stwio r3, 4(r7)
	movui r3, 0xc0			/* Move to next line */
	stwio r3, 0(r7)
	stwio r3, 0(r7)		
	movui r3, 80			/* P */
	stwio r3, 4(r7)	
	movui r3, 65			/* A */
	stwio r3, 4(r7)	
	movui r3, 83			/* SS */
	stwio r3, 4(r7)
	stwio r3, 4(r7)
	movui r3, 87			/* W */
	stwio r3, 4(r7)	
	movui r3, 79			/* O */
	stwio r3, 4(r7)	
	movui r3, 82			/* R */
	stwio r3, 4(r7)
	movui r3, 68			/* D */
	stwio r3, 4(r7)
	br PROMPT_EPI
STATE3:
	movui r3, 80			/* P */
	stwio r3, 4(r7)	
	movui r3, 76			/* L */
	stwio r3, 4(r7)
	movui r3, 69			/* E */
	stwio r3, 4(r7)	
	movui r3, 65			/* A */
	stwio r3, 4(r7)
	movui r3, 83			/* S */
	stwio r3, 4(r7)
	movui r3, 69			/* E */
	stwio r3, 4(r7)	
	movui r3, 32			/*   */
	stwio r3, 4(r7)	
	movui r3, 69			/* E */
	stwio r3, 4(r7)		
	movui r3, 78			/* N */
	stwio r3, 4(r7)
	movui r3, 84			/* T */	
	stwio r3, 4(r7)	
	movui r3, 69			/* E */
	stwio r3, 4(r7)	
	movui r3, 82			/* R */
	stwio r3, 4(r7)
	movui r3, 0xc0			/* Move to next line */
	stwio r3, 0(r7)
	stwio r3, 0(r7)		
	movui r3, 80			/* P */
	stwio r3, 4(r7)	
	movui r3, 65			/* A */
	stwio r3, 4(r7)	
	movui r3, 83			/* SS */
	stwio r3, 4(r7)
	stwio r3, 4(r7)
	movui r3, 87			/* W */
	stwio r3, 4(r7)	
	movui r3, 79			/* O */
	stwio r3, 4(r7)	
	movui r3, 82			/* R */
	stwio r3, 4(r7)
	movui r3, 68			/* D */
	stwio r3, 4(r7)
PROMPT_EPI:
	ldw   r7,4(sp)
	ldw   r3,0(sp)
	addi  sp,sp,8
	ret



LCD_PRINT:
	addi  sp,sp,-16
	stw   r3,0(sp)
	stw   r5,4(sp)
	stw   r7,8(sp)
	stw   ra,12(sp)
	movia r7, LCD_DISPLAY
	movui r3, 42			/* asterisk */
	call  RANDINT
	bne   r16, r0, PRINT_LOOP
	call  LCD_INIT
PRINT_LOOP:
	beq   r2, r0, DONE
	movi  r5, 16			/* max num of char per line */
	beq   r16, r5, JUMPLINE
	movi  r5, 32			/* buffer overflow */
	beq   r16,r5, OVERFLOW
	stwio r3, 4(r7)
	addi  r16, r16, 1
	subi  r2, r2, 1
	br    PRINT_LOOP
JUMPLINE:
	movui r3, 0xc0			/* Move to next line */
	stwio r3, 0(r7)
	movui r3, 42
	stwio r3, 4(r7)
	addi  r16,r16,1
	subi  r2,r2,1
	br    PRINT_LOOP
OVERFLOW:
	call  LCD_INIT
	
	movui r3, 66			/* B */
	stwio r3, 4(r7)	
	movui r3, 85			/* U */
	stwio r3, 4(r7)
	movui r3, 70			/* FF*/
	stwio r3, 4(r7)	
	stwio r3, 4(r7)
	movui r3, 69			/* E */
	stwio r3, 4(r7)	
	movui r3, 82			/* R */
	stwio r3, 4(r7)
	movui r3, 32			/*   */
	stwio r3, 4(r7)		
	movui r3, 79			/* O */
	stwio r3, 4(r7)	
	movui r3, 86			/* V */
	stwio r3, 4(r7)	
	movui r3, 69			/* E */
	stwio r3, 4(r7)	
	movui r3, 82			/* R */
	stwio r3, 4(r7)
	movui r3, 70			/* F */
	stwio r3, 4(r7)	
	movui r3, 76			/* L */
	stwio r3, 4(r7)	
	movui r3, 79			/* O */
	stwio r3, 4(r7)				
	movui r3, 87			/* W */
	stwio r3, 4(r7)	
	
	
	call  wait
  	call  LCD_INIT
	call  LCD_PROMPT
	call  RESET_PASSWORD
	movui r23, 1
  	
  	
DONE:
	ldw   ra,12(sp)
	ldw   r7,8(sp)
	ldw   r5,4(sp)
	ldw   r3,0(sp)
	addi  sp,sp,16
	ret



LCD_PRINT2:
	addi  sp,sp,-16
	stw   r3,0(sp)
	stw   r5,4(sp)
	stw   r7,8(sp)
	stw   ra,12(sp)
	
	movia r7, LCD_DISPLAY
	bne   r16, r0, LCD_PRINT2_BODY
	call  LCD_INIT

LCD_PRINT2_BODY:
	movi  r5, 10			/* max num of char of input */
	beq   r16, r5, LIMIT
	add   r3, r8, r0
	/*movui r3, 42*/			/* asterisk */
	call CONVERT
	stwio r2, 4(r7)
	addi  r16, r16, 1
	br LCD2EPI       
LIMIT:
	call  LCD_INIT

	movui r3, 80			/* P */
	stwio r3, 4(r7)	
	movui r3, 65			/* A */
	stwio r3, 4(r7)	
	movui r3, 83			/* SS */
	stwio r3, 4(r7)
	stwio r3, 4(r7)
	movui r3, 87			/* W */
	stwio r3, 4(r7)	
	movui r3, 79			/* O */
	stwio r3, 4(r7)	
	movui r3, 82			/* R */
	stwio r3, 4(r7)
	movui r3, 68			/* D */
	stwio r3, 4(r7)
	movui r3, 32			/*   */
	stwio r3, 4(r7)
	movui r3, 67			/* C */
	stwio r3, 4(r7)	
	movui r3, 65			/* A */
	stwio r3, 4(r7)
	movui r3, 78			/* NN */
	stwio r3, 4(r7)
	stwio r3, 4(r7)
	movui r3, 79			/* O */
	stwio r3, 4(r7)	
	movui r3, 84			/* T */	
	stwio r3, 4(r7)	
	movui r3, 0xc0			/* Move to next line */
	stwio r3, 0(r7)
	movui r3, 69			/* E */
	stwio r3, 4(r7)	
	movui r3, 88			/* X */
	stwio r3, 4(r7)	
	movui r3, 67			/* C */
	stwio r3, 4(r7)	
	movui r3, 69			/* EE */
	stwio r3, 4(r7)	
	stwio r3, 4(r7)	
	movui r3, 68			/* D */
	stwio r3, 4(r7)
	movui r3, 32			/*   */
	stwio r3, 4(r7)
	movui r3, 49			/* 1 */
	stwio r3, 4(r7)
	movui r3, 48			/* 0 */
	stwio r3, 4(r7)
	movui r3, 32			/*   */
	stwio r3, 4(r7)
	movui r3, 67			/* C */
	stwio r3, 4(r7)	
	movui r3, 72			/* H */
	stwio r3, 4(r7)
	movui r3, 65			/* A */
	stwio r3, 4(r7)
	movui r3, 82			/* R */
	stwio r3, 4(r7)	
	movui r3, 83			/* S */
	stwio r3, 4(r7)	
	
	call  wait
  	call  LCD_INIT
	call  LCD_PROMPT
	movui r23, 1
  	movui r3, 1
  	beq   r22, r3, RS1
  	
RS2:
	call  RESET_PASSWORD2
	br    LCD2EPI
	
RS1:
	call  RESET_PASSWORD1
	
LCD2EPI:
	ldw   ra,12(sp)
	ldw   r7,8(sp)
	ldw   r5,4(sp)
	ldw   r3,0(sp)
	addi  sp,sp,16
	ret
	

ENTER:
	addi  sp,sp,-16
	stw   r3,0(sp)
	stw   r7,4(sp)
	stw   r9,8(sp)
	stw   ra,12(sp)

	movia r7, LCD_DISPLAY
	call  CHECK_PSW
	call  RESET_PASSWORD
	beq   r2, r0, INVALID
VALID:
	call  LCD_INIT
	
	movui r3, 86			/* V */
	stwio r3, 4(r7)			
	movui r3, 65			/* A */
	stwio r3, 4(r7)			
	movui r3, 76			/* L */
	stwio r3, 4(r7)	
	movui r3, 73			/* I */
	stwio r3, 4(r7)	
	movui r3, 68			/* D */
	stwio r3, 4(r7)	
	movui r3, 32			/*   */
	stwio r3, 4(r7)	
	movui r3, 80			/* P */
	stwio r3, 4(r7)	
	movui r3, 65			/* A */
	stwio r3, 4(r7)	
	movui r3, 83			/* SS */
	stwio r3, 4(r7)
	stwio r3, 4(r7)
	movui r3, 87			/* W */
	stwio r3, 4(r7)	
	movui r3, 79			/* O */
	stwio r3, 4(r7)	
	movui r3, 82			/* R */
	stwio r3, 4(r7)
	movui r3, 68			/* D */
	stwio r3, 4(r7)
	
	br    DELAY
INVALID:
	call  LCD_INIT
	
	movui r3, 73			/* I */
	stwio r3, 4(r7)
	movui r3, 78			/* N */
	stwio r3, 4(r7)	
	movui r3, 86			/* V */
	stwio r3, 4(r7)			
	movui r3, 65			/* A */
	stwio r3, 4(r7)			
	movui r3, 76			/* L */
	stwio r3, 4(r7)	
	movui r3, 73			/* I */
	stwio r3, 4(r7)	
	movui r3, 68			/* D */
	stwio r3, 4(r7)	
	movui r3, 32			/*   */
	stwio r3, 4(r7)	
	movui r3, 80			/* P */
	stwio r3, 4(r7)	
	movui r3, 65			/* A */
	stwio r3, 4(r7)	
	movui r3, 83			/* SS */
	stwio r3, 4(r7)
	stwio r3, 4(r7)
	movui r3, 87			/* W */
	stwio r3, 4(r7)	
	movui r3, 79			/* O */
	stwio r3, 4(r7)	
	movui r3, 82			/* R */
	stwio r3, 4(r7)
	movui r3, 68			/* D */
	stwio r3, 4(r7)

DELAY:
  	call  wait
ENTER_EPI:
	call  LCD_INIT
	call  LCD_PROMPT
	ldw   ra,12(sp)
	ldw   r9,8(sp)
	ldw   r7,4(sp)
	ldw   r3,0(sp)
	addi  sp,sp,16
	ret

ENTER1:
	addi  sp,sp,-4
	stw   ra,0(sp)
	movui r22, 2
	call  LCD_INIT
	call  LCD_PROMPT
	ldw   ra,0(sp)
	addi  sp,sp,4
	ret

ENTER2:	
	addi  sp,sp,-16
	stw   r3,0(sp)
	stw   r7,4(sp)
	stw   r9,8(sp)
	stw   ra,12(sp)

	movia r7, LCD_DISPLAY
	call  CHECK_PSW2
	beq   r2, r0, UNMATCH
	
MATCH:
	movia r22, 3
	call  LCD_INIT
	
	movui r3, 80			/* P */
	stwio r3, 4(r7)	
	movui r3, 65			/* A */
	stwio r3, 4(r7)	
	movui r3, 83			/* SS */
	stwio r3, 4(r7)
	stwio r3, 4(r7)
	movui r3, 87			/* W */
	stwio r3, 4(r7)	
	movui r3, 79			/* O */
	stwio r3, 4(r7)	
	movui r3, 82			/* R */
	stwio r3, 4(r7)
	movui r3, 68			/* D */
	stwio r3, 4(r7)
	movui r3, 32			/*   */
	stwio r3, 4(r7)	
	movui r3, 83			/* S */
	stwio r3, 4(r7)	
	movui r3, 69			/* E */
	stwio r3, 4(r7)	
	movui r3, 84			/* T */
	stwio r3, 4(r7)	
	
	br    DELAY2
UNMATCH:
	movia r22, 1
	/*call  RESET_PASSWORD1
	call  RESET_PASSWORD2*/
	call  LCD_INIT
	
	movui r3, 85			/* U */
	stwio r3, 4(r7)
	movui r3, 78			/* N */
	stwio r3, 4(r7)	
	movui r3, 77			/* M */
	stwio r3, 4(r7)			
	movui r3, 65			/* A */
	stwio r3, 4(r7)			
	movui r3, 84			/* T */
	stwio r3, 4(r7)	
	movui r3, 67			/* C */
	stwio r3, 4(r7)	
	movui r3, 72			/* H */
	stwio r3, 4(r7)	
	movui r3, 73			/* I */
	stwio r3, 4(r7)
	movui r3, 78			/* N */
	stwio r3, 4(r7)
	movui r3, 71			/* G */
	stwio r3, 4(r7)
	movui r3, 0xc0			/* Move to next line */
	stwio r3, 0(r7)
	movui r3, 80			/* P */
	stwio r3, 4(r7)	
	movui r3, 65			/* A */
	stwio r3, 4(r7)	
	movui r3, 83			/* SS */
	stwio r3, 4(r7)
	stwio r3, 4(r7)
	movui r3, 87			/* W */
	stwio r3, 4(r7)	
	movui r3, 79			/* O */
	stwio r3, 4(r7)	
	movui r3, 82			/* R */
	stwio r3, 4(r7)
	movui r3, 68			/* D */
	stwio r3, 4(r7)

	
DELAY2:
  	call  wait
ENTER2_EPI:
	call  LCD_INIT
	call  LCD_PROMPT
	ldw   ra,12(sp)
	ldw   r9,8(sp)
	ldw   r7,4(sp)
	ldw   r3,0(sp)
	addi  sp,sp,16
	ret



RANDINT:
	addi  sp,sp,-8
	stw   r3,0(sp)
	stw   ra,4(sp)
	movia r3,ADDR_RNG
SUBLOOP:	
	ldwio r2,0(r3)  /* Read from Random Number Generator */
	andi  r2,r2,0xF
  	beq   r2, r0, SUBLOOP
RAND_LOOP:  
	subi  r2,r2,3
	ble   r2,r0,RAND_RET
	br    RAND_LOOP  
RAND_RET:
	addi  r2,r2,3
	ldw   ra,4(sp)
	ldw   r3,0(sp)
	addi  sp,sp,8
	ret


RESET_PASSWORD:
	movia r19,password_buffer
	stw r0,0(r19)
	stw r0,4(r19)
	ret
	
RESET_PASSWORD1:
	movia r20,password_input1
	stw r0,0(r20)
	stw r0,4(r20)
	ret
	
RESET_PASSWORD2:
	movia r21,password_input2
	stw r0,0(r21)
	stw r0,4(r21)
	ret


PRINT_PSW:
	addi  sp, sp, -8
	stw   r3, 0(sp)
	stw   ra, 4(sp)
	call  LCD_INIT
	movia r19,password_buffer
PRINT_PSW_LOOP:	
	ldw   r3, 0(r19)
	beq   r3, r0, PRINT_PSW_EPI				
	stwio r3, 4(r7)	
	addi  r19, r19, 1
	br    PRINT_PSW_LOOP
PRINT_PSW_EPI:
	call  RESET_PASSWORD
	movui r3, 68			/* D */
	stwio r3, 4(r7)	
	ldw   ra, 4(sp)
	ldw   r3, 0(sp)
	addi  sp, sp, 8
	ret

CONVERT:
	addi  sp, sp, -12
	stw   r4, 0(sp)
	stw   r5, 4(sp)
	stw   ra, 8(sp)
	
	movui  r4,0x1C
	beq   r3,r4,IS_A
	movui  r4,0x32
	beq   r3,r4,IS_B
	movui  r4,0x21
	beq   r3,r4,IS_C
	movui  r4,0x23
	beq   r3,r4,IS_D
	movui  r4,0x24
	beq   r3,r4,IS_E
	movui  r4,0x2B
	beq   r3,r4,IS_F
	movui  r4,0x34
	beq   r3,r4,IS_G
	movui  r4,0x33
	beq   r3,r4,IS_H
	movui  r4,0x43
	beq   r3,r4,IS_I
	movui  r4,0x3B
	beq   r3,r4,IS_J
	movui  r4,0x42
	beq   r3,r4,IS_K
	movui  r4,0x4B
	beq   r3,r4,IS_L
	movui  r4,0x3A
	beq   r3,r4,IS_M
	movui  r4,0x31
	beq   r3,r4,IS_N
	movui  r4,0x44
	beq   r3,r4,IS_O
	movui  r4,0x4D
	beq   r3,r4,IS_P
	movui  r4,0x15
	beq   r3,r4,IS_Q
	movui  r4,0x2D
	beq   r3,r4,IS_R
	movui  r4,0x1B
	beq   r3,r4,IS_S
	movui  r4,0x2C
	beq   r3,r4,IS_T
	movui  r4,0x3C
	beq   r3,r4,IS_U
	movui  r4,0x2A
	beq   r3,r4,IS_V
	movui  r4,0x1D
	beq   r3,r4,IS_W
	movui  r4,0x22
	beq   r3,r4,IS_X
	movui  r4,0x35
	beq   r3,r4,IS_Y
	movui  r4,0x1A
	beq   r3,r4,IS_Z
	movui  r4,0x45
	beq   r3,r4,IS_0
	movui  r4,0x16
	beq   r3,r4,IS_1
	movui  r4,0x1E
	beq   r3,r4,IS_2
	movui  r4,0x26
	beq   r3,r4,IS_3
	movui  r4,0x25
	beq   r3,r4,IS_4
	movui  r4,0x2E
	beq   r3,r4,IS_5
	movui  r4,0x36
	beq   r3,r4,IS_6
	movui  r4,0x3D
	beq   r3,r4,IS_7
	movui  r4,0x3E
	beq   r3,r4,IS_8
	movui  r4,0x46
	beq   r3,r4,IS_9

IS_unknown:
	movui r2,63
	br CONVERT_EPI
IS_A:
	movui r2,65
	br CONVERT_EPI
IS_B:
	movui r2,66
	br CONVERT_EPI
IS_C:
	movui r2,67
	br CONVERT_EPI
IS_D:
	movui r2,68
	br CONVERT_EPI
IS_E:
	movui r2,69
	br CONVERT_EPI
IS_F:
	movui r2,70
	br CONVERT_EPI
IS_G:
	movui r2,71
	br CONVERT_EPI
IS_H:
	movui r2,72
	br CONVERT_EPI
IS_I:
	movui r2,73
	br CONVERT_EPI
IS_J:
	movui r2,74
	br CONVERT_EPI
IS_K:
	movui r2,75
	br CONVERT_EPI
IS_L:
	movui r2,76
	br CONVERT_EPI
IS_M:
	movui r2,77
	br CONVERT_EPI
IS_N:
	movui r2,78
	br CONVERT_EPI
IS_O:
	movui r2,79
	br CONVERT_EPI
IS_P:
	movui r2,80
	br CONVERT_EPI
IS_Q:
	movui r2,81
	br CONVERT_EPI
IS_R:
	movui r2,82
	br CONVERT_EPI
IS_S:
	movui r2,83
	br CONVERT_EPI
IS_T:
	movui r2,84
	br CONVERT_EPI
IS_U:
	movui r2,85
	br CONVERT_EPI
IS_V:
	movui r2,86
	br CONVERT_EPI
IS_W:
	movui r2,87
	br CONVERT_EPI
IS_X:
	movui r2,88
	br CONVERT_EPI
IS_Y:
	movui r2,89
	br CONVERT_EPI
IS_Z:
	movui r2,90
	br CONVERT_EPI
IS_0:
	movui r2,48
	br CONVERT_EPI
IS_1:
	movui r2,49
	br CONVERT_EPI
IS_2:
	movui r2,50
	br CONVERT_EPI
IS_3:
	movui r2,51
	br CONVERT_EPI
IS_4:
	movui r2,52
	br CONVERT_EPI
IS_5:
	movui r2,53
	br CONVERT_EPI
IS_6:
	movui r2,54
	br CONVERT_EPI
IS_7:
	movui r2,55
	br CONVERT_EPI
IS_8:
	movui r2,56
	br CONVERT_EPI
IS_9:
	movui r2,57
	br CONVERT_EPI
	
CONVERT_EPI:
	stw   ra, 8(sp)
	ldw   r4, 0(sp)
	ldw   r5, 4(sp)
	addi  sp, sp, 12
	ret
	
	
CHECK_PSW:
	addi  sp, sp, -20
	stw   r4, 0(sp)
	stw   r5, 4(sp)
	stw   r6, 8(sp)
	stw   r7, 12(sp)
	stw   ra, 16(sp)
	movia r6, password_buffer
	movia r7, password_input1
CHECKLOOP:
	ldw   r4, 0(r6)
	ldw   r5, 0(r7)
	bne   r4, r5, INVALID_PSW
	beq   r4, r0, VALID_PSW
	addi  r6, r6, 4
	addi  r7, r7, 4
	br    CHECKLOOP
INVALID_PSW:
	mov   r2, r0
	br    CHECK_EPI
VALID_PSW:
	movi  r2, 1
CHECK_EPI:
	ldw   ra, 16(sp)
	ldw   r7, 12(sp)
	ldw   r6, 8(sp)
	ldw   r5, 4(sp)
	ldw   r4, 0(sp)
	addi  sp, sp, 20
	ret

CHECK_PSW2:
	addi  sp, sp, -20
	stw   r4, 0(sp)
	stw   r5, 4(sp)
	stw   r6, 8(sp)
	stw   r7, 12(sp)
	stw   ra, 16(sp)
	movia r6, password_input1
	movia r7, password_input2
CHECKLOOP2:
	ldw   r4, 0(r6)
	ldw   r5, 0(r7)
	bne   r4, r5, UNMATCHING_PSW
	beq   r4, r0, MATCHING_PSW
	addi  r6, r6, 4
	addi  r7, r7, 4
	br    CHECKLOOP2
UNMATCHING_PSW:
	mov   r2, r0
	call  RESET_PASSWORD1
	call  RESET_PASSWORD2
	br    CHECK2_EPI
MATCHING_PSW:
	movi  r2, 1
CHECK2_EPI:
	ldw   ra, 16(sp)
	ldw   r7, 12(sp)
	ldw   r6, 8(sp)
	ldw   r5, 4(sp)
	ldw   r4, 0(sp)
	addi  sp, sp, 20
	ret
	


wait:
	addi sp,sp,-4
	stw r7,0(sp)

	movia r7,TIMER
	movi r2,0x0
	stwio r2,0(r7)
	movui r2,%lo(TIME)
	stwio r2,8(r7)
	movui r2,%hi(TIME)
	stwio r2,12(r7)

	movui r2,4
	stwio r2,4(r7)

wait_poll:
	movia r7,TIMER
	ldwio r7,0(r7)
	andi r7,r7,0x01
	beq r0,r7,wait_poll

wait_epi:
	ldw r7,0(sp)
	addi sp,sp,4
	ret

wait2:
	addi sp,sp,-4
	stw r7,0(sp)
			
	movia r7,TIMER
	movi r3,0x0
	stwio r3,0(r7)
			
	andi r3,r2,0xffff
	stwio r3,8(r7)
	srli r2,r2,16
	stwio r2,12(r7)


	movui r2,4
	stwio r2,4(r7)

wait2_poll:
	movia r7,TIMER
	ldwio r7,0(r7)
	andi r7,r7,0x01	
	beq r0,r7,wait_poll

wait2_epi:
	ldw r7,0(sp)
	addi sp,sp,4

	ret

door_open:
	addi sp,sp,-12
	stw ra,0(sp)
	stw r6,4(sp)
	stw r7,8(sp)

	movia r6,DOOR
	movui r7,0xff
	stwio r7,4(r6)
	movui r7,0b11111000
	stwio r7,0(r6)

	call wait	
	call door_stop
		
	ldw ra,0(sp)
	ldw r6,4(sp)
	ldw r7,8(sp)
	addi sp,sp,12
	
	ret

door_close:
	addi sp,sp,-12
	stw ra,0(sp)
	stw r6,4(sp)
	stw r7,8(sp)

	movia r6,DOOR
	movui r7,0xff
	stwio r7,4(r6)
	movui r7,0b11111010
	stwio r7,0(r6)

	call wait3	
	call emergency_open
	call door_stop
	
	ldw ra,0(sp)
	ldw r6,4(sp)
	ldw r7,8(sp)
	addi sp,sp,12
	
	ret

door_stop:
	addi sp,sp,-12
	stw ra,0(sp)
	stw r6,4(sp)
	stw r7,8(sp)

	movia r6,DOOR
	movui r7,0b11111001
	stwio r7,0(r6)

	ldw ra,0(sp)
	ldw r6,4(sp)
	ldw r7,8(sp)
	addi sp,sp,12
	
	ret

time_left:
	addi sp,sp,-12
	stw ra,0(sp)
	stw r7,4(sp)
	stw r3,8(sp)

   	movia r7,TIMER           
   	stwio r0,16(r7)              
   	ldwio r3,16(r7)              
   	ldwio r2,20(r7)              
   	slli  r2,r2,16		
   	or    r2,r2,r3

	ldw ra,0(sp)
	ldw r7,4(sp)
	ldw r3,8(sp)
	addi sp,sp,12
	ret

emergency_open:
	addi sp,sp,-12
	stw ra,0(sp)
	stw r6,4(sp)
	stw r7,8(sp)

	call time_left
	call door_stop

	movui r8,%lo(TIME)
	movui r3,%hi(TIME)
	slli  r3,r3,16
	or    r3,r3,r8
	sub   r2,r3,r2

	movia r6,DOOR
	movui r7,0xff
	stwio r7,4(r6)
	movui r7,0b11111000
	stwio r7,0(r6)
			
	call wait2
	call door_stop

	ldw ra,0(sp)
	ldw r6,4(sp)
	ldw r7,8(sp)
	addi sp,sp,12
	

	ret
	
sensor_init:

	movia r6,DOOR			/*turn on the lights/stop motor*/
	movui r7,0xff
	stwio r7,4(r6)
	movui r7,0b11111011
	stwio r7,0(r6)
	
	movia r6,SENSORB		/*activate sensor control*/
	movui r7,0xff
	stwio r7,4(r6)

	movia r6,SENSORC		/*set input/output ports*/
	movui r7,0x0f
	stwio r7,4(r6)
	
	movia r6,SENSORB		/*prepare to load the treshold*/
	movui r7,0xde
	stwio r7,0(r6)

	movia r6,SENSORC		/*load the treshold*/
	movui r7,0x1
	stwio r7,0(r6)

	movia r6,SENSORB		/*flush register B*/
	movi  r7,0xff                 
	stwio r7,0(r6)
	
	movi  r7,0xef			 /*activate state mode*/             
	stwio r7,0(r6)
	
	movia r6,SENSORC		/*enable interrupts on sensor 1*/
	movui r7,0x1f
	stwio r7,8(r6)
	
	ret


/**************** INTERRUPT HANDLER ****************/
.section .exceptions, "ax"
IHANDLER:
	addi  sp, sp, -4
	stw   ra, 0(sp)


	rdctl et, ctl4				/* Check that interrupt was caused by	*/
	beq et, r0, SKIP_EA_DEC			/* hardware, otherwise return.		*/

	movia r7, PS2				/* Check that interrupt was caused by	*/
	ldwio r8, 4(r7)				/* PS2 port, otherwise return.		*/
	andi r8, r8, 0x100
	beq r8, r0, SKIP_EA_DEC

Receive_byte:
	ldwio r8, 0(r7)				/* Load first byte from PS/2		*/

	andhi r9, r8, 0xffff			/* Check if data is valid		*/
	beq r9, r0, SKIP_EA_DEC

	andi r8, r8, 0xff			/* Byte of data loaded			*/
	
	movui r10,0xfa				/* filter out initial response signals from keyboard */
	beq r8,r10,SKIP_EA_DEC		
	movui r10,0xaa
	beq r8,r10,SKIP_EA_DEC	
	movui r10,0xfe
	beq r8,r10,SKIP_EA_DEC			
	
	movui r10,0xf0				/* check for break code */
	beq r8,r10,break_code		
	beq r18,r0,skip_break			/* skip break code following F0 */
	
	movia r7,ADDR_7SEG			/* for debugging */
	stwio r8,0(r7)
	
	movui r12, 1
	beq r12, r22, mode1
	movui r12, 2
	beq r12, r22, mode2
	movui r12, 3
	beq r12, r22, mode3
	
mode1:
	movi r11, 0x5A				/* key pressed is enter */
	beq r8, r11, validate1
	
	beq r8, r0, SKIP_EA_DEC		
	
	call LCD_PRINT2				/* display character */
	br Push_byte1

validate1:
	beq r8, r0, SKIP_EA_DEC
	call ENTER1
	br SKIP_EA_DEC

Push_byte1:
	bne r23,r0,overflowHandler
	stw r8,0(r20)
	addi r20,r20,4
	stw r0,0(r20)
	br SKIP_EA_DEC
	
	

mode2:
	movi r11, 0x5A				/* key pressed is enter */
	beq r8, r11, validate2
	
	beq r8, r0, SKIP_EA_DEC		
	
	call LCD_PRINT2				/* display character */
	br Push_byte2

validate2:
	beq r8, r0, SKIP_EA_DEC
	call ENTER2
	br SKIP_EA_DEC

Push_byte2:
	bne r23,r0,overflowHandler
	stw r8,0(r21)
	addi r21,r21,4
	stw r0,0(r21)
	br SKIP_EA_DEC


mode3:

	movi r11, 0x5A				/* key pressed is enter */
	beq r8, r11, validate3
	
	beq r8, r0, SKIP_EA_DEC		
	
	call LCD_PRINT				/* display character */
	br Push_byte3

validate3:
	beq r8, r0, SKIP_EA_DEC
	call ENTER
	br SKIP_EA_DEC

Push_byte3:
	bne r23,r0,overflowHandler
	stw r8,0(r19)
	addi r19,r19,4
	stw r0,0(r19)
	br SKIP_EA_DEC


overflowHandler:
	movui r23, 0
	br SKIP_EA_DEC


break_code:
	movui r18,0
	br SKIP_EA_DEC

skip_break:
	movui r18,1

SKIP_EA_DEC:
	ldw ra, 0(sp)
	addi  sp, sp, 4
	subi ea, ea, 4
	eret

.data


password_input1:
	.skip 44
	
password_input2:
	.skip 44

password_buffer:
	.skip 132
