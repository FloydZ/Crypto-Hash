
.mmx
.xmm

.data?
	CMWCBuffer 	dd 4096 dup (?)
.data
	CMWCi	dd	4095
	CMWCc	dd	362436
	CPHI		dd	9e3779b9h
.code
CMWCInit proc uses ecx ebx eax esi x:Dword
	mov edx, x
	mov MWCc, edx
	mov ebx, offset CMWCBuffer
	
	xor ecx, ecx
	mov eax, CPHI
	
	mov [ebx + 4 * ecx], edx
	
	add eax, edx
	add ecx, 1
	mov [ebx + 4 * ecx], eax
 
	add eax, edx
	add ecx, 1
	mov [ebx + 4 * ecx], eax
	
	add ecx, 1
	.while ecx < 4096 
		sub ecx,3
		mov eax, [ebx + 4 * ecx];base
		
		add ecx, 1
		xor eax, [ebx + 4 * ecx]
		xor eax, CPHI
		add ecx, 2
		xor eax, ecx 
		
		mov [ebx + 4 * ecx], eax
		add ecx, 1
		
	.endw
	ret
CMWCInit endp

CMWC proc uses ebx edx ecx
	mov edx, CMWCc
	mov ecx, CMWCi
	add ecx, 1
	and ecx, 4095
	
	mov ebx, offset CMWCBuffer
	
	mov eax, 18705
	movd mm0, eax
	movd mm1, [ebx + ecx * 4]
	pmuludq   mm0, mm1
	movd mm1, edx
	paddd mm0, mm1
	;psrlq mm0, 32
	movd edx, mm0
	
	mov eax, 0ffffffeh
	sub eax, edx
	
	mov [ebx + ecx * 4], eax
	ret
CMWC endp
