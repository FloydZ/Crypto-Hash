.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnAddDw proc uses edi bn:DWORD,dwVal
	mov edi,bn
	mov eax,dwVal
	call _bn_adddw_ignoresign
	ret
bnAddDw endp

end