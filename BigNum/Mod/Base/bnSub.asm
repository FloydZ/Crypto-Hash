.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnSub proc uses edi esi ebx bnX:DWORD,bnY:DWORD
;----------------------;
;	+x - +y = x-y      ;
;	+x - -y = +(x+y)   ;
;	-x - +y = -(x+y)   ;
;	-x - -y = y-x      ;
;----------------------;
	mov edi,bnX
	mov esi,bnY
	mov ebx,[edi].BN.bSigned
	mov eax,[esi].BN.bSigned
	.if eax == ebx
		bnSCreateX edi,esi
		invoke bnMov,edi,bnX
		invoke bnMov,esi,bnY
		call _bn_cmp_array
		test eax,eax
		.if sign?
			xchg esi,edi
			xor ebx,1
		.endif
		mov [edi].BN.bSigned,ebx
		call _bn_sub_ignoresign
		invoke bnMov,bnX,edi
		bnSDestroyX
		ret
	.endif
	call _bn_add_ignoresign
	ret 
bnSub endp
end