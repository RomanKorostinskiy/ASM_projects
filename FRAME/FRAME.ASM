.model tiny
.code
org 100h

CONSOLE_WIDE	 = 80
CONSOLE_HEIGHT	 = 24

FRAME_WIDE 		 = 70
FRAME_HEIGHT	 = 10

FRAME_START 	 = (((CONSOLE_HEIGHT - FRAME_HEIGHT)/2) * CONSOLE_WIDE + (CONSOLE_WIDE - FRAME_WIDE)/2) * 2
MIDLE_OF_CONSOLE = ((CONSOLE_HEIGHT/2) * CONSOLE_WIDE + CONSOLE_WIDE/2) * 2

GREEN_YELLOW	 = 2eh
RED_WHITE		 = 4fh

VIDEOSEG_ADR	equ 0b800h

.press_key	macro
			xor ah, ah
			int 16h
			endm

Start:		mov ax, VIDEOSEG_ADR
			mov es, ax
			
			mov ah, 01h
			int 21h
			
			cmp al, '1'
			je Frame1
			
			cmp al, '2'
			je Frame2
			
			call InvalidInput
			jmp EndOfProgram
			
Frame1:		push GREEN_YELLOW
			push offset ArrayTop1
			push offset ArrayMid1
			push offset ArrayBot1
			call DrawTable
			
			mov si, offset ArrayAnekdot1								; set addr of line array
			mov di, MIDLE_OF_CONSOLE - SIZEOF_ArrayAnekdot1/ 2 * 2		;start addr to draw
			mov cx, SIZEOF_ArrayAnekdot1								;set line length
			mov ah, GREEN_YELLOW										;set color
			call DrawLine
			
			jmp EndOfProgram
			
Frame2:		push RED_WHITE
			push offset ArrayTop2
			push offset ArrayMid2
			push offset ArrayBot2
			call DrawTable
			
			mov si, offset ArrayAnekdot2								; set addr of line array
			mov di, MIDLE_OF_CONSOLE - SIZEOF_ArrayAnekdot2/ 2 * 2		;start addr to draw
			mov cx, SIZEOF_ArrayAnekdot2								;set line length
			mov ah, RED_WHITE		  									;set color
			call DrawLine
			
			jmp EndOfProgram
			
EndOfProgram: .press_key
			
			mov ax, 4ch
			int 21h

;------------------
; Entry: Stack: ColorCode -> [bp + 10], offset ArrayTop -> [bp + 8], offset ArrayMid -> [bp + 6], offset ArrayBot-> [bp + 4]
; Exit: None
; Note: ES = video segment addr
; Destr: AX, CX, SI, DI
;------------------

DrawTable proc
			push bp
			mov bp, sp
			
			cld

			mov si, [bp + 8]
			mov ax, 0
			call GetStartAddr
			mov cx, FRAME_WIDE
			mov ah, [bp + 10]
			call DrawLine
			
			
			mov bx, 1
PrintFrame: mov si, [bp + 6]
			mov ax, bx
			call GetStartAddr
			mov cx, FRAME_WIDE
			mov ah, [bp + 10]
			call DrawLine
			inc bx
			cmp bx, FRAME_HEIGHT - 2
			jbe PrintFrame
			
			
			mov si, [bp + 4]
			mov ax, FRAME_HEIGHT - 1
			call GetStartAddr
			mov cx, FRAME_WIDE
			mov ah, [bp + 10]
			call DrawLine
			
			pop bp
			ret
			endp
			

;------------------
; Entry: DI = start addr to draw, SI = addr of line array, CX = line length, AH = color
; Exit: None
; Note: ES = video segment addr
; Destr: AX, CX, SI, DI
;------------------

DrawLine proc
			cld
			
NextSym:	lodsb
			stosw
			loop NextSym		; print horisontal line
			
			ret
			endp
			
;------------------
; Entry: AX = number of string
; Exit: DI = start addr to draw
; Destr: AX, DX, DI
;------------------
			
GetStartAddr proc
			mov dx, CONSOLE_WIDE * 2
			mul dx
			add ax, FRAME_START
			mov di, ax

			ret
			endp
			
;------------------
; Entry: -
; Exit: -
; Note: ES = video segment addr
; Destr: SI, DI, CX, AX 
;------------------
			
InvalidInput proc
			mov si, offset ArrayInvalidInput							; set addr of line array
			mov di, MIDLE_OF_CONSOLE - SIZEOF_ArrayInvalidInput / 2 * 2	;start addr to draw
			mov cx, SIZEOF_ArrayInvalidInput							;set line length
			mov ah, RED_WHITE											;set color
			call DrawLine
			
			ret
			endp
			
			
ArrayTop1: db 0dah, FRAME_WIDE - 2 dup(0c4h), 0bfh
ArrayMid1: db 0b3h, FRAME_WIDE - 2 dup(' '), 0b3h
ArrayBot1: db 0c0h, FRAME_WIDE - 2 dup(0c4h), 0d9h

ArrayTop2: db 0c9h, FRAME_WIDE - 2 dup(0cdh), 0bbh
ArrayMid2: db 0bah, FRAME_WIDE - 2 dup(' '), 0bah
ArrayBot2: db 0c8h, FRAME_WIDE - 2 dup(0cdh), 0bdh

ArrayInvalidInput: db "Invalid input: only mode 1 and 2 are available"
SIZEOF_ArrayInvalidInput equ $ - ArrayInvalidInput

ArrayAnekdot1: db "Kupil muzhik shlyapu, a ona emu kak raz"
SIZEOF_ArrayAnekdot1 equ $ - ArrayAnekdot1

ArrayAnekdot2: db "SHyol medved' po lesu. Vidit: mashina gorit. Sel v neyo i sgorel."
SIZEOF_ArrayAnekdot2 equ $ - ArrayAnekdot2

			end Start