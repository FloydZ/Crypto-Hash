

Cipher 	   	PROTO pAlgorithm:DWORD, EncDec:DWORD, pIn:DWORD, pOut:DWORD, iSize:DWORD, pKey:DWORD, iKeySize:DWORD, pMode:DWORD, pIV:DWORD
CFBENCproc 	PROTO pInit:DWORD, pUpdate:DWORD, pIn:DWORD, pOut:DWORD, iSize:DWORD, iInputSize:DWORD, pKey:DWORD, iKeySize:DWORD, pIV:DWORD
CFBDECproc 	PROTO pInit:DWORD, pUpdate:DWORD, pIn:DWORD, pOut:DWORD, iSize:DWORD, iInputSize:DWORD, pKey:DWORD, iKeySize:DWORD, pIV:DWORD
CBCDECproc 	PROTO pInit:DWORD, pUpdate:DWORD, pIn:DWORD, pOut:DWORD, iSize:DWORD, iInputSize:DWORD, pKey:DWORD, iKeySize:DWORD, pIV:DWORD
CBCENCproc 	PROTO pInit:DWORD, pUpdate:DWORD, pIn:DWORD, pOut:DWORD, iSize:DWORD, iInputSize:DWORD, pKey:DWORD, iKeySize:DWORD, pIV:DWORD
ECBproc   	PROTO pInit:DWORD, pUpdate:DWORD, pIn:DWORD, pOut:DWORD, iSize:DWORD, iInputSize:DWORD, pKey:DWORD, iKeySize:DWORD
StrCmp 		PROTO :DWORD,:DWORD


.data
aes  db "aes",0
des  db "des",0
xtea  db "xtea",0
twofish  db "twofish",0
rc2  db "rc2",0
rc4  db "rc4",0
rc5  db "rc5",0
rc6  db "rc6",0
q128  db "q128",0
mmb  db "mmb",0
scop  db "scop",0
tea  db "tea",0
misty1  db "misty1",0

CBC db "CBC",0
CFB db "CFB",0
ECB db "ECB",0
.code
;TODO
;CFB buggt die letzte runde

Cipher proc uses esi edi pAlgorithm:DWORD, EncDec:DWORD, pIn:DWORD, pOut:DWORD, iSize:DWORD, pKey:DWORD, iKeySize:DWORD, pMode:DWORD, pIV:DWORD
	;funktionsweise
	;1	Tabelle mit -> Valid Keysize, Valid In/Out Size
	;2	Tabelle mit PTR auf richtige Funktionen
	;3	Oder fallunterscheidung

	invoke StrCmp, pAlgorithm, offset aes
	.if (eax == 0) 
		mov edi, offset RijndaelInit
		.if (EncDec == 0)
			mov esi, offset RijndaelEncrypt
		.else 
			mov esi, offset RijndaelDecrypt
		.endif
	.endif
	
	invoke StrCmp, pMode, offset ECB
	.if (eax == 0) 
		invoke ECBproc, edi, esi, pIn, pOut, iSize, 16, pKey, iKeySize
	.endif
	
	invoke StrCmp, pMode, offset CFB
	.if (eax == 0) 
		.if (EncDec == 0)
			invoke CFBENCproc, edi, esi, pIn, pOut, iSize, 16, pKey, iKeySize, pIV
		.else 
			invoke CFBDECproc, edi, esi, pIn, pOut, iSize, 16, pKey, iKeySize, pIV
		.endif
		
	.endif
	
	invoke StrCmp, pMode, offset CBC
	.if (eax == 0) 
		.if (EncDec == 0)
			invoke CBCENCproc, edi, esi, pIn, pOut, iSize, 16, pKey, iKeySize, pIV
		.else 
			invoke CBCDECproc, edi, esi, pIn, pOut, iSize, 16, pKey, iKeySize, pIV
		.endif
		
	.endif
	
	ret
Cipher endp
;output = output xor intput in isize steps
XORproc proc uses edx ebx ecx edi esi input:DWORD, output:DWORD, isize:DWORD
	mov edx, input
	mov ebx, output
	
	xor ecx, ecx
CFB_XOR_LOOP:
	cmp ecx, isize
	jz CFB_XOR_END
	
	mov eax, DWORD PTR [ebx]
	xor eax, DWORD PTR [edx]
	mov DWORD PTR [ebx], eax
	
	
	mov eax, 4
	
	add ebx, eax
	add edx, eax
	
	inc ecx
	jmp CFB_XOR_LOOP
CFB_XOR_END:	
	ret
XORproc endp

CFBDECproc proc uses edx ecx ebx esi edi pInit:DWORD, pUpdate:DWORD, pIn:DWORD, pOut:DWORD, iSize:DWORD, iInputSize:DWORD, pKey:DWORD, iKeySize:DWORD,  pIV:DWORD
	LOCAL iXOR:DWORD
	
	push iKeySize
	push pKey
	call pInit
	
	xor edx, edx
	
	mov eax, iInputSize
	mov ebx, 4
	div ebx
	dec eax
	mov iXOR, eax
	
	push pOut											
	push pIV
	call pUpdate										; so IV schon mal verschlüsselt

	invoke XORproc, pIn, pOut, iXOR
	
	mov eax, iSize
	xor edx, edx
	div iInputSize										; eax = iSize/ iInput Size = Anzahl Runden
	test edx, edx
	jne CFBDEC_ungerade
	jmp CFBDEC_gerade
CFBDEC_ungerade:
	inc eax 									
CFBDEC_gerade:	
	mov esi, eax
	
	mov ecx, 0h
	inc ecx
	
	mov edi ,pIn										
	mov ebx, pOut
	
MainLoopCFBDEC:
	cmp esi, ecx
	jz FinishCFBDEC
	push ecx
	;fahrplan
	;1 pIn XOR pOut = POut
	;2 pIn -> DEC -> pOUt + 1
	invoke XORproc, edi, ebx, iXOR
	
	mov edx, iInputSize
	add ebx, edx
	
	push ebx
	push edi
	call pUpdate
	
	mov edx, iInputSize
	add edi, edx

	pop ecx
	inc ecx
	jmp MainLoopCFBDEC
FinishCFBDEC:
	;3 pOut_last XOR PIn_last = pOut_last
	invoke XORproc, edi, ebx, iXOR
	ret
CFBDECproc endp

CFBENCproc proc uses edx ecx ebx esi edi pInit:DWORD, pUpdate:DWORD, pIn:DWORD, pOut:DWORD, iSize:DWORD, iInputSize:DWORD, pKey:DWORD, iKeySize:DWORD,  pIV:DWORD
	LOCAL iXOR:DWORD
	
	push iKeySize
	push pKey
	call pInit
	
	xor edx, edx
	
	mov eax, iInputSize
	mov ebx, 4
	div ebx
	dec eax
	mov iXOR, eax
	
	push pOut											
	push pIV
	call pUpdate										; so IV schon mal verschlüsselt

	invoke XORproc, pIn, pOut, iXOR
	
	mov eax, iSize
	xor edx, edx
	div iInputSize										; eax = iSize/ iInput Size = Anzahl Runden
	test edx, edx
	jne CFBDEC_ungerade
	jmp CFBDEC_gerade
CFBDEC_ungerade:
	inc eax 									
CFBDEC_gerade:
	mov esi, eax
	
	mov ecx, 1h

MainLoopCFBENC:
	cmp esi, ecx
	jz FinishCFBENC
	push ecx
	
	mov edi ,pIn										;wir für später vorbereitet
	mov ebx, pOut
	mov edx, ecx
	imul edx, iInputSize
	
	add edi, edx
	push edi											; nach pUpdate wieder gepop
	
	add ebx, edx
	push ebx											; pOut = pOut +1
	push ebx											; für später
	
	
	dec ecx
	mov ebx, pOut
	mov edx, ecx
	imul edx, iInputSize
	add ebx, edx
	push ebx											; pIn  = pOut

	call pUpdate
	
	
	pop ebx												;pOut +1
	pop edx												;pIn + 1
	invoke XORproc, edx, ebx, iXOR 						; ebx = ebx xor edx
	
	pop ecx
	inc ecx
	jmp MainLoopCFBENC
FinishCFBENC:
	ret
CFBENCproc endp

ECBproc proc uses edx ecx ebx esi pInit:DWORD, pUpdate:DWORD, pIn:DWORD, pOut:DWORD, iSize:DWORD, iInputSize:DWORD, pKey:DWORD, iKeySize:DWORD
	
	push iKeySize
	push pKey
	call pInit
	
	mov eax, iSize
	xor edx, edx
	div iInputSize										; eax = iSize/ iInput Size = Anzahl Runden
	test edx, edx
	jne CFBDEC_ungerade
	jmp CFBDEC_gerade
CFBDEC_ungerade:
	inc eax 									
CFBDEC_gerade:
	mov esi, eax
	xor ecx, ecx

MainLoopECB:
	cmp esi, ecx
	jz FinishECB
	push ecx
	
	mov eax, pOut
	mov edx, ecx
	imul edx, iInputSize
	
	add eax, edx
	push eax						;pOut + offset
	
	mov eax, pIn
	add eax, edx
	push eax						;pIn + offset
	
	call pUpdate
	
	pop ecx
	inc ecx
	jmp MainLoopECB
FinishECB:
	ret
ECBproc endp

CBCENCproc proc uses edx ecx ebx esi pInit:DWORD, pUpdate:DWORD, pIn:DWORD, pOut:DWORD, iSize:DWORD, iInputSize:DWORD, pKey:DWORD, iKeySize:DWORD, pIV:DWORD
	LOCAL iXOR:DWORD
	;LOCAL pTemp[16]:byte
	
	push iKeySize
	push pKey
	call pInit
	
	xor edx, edx
	
	mov eax, iInputSize
	mov ebx, 4
	div ebx
	dec eax
	mov iXOR, eax
	
	invoke XORproc, pIV, pIn, iXOR
	
	mov eax, iSize
	xor edx, edx
	div iInputSize										; eax = iSize/ iInput Size = Anzahl Runden
	test edx,edx
	jne CNCENC_ungerade
	jmp CBCENC_gerade
CNCENC_ungerade:
	inc eax 									
CBCENC_gerade:
	mov esi, eax
	xor ecx, ecx
	
	mov edi ,pIn										
	mov ebx, pOut
MainLoopCBCENC:
	cmp esi, ecx
	jz FinishCBCENC
	push ecx
	
	push ebx						;out	
	push edi						;in
	call pUpdate
	
	mov edx, iInputSize
	add edi, edx
	invoke XORproc, pOut, pIn, iXOR
	
	mov edx, iInputSize
	add ebx, edx
	
	pop ecx
	inc ecx
	jmp MainLoopCBCENC
FinishCBCENC:
	push ebx
	push edi
	call pUpdate				;letzte enc
	
	ret
CBCENCproc endp

CBCDECproc proc uses edx ecx ebx esi pInit:DWORD, pUpdate:DWORD, pIn:DWORD, pOut:DWORD, iSize:DWORD, iInputSize:DWORD, pKey:DWORD, iKeySize:DWORD, pIV:DWORD
	LOCAL iXOR:DWORD
	;LOCAL pTemp[16]:byte
	
	push iKeySize
	push pKey
	call pInit
	
	xor edx, edx
	mov eax, iInputSize
	mov ebx, 4
	div ebx
	dec eax
	mov iXOR, eax
	
	mov edi ,pIn										
	mov ebx, pOut
	push ebx
	push edi
	call pUpdate
	
	invoke XORproc, pIV, pOut, iXOR
	
	mov eax, iSize
	xor edx, edx
	div iInputSize										; eax = iSize/ iInput Size = Anzahl Runden
	test edx,edx
	jne CNCDEC_ungerade
	jmp CBCDEC_gerade
CNCDEC_ungerade:
	inc eax 									
CBCDEC_gerade:
	mov esi, eax
	xor ecx, ecx
	

MainLoopCBCDEC:
	cmp esi, ecx
	jz FinishCBCDEC
	push ecx
	
	mov edx, iInputSize
	add edi, edx
	add ebx, edx
		
	push ebx										;pOut + 1
	push edi										;pIn +1
	call pUpdate
	
	mov edx, iInputSize
	sub edi, edx
	
	invoke XORproc, edi, ebx, iXOR					;pIn XOR pOUT + 1 = Pout +1 
		
	add edi, edx
	
	pop ecx
	inc ecx
	jmp MainLoopCBCDEC
FinishCBCDEC:

	
	ret
CBCDECproc endp

StrCmp proc uses esi edx ecx pString1:DWORD, pString2:DWORD
	mov ecx, pString1
	mov eax, pString2
	
    mov	edx, [ecx]	; Comparing two strings in edx and esi
    mov  esi,  [eax]
    xor    edx,  esi
    jnz    end_check

	mov eax, 0
	ret
	
end_check:     
	mov eax, 1
	ret
 
StrCmp endp
