.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnCmpAbs proc uses edi esi bnX:DWORD,bnY:DWORD
; 0 if |X|=|Y|      1 if |X|>|Y|      -1 if |X|<|Y|
	mov edi,bnX
	mov esi,bnY
	call _bn_cmp_array
	ret
bnCmpAbs endp

end