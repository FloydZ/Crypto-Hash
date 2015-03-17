.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

include g:\masm32\include\user32.inc
include g:\masm32\include\kernel32.inc

include	..\..\lib\sha1.inc
include	..\..\lib\rc4.inc

.data?
hexTable	db	4*20 dup (?)
randHash	db	20 dup (?)
_randCount	dd	?
	random_data_len	equ	$ - offset hexTable
.code
random		proc	ptrOut:DWORD, lenByte:DWORD

	pushad

	mov	ecx, dword ptr [esp+20h+8]
	mov	edi, dword ptr [esp+20h+4]
	jecxz	@clear

	mov	eax, dword ptr [_randCount]
	test	eax, eax
	jnz	@F

	call	randomInit
@@:
	xor	eax, eax
	mov	ebx, ecx
	mov	esi, edi
	shr	ecx, 2
	cld
	rep	stosd
	mov	ecx, ebx
	and	ecx, 3
	rep	stosb

	invoke	rc4_crypt, esi, ebx

	add	ebx, dword ptr [_randCount]
	cmp	ebx, 8000h
	cmovnc	ebx, eax	;if ebx >= 8000h reinit
	mov	dword ptr [_randCount], ebx

@done:
	popad
	ret	8

@clear:
	xor	eax, eax
	mov	ecx, random_data_len/4	
	mov	edi, offset hexTable
	cld
	rep	stosd

	invoke	rc4_clear
	jmp	@done

random		endp

randomInit	proc

	pushad

	mov	esi, offset randHash
	mov	edi, offset hexTable

	invoke	GlobalMemoryStatus, edi		;requires 20h bytes

	invoke	sha1, edi, dword ptr [edi], edi			;1
	add	edi, 20

	invoke	GetCursorPos, esi
	invoke	GetCurrentProcessId
	mov	dword ptr [esi+8], eax
	invoke	GetCurrentThreadId
	mov	dword ptr [esi+12], eax

	invoke	sha1, edi, 16, esi				;2
	add	edi, 20

	invoke	GetLocalTime, esi

	invoke	sha1, edi, 16, esi				;3
	add	edi, 20

	xor	ebx, ebx
	invoke	GetVolumeInformation, ebx, ebx, ebx, esi, ebx, ebx, ebx, ebx
	invoke	GetTickCount
	mov	dword ptr [esi+4], eax
	rdtsc
	mov	dword ptr [esi+8], eax
	mov	dword ptr [esi+12], edx

	invoke	sha1, edi, 16, esi				;4

	invoke	sha1, offset randHash, 20*4, offset hexTable
	invoke	rc4_setkey, offset randHash, 20

	mov	ebx, 32
@@:	invoke	rc4_crypt, offset hexTable, 20*4
	dec	ebx
	jnz	@B

	popad
	ret

randomInit	endp

end