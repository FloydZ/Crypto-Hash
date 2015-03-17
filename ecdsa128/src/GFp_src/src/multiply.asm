.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

include	..\..\lib\gfp.inc

.data?
mulSpace	VBIGINT<>

.code
multiply	proc	ptrA:DWORD, ptrB:DWORD, ptrC:DWORD

	;c=ab

	pushad

	mov	esi, dword ptr [esp+20h+4]
	mov	edi, dword ptr [esp+20h+8]

	mov	eax, dword ptr [esi]
	mul	dword ptr [edi]
	xor	ecx, ecx
	mov	dword ptr [mulSpace], eax
	mov	ebp, edx

	mov	eax, dword ptr [esi+4]
	mul	dword ptr [edi]
	xor	ebx, ebx
	add	ebp, eax
	adc	ecx, edx
	mov	eax, dword ptr [esi]
	mul	dword ptr [edi+4]
	add	eax, ebp
	adc	ecx, edx
	mov	dword ptr [mulSpace+4], eax
	adc	ebx, 0

	mov	eax, dword ptr [esi+8]
	mul	dword ptr [edi]
	xor	ebp, ebp
	add	ecx, eax
	adc	ebx, edx
	mov	eax, dword ptr [esi+4]
	mul	dword ptr [edi+4]
	add	ecx, eax
	adc	ebx, edx
	adc	ebp, 0
	mov	eax, dword ptr [esi]
	mul	dword ptr [edi+8]
	add	eax, ecx
	adc	ebx, edx
	mov	dword ptr [mulSpace+8], eax
	adc	ebp, 0

	mov	eax, dword ptr [esi+12]
	mul	dword ptr [edi]
	xor	ecx, ecx
	add	ebx, eax
	adc	ebp, edx
	mov	eax, dword ptr [esi+8]
	mul	dword ptr [edi+4]
	add	ebx, eax
	adc	ebp, edx
	adc	ecx, 0
	mov	eax, dword ptr [esi+4]
	mul	dword ptr [edi+8]
	add	ebx, eax
	adc	ebp, edx
	adc	ecx, 0
	mov	eax, dword ptr [esi]
	mul	dword ptr [edi+12]
	add	eax, ebx
	adc	ebp, edx
	mov	dword ptr [mulSpace+12], eax
	adc	ecx, 0

	mov	eax, dword ptr [esi+12]
	mul	dword ptr [edi+4]
	xor	ebx, ebx
	add	ebp, eax
	adc	ecx, edx
	mov	eax, dword ptr [esi+8]
	mul	dword ptr [edi+8]
	add	ebp, eax
	adc	ecx, edx
	adc	ebx, 0
	mov	eax, dword ptr [esi+4]
	mul	dword ptr [edi+12]
	add	eax, ebp
	adc	ecx, edx
	mov	dword ptr [mulSpace+16], eax
	adc	ebx, 0

	mov	eax, dword ptr [esi+12]
	mul	dword ptr [edi+8]
	xor	ebp, ebp
	add	ecx, eax
	adc	ebx, edx
	mov	eax, dword ptr [esi+8]
	mul	dword ptr [edi+12]
	add	ecx, eax
	adc	ebx, edx
	adc	ebp, 0
	mov	eax, dword ptr [esi+12]
	mul	dword ptr [edi+12]
	add	eax, ebx
	adc	edx, ebp

					;+20=ecx, +24=eax, +28=edx
	mov	esi, dword ptr [esp+20h+12]
					;ptrOut
	mov	edi, offset mulSpace
	mov	dword ptr [esi+20], ecx
	mov	dword ptr [esi+24], eax
	mov	dword ptr [esi+28], edx

	mov	eax, dword ptr [edi]
	mov	ebx, dword ptr [edi+4]
	mov	ecx, dword ptr [edi+8]
	mov	edx, dword ptr [edi+12]
	mov	ebp, dword ptr [edi+16]

	mov	dword ptr [esi+ 0], eax
	mov	dword ptr [esi+ 4], ebx
	mov	dword ptr [esi+ 8], ecx
	mov	dword ptr [esi+12], edx
	mov	dword ptr [esi+16], ebp

	and	dword ptr [edi   ], 0
	and	dword ptr [edi+4 ], 0
	and	dword ptr [edi+8 ], 0
	and	dword ptr [edi+12], 0
	and	dword ptr [edi+16], 0

	popad
	ret	12

multiply	endp

end