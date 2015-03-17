.686
.model flat,stdcall
option casemap:none
include windows.inc
include wincrypt.inc
include .\bnlib.inc
include .\bignum.inc

.code

bnInit proc MaxBits:DWORD
	mov eax,MaxBits
	and eax,03FFFh; limit
	add eax,31
	and eax,-32; align 32
	mov edx,eax
	shr edx,3; bytes
	shr eax,5; dwords
	shl edx,BN_SIZE_EXPAND/2; BN_SIZE_EXPAND is 2 or 4 
	shl eax,BN_SIZE_EXPAND/2
	add edx,BN.dwArray; place for size & sign 
	mov BN_MAX_DWORD,eax
	mov BN_ALLOC_BYTES,edx
	mov edx,BN_ALLOC_BYTES
	imul edx,BN_SIZE_HEAP
	;; allocate 16 bigs for start
	invoke HeapCreate,HEAP_GENERATE_EXCEPTIONS+HEAP_ZERO_MEMORY,edx,0
	mov BN_HHEAP,eax
	__PROV_RSA_FULL equ 1
	invoke CryptAcquireContextA,addr BN_HPROV,0,0,__PROV_RSA_FULL,0
	cmp BN_HHEAP,1
	sbb edx,edx
	inc edx
	and eax,edx
	ret
bnInit endp

end
