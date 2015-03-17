.686
.model flat,stdcall
option casemap:none
include windows.inc
include wincrypt.inc
include .\bnlib.inc
include .\bignum.inc

.code

bnRandom proc uses edi bn,nbit
LOCAL hProv,Result
	xor eax,eax
	mov ecx,nbit
	mov edi,bn
	shr ecx,5
	mov Result,eax
	.if ecx<=BN_MAX_DWORD
		mov [edi].BN.dwSize,ecx
		mov [edi].BN.bSigned,eax
		invoke CryptGenRandom,BN_HPROV,addr[ecx*4],addr[edi].BN.dwArray
		inc Result
	.endif
	mov eax,Result
	ret
bnRandom endp

end
