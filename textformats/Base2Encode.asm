
.code

Base2Encode proc uses esi edi ebx pInputData,dwDataLen,pOutputData
	mov esi,pInputData
	mov ebx,dwDataLen
	mov edi,pOutputData
	xor eax,eax
	xor edx,edx
	stosb
	dec edi
	test ebx,ebx
	jz @F
	.repeat
		movzx eax,byte ptr [esi]
		inc esi
		.repeat
			mov cl,'0' shr 1
			add al,al
			adc cl,cl
			inc edx
			mov [edi],cl
			inc edi
		.until !(edx&7)
		dec ebx
	.until zero?
@@:	mov eax,edx
	ret
Base2Encode endp

