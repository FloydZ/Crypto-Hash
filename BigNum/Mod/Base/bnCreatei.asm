.686
.model flat,stdcall
option casemap:none
include windows.inc
include .\bnlib.inc
include .\bignum.inc

.code

bnCreatei proc initVal:SDWORD
	invoke HeapAlloc,BN_HHEAP,HEAP_GENERATE_EXCEPTIONS+HEAP_ZERO_MEMORY,BN_ALLOC_BYTES
	.if eax
		mov edx,initVal
		mov [eax].BN.dwSize,1
		test edx,edx
		sets byte ptr [eax].BN.bSigned
		.if sign?
			neg edx
		.endif
		mov [eax].BN.dwArray[0*4],edx
		ret
	.endif
	mov eax,BNERR_ALLOC
	call _bn_error
	ret
bnCreatei endp

end
