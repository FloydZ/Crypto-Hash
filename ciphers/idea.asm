comment ~

IDEA / IPES

wielkosc bloku : 8 bajtow
dlugosc klucza : 16 bajtow

szyfrowanie:
	invoke	IdeaExpandKey, ADDR _key			;ustawienie klucza
								;raz ustawiony klucz moze byc wykorzystany kilka razy
								;klucz jest 'tracony' dla szyfrowania po wywolaniu
								;IdeaInvertKey lub IdeaClear
	invoke	IdeaCrypt, ADDR _data_out, ADDR _data_in
	invoke	IdeaClear					;czyszczenie wewnetrznych danych
								;uzyj tylko raz po zakonczeniu wszystkich czynnosci

deszyfrowanie:
	invoke	IdeaExpandKey, ADDR _key			;ustawienie klucza
	invoke	IdeaInvertKey					;przystosowanie go do deszyfrowania
	invoke	IdeaCrypt, ADDR _data_out, ADDR _data_in
	invoke	IdeaClear


Procedura IdeaExpandKey to nieznacznie przerobiony kod z tiny Idea by Fauzan Mirza.
Procedura IdeaCrypt zoptymalizowana jest wedlug pomyslu Paulo Barreto.

WiteG//xtreeme

~

IdeaExpandKey	PROTO	:DWORD
IdeaInvertKey	PROTO
IdeaClear	PROTO
IdeaCrypt	PROTO	:DWORD, :DWORD


lKey	equ	2*(6*8+4)

.data?
internalPass	dw (6*8 + 4) dup (?)
internalDePass	dw (6*8 + 4) dup (?)
count		dd ?
_ptrOut		dd ?
s2		dw ?
s3		dw ?

.code
IdeaExpandKey	proc	ptrPass:DWORD

	pushad
	mov	esi, ptrPass
	mov	edi, offset internalPass

	mov	eax, dword ptr [esi]
	mov	edx, dword ptr [esi+4]

	mov	dword ptr [edi], eax
	mov	dword ptr [edi+4], edx

	mov	eax, dword ptr [esi+8]
	mov	edx, dword ptr [esi+12]

	mov	dword ptr [edi+8], eax
	mov	dword ptr [edi+12], edx

	add     edi,16-2
	mov     bx,8
@@keyloop:
	add	edi, 2
	mov     ax,bx                   ; Determine which two of the previous
	and     al,7                    ;  eight words are needed for this
	cmp     al,6                    ;  key expansion round
	ja      @@above
	jb      @@below
	mov     ax,word ptr [edi-14]
	mov     dx,word ptr [edi-28]
	jmp     @@update
@@above:
	mov     ax,word ptr [edi-30]
	mov     dx,word ptr [edi-28]
	jmp     @@update
@@below:
	mov     ax,word ptr [edi-14]
	mov     dx,word ptr [edi-12]
@@update:
	shl     ax,9
	shr     dx,7                   ; Calculate the rotated value
	inc     bl
	or      ax,dx                   ; ax = (ax << 9) | (dx >> 7)
	cmp     bl,52
	mov	word ptr [edi], ax
	jnz	@@keyloop

	popad
	ret
IdeaExpandKey	endp

IdeaInvertKey	proc
	pushad

	movzx	eax, word ptr [internalPass + 3*2]
	call	InvMul

	mov	word ptr [internalDePass + lKey - 1*2], ax

	mov	bx, word ptr [internalPass + 2*2]
	mov	cx, word ptr [internalPass + 1*2]

	neg	bx
	neg	cx

	mov	word ptr [internalDePass + lKey - 2*2], bx
	mov	word ptr [internalDePass + lKey - 3*2], cx

	mov	ax, word ptr [internalPass + 0*2]
	call	InvMul
	mov	word ptr [internalDePass + lKey - 4*2], ax

	mov	edi, offset internalDePass + lKey - 4*2
	mov	esi, offset internalPass + 2*4
	mov	cl, 7

@@:
	mov	ax, word ptr [esi + 1*2]
	mov	bx, word ptr [esi + 0*2]

	mov	word ptr [edi - 1*2], ax
	mov	word ptr [edi - 2*2], bx

	mov	ax,  word ptr [esi + 5*2]
	call	InvMul
	mov	word ptr [edi - 3*2], ax

	mov	bx, word ptr [esi + 3*2]
	mov	dx, word ptr [esi + 4*2]

	neg	bx
	neg	dx

	mov	word ptr [edi - 4*2], bx
	mov	word ptr [edi - 5*2], dx

	mov	ax, word ptr [esi + 2*2]
	call	InvMul
	mov	word ptr [edi - 6*2], ax

	add	esi, 12
	sub	edi, 12
	
	dec	cl
	jnz	@B

	mov	ax, word ptr [esi + 1*2]
	mov	bx, word ptr [esi + 0*2]

	mov	word ptr [edi - 1*2], ax
	mov	word ptr [edi - 2*2], bx

	mov	ax,  word ptr [esi + 5*2]
	call	InvMul
	mov	word ptr [edi - 3*2], ax

	mov	bx, word ptr [esi + 4*2]
	mov	dx, word ptr [esi + 3*2]

	neg	bx
	neg	dx

	mov	word ptr [edi - 4*2], bx
	mov	word ptr [edi - 5*2], dx

	mov	ax, word ptr [esi + 2*2]
	call	InvMul
	mov	word ptr [edi - 6*2], ax

	mov	esi, offset internalDePass
	mov	edi, offset internalPass
	mov	ecx, lKey/4

	cld
	rep	movsd
	popad
	ret
