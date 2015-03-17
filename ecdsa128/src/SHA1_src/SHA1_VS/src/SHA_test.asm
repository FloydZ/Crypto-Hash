;The Pseudorandomly Generated Messages Test
;it only generates (does NOT compare!) hashes

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

include	..\lib\sha1.inc

copyHash	PROTO	:DWORD, :DWORD
printHash	PROTO	:DWORD

.data
_SEED	db	08bh,0fdh,016h,02ch,0b9h,0d3h,0b0h,04dh,0cbh,07eh,054h,0b4h,0ddh,0b2h,0b5h,0d8h,0d9h,0c8h,099h,0f8h

.data?
_MD0	db	20 dup (?)
_MD1	db	20 dup (?)
_MD2	db	20 dup (?)
_HASH	db	20 dup (?)

;INPUT: Seed - A random seed n bits long
;{
;	for (j=0; j<100; j++)
;	{
;		MD0 = MD1 = MD2 = Seed;
;
;		for (i=3; i<1003; i++)
;		{
;			Mi = MDi-3 || MDi-2 || MDi-1;
;			MDi = SHA(Mi);
;		}
;		MDj = Seed = MDi;
;		OUTPUT: MDj
;	}
;}

.code
start:
	pushad

	invoke	printHash, offset _SEED

	mov	ecx, 100

@mainLoop:

	invoke	copyHash, offset _SEED, offset _MD0
	invoke	copyHash, offset _SEED, offset _MD1
	invoke	copyHash, offset _SEED, offset _MD2

	mov	edx, 1000

	@@:
		invoke	sha1, offset _HASH, 60, offset _MD0
		invoke	copyHash, offset _MD1, offset _MD0
		invoke	copyHash, offset _MD2, offset _MD1
		invoke	copyHash, offset _HASH, offset _MD2

		dec	edx
		jnz	@B

	invoke	copyHash, offset _HASH, offset _SEED
	invoke	printHash, offset _SEED

	dec	ecx
	jnz	@mainLoop

	popad
	ret

copyHash	proc	ptrSrcHash:DWORD, ptrDestHash:DWORD

	pushad

	mov	esi, ptrSrcHash

	mov	eax, dword ptr [esi   ]
	mov	ebx, dword ptr [esi+ 4]
	mov	ecx, dword ptr [esi+ 8]
	mov	edx, dword ptr [esi+12]
	mov	edi, dword ptr [esi+16]

	mov	esi, ptrDestHash

	mov	dword ptr [esi   ], eax
	mov	dword ptr [esi+ 4], ebx
	mov	dword ptr [esi+ 8], ecx
	mov	dword ptr [esi+12], edx
	mov	dword ptr [esi+16], edi

	popad
	ret

copyHash	endp

printHash	proc	ptrHash:DWORD

LOCAL	_Temp : DWORD
LOCAL	_String[44] : BYTE

	pushad

       	lea	esi, _Temp
	lea	edi, _String
	and	dword ptr [esi], 0

	push	20
	push	ptrHash
	push	edi
	call	ConvertHexToString

	mov	dword ptr [edi+40], 0A0Dh

	invoke	GetStdHandle, STD_OUTPUT_HANDLE
	mov	ebx, eax

	push	0
	push	esi
	push	(40+2)
	push	edi
	push	ebx
	call	WriteConsoleA

	popad
	ret

printHash	endp

ConvertHexToString	proc	ptrOut:DWORD, ptrIn:DWORD, lIn:DWORD
	pushad
	mov	esi, ptrIn
	mov	edi, ptrOut
	mov	ecx, lIn
	cld
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
	loop	@loop
	xor	al, al
	stosb
	popad
	ret
ConvertHexToString	endp

end start