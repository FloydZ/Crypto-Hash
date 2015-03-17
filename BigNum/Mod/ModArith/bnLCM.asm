.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

;
;	least common multiple
;

bnLCM proc uses edi esi bnX:DWORD, bnY:DWORD, bnR:DWORD
	bnCreateX edi,esi
	invoke bnGCD,bnX,bnY,edi
	invoke bnMul,bnX,bnY,esi
	invoke bnDiv,esi,edi,bnR,0
	bnDestroyX
	ret
bnLCM endp

end