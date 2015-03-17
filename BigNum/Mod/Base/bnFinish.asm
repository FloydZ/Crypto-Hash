.686
.model flat,stdcall
option casemap:none
include windows.inc
include wincrypt.inc
include .\bnlib.inc
include .\bignum.inc

.code

bnFinish proc
	mov ecx,BN_HPROV
	jecxz @F
	invoke CryptReleaseContext,ecx,0
@@:	mov ecx,BN_HHEAP
	jecxz @F
	invoke HeapDestroy,ecx
@@:	ret
bnFinish endp

end
