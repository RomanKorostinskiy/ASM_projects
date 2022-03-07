.186
.model tiny
.code
org 100h

BLACK_YELLOW = 0ah

jumps ; автоматически выполняет преобразование условных jump-ов

Start:		;mov ah, 2509h			; Set new ISR(процедура обработки прерываний) 09h
			;mov dx, offset New09	; ds = cs: model tiny
			;int 21h
			
;					ccssmmm
			mov al, 10110110b		; настраиваем порт 43h таймера (b6h)
			out 43h, al
			mov al, 90h
			out 42h, al
			mov al, 0ah
			out 42h, al
			
			in al, 61h				
			or al, 3
			out 61h, al
			
			;mov ax, 3100h			; TSR
			;mov dx, offset EOP
			;shr dx, 4
			;inc dx
			mov ax, 4ch
			int 21h
			
New09		proc
			push ax di es
		
			mov ax, 0b800h
			mov es, ax
		
			mov di, (12*80 + 40) * 2
			mov ah, BLACK_YELLOW
			in al, 60h
			stosw
			
			in al, 61h ; нужно мигнуть старшим битом чтобы клава поняла что мы считали скан код
			or al, 80h ; мигаем саршим битом
			xor al, 01h
			out 61h, al
			and al, not 80h
			out 61h, al
			
			in al, 20h
			or al, 20h
			out 20h, al
			
			endp
		

end 		Start