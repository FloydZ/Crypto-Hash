.686
.model flat,stdcall
option casemap:none
include windows.inc
include .\bnlib.inc
include .\bignum.inc

.code

bnCreate proc
	invoke HeapAlloc,BN_HHEAP,HEAP_GENERATE_EXCEPTIONS+HEAP_ZERO_MEMORY,BN_ALLOC_BYTES
	.if eax
		mov [eax].BN.dwSize,1
		ret
	.endif
	mov eax,BNERR_ALLOC
	call _bn_error
	ret
bnCreate endp

end