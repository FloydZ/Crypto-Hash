.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnCmp proc uses edi esi bnX:DWORD,bnY:DWORD
;	0 if X=Y      1 if X>Y      -1 if X<Y
	mov edi,bnX
	mov esi,bnY
	mov eax,[esi].BN.bSigned; 1 or 0
	cmp eax,[edi].BN.bSigned; 1 or 0
	jne @F
	call _bn_cmp_array
	ret
@@:	sbb eax,eax
	lea eax,[eax*2+1]
	ret
bnCmp endp

end

