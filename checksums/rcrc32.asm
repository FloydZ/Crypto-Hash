
INIT_CRC32 equ 0
EXTERNDEF CRC32Table:DWORD

.code
CRC32 proto :DWORD,:DWORD,:DWORD

;align 16
RCRC32 proc uses ebx esi edi pData:dword,dwDataLen:dword,dwOffset:dword,dwWantCrc:dword
	mov esi,pData
	invoke CRC32,esi,dwOffset,INIT_CRC32
	mov edx,dwDataLen
	mov edi,esi
	test edx,edx
	mov ecx,dwWantCrc
	jz @@Exit
	add esi,edx
	add edi,dwOffset
	mov [edi],eax
	xor ecx,-1
	xor eax,eax
	push ecx
	mov edx,4
	push eax
	; rcrc32(@wantcrc,4)
	.repeat
		mov al,[esp+edx+3]
		call @@GetTableEntry
		xor [esp+edx],eax
		xor [esp+edx-1],cl
		dec edx
	.until zero?
	add edi,4
	jmp @F
	; rcrc32(pData+dwOffset+4,dwDataLen-dwOffset))
	.repeat
		mov eax,[esp]
		sub esi,4
		xor ecx,ecx
		xor eax,[esi]
		mov [esp],ecx
		mov [esp+4],eax
		mov edx,4
		.repeat
			mov al,[esp+edx+3]
			call @@GetTableEntry
			xor [esp+edx],eax
			xor [esp+edx-1],cl
			dec edx
		.until zero?
@@:
	.until esi <= edi  
	pop eax
	xor eax,-1
	xor [edi-4],eax; dwRCRC xor crc32(pData,dwOffset,0)
	add esp,4
@@Exit:
	ret
@@GetTableEntry:
	xor ecx,ecx
	.repeat
		.break .if al == byte ptr [CRC32Table+ecx*4+3]
		inc cl
	.until zero?
	mov eax,[CRC32Table+ecx*4]
	retn
RCRC32 endp
