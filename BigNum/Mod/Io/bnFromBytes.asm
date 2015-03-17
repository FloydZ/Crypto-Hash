.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

;;
;;	copies sequence of bytes to a bn
;;
;_a_ 
bnFromBytes proc uses edi esi pBytes:DWORD,dwBytesLen:dword,bn:DWORD,bSigned:dword
	invoke bnClear,bn
	mov ecx,dwBytesLen
	mov edi,bn
	mov eax,ecx
	mov esi,pBytes
	add eax,3
	and eax,-4
	shr eax,2
	mov [edi].BN.dwSize,eax
	movzx edx,byte ptr bSigned
	mov [edi].BN.bSigned,edx
	lea edi,[edi].BN.dwArray[0]
	rep movsb
	ret
bnFromBytes endp

end
