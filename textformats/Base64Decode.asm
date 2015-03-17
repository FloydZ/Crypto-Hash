
.data 
align 4
b64table label byte
db 0,42 dup (-1)
db 62; + ; [02Bh]
db 3 dup(-1)
db 63; / ; [02Fh]
db 52,53,54,55,56,57,58,59,60,61; 0..9 ;30-39
db 3 dup(-1)
db 0 ; = ; [03Dh]
db 3 dup(-1)
db 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25; A..Z
db 6 dup(-1)
db 26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51; a..z
db 133 dup (-1)

.code

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE
Base64Decode proc pInputStr:DWORD,pOutputData:DWORD
	push ebp
	push esi
	push edi
	push ebx
	mov edi,[esp+1*4][4*4];pInputStr
	xor eax,eax
	mov esi,edi
	.repeat; strlen 
		mov al,[edi]
		add edi,4
		test al,al
	.until zero?
	lea ebp,[edi-4]
	mov eax,'='
	sub ebp,esi; 4parts
	jz @F
	cmp al,[esi+ebp-1]; padd?
	sete dl
	.if zero?;equal?
		mov [esi+ebp-1],ah
	.endif
	cmp al,[esi+ebp-2]
	sete al
	.if zero?;equal?
		mov [esi+ebp-2],ah
	.endif
	add al,dl
	mov edi,[esp+2*4][4*4];pOutputData
	shr ebp,2
	lea edx,[ebp*2+ebp]
	sub edx,eax
	push edx; result = length
	.repeat
		; CCDDDDDD BBBBCCCC AAAAAABB
		mov ecx,[esi]
		movzx edx,cl
		movzx ebx,ch
		mov al,[edx+b64table]; ..AAAAAA
		mov ah,[ebx+b64table]; ..BBBBBB
		shr ecx,16
		add esi,4
		movzx edx,cl
		movzx ecx,ch
		mov bl,[edx+b64table]; ..CCCCCC
		mov bh,[ecx+b64table]; ..DDDDDD
		mov dl,ah
		mov dh,bl
		shl al,2;AAAAAA..
		shr bl,2;....CCCC
		shl dh,6;CC......
		shl ah,4;BBBB....
		shr dl,4;......BB
		or bh,dh
		or al,dl
		or ah,bl
		mov [edi+0],al
		mov [edi+2],bh
		mov [edi+1],ah
		dec ebp
		lea edi,[edi+3]
	.until zero?
	pop eax
@@:	pop ebx
	pop edi
	pop esi
	pop ebp
	ret 2*4
Base64Decode endp

OPTION PROLOGUE:PROLOGUEDEF 
OPTION EPILOGUE:EPILOGUEDEF

