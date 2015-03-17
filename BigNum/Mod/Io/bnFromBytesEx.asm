.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

;;
;;	converts sequence of bytes to a bn bswap-ed
;;
;_a_
bnFromBytesEx proc uses edi esi pBytes:DWORD,dwBytesLen:dword,bn:DWORD,bSigned:dword
	invoke bnClear,bn
	mov edx,BN_ALLOC_BYTES
	mov ecx,dwBytesLen
	sub edx,4
	mov esi,pBytes
	sub edx,ecx
	.if !sign?
		mov edx,ecx
		mov edi,bn
		shr edx,2
		lea edi,[edi].BN.dwArray
		lea esi,[esi+ecx]
		.if !zero?
			mov [edi-BN.dwArray],edx
		@@:
			mov eax,[esi-4]
			sub esi,4
			bswap eax
			stosd
			dec edx
			jnz @B
		.endif
		and ecx,3
		.if !zero?
			neg ecx
		@@:
			mov al,[esi+ecx]
			stosb
			inc ecx
			jnz @B
			mov edi,bn
			inc [edi].BN.dwSize
		.endif
		mov eax,bSigned
		mov [edi].BN.bSigned,eax
	.endif
	ret
bnFromBytesEx endp

end

