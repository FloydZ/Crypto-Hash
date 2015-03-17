.686
option casemap:none
include bnlib.inc
include bignum.inc

.code

;;
;;	copies sequence of bytes to a bn
;;
;_a_ 
bnFromBytes proc uses edi esi pBytes:DWORD,dwBytesLen:dword,bn:DWORD,bSigned:dword
	invoke bnClear,bn
	mov ecx,dwBytesLen
	mov edi,bn
	mov eax,ecx
	mov esi,pBytes
	add eax,3
	and eax,-4
	shr eax,2
	mov [edi].BN.dwSize,eax
	movzx edx,byte ptr bSigned
	mov [edi].BN.bSigned,edx
	lea edi,[edi].BN.dwArray[0]
	rep movsb
	ret
bnFromBytes endp

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

;;
;;	arg1 = pointer to base10 string, zero terminated
;;	arg2 = bn
;;	converts ascii string to bn
;;
;_a_ 
bnFromStr proc uses ebx edi esi ptrStr:DWORD, bn:DWORD
	mov edi,bn
	mov esi,ptrStr
	invoke bnClear,edi
	.if word ptr [esi]=='0'
		ret
	.endif
	.if byte ptr [esi]=='-'
		inc esi
		mov byte ptr [edi].BN.bSigned,1
	.endif
	.while BYTE PTR [esi]=='0' ; call StrDel0 
		inc esi
	.endw
	.while 1;<>0
		movzx ebx,byte ptr [esi]
		.break .if !ebx
		sub ebx,'0'
		add esi,1
		invoke bnMulDw,edi,10
		invoke bnAddDw,edi,ebx
	.endw  
	ret
bnFromStr endp

;;
;;	copies bn to sequence of bytes
;;	returns sign
;;
;_a_
bnToBytes proc uses edi esi bn:DWORD, pBytes:DWORD
	mov esi,bn
	mov edi,pBytes
	mov ecx,[esi].BN.dwSize
	shl ecx,2
	lea esi,[esi].BN.dwArray[0]
	rep movsb
	mov eax,[esi].BN.bSigned
	ret
bnToBytes endp

;;
;;	converts bn to sequence of bytes bswap-ed
;;	returns sign
;_a_ 
bnToBytesEx proc uses esi edi bn:dword,pBytes:dword
	mov esi,bn
	mov edi,pBytes
	mov ecx,[esi].BN.dwSize
	mov edx,[esi].BN.bSigned
	lea esi,[esi].BN.dwArray[ecx*4-4]
	.repeat
		mov eax,[esi]
		sub esi,4
		bswap eax
		stosd
		dec ecx
	.until zero?
	mov eax,edx
	ret
bnToBytesEx endp


bnToHex proc uses edi esi ebx bn:DWORD,ptrStr:DWORD
	mov esi,bn
	mov edi,ptrStr
	.if BN_IS_ZERO(esi)
		mov dword ptr [edi],'00'
		mov eax,2
		ret
	.endif
	.if [esi].BN.bSigned
		mov byte ptr [edi],'-'
		inc edi
	.endif
	mov eax,[esi].BN.dwSize
	lea esi,[esi].BN.dwArray[eax*4-4]
	mov ecx,[esi]
	mov edx,ecx
	bswap ecx
	mov ebx,3
	dec cl
	sbb ebx,0
	dec ch
	sbb ebx,0
	dec dh
	sbb ebx,0
	.repeat
		movzx eax,byte ptr [esi+ebx]
		mov ecx,eax
		shr ecx,4
		and eax,1111b
		and ecx,1111b
		cmp eax,10
		sbb edx,edx
		adc eax,0
		lea eax,[eax+edx*8+('0'+7)]
		cmp ecx,10
		sbb edx,edx
		adc ecx,0
		shl eax,8
		lea ecx,[ecx+edx*8+('0'+7)]
		or eax,ecx
		mov [edi],ax
		add edi,2	
		dec ebx
	.until sign?
	mov esi,bn
	mov ebx,[esi].BN.dwSize
	jmp @F
	.repeat
		mov ecx,[esi].BN.dwArray[ebx*4-4]
		mov edx,ecx
		shr edx,4
		push ebx
		and ecx,0F0F0F0Fh
		and edx,0F0F0F0Fh
		lea ebx,[ecx+06060606h]
		lea eax,[edx+06060606h]
		and ebx,10101010h
		and eax,10101010h
		shr ebx,4
		shr eax,4
		lea ecx,[ecx+ebx*8+30303030h]
		lea edx,[edx+eax*8+30303030h]
		sub ecx,ebx
		sub edx,eax
		pop ebx
		mov [edi+7],cl
		mov [edi+6],dl
		mov [edi+5],ch
		mov [edi+4],dh
		shr ecx,16
		mov byte ptr [edi+8],0
		shr edx,16
		mov [edi+3],cl
		mov [edi+2],dl
		mov [edi+1],ch
		mov [edi+0],dh
		add edi,8
@@:		dec ebx
	.until zero?
	mov eax,edi
	sub eax,ptrStr
	mov [edi],bl
	ret
bnToHex endp



;;
;;	analogue to bn2Hex
;;
;_a_ 
bnToStr proc uses ebx edi esi bn:DWORD, ptrStr:DWORD
	mov esi,bn
	mov ebx,ptrStr
	.if BN_IS_ZERO(esi)
		mov word ptr [ebx],'0'
		ret
	.endif
	.if [esi].BN.bSigned
		mov byte ptr [ebx],'-'
		inc ebx
		inc ptrStr
	.endif
	bnCreateX edi
	invoke bnMov,edi,esi
	.while !BN_IS_ZERO(edi)
		invoke bnDivDw,edi,10,edi
		add al,'0'
		mov [ebx],al
		inc ebx
	.endw  
	and byte ptr [ebx],0
	mov esi,ptrStr
	mov eax,ebx
	sub eax,esi
	shr eax,1
	.if !zero?
		.repeat
			dec ebx
			mov dl, [esi]
			mov cl, [ebx]
			inc esi
			mov [ebx], dl
			mov [esi-1], cl
			dec eax
		.until ZERO?
	.endif
	bnDestroyX
	ret
bnToStr endp
