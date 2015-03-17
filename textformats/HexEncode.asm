
.code
HexEncode proc uses edi esi ebx pBuff:dword,dwLen:dword,pOutBuff:dword
	mov ebx,dwLen
	mov edi,pOutBuff
	test ebx,ebx
	mov esi,pBuff
	jz @F
	.repeat
		movzx eax,byte ptr [esi]
		mov ecx,eax
		add edi,2
		shr ecx,4
		and eax,1111b
		and ecx,1111b
		cmp eax,10
		sbb edx,edx
		adc eax,0
		lea eax,[eax+edx*8+'7']
		cmp ecx,10
		sbb edx,edx
		adc ecx,0
		shl eax,8
		lea ecx,[ecx+edx*8+'7']
		or eax,ecx
		inc esi
		mov [edi-2],ax
		dec ebx
	.until ZERO?
@@:
	mov eax,edi
	mov byte ptr [edi],0
	sub eax,pOutBuff
	ret
HexEncode endp

