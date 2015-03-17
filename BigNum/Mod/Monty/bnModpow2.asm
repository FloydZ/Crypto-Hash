.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code
bnModpow2 proc uses esi edi ebx bnX:DWORD,bitsY:DWORD,bnRem:DWORD
	mov eax,bnX
	mov edi,bnRem	
	invoke bnMov,edi,eax
	mov ebx,bitsY
	mov ecx,ebx
	shr ebx,5
	;jz @F
	and ecx,31
	mov edx,1
	mov esi,[edi].BN.dwSize
	shl edx,cl
	xor eax,eax
	dec edx
	inc ebx
	.repeat
		.if esi == ebx 
			and [edi].BN.dwArray[esi*4-4],edx
			.break
		.endif
		mov [edi].BN.dwArray[esi*4-4],eax
		dec esi
	.until zero?
;@@:	
	mov ecx,[edi].BN.dwSize
	call _bn_normalize
	ret
bnModpow2 endp


end