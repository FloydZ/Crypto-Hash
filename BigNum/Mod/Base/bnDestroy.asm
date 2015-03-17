.686
.model flat,stdcall
option casemap:none
include windows.inc
include .\bnlib.inc
include .\bignum.inc

.code

bnDestroy proc bn:DWORD
	invoke HeapFree,BN_HHEAP,HEAP_GENERATE_EXCEPTIONS+HEAP_ZERO_MEMORY,bn
	.if eax
		ret
	.endif
	mov eax,BNERR_FREE
	call _bn_error
	ret
bnDestroy endp

end
