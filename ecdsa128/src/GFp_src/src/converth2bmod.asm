.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

extern	__mod:DWORD

include	..\..\lib\gfp.inc

.data
hashSpace	VBIGINT<>

.code
;convert hash to big number mod actual modulus

converth2bmod	proc	ptrHash:DWORD, ptrOut:DWORD

	pushad
	mov	esi, dword ptr [esp+20h+4]
	mov	edi, offset hashSpace
	mov	ecx, 16
	mov	ebx, edi

@@:	mov	eax, dword ptr [esi+ecx]
	bswap	eax
	mov	dword ptr [ebx], eax
	add	ebx, 4
	sub	ecx, 4
	jns	@B

	and	dword ptr [ebx], 0
	and	dword ptr [ebx+4], 0
	and	dword ptr [ebx+8], 0

	invoke	modulo, edi, dword ptr [esp+20h+8]

	xor	eax, eax
	mov	ecx, 8
	cld
	rep	stosd

	popad
	ret	8

converth2bmod	endp

end