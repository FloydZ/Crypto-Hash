.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnFromHex proc uses edi esi ebx ptrStr:DWORD,bn:DWORD
	mov esi,bn
	mov edi,ptrStr
	invoke bnClear,esi
	mov al,[edi]
	mov edx,0
	test al,al
	je @@Exit
	cmp al,'-'
	jne @F
	mov edx,1
	.repeat
		inc edi     ; skip leading zero(s)
		mov al,[edi]
@@:	.until al != '0' 	
	mov	ecx,edi
	jmp @F
	.repeat
		inc ecx
@@:		mov al,[ecx]
	.until !al
	sub ecx,edi ; new length
	jz @@Exit
	mov [esi].BN.bSigned,edx
	mov eax,ecx ; {
	add ecx,7   ;
	and ecx,-8  ; align 8
	shr ecx,3   ; number of 8-char parts
	xor ebx,ebx
	mov [esi].BN.dwSize,ecx ; } bignum len (dwords)
	xor edx,edx
	lea esi,[esi].BN.dwArray[ecx*4-4]  ; point to last dword in array (MSD)
	.while eax
		movzx edx,byte ptr [edi]
		add edx, - 'a'
		jns @F
		add edx, 'a' - 'A'
		jns @F
		add edx,7
@@:		add edx,10
		dec eax
		shl ebx,4
		mov ecx,eax
		inc edi
		add ebx,edx
		and ecx,7; mod 8 ; wait for a dword
		.if zero?
			mov [esi],ebx        
			sub esi,4; LSD...MSD
		.endif
	.endw
	mov eax,esi
@@Exit:
	ret
bnFromHex endp

end
