.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnToHex proc uses edi esi ebx bn:DWORD,ptrStr:DWORD
	mov esi,bn
	mov edi,ptrStr
	.if BN_IS_ZERO(esi)
		mov dword ptr [edi],'00'
		mov eax,2
		ret
	.endif
	.if [esi].BN.bSigned
		mov byte ptr [edi],'-'
		inc edi
	.endif
	mov eax,[esi].BN.dwSize
	lea esi,[esi].BN.dwArray[eax*4-4]
	mov ecx,[esi]
	mov edx,ecx
	bswap ecx
	mov ebx,3
	dec cl
	sbb ebx,0
	dec ch
	sbb ebx,0
	dec dh
	sbb ebx,0
	.repeat
		movzx eax,byte ptr [esi+ebx]
		mov ecx,eax
		shr ecx,4
		and eax,1111b
		and ecx,1111b
		cmp eax,10
		sbb edx,edx
		adc eax,0
		lea eax,[eax+edx*8+('0'+7)]
		cmp ecx,10
		sbb edx,edx
		adc ecx,0
		shl eax,8
		lea ecx,[ecx+edx*8+('0'+7)]
		or eax,ecx
		mov [edi],ax
		add edi,2	
		dec ebx
	.until sign?
	mov esi,bn
	mov ebx,[esi].BN.dwSize
	jmp @F
	.repeat
		mov ecx,[esi].BN.dwArray[ebx*4-4]
		mov edx,ecx
		shr edx,4
		push ebx
		and ecx,0F0F0F0Fh
		and edx,0F0F0F0Fh
		lea ebx,[ecx+06060606h]
		lea eax,[edx+06060606h]
		and ebx,10101010h
		and eax,10101010h
		shr ebx,4
		shr eax,4
		lea ecx,[ecx+ebx*8+30303030h]
		lea edx,[edx+eax*8+30303030h]
		sub ecx,ebx
		sub edx,eax
		pop ebx
		mov [edi+7],cl
		mov [edi+6],dl
		mov [edi+5],ch
		mov [edi+4],dh
		shr ecx,16
		mov byte ptr [edi+8],0
		shr edx,16
		mov [edi+3],cl
		mov [edi+2],dl
		mov [edi+1],ch
		mov [edi+0],dh
		add edi,8
@@:		dec ebx
	.until zero?
	mov eax,edi
	sub eax,ptrStr
	mov [edi],bl
	ret
bnToHex endp

end
