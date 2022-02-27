.model tiny
.code
org 100h

VIDEOSEG	equ 0b800h 			; DEFINE

.getch		macro				; MACROS
		xor ah, ah			; ah = 0
		int 16h				; waiting keyboard
		endm				; end macro

Start:		mov ax, VIDEOSEG
		mov es, ax
	 
		.getch
		
		mov bx, (15*80d + 40d) * 2	; center of 5th string (2 because there is 2 bytes to store symbol)
		
		mov byte ptr es:[bx], 'A'	; put 'A' in address bx
		
									;mov word ptr es:[bx], 'A' or 4e00h ; <- insted of: mov byte...
		
		.getch

		mov byte ptr es:[bx + 1], 2eh	; makes yelow char in red font

		.getch

		mov ah, 4ch				; exit(0)
		int 21h

		end Start