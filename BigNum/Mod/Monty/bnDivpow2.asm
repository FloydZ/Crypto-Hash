.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnDivpow2 proc bnX:DWORD,bitsY:DWORD,bnQuo:DWORD
	invoke bnMov,bnQuo,bnX
	invoke bnShr,bnQuo,bitsY
	ret
bnDivpow2 endp

end