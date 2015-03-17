.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

;;
;;	converts bn to sequence of bytes bswap-ed
;;	returns sign
;_a_ 
bnToBytesEx proc uses esi edi bn:dword,pBytes:dword
	mov esi,bn
	mov edi,pBytes
	mov ecx,[esi].BN.dwSize
	mov edx,[esi].BN.bSigned
	lea esi,[esi].BN.dwArray[ecx*4-4]
	.repeat
		mov eax,[esi]
		sub esi,4
		bswap eax
		stosd
		dec ecx
	.until zero?
	mov eax,edx
	ret
bnToBytesEx endp

end
