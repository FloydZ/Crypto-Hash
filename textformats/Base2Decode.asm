
.code
Base2Decode proc uses esi edi ebx pInputStr,pOutputData
	xor eax,eax
	mov esi,pInputStr
	xor edx,edx
	mov edi,pOutputData
	xor ebx,ebx
	jmp @F
	.repeat
		add edx,edx
		inc esi
		and eax,1
		add ebx,1
		or edx,eax
		.if !(ebx&7)
			mov [edi],dl
			inc edi
		.endif
	@@:	movzx eax,byte ptr [esi]
	.until !eax
	mov eax,ebx
	ret
Base2Decode endp


