.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnMulpow2 proc bnX:DWORD,bitsY:DWORD,bnProd:DWORD
	invoke bnMov,bnProd,bnX
	invoke bnShl,bnProd,bitsY
	ret
bnMulpow2 endp
end