IdeaInvertKey	endp

InvMul		proc
	cmp	eax, 1
	jbe	@@done

	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi

	mov	esi, 1
	mov	ecx, eax
	xor	ebx, ebx
	mov	edi, 10001h
@@:
	mov	eax, edi
	cdq
	idiv	ecx

	test	edx, edx
	jz	@F

	imul	eax, esi
	sub	ebx, eax

	mov	eax, esi
	mov	edi, ecx
	mov	esi, ebx
	mov	ecx, edx
	mov	ebx, eax
	jmp	@B

@@:
	test	esi, esi
	jge	@F

	add	esi, 10001h
@@:
	mov	eax, esi

	pop	edi
	pop	esi
	pop	edx
	pop	ecx
	pop	ebx
@@done:
	ret
InvMul		endp

IdeaCrypt	proc	ptrOut:DWORD, ptrIn:DWORD

	pushad
	
	mov	eax, ptrOut
	mov	esi, ptrIn

	mov	_ptrOut, eax

	mov	bx, word ptr [esi]	; x1
	mov	cx, word ptr [esi+2]	; x2
	mov	di, word ptr [esi+4]	; x3
	mov	bp, word ptr [esi+6]	; x4

	mov	count, 8
	mov	esi, offset internalPass

@@mainloop:
	mov	ax, bx
	mul	word ptr [esi]		;MUL(x1,*key++)				;mul mod 2^16 + 1
	sub	ax, dx
	jnz	@F

	inc	eax			;inc eax = 1B; inc al, inc ax = 2B
        sub	ax, bx
       	sub	ax, word ptr [esi]
	clc
@@:
	adc	ax, 0

	add	di, [esi+4]		;x3 += *key++;  tu kolejnosc odwrocona
	add	cx, [esi+2]		;x2 += *key++;

	mov	s3, di			;s3 = x3;
	mov	bx, ax			;

	xor	ax, di			;x3 ^= x1;
       	mul	word ptr [esi+8]	;MUL(x3, *key++);
        sub	ax, dx
	jnz	@F

	mov	ax, bx
	xor	ax, di
	neg	ax
	inc	ax
	sub	ax, word ptr [esi+8]
	clc
@@:
	adc	ax, 0
	mov	di, ax			;x3
	mov	s2, cx			;s2 = x2;

	mov	ax, bp
	mul	word ptr [esi+6]	;MUL(x4, *key++);
	sub	ax, dx
	jnz	@F

	inc	eax
	sub	ax, bp
	sub	ax, word ptr [esi+6]
	clc
@@:
	adc	ax, 0
	mov	bp, ax			;x4
		
	xor	ax, cx			;x2 ^= x4;
	add	ax, di			;x2 += x3;

	mul	word ptr [esi+10]	;MUL(x2, *key++);
	sub	ax, dx
	jnz	@F

	mov	ax, bp
	xor	ax, cx
	add	ax, di
	neg	ax
	inc	ax
	sub	ax, word ptr [esi+10]
	clc
@@:
	adc	ax, 0			;x2

	add	di, ax			;x3 += x2;

	xor	bx, ax			;x1 ^= x2
	xor	bp, di			;x4 ^= x3
	xor	ax, s3			;x2 ^= s3
	xor	di, s2			;x3 ^= s2
	mov	cx, ax			;x2

	add	esi, 12
	dec	count
	jne	@@mainloop

	mov	esi, _ptrOut

	add	di, word ptr [internalPass+8*12+2]	;x3 += *key++;
	add	cx, word ptr [internalPass+8*12+4]	;x2 += *key++;

	mov	word ptr [esi+2], di
	mov	word ptr [esi+4], cx

	mov	ax, bx
	mul	word ptr [internalPass+8*12]
        sub	ax, dx
        jnz	@F

	inc	eax
       	sub	ax, bx
        sub	ax, [internalPass+8*12]
	clc
@@:
	adc	ax, 0
	mov 	word ptr [esi], ax       		;= y1

       	mov	ax, bp
        mul	word ptr [internalPass+8*12+6]
        sub	ax, dx
        jnz	@F

	inc	eax
       	sub	ax, bp
       	sub	ax, word ptr [internalPass+8*12+6]
	clc
@@:
	adc	ax, 0
	mov	[esi+6], ax				;= y4

	popad
	ret
IdeaCrypt	endp

IdeaClear	proc
	push	eax
	push	ecx
	push	edi

	xor	eax, eax
	mov	ecx, 55
	mov	edi, offset internalPass

	cld
	rep	stosd

	pop	edi
	pop	ecx
	pop	eax
	ret
IdeaClear	endp