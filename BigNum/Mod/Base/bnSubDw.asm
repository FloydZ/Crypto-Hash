.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnSubDw proc uses edi bn:DWORD,dwVal
	mov edi,bn
	mov eax,dwVal
	call _bn_subdw_ignoresign
	ret
bnSubDw endp

end