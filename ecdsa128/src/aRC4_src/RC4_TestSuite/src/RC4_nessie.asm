.686p
.mmx
.model flat,stdcall
option casemap:none

include g:\masm32\include\windows.inc
include g:\masm32\include\user32.inc
include g:\masm32\include\kernel32.inc
include g:\masm32\include\oleaut32.inc
include g:\masm32\include\comctl32.inc
include g:\masm32\include\advapi32.inc
includelib g:\masm32\lib\user32.lib
includelib g:\masm32\lib\kernel32.lib
includelib g:\masm32\lib\oleaut32.lib
includelib g:\masm32\lib\comctl32.lib
includelib g:\masm32\lib\advapi32.lib

include	..\lib\rc4.inc
include	..\lib\utils.inc

printSeparator	PROTO
printSet	PROTO	:DWORD, :DWORD, :DWORD, :DWORD
printBytes	PROTO	:DWORD, :DWORD
printString	PROTO	:DWORD
xorStream	PROTO	:DWORD, :DWORD

.data
szIntro	db "********************************************************************************",00dh,00ah
	db "*Project NESSIE - New European Schemes for Signature, Integrity, and Encryption*",00dh,00ah
	db "********************************************************************************",00dh,00ah
	db 00dh,00ah
	db "Primitive Name: Rc4 (arcfour)",00dh,00ah
	db "=============================",00dh,00ah
	db "Key size: 128 bits",00dh,00ah
	db "No initial value (IV) mode",00dh,00ah
	db 00dh,00ah,000h
szTVSt1	db "Test vectors -- set 1",00dh,00ah,"=====================",00dh,00ah,00dh,00ah,000h
szTVSt2	db "Test vectors -- set 2",00dh,00ah,"=====================",00dh,00ah,00dh,00ah,000h
szTVSt3	db "Test vectors -- set 3",00dh,00ah,"=====================",00dh,00ah,00dh,00ah,000h
szTVSt4	db "Test vectors -- set 4",00dh,00ah,"=====================",00dh,00ah,00dh,00ah,000h
szSet1	db "Set 1, vector#%3d:",00dh,00ah,000h
szSet2	db "Set 2, vector#%3d:",00dh,00ah,000h
szSet3	db "Set 3, vector#%3d:",00dh,00ah,000h
szSet4	db "Set 4, vector#%3d:",00dh,00ah,000h
szKey	db "                           key=",0
szStm1	db "                 stream[0..63]=",0
szStm2	db "              stream[192..255]=",0
szStm3	db "              stream[256..319]=",0
szStm4	db "              stream[448..511]=",0
szStm5	db "           stream[0..511]xored=",0
szStm6	db "          stream[65472..65535]=",0
szStm7	db "          stream[65536..65599]=",0
szStm8	db "        stream[131008..131071]=",0
szStm9	db "        stream[0..131071]xored=",0
szNull	db "                               ",0
szOutro	db 00dh,00ah,00dh,00ah,"End of test vectors",00dh,00ah,0

.data?
_BUFFER	db 512 dup (?)
_KEY	db 16 dup (?)

.code
start:
	pushad

	invoke	GetStdHandle, STD_OUTPUT_HANDLE
	invoke	SetConsoleScreenBufferSize, eax, 3C000051h

	invoke	printString, offset szIntro

;------------------------------------------------------------

	invoke	printString, offset szTVSt1

	xor	ebx, ebx
@@:
	push	ebx
	push	offset szSet1
	push	offset _BUFFER
	call	wsprintfA
	add	esp, 3*4

	invoke	printString, offset _BUFFER

	call	clearStream

	and	dword ptr [_KEY   ], 0
	and	dword ptr [_KEY+ 4], 0
	and	dword ptr [_KEY+ 8], 0
	and	dword ptr [_KEY+12], 0

	mov	eax, ebx
	shr	eax, 3
	mov	ecx, ebx
	and	ecx, 7
	neg	ecx
	add	ecx, 7
	mov	edx, 1
	shl	edx, cl
	mov	dword ptr [_KEY+eax], edx

	invoke	printString, offset szKey
	invoke	printBytes, offset _KEY, 16

	invoke	rc4_setkey, offset _KEY, 16
	invoke	rc4_crypt, offset _BUFFER, 512

	invoke	printString, offset szStm1
	invoke	printBytes, offset _BUFFER, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+16, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+32, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+48, 16

	invoke	printString, offset szStm2
	invoke	printBytes, offset _BUFFER+192, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+208, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+224, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+240, 16

	invoke	printString, offset szStm3
	invoke	printBytes, offset _BUFFER+256, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+272, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+288, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+304, 16

	invoke	printString, offset szStm4
	invoke	printBytes, offset _BUFFER+448, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+464, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+480, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+496, 16

	invoke	xorStream, offset _BUFFER, 512

	invoke	printString, offset szStm5
	invoke	printBytes, offset _BUFFER, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+16, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+32, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+48, 16

	invoke	printSeparator

	inc	ebx
	cmp	ebx, 128
	jnz	@B

;------------------------------------------------------------

	invoke	printString, offset szTVSt2

	xor	ebx, ebx
@loop2:
	push	ebx
	push	offset szSet2
	push	offset _BUFFER
	call	wsprintfA
	add	esp, 3*4

	invoke	printString, offset _BUFFER

	call	clearStream

	xor	ecx, ecx
@@:	mov	byte ptr [_KEY+ecx], bl
	inc	ecx
	and	ecx, 0Fh
	jnz	@B

	invoke	printString, offset szKey
	invoke	printBytes, offset _KEY, 16

	invoke	rc4_setkey, offset _KEY, 16
	invoke	rc4_crypt, offset _BUFFER, 512

	invoke	printString, offset szStm1
	invoke	printBytes, offset _BUFFER, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+16, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+32, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+48, 16

	invoke	printString, offset szStm2
	invoke	printBytes, offset _BUFFER+192, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+208, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+224, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+240, 16

	invoke	printString, offset szStm3
	invoke	printBytes, offset _BUFFER+256, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+272, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+288, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+304, 16

	invoke	printString, offset szStm4
	invoke	printBytes, offset _BUFFER+448, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+464, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+480, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+496, 16

	invoke	xorStream, offset _BUFFER, 512

	invoke	printString, offset szStm5
	invoke	printBytes, offset _BUFFER, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+16, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+32, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+48, 16

	invoke	printSeparator

	inc	ebx
	cmp	ebx, 256
	jnz	@loop2

;------------------------------------------------------------

	invoke	printString, offset szTVSt3

	xor	ebx, ebx
@loop3:
	push	ebx
	push	offset szSet3
	push	offset _BUFFER
	call	wsprintfA
	add	esp, 3*4

	invoke	printString, offset _BUFFER

	call	clearStream

	xor	ecx, ecx
	mov	eax, ebx
@@:	
	mov	byte ptr [_KEY+ecx], al
	inc	ecx
	inc	eax
	and	eax, 0FFh
	and	ecx, 0Fh
	jnz	@B

	invoke	printString, offset szKey
	invoke	printBytes, offset _KEY, 16

	invoke	rc4_setkey, offset _KEY, 16
	invoke	rc4_crypt, offset _BUFFER, 512

	invoke	printString, offset szStm1
	invoke	printBytes, offset _BUFFER, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+16, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+32, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+48, 16

	invoke	printString, offset szStm2
	invoke	printBytes, offset _BUFFER+192, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+208, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+224, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+240, 16

	invoke	printString, offset szStm3
	invoke	printBytes, offset _BUFFER+256, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+272, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+288, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+304, 16

	invoke	printString, offset szStm4
	invoke	printBytes, offset _BUFFER+448, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+464, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+480, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+496, 16

	invoke	xorStream, offset _BUFFER, 512

	invoke	printString, offset szStm5
	invoke	printBytes, offset _BUFFER, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+16, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+32, 16
	invoke	printString, offset szNull
	invoke	printBytes, offset _BUFFER+48, 16

	invoke	printSeparator

	inc	ebx
	cmp	ebx, 256
	jnz	@loop3

;------------------------------------------------------------

	invoke	printString, offset szTVSt4

	invoke	GlobalAlloc, GMEM_FIXED, 131072
	mov	edi, eax


	xor	ebx, ebx
@loop4:
	push	ebx
	push	offset szSet4
	push	offset _BUFFER
	call	wsprintfA
	add	esp, 3*4

	invoke	printString, offset _BUFFER

	mov	esi, edi
	xor	eax, eax
	mov	ecx, 131072/4
	cld
	rep	stosd
	mov	edi, esi

	xor	ecx, ecx
