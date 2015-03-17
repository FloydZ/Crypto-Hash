.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

include	..\..\lib\gfp.inc
include	..\..\lib\ecp.inc

extern	tempInt1:DWORD
extern	tempInt2:DWORD
extern	tempInt3:DWORD

.code
ECP_Add_J	proc	ptrA:DWORD, ptrB:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]
	mov	edi, dword ptr [esp+20h+8]

	assume	esi: ptr ECPOINTJ
	assume	edi: ptr ECPOINTJ

	lea	edx, [esi].Y
	lea	ecx, [esi].Z		;P

	lea	ebx, [edi].Y		;Q
	lea	ebp, [edi].Z
					;A=P: X2 = esi, Y2 = edx, Z2 = ecx
					;B=Q: X  = edi, Y  = ebx, Z  = ebp
	invoke	comparezero, ecx
	jz	@ret			;if (Z2 == 0) return B, do nothing

	invoke	comparezero, ebp
	jz	@returnA		;if (Z  == 0) return A

	invoke	compareone, ecx
	jz	@F

	invoke	mulmod, ecx, ecx, offset tempInt1			;T1 = Z2^2	
	invoke	mulmod, offset tempInt1, edi, edi			;X = X*T1
	invoke	mulmod, offset tempInt1, ecx, offset tempInt1		;T1 = Z2*T1
	invoke	mulmod, offset tempInt1, ebx, ebx			;Y = Y*T1
@@:
	invoke	mulmod, ebp, ebp, offset tempInt1			;T1 = Z^2
	invoke	mulmod, offset tempInt1, esi, offset tempInt2		;T2 = X2*T1
	invoke	mulmod, offset tempInt1, ebp, offset tempInt1		;T1 = Z*T1
	invoke	mulmod, offset tempInt1, edx, offset tempInt1		;T1 = Y2*T1
	invoke	submod, offset tempInt1, ebx, offset tempInt1		;T1 = T1 - Y
	invoke	submod, offset tempInt2, edi, offset tempInt2		;T2 = T2 - X
	invoke	comparezero, offset tempInt2
	jnz	@T2ne0

		invoke	comparezero, offset tempInt1
		jnz	@return0

			invoke	ECP_Dbl_J, esi, edi
			jmp	@ret

@T2ne0:
	invoke	compareone, ecx
	jz	@F

		invoke	mulmod, ebp, ecx, ebp				;Z = Z*Z2

@@:
	invoke	mulmod, ebp, offset tempInt2, ebp			;Z = Z*T2
	invoke	mulmod, offset tempInt2, offset tempInt2, offset tempInt3
									;T3 = T2^2
	invoke	mulmod, offset tempInt2, offset tempInt3, offset tempInt2
									;T2 = T2*T3
	invoke	mulmod, offset tempInt3, edi, offset tempInt3		;T3 = X*T3
	invoke	mulmod, offset tempInt1, offset tempInt1, edi		;X = T1^2
	invoke	mulmod, offset tempInt2, ebx, ebx			;Y = T2*Y
	invoke	submod, edi, offset tempInt2, offset tempInt2		;T2 = X - T2
	invoke	addmod, offset tempInt3, offset tempInt3, edi		;X = 2*T3
	invoke	submod, offset tempInt2, edi, edi			;X = T2 - X
	invoke	submod, offset tempInt3, edi, offset tempInt2		;T2 = T3 - X
	invoke	mulmod, offset tempInt1, offset tempInt2, offset tempInt2
									;T2 = T1*T2
	invoke	submod, offset tempInt2, ebx, ebx			;Y = T2 - Y

@ret:
	invoke	zero, offset tempInt1
	invoke	zero, offset tempInt2
	invoke	zero, offset tempInt3
	popad
	ret	8

@return0:
					;A=P: X2 = esi, Y2 = edx, Z2 = ecx
					;B=Q: X  = edi, Y  = ebx, Z  = ebp
	invoke	zero, ebp
	jmp	@ret
@returnA:
	invoke	copy, esi, edi
	invoke	copy, edx, ebx
	invoke	copy, ecx, ebp

	jmp	@ret

ECP_Add_J	endp

end