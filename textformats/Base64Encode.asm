
.data 
align 4
b64chars label byte
db 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

.code

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

; returns b64 string len
Base64Encode proc pInputData:DWORD,dwDataLen:DWORD,pOutputStr:DWORD
	push ebp
	push esi
	push edi
	push ebx
	mov esi,[esp+1*4][4*4];pInputData
	mov ebp,[esp+2*4][4*4];dwDataLen
	mov edi,[esp+3*4][4*4];pOutputStr
	.repeat
		test ebp,ebp
		jz @F; exact divide 3?
		; EEEEEEFF CCDDDDDD BBBBCCCC AAAAAABB
		mov al,[esi+0]
		mov dl,[esi+1]
		mov bl,[esi+2]
		mov ah,al
		mov dh,dl
		mov bh,bl
		and ah,00000011b
		and dh,00001111b
		and bh,00111111b
		shr al,2
		shr dl,4
		shr bl,6
		shl ah,4
		shl dh,2
		or ah,dl
		or bl,dh
		movzx edx,al
		movzx ecx,ah
		mov al,[edx+b64chars]
		mov ah,[ecx+b64chars]
		movzx edx,bl
		movzx ecx,bh
		mov bl,[edx+b64chars]
		mov bh,[ecx+b64chars]
		and eax,0FFFFh
		shl ebx,16
		add esi,3
		or eax,ebx
		stosd
		sub ebp,3
	.until SIGN?
    add edi,ebp
    .repeat
		mov byte ptr [edi],'='
	    inc edi
		inc ebp
    .until ZERO?
@@:	mov eax,edi
	pop ebx
	mov [eax],bp
	pop edi
	pop esi
	sub eax,[esp+3*4][1*4];pOutputStr
	pop ebp
	ret 3*4
Base64Encode endp

OPTION PROLOGUE:PROLOGUEDEF 
OPTION EPILOGUE:EPILOGUEDEF
