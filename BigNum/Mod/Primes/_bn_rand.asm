.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.data?
bn_dwrandseed dd ?

.code

;; returns offset of bn_dwrandseed so we can change it
;; if needed
_bn_dwrandomize proc c
	rdtsc
	mov bn_dwrandseed,eax
	mov eax,offset bn_dwrandseed
	ret
_bn_dwrandomize endp

; ecx = range
_bn_dwrandom proc c
	mov eax,bn_dwrandseed
	mov edx,41c64e6dh
	mul edx
	add eax,3039h
	xor edx,edx
	mov bn_dwrandseed,eax
	div ecx
	mov eax,edx
	ret
_bn_dwrandom endp

end
