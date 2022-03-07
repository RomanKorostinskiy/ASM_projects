.186
.model tiny
.code
org 100h

RED_YELLOW	= 4eh

Start:		mov di, 0b800h
			mov es, di
			mov di, (5* 80 + 80/2) * 2
			mov ah, RED_YELLOW
			cld

Next:		in al, 60h		; read from keyboard port
			stosw			; mov es:[di], ax
			and di, 0FFFh 	; ограничиваем адреса для печати (символы не выходят за пределы экрана)

			mov cx, 0FFFFh
			nop
Delay:		nop
			loop delay

			cmp al, 1		; waiting for esc
			jne Next

			mov ax, 4c00h
			int 21h

end 		Start