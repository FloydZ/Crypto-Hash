
.mmx
.xmm

.data?
	MWCBuffer 	dd 1038 dup (?)
.data
	MWCi	dd	1037
	MWCc	dd	0
	PHI		dd	9e3779b9h
.code
MWCInit proc uses ecx ebx eax esi x:Dword
	mov edx, x
	mov MWCc, edx
	mov ebx, offset MWCBuffer
	
	xor ecx, ecx
	mov eax, PHI
	
	mov [ebx + 4 * ecx], edx
	
	add eax, edx
	add ecx, 1
	mov [ebx + 4 * ecx], eax
 
	add eax, edx
	add ecx, 1
	mov [ebx + 4 * ecx], eax
	
	add ecx, 1
	.while ecx < 1038 
		sub ecx,3
		mov eax, [ebx + 4 * ecx];base
		
		add ecx, 1
		xor eax, [ebx + 4 * ecx]
		xor eax, PHI
		add ecx, 2
		xor eax, ecx 
		
		mov [ebx + 4 * ecx], eax
		add ecx, 1
		
	.endw
	ret
MWCInit endp

MWC proc uses ebx ecx edx
	mov edx, MWCc
	mov ecx, MWCi
	mov ebx, offset MWCBuffer
	
	mov eax, 611376378
	movd mm0, eax
	movd mm1, [ebx + ecx * 4]
	pmuludq   mm0, mm1
	movd mm1, edx
	paddd mm0, mm1
	psrlq mm0, 32
	
	movd eax, mm0	
	mov MWCc, eax
	
	sub ecx, 1
	jz j2
	
	mov MWCi, ecx
	mov [ebx + ecx * 4], eax
	ret
	
j2:
	mov MWCi, 1037
	xor ecx, ecx
	mov [ebx], eax
	
	
	ret
MWC endp
