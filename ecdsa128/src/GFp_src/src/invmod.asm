.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

include	..\..\lib\gfp.inc

extern	__mod:DWORD

.data?
temp_a		BIGINT<>
temp_c		BIGINT<>
temp_u		BIGINT<>
temp_v		BIGINT<>

.code

;"Software Implementation of the NIST Elliptic Curves Over Prime Fields"
; Algorithm 12 (modified)

invmod		proc	ptrInOut:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]

	mov	eax, offset temp_u
	mov	ebx, offset temp_v
	mov	ecx, offset temp_a
	mov	edx, offset temp_c

	invoke	copy, esi, eax
	invoke	copy, offset __mod, ebx
	invoke	zero, ecx
	invoke	zero, edx

	mov	dword ptr [ecx], 1

@cmp_u_0:
	invoke	comparezero, eax
	jz	@exit

@TESTLOWBIT_u:
	test	dword ptr [eax], 1
	jnz	@TESTLOWBIT_v

		invoke	div2, eax
		invoke	div2mod, ecx
		jmp	@TESTLOWBIT_u


@TESTLOWBIT_v:
	test	dword ptr [ebx], 1
	jnz	@COMPARE_u_v

		invoke	div2, ebx
		invoke	div2mod, edx
		jmp	@TESTLOWBIT_v

@COMPARE_u_v:
	invoke	compare, eax, ebx		;u==v

	ja	@u_gt_v
	jz	@exit

		invoke	submod, ebx, eax, ebx		;v=v-u
		invoke	submod, edx, ecx, edx		;c=c-a
		jmp	@cmp_u_0

	@u_gt_v:
		invoke	submod, eax, ebx, eax		;u=u-v

	@u_gtqu_v:
		invoke	submod, ecx, edx, ecx		;a=a-c
		jmp	@cmp_u_0

@exit:
	invoke	copy, edx, esi

	invoke	zero, eax
	invoke	zero, ebx
	invoke	zero, ecx
	invoke	zero, edx

	popad
	ret	4

invmod		endp

end