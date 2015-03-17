.data?
	MillerRabinBuffer dd 32 dup (?)
	PTR_RNG_FKT dd ?
.code
;DO NOT FORGET to ini the RNG
MillerRabinInit proc RNG_FKT:DWORD
	m2m PTR_RNG_FKT, RNG_FKT
	ret
MillerRabinInit endp

MillerRabinTest proc uses ecx edi esi bnW:DWORD, Iter:DWORD
	
	LOCAL bnProdukt:DWORD
	LOCAL bnW2:DWORD
	LOCAL bnM:DWORD
	LOCAL bnB:DWORD
	LOCAL bnG:DWORD
	LOCAL bnZ:DWORD
	LOCAL bnX:DWORD
	LOCAL a:DWORD
	LOCAL wlen:DWORD
	LOCAL b:DWORD
	
	
	invoke bnCreate
	mov bnM, eax
	invoke bnCreate
	mov bnB, eax
	invoke bnCreate
	mov bnW2, eax
	invoke bnCreate
	mov bnZ, eax
	invoke bnCreate
	mov bnX, eax
	invoke bnCreate
	mov bnG, eax
	
	invoke bnCreate
	mov ebx, eax
	invoke bnCreatei, 2
	mov bnProdukt, eax
	
	invoke bnMov, bnW2, bnW
	invoke bnDec, bnW2
	
;gesucht is a sodass (w-1)/2^a	
	xor ecx, ecx	;counter
	xor esi, esi 	;treffer
MillerRabinLoopA:
	invoke bnDiv, bnW2, bnProdukt, bnM, ebx

	.if BN_IS_ZERO(ebx)					;Treffer 
		mov esi, 1
	.else 
		.if (esi == 1)
			jmp MillerRabinStrike
		.endif
	.endif

	invoke bnMulDw, bnProdukt, 2
	add ecx, 1
	jmp MillerRabinLoopA
	
MillerRabinStrike:						;a gefunden
	dec ecx
	mov a, ecx
	
	;m = (w -1)/2^a
	invoke bnMov, bnM, bnProdukt 
	
	;wlen = Len(w)
	invoke bnBits, bnW
	mov wlen, eax
	mov ecx, 1
	push ecx
MillerRabinMainLoop:
		call PTR_RNG_FKT
		.if (eax == 0)
			jmp MillerRabinEnd
		.endif
		
		;.if (eax >= bnM)						Fehlt noch
		
		invoke bnMovzx, bnB, 2 ;Debug eax
		
		;g = gdc (b,m)
		invoke bnGCD, bnB, bnW, bnG
		
		;z = b^m mod w
		invoke bnModExp, bnB, bnM, bnW, bnZ
		
		.if BN_IS_ONE(bnZ)	
			jmp MillerRabinEnd
		.endif
		
		invoke bnCmp,bnProdukt, bnW2
		.if (eax == 0)
			jmp MillerRabinEnd
		.endif
		
		invoke bnMovzx, bnProdukt, 2
		xor ecx, ecx
		
		;x = z
		;z = x^2 mod w
		MillerRabinLoopB:
			inc ecx
			push ecx
			invoke bnMov,bnX, bnZ
			invoke bnModExp, bnX, bnProdukt, bnW, bnZ
			
			invoke bnCmp, bnZ, bnW2
			.if (eax == 0)
				pop ecx
				jmp MillerRabinEnd
			.endif
			.if BN_IS_ONE(bnZ)
				pop ecx	
				jmp MillerRabinPreEnd
			.endif
			
			pop ecx
			mov eax, a
			cmp eax, ecx
			jne MillerRabinLoopB
			
		
		invoke bnMov, bnX, bnZ
		invoke bnModExp, bnX, bnProdukt, bnW, bnZ
		.if BN_IS_ONE(bnZ)	
			jmp MillerRabinPreEnd
		.endif
		
		invoke bnMov, bnX, bnZ
		
MillerRabinPreEnd:
		invoke bnDec, bnX
		invoke bnGCD, bnX, bnW, bnG
		
		.if BN_IS_ONE(bnG)	
			mov eax, 1
			ret 
		.endif
		
		mov eax, 2
		ret 
MillerRabinEnd:
	pop ecx
	cmp ecx, Iter
	jne MillerRabinMainLoop
	
	mov eax, 0
	ret
MillerRabinTest endp