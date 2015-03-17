.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

include	..\..\lib\gfp.inc
include	..\..\lib\ecp.inc

.data?
tempECMInt	BIGINT<>
tempECMPnt1	ECPOINTJ<>
tempECMPnt2	ECPOINTJ<>

.code
ECP_Mul		proc	ptrInt:DWORD, ptrA:DWORD, ptrB:DWORD

	pushad

	mov	ebp, dword ptr [esp+20h+4]	;ptrInt
	mov	esi, dword ptr [esp+20h+8]	;ptrA

	mov	edi, offset tempECMPnt1
	mov	ebx, offset tempECMInt

	invoke	copy, ebp, ebx			;n
	invoke	ECP_A2J, esi, edi		;edi = P (J)

	mov	esi, offset tempECMPnt2
	assume	esi: ptr ECPOINTJ

	lea	eax, [esi].Z
	invoke	zero, eax			;esi = Q (J) inf.

	invoke	comparezero, ebx
	jz	@done

@loop:
	invoke	div2, ebx
	jnc	@F

		invoke	ECP_Add_J, edi, esi
	@@:

	invoke	comparezero, ebx
	jz	@done
		
	invoke	ECP_Dbl_J, edi, edi
	jmp	@loop

@done:
	invoke	ECP_J2A, esi, dword ptr [esp+20h+12]

	invoke	ECP_Zero_J, esi
	invoke	ECP_Zero_J, edi

	popad
	ret	12

ECP_Mul		endp
end