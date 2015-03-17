.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnAdd proc uses edi esi ebx bnX:DWORD,bnY:DWORD
;----------------------;
;	+x + +y = +(x+y)   ;
;	-x + -y = -(x+y)   ;
;	+x + -y = x-y      ;
;	-x + +y = y-x      ;
;----------------------;
	mov edi,bnX
	mov esi,bnY
	mov eax,[edi].BN.bSigned
	mov ebx,[esi].BN.bSigned
	.if eax == ebx
		call _bn_add_ignoresign  
		ret
	.endif
	bnSCreateX edi,esi
	invoke bnMov,edi,bnX
	invoke bnMov,esi,bnY
	call _bn_cmp_array
	test eax,eax
	.if sign?
		xchg esi,edi
		mov [edi].BN.bSigned,ebx
	.endif
	call _bn_sub_ignoresign
	invoke bnMov,bnX,edi
	bnSDestroyX
	ret
bnAdd endp

end