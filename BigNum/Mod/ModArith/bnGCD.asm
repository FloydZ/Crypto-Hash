.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

;
;	result=gcd(x,y)
;	greatest common divisor (x,y)
;	Modern Euclidean Algorithm 
;	
bnGCD proc uses ebx edi esi bnX:DWORD, bnY:DWORD, bnResult:DWORD
	bnCreateX edi,ebx,esi
	invoke bnMov,edi,bnX
	invoke bnMov,esi,bnY
	.while !BN_IS_ZERO(esi)
		invoke bnMod,edi,esi,ebx; ebx = edi % esi
		invoke bnMov,edi,esi    ; edi = esi
		invoke bnMov,esi,ebx    ; esi = ebx
	.endw
	invoke bnMov,bnResult,edi
	bnDestroyX
	ret
bnGCD endp

end