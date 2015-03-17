.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code
;; ECX == predicted maximum
_bn_normalize proc c; uses ecx
	.repeat
		cmp [edi].BN.dwArray[ecx*4-1*4],0
		jnz @F
		dec ecx
	.until zero?; bn == 0
	mov [edi].BN.bSigned,ecx
	inc ecx
@@:	mov [edi].BN.dwSize,ecx
	ret
_bn_normalize endp

end
