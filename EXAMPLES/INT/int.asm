.186
.model tiny
.code
org 100h

RED_YELLOW	= 4eh

Start:		cli							; <- опустить пониже ; стираем флаг отвечающий за внешние прерывания (непонятно зачем)
			xor di, di
			mov es, di
			mov di, 09h * 4				; кладем адрес из таблицы прерываний

			mov ax, es:[di]				; взяли адрес старого обработчика
			mov old09Ofs, ax			;
			mov ax, es:[di+2]
			mov old09Seg, ax			; сохранили адрес старого обработчика


			mov es:[di], offset New09
			push cs						; просто так не получится замувать
			pop ax
			mov es:[di+2], ax
			sti							; обратно разрешить внешние прерывания

DoWait:		;in al, 60h
			;cmp al, 1
			;jne DoWait

			;mov ax, 4c00h
			mov ax, 3100h		; нужно чтобы программа оставалась в памяти
			mov dx, offset HappyEnd
			shr dx, 4 			; поделить на 16 (побитовый сдвиг на 4)
			inc dx
			int 21h

;-------------------------------------------------Это был код вставки в таблицу прерываний

New09		proc			; обработчик прерывания
			push ax di es	; сохраняем регистры

			mov di, 0b800h
			mov es, di
			mov di, (5* 80 + 80/2) * 2
			mov ah, RED_YELLOW
			cld

Next:		;in al, 60h		; read from keyboard port
			;stosw			; mov es:[di], ax

			;in al, 61h		; Send ACK(подтверждение) to kybd
			;mov ah, al
			;or al, 80h 		; выставляем старший бит
			;out 61h, al
			;mov al, ah
			;out 61h, al

			;mov al, 20h		; Send EOI(end of interrupt)
			;out 20h, al		

			pop es di ax	; восстанавливаем регистры
			;iret			; возврат из прерывания
			;endp

			db 0EAh
old09Ofs:	dw 0
old09Seg:	dw 0
			endp

;-------------------------------------------------

HappyEnd:

end 		Start