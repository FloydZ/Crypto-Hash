.const

ADLER32_BASE equ 65521 ; largest prime smaller than 65536
ADLER32_NMAX equ 5552 ; largest n such that 255n(n+1)/2 + (n+1)(BASE-1) <= 2^32-1

.code

align dword
Adler32 proc uses edi esi ebx lpBuffer:DWORD, dwBufLen:DWORD, dwAdler:DWORD
	mov eax,dwAdler
	mov ecx,dwBufLen
	mov ebx,dwAdler
	and eax,0FFFFh
	shr ebx,16
	mov esi,lpBuffer
	jmp @F
	.repeat
		mov edi,ADLER32_NMAX
		.if ecx<edi
			mov edi,ecx
		.endif
        sub ecx,edi
		.repeat
			movzx edx,byte ptr [esi]
			add eax,edx
			inc esi
			add ebx,eax
			dec edi
		.until ZERO?
        mov edi,ADLER32_BASE
        xor edx,edx
        div edi
        push edx
        mov eax,ebx
        xor edx,edx
        div edi
        mov ebx,edx
        pop eax
@@:		test ecx,ecx
	.until ZERO?
	shl ebx,16
	add eax,ebx
	ret
Adler32 endp
