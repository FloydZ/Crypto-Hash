.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

include	..\..\lib\gfp.inc
include	..\..\lib\ecp.inc

extern	_A:DWORD

extern	tempInt1:DWORD
extern	tempInt2:DWORD

.code
ECP_Dbl_J	proc	ptrA:DWORD, ptrB:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]
	mov	edi, dword ptr [esp+20h+8]

	assume	esi: ptr ECPOINTJ
	assume	edi: ptr ECPOINTJ

	lea	edx, [esi].Y
	lea	ecx, [esi].Z

	lea	ebx, [edi].Y
	lea	ebp, [edi].Z

	invoke	comparezero, ecx
	jz	@return0

	invoke	mulmod, ecx, ecx, offset tempInt1	;T1 = Z^2
	invoke	mulmod, edx, ecx, ebp			;Z_2 = Z*Y
	invoke	addmod, ebp, ebp, ebp			;Z = 2*Z

	invoke	adduintmod, offset _A, 3, offset tempInt2
	invoke	comparezero, offset tempInt2		;(_A == -3)

	jnz	@nm3

		invoke	submod, esi, offset tempInt1, offset tempInt2			;T2 = X - T1
		invoke	addmod, esi, offset tempInt1, offset tempInt1			;T1 = X + T1
		invoke	mulmod, offset tempInt1, offset tempInt2, offset tempInt2	;T2 = T1 * T2
		invoke	addmod, offset tempInt2, offset tempInt2, offset tempInt1	;T1 = 2*T2
		invoke	addmod, offset tempInt1, offset tempInt2, offset tempInt1	;T1 = T1 + T2
		jmp	@F

	@nm3:
		invoke	mulmod, offset tempInt1, offset tempInt1, offset tempInt1	;T1 = T1^2
		invoke	mulmod, offset _A, offset tempInt1, offset tempInt1		;T1 = A * T1
		invoke	mulmod, esi, esi, offset tempInt2				;T2 = X^2
		invoke	addmod, offset tempInt1, offset tempInt2, offset tempInt1	;T1 = T1 + T2
		invoke	addmod, offset tempInt2, offset tempInt2, offset tempInt2	;T2 = 2*T2
		invoke	addmod, offset tempInt1, offset tempInt2, offset tempInt1	;T1 = T1 + T2
@@:
	invoke	addmod, edx, edx, ebx			;Y_2 = 2*Y
	invoke	mulmod, ebx, ebx, ebx			;Y = Y^2
	invoke	mulmod, ebx, ebx, offset tempInt2	;T2 = Y^2
	invoke	mulmod, ebx, esi, ebx			;Y = Y*X

	invoke	div2mod, offset tempInt2		;T2 = T2/2
	invoke	mulmod, offset tempInt1, offset tempInt1, edi
							;X_2 = T1^2
	invoke	submod, edi, ebx, edi			;X = X - Y
	invoke	submod, edi, ebx, edi			;X = X - Y
	invoke	submod, ebx, edi, ebx			;Y = Y - X
	invoke	mulmod, ebx, offset tempInt1, ebx	;Y = Y * T1
	invoke	submod, ebx, offset tempInt2, ebx	;Y = Y - T2

	invoke	zero, offset tempInt1
	invoke	zero, offset tempInt2

@ret:	popad
	ret	8

@return0:
	invoke	zero, ebp
	jmp	@ret
ECP_Dbl_J	endp

end