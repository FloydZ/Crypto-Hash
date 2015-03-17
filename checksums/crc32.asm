.data
;align 16
CRC32Table label dword
i = 0
crc = i
WHILE i LT 256
	crc = i
	REPT 8
	    crc = (crc shr 1) xor (0EDB88320h * (crc and 1))
	ENDM
	DD crc
	i = i + 1
ENDM

.code

;align 16
CRC32 proc uses esi lpBuffer:DWORD,dwBufLen:DWORD,dwCRC:DWORD
	mov eax,dwCRC
	mov ecx,dwBufLen
	xor eax,-1
	test ecx,ecx
	mov esi,lpBuffer
	jz @F
	.repeat
		xor al,[esi]
		movzx edx,al
		shr eax,8
		mov edx,[CRC32Table+edx*4]
		inc esi
		xor eax,edx
		dec ecx
	.until zero?
@@:	xor eax,-1
	ret
CRC32 endp
