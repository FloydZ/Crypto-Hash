.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnShl proc uses edi esi ebx bn:DWORD,sc:DWORD
	mov edx,sc
	shr edx,5
	jnz @@Shl32 
@@Shlle31:	; do <32 bit shifts
	mov ecx,sc
	mov esi,bn
	and ecx,31
	jz @@Exit
	mov ebx,[esi].BN.dwSize
	xor eax,eax
	lea esi,[esi].BN.dwArray[ebx*4-2*4]
	mov edx,[esi+1*4]
	shld eax,edx,cl
	mov edi,eax
	jmp @F
	.repeat
		mov eax,[esi]
		shld edx,eax,cl
		mov [esi+1*4],edx
		mov edx,eax
		sub esi,4
@@:		dec ebx
	.until zero?
	shl edx,cl
	mov eax,edi
	mov [esi+1*4],edx
	mov edi,bn
	call _bn_add_carry_dword
@@Exit:	
	ret
@@Shl32:	; do 32 bit shifts
	mov esi,bn
	mov ebx,[esi].BN.dwSize
	lea eax,[ebx+edx]
	.if eax <= BN_MAX_DWORD
		mov [esi].BN.dwSize,eax
		lea edi,[esi].BN.dwArray[eax*4-4]
		lea esi,[esi].BN.dwArray[ebx*4-4]
		std
		mov ecx,ebx
		rep movsd
		mov ecx,edx
		xor eax,eax
		rep stosd
		cld
		jmp @@Shlle31 
	.endif
	mov eax,BNERR_OVERFLOW
	call _bn_error
	ret
bnShl endp
end