.model tiny
.code
org 100h

VIDEOSEG_ADR		equ 0b800h
CONSOLE_WIDE	 	= 80
CONSOLE_HEIGHT	 	= 24
MIDLE_OF_CONSOLE 	= ((CONSOLE_HEIGHT/2) * CONSOLE_WIDE + CONSOLE_WIDE/2) * 2
RED_WHITE		 	= 4fh

Start:		push offset String
			call Strlen
			
			mov ax, VIDEOSEG_ADR
			mov es, ax
			push bx
			call Itoa
			
			mov ax, 4ch
			int 21h
			
;------------------
; Entry: Stack: string offset -> [bp + 4]
; Exit: BX = string len
; Destr: SI, BX
;------------------
	
Strlen proc
			push bp
			mov bp, sp
			
			mov si, [bp + 4]
			
			xor bx, bx
NextSym:	cmp byte ptr ds:[si], '$'
			inc bx
			inc si
			jne NextSym
			
			pop bp
			ret
			endp
			
;------------------
; Entry: Stack: integer -> [bp + 4]
; Exit: BX = string offset
; Note: ES = video segment addr
; Destr: AX, BX, SI, DI
;------------------
			
Itoa proc
			push bp
			mov bp, sp
			
			mov di, MIDLE_OF_CONSOLE
			
Continue:	mov ax, [bp + 4]
			mov bx, 10
			div bx
			mov [bp + 4], ax	; save quotient
			
			add dx, '0'
			mov al, dl
			mov ah, RED_WHITE
			stosw
			
			cmp byte ptr [bp + 4], 0
			je Stop
			jmp Continue
			
Stop:		pop bp
			ret
			endp
			
String: db "cringe$"
			
			end Start