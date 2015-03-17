.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

;;
;;	copies bn to sequence of bytes
;;	returns sign
;;
;_a_
bnToBytes proc uses edi esi bn:DWORD, pBytes:DWORD
	mov esi,bn
	mov edi,pBytes
	mov ecx,[esi].BN.dwSize
	shl ecx,2
	lea esi,[esi].BN.dwArray[0]
	rep movsb
	mov eax,[esi].BN.bSigned
	ret
bnToBytes endp

end