@@:
	mov	eax, ecx
	mov	edx, 53h
	mul	edx
	lea	edx, [4*ebx+ebx]
	add	eax, edx
	mov	byte ptr [_KEY+ecx], al
	inc	ecx
	and	ecx, 0Fh
	jnz	@B

	invoke	printString, offset szKey
	invoke	printBytes, offset _KEY, 16

	invoke	rc4_setkey, offset _KEY, 16
	invoke	rc4_crypt, edi, 131072

	invoke	printString, offset szStm1
	mov	eax, edi
	invoke	printBytes, eax, 16
	invoke	printString, offset szNull
	lea	eax, [edi+16]
	invoke	printBytes, eax, 16
	invoke	printString, offset szNull
	lea	eax, [edi+32]
	invoke	printBytes, eax, 16
	invoke	printString, offset szNull
	lea	eax, [edi+48]
	invoke	printBytes, eax, 16

	invoke	printString, offset szStm6
	lea	eax, [edi+65472]
	invoke	printBytes, eax, 16
	invoke	printString, offset szNull
	lea	eax, [edi+65488]
	invoke	printBytes, eax, 16
	invoke	printString, offset szNull
	lea	eax, [edi+65504]
	invoke	printBytes, eax, 16
	invoke	printString, offset szNull
	lea	eax, [edi+65520]
	invoke	printBytes, eax, 16

	invoke	printString, offset szStm7
	lea	eax, [edi+65536]
	invoke	printBytes, eax, 16
	invoke	printString, offset szNull
	lea	eax, [edi+65552]
	invoke	printBytes, eax, 16
	invoke	printString, offset szNull
	lea	eax, [edi+65568]
	invoke	printBytes, eax, 16
	invoke	printString, offset szNull
	lea	eax, [edi+65584]
	invoke	printBytes, eax, 16

	invoke	printString, offset szStm8
	lea	eax, [edi+131008]
	invoke	printBytes, eax, 16
	invoke	printString, offset szNull
	lea	eax, [edi+131024]
	invoke	printBytes, eax, 16
	invoke	printString, offset szNull
	lea	eax, [edi+131040]
	invoke	printBytes, eax, 16
	invoke	printString, offset szNull
	lea	eax, [edi+131056]
	invoke	printBytes, eax, 16

	invoke	xorStream, edi, 131072

	invoke	printString, offset szStm9
	mov	eax, edi
	invoke	printBytes, eax, 16
	invoke	printString, offset szNull
	lea	eax, [edi+16]
	invoke	printBytes, eax, 16
	invoke	printString, offset szNull
	lea	eax, [edi+32]
	invoke	printBytes, eax, 16
	invoke	printString, offset szNull
	lea	eax, [edi+48]
	invoke	printBytes, eax, 16
	invoke	printSeparator

	inc	ebx
	cmp	ebx, 4
	jnz	@loop4

	invoke	printString, offset szOutro

	invoke	GlobalFree, edi

	popad
	ret


clearStream	proc
	pushad
	xor	eax, eax
	mov	ecx, 512/4
	mov	edi, offset _BUFFER
	cld
	rep	stosd
	popad
	ret
clearStream	endp

xorStream	proc	ptrBuffer:DWORD, lenStream:DWORD
	pushad

	mov	eax, lenStream
	mov	ecx, 64
	xor	edx, edx
	div	ecx
	mov	ecx, eax
	dec	ecx

	mov	esi, ptrBuffer
	mov	edi, esi
	
@loop:	add	edi, 64
	mov	edx, 60
@@:	mov	eax, dword ptr [edi+edx]
	xor	dword ptr [esi+edx], eax
	sub	edx, 4
	jns	@B

	dec	ecx
	jnz	@loop

	popad
	ret
xorStream	endp

printString	proc	ptrString:DWORD

LOCAL	_Temp : DWORD

	pushad

       	lea	esi, _Temp

	and	dword ptr [esi], 0

	invoke	GetStdHandle, STD_OUTPUT_HANDLE
	mov	ebx, eax

	invoke	getstringlen, ptrString

	push	0
	push	esi
	push	eax
	push	ptrString
	push	ebx
	call	WriteConsoleA

	popad
	ret

printString	endp

printBytes	proc	ptrData:DWORD, lenData:DWORD

LOCAL	_Temp	: DWORD
LOCAL	_HStd	: DWORD
LOCAL	_Buffer[60]:BYTE

	pushad

	invoke	GetStdHandle, STD_OUTPUT_HANDLE
	mov	_HStd, eax

	mov	ebx, lenData
	test	ebx, ebx
	jz	@done

	mov	esi, ptrData
	cld

@nextLoop:
	lea	edi, _Buffer
	xor	edx, edx
	xor	ecx, ecx
@loop:	lodsb
	mov	ah, al
	and	ax, 0FF0h
	shr	al, 4
	cmp	al, 0Ah
	jb	@F
	add	al, 7
@@:	add	al, 30h
	stosb
	shr	ax, 8
	cmp	al, 0Ah
	jb	@F
	add	al, 7
@@:	add	al, 30h
	stosb

	add	edx, 2
	dec	ebx
	jz	@show

	inc	ecx
	and	ecx, 0Fh
	jnz	@loop

	mov	eax, edx

	push	0
       	lea	edx, _Temp
	and	dword ptr [edx], 0
	push	edx
	push	eax
	lea	edx, _Buffer
	push	edx
	push	_HStd
	call	WriteConsoleA

	invoke	printSeparator
	jmp	@nextLoop

@show:
	mov	eax, edx

	push	0
       	lea	edx, _Temp
	and	dword ptr [edx], 0
	push	edx
	push	eax
	lea	edx, _Buffer
	push	edx
	push	_HStd
	call	WriteConsoleA

	invoke	printSeparator
@done:
	popad
	ret

printBytes	endp

printSeparator	proc

LOCAL	_Temp : DWORD
LOCAL	_EOL : DWORD

	pushad

       	lea	esi, _Temp
	lea	edi, _EOL

	and	dword ptr [esi], 0
	mov	dword ptr [edi], 0A0Dh

	invoke	GetStdHandle, STD_OUTPUT_HANDLE
	mov	ebx, eax

	push	0
	push	esi
	push	2
	push	edi
	push	ebx
	call	WriteConsoleA

	popad
	ret

printSeparator	endp

end start