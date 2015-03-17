.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

;;
;;	analogue to bn2Hex
;;
;_a_ 
bnToStr proc uses ebx edi esi bn:DWORD, ptrStr:DWORD
	mov esi,bn
	mov ebx,ptrStr
	.if BN_IS_ZERO(esi)
		mov word ptr [ebx],'0'
		ret
	.endif
	.if [esi].BN.bSigned
		mov byte ptr [ebx],'-'
		inc ebx
		inc ptrStr
	.endif
	bnCreateX edi
	invoke bnMov,edi,esi
	.while !BN_IS_ZERO(edi)
		invoke bnDivDw,edi,10,edi
		add al,'0'
		mov [ebx],al
		inc ebx
	.endw  
	and byte ptr [ebx],0
	mov esi,ptrStr
	mov eax,ebx
	sub eax,esi
	shr eax,1
	.if !zero?
		.repeat
			dec ebx
			mov dl, [esi]
			mov cl, [ebx]
			inc esi
			mov [ebx], dl
			mov [esi-1], cl
			dec eax
		.until ZERO?
	.endif
	bnDestroyX
	ret
bnToStr endp

end
