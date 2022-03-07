.186
.model tiny
.code
org 100h

jumps

F_1		= 11D0h
F_2		= 10D0h
F_3		= 0FDFh
F_4		= 0EFBh
F_5		= 0E23h
F_6		= 0D58h
F_7		= 0C98h
F_8		= 0BE3h
F_9		= 0B39h
F_10	= 0A97h
F_11	= 09FFh
F_12	= 970h

Start:		call PianoProc

			mov ax, 4ch
			int 21h
			
;------------------
; Entry:
; Exit:
; Destr: AX, DI
;------------------
PianoProc proc
Next:		in al, 60h
			
			cmp al, 80h
			jae StopSound
			
			cmp al, 0dh			; skip other scan codes
			ja Next
			
			cmp al, 01h
			je EndProgram
			
			call GetFreqPosProc
			call PlaySoundProc
			
StopSound:	call StopSoundProc

			jmp Next

EndProgram:
			call StopSoundProc
			
			ret
			endp

;------------------
; Entry: AL = Scan Code
; Exit: DI = Freq Position
; Destr: AX
;------------------
		
GetFreqPosProc proc
			sub al, 2
			shl al, 1
			mov di, ax
			
			ret
			endp

;------------------
; Entry: DI = scan code
; Exit: None
; Destr: AX
;------------------			
PlaySoundProc	proc
			mov al, 0b6h						; 0b6h = 10110110b
			out 43h, al							; set port 43h of timer
			mov al, byte ptr FreqArray[di]		; low bytes of divisor
			out 42h, al
			mov al,  byte ptr FreqArray[di + 1]		
			out 42h, al
			
			in al, 61h				
			or al, 3h							; enable speaker by seting bit 1 ; set timer to speaker by seting bit 0
			out 61h, al
			
			ret
			endp
			
;------------------
; Entry: Stack: Freq Divider -> [bp + 4]
; Exit: None
; Destr: AX
;------------------	

StopSoundProc	proc
			
			in al, 61h				
			and al, 0FCh				; clear bits 1 and 0
			out 61h, al

			ret
			endp
			
FreqArray dw F_1, F_2, F_3, F_4, F_5, F_6, F_7, F_8, F_9, F_10, F_11, F_12
			
end 		Start