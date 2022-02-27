.model tiny
.code
org 100h

Start:
mov dx, offset String 
mov ah, 09h
int 21h
mov ah, 4ch
int 21h

String db 'le cringe$'

end Start																																																																																																																																										