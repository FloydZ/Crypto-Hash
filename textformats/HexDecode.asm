
.code

HexDecode proc uses esi edi ebx pHexStr:dword,pOutBuffer:dword
	mov esi,pHexStr
	mov edi,pOutBuffer
	jmp @1
@@:
	and ebx,0Fh
	add eax,ebx
	mov [edi],al
	inc edi
@1:
	movzx edx,byte ptr[esi]
	cmp edx,40h
	sbb ebx,ebx
	sub edx,37h
	and ebx,7
	inc esi
	add ebx,edx
	js @F
	mov eax,ebx
	shl eax,4
	mov [edi],al
	movzx edx,byte ptr[esi]
	cmp edx,40h
	sbb ebx,ebx
	sub edx,37h
	and ebx,7
	inc esi
	add ebx,edx
	jns @B	
@@:	
	ret
HexDecode endp

