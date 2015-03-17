
.data
;align 16
CRC16_Table label dword
i = 0
crc = i
WHILE i LT 256
	crc = i
	REPT 8
	    crc = (crc shr 1) xor (0A001h * (crc and 1))
	ENDM
	DW crc
	i = i + 1
ENDM

.code
;align 16
CRC16 proc uses esi edi ebx lpBuffer:DWORD, dwBufLen:DWORD, dwCRC:DWORD
	mov eax,dwCRC
	mov esi,lpBuffer
	and eax,0FFFFh
	mov ecx,dwBufLen 
	jmp @F
	.repeat
		xor al,[esi]
		movzx edx,al
		movzx edx,word ptr [CRC16_Table+2*edx]
		shr eax,8
		dec ecx
		xor eax,edx
		inc esi
@@:
		test ecx,ecx
	.until ZERO?
	ret	
CRC16 endp