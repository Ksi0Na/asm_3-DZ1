use16
org 0x100

printer:					;вывод смещенной строки
	push cx
	xor cx, cx
	inc cl
	
	call get_str_len
	mov ax, 0xb800
	mov es, ax
	
	call do_magic
	mov bh, 0xE4
	
	mov cl, 80
	print_str:				;просто вывод строки
		cmp si, [str_len]
		je do_1
		jne not_do_1
		do_1:				;если конец строки, то перекидываю на начало строки
			mov si, 1
			mov dx, 0
		not_do_1:
			add si, dx
		
			mov bl, [ds:si]
			;mov bl, 'Ten min'
			
			mov word[es:di], bx
			add di, 2
			
			inc dx					;dx нужен только для вывода строки
			
			mov si, [si_1]			;si нужен для смещения строки
		
	loop print_str
	mov si, [si_1]
	pop cx 
	call _delay
loop printer
int 0x20

do_magic:
	mov si, msg
	inc si					;смещаю начало строки 
	cmp si, [str_len]
	je do_1_now
	jne not_do_1_now
	do_1_now:				;если конец строки, то перекидываю на начало строки
		mov si, 1
	not_do_1_now:
		mov [si_1], si			;сохраняю
		mov dx, 0
		mov di, 0
	ret

get_str_len:
	pusha
	push si
	
	mov si, msg
	mov cl, 1
	counter:
		inc ax
		call check_end
		inc cl
	loop counter
	mov [str_len], ax
	
	pop si
	popa 
	ret

check_end:
	mov dl, [ds:si]
	inc si
	cmp dl, '$' 		
	je is_end
is_end:
	dec cl
	dec al
	ret

_delay:
	pusha
	mov ah, 0
	int 0x1a
_wait:
	push dx
	mov ah, 0
	int 0x1a
	pop bx
	cmp bx, dx
	je _wait
	popa
	ret
	
	;$Annushka has already bought the sunflower oil, and has not only bought it, but has already spilled it.   $
	
str_len dw 0
si_1 dw 0
msg db '$Annushka   $'