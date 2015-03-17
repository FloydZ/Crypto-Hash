.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

extern	__mod:DWORD
extern	__c:DWORD

include	..\..\lib\gfp.inc

.data?
modSpace	VBIGINT<>

.code

modulo		proc	ptrA:DWORD, ptrC:DWORD

	;c=a mod __mod
	;HAC, Algorithm 14.47

	pushad

	mov	esi, dword ptr [esp+20h+4]	;ptrA
	mov	edi, offset modSpace		;8 DD
	mov	ebx, dword ptr [esp+20h+8]	;ptrC

	lea	ebp, [esi+16]
	invoke	copy, esi, ebx

@@:	invoke	comparezero, ebp
	jz	@F

	invoke	multiply, ebp, offset __c, edi
	invoke	addmod, edi, ebx, ebx		;out = r + r[i]
	lea	ebp, [edi+16]			;ptr q[i] = edi+16
	jmp	@B

@@:	invoke	compare, ebx, offset __mod
	jb	@F

	invoke	submod, ebx, offset __mod, ebx
	jmp	@B

@@:	xor	eax, eax
	mov	ecx, 8
	cld
	rep	stosd
	popad
	ret	8

modulo		endp

end