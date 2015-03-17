.686
option casemap:none
include bnlib.inc
include bignum.inc



.data

ALIGN DWORD
BN_ALLOC_BYTES	dd ((BN_DEFAULT_BITS/08)*BN_SIZE_EXPAND)+BN.dwArray
BN_MAX_DWORD	dd ((BN_DEFAULT_BITS/32)*BN_SIZE_EXPAND)
BN_HPROV		dd -1
BN_HHEAP		dd -1 ; separate heap





.code
;; X=X^^(1/2)

ABS_BN_LE_ONE macro bnreg:req
	exitm <>
endm 


bnInit proc MaxBits:DWORD
	mov eax,MaxBits
	and eax,03FFFh; limit
	add eax,31
	and eax,-32; align 32
	mov edx,eax
	shr edx,3; bytes
	shr eax,5; dwords
	shl edx,BN_SIZE_EXPAND/2; BN_SIZE_EXPAND is 2 or 4 
	shl eax,BN_SIZE_EXPAND/2
	add edx,BN.dwArray; place for size & sign 
	mov BN_MAX_DWORD,eax
	mov BN_ALLOC_BYTES,edx
	mov edx,BN_ALLOC_BYTES
	imul edx,BN_SIZE_HEAP
	;; allocate 16 bigs for start
	invoke HeapCreate,HEAP_GENERATE_EXCEPTIONS+HEAP_ZERO_MEMORY,edx,0
	mov BN_HHEAP,eax
	__PROV_RSA_FULL equ 1
	invoke CryptAcquireContext,addr BN_HPROV,0,0,__PROV_RSA_FULL,0
	cmp BN_HHEAP,1
	sbb edx,edx
	inc edx
	and eax,edx
	ret
bnInit endp

bnCreate proc
	invoke HeapAlloc,BN_HHEAP,HEAP_GENERATE_EXCEPTIONS+HEAP_ZERO_MEMORY,BN_ALLOC_BYTES
	.if eax
		mov [eax].BN.dwSize,1
		ret
	.endif
	mov eax,BNERR_ALLOC
	call _bn_error
	ret
bnCreate endp

bnCreateDw proc initVal:DWORD
	invoke HeapAlloc,BN_HHEAP,HEAP_GENERATE_EXCEPTIONS+HEAP_ZERO_MEMORY,BN_ALLOC_BYTES
	.if eax
		mov edx,initVal
		mov [eax].BN.dwSize,1
		mov [eax].BN.dwArray[0*4],edx
		ret
	.endif
	mov eax,BNERR_ALLOC
	call _bn_error
	ret
bnCreateDw endp

bnCreatei proc initVal:SDWORD
	invoke HeapAlloc,BN_HHEAP,HEAP_GENERATE_EXCEPTIONS+HEAP_ZERO_MEMORY,BN_ALLOC_BYTES
	.if eax
		mov edx,initVal
		mov [eax].BN.dwSize,1
		test edx,edx
		sets byte ptr [eax].BN.bSigned
		.if sign?
			neg edx
		.endif
		mov [eax].BN.dwArray[0*4],edx
		ret
	.endif
	mov eax,BNERR_ALLOC
	call _bn_error
	ret
bnCreatei endp

bnDestroy proc bn:DWORD
	invoke HeapFree,BN_HHEAP,HEAP_GENERATE_EXCEPTIONS+HEAP_ZERO_MEMORY,bn
	.if eax
		ret
	.endif
	mov eax,BNERR_FREE
	call _bn_error
	ret
bnDestroy endp

bnAdd proc uses edi esi ebx bnX:DWORD,bnY:DWORD
;----------------------;
;	+x + +y = +(x+y)   ;
;	-x + -y = -(x+y)   ;
;	+x + -y = x-y      ;
;	-x + +y = y-x      ;
;----------------------;
	mov edi,bnX
	mov esi,bnY
	mov eax,[edi].BN.bSigned
	mov ebx,[esi].BN.bSigned
	.if eax == ebx
		call _bn_add_ignoresign  
		ret
	.endif
	bnSCreateX edi,esi
	invoke bnMov,edi,bnX
	invoke bnMov,esi,bnY
	call _bn_cmp_array
	test eax,eax
	.if sign?
		xchg esi,edi
		mov [edi].BN.bSigned,ebx
	.endif
	call _bn_sub_ignoresign
	invoke bnMov,bnX,edi
	bnSDestroyX
	ret
bnAdd endp

bnMod proc uses edi esi ebx bnX:DWORD,bnY:DWORD,bnRem:DWORD

	mov esi,bnY
	mov edi,bnX

	cmp [esi].BN.dwSize,1 ;	.if !BN_IS_ZERO(edi); DBZ
	jne @F
	cmp [esi].BN.dwArray[0],0
	je @@DivisionByZero
@@:	
	cmp [edi].BN.dwSize,1;	.if !BN_IS_ZERO(esi); DZ
	jne @F
	cmp [edi].BN.dwArray[0],0
	je @@DivideZero
@@:	
	call _bn_cmp_array;invoke bnCmpAbs,bnX,bnY
	.if sdword ptr eax>0
 		; X > Y
		bnSCreateX esi;tempRem
		invoke bnBits,edi
;		lea ebx,[eax-1]
	;int 1;*
	lea ebx,[eax-1]
	invoke bnBits,bnY;*
	sub ebx,eax;*
	inc ebx;*
	invoke bnMov,esi,edi;*
	invoke bnShr,esi,ebx;*
	jmp @F;*		
		.repeat
			invoke bnShl1,esi;tempRem
			bt [edi].BN.dwArray[0],ebx
			setc al
			or byte ptr [esi].BN.dwArray[0],al
	@@:;*		
			invoke bnCmpAbs,esi,bnY
			test eax,eax
			.if !SIGN?
				invoke bnSub,esi,bnY
			.endif
			dec ebx
		.until SIGN?

		invoke bnMov,bnRem,esi

		mov eax,bnX
		mov edx,bnRem
		mov ebx,[eax].BN.bSigned
		mov [edx].BN.bSigned,ebx

		bnSDestroyX
		ret
	.endif
	
	test eax,eax
	.if zero?
		; X = Y
		invoke bnClear,bnRem
		ret
	.endif

	; (X < Y) OR (X = 0)
@@DivideZero:
	invoke bnMov,bnRem,bnX
	ret

@@DivisionByZero:
	mov eax,BNERR_DBZ 
	call _bn_error
	;xor edx,edx
	;div edx
	ret
	
bnMod endp

bnModDw proc uses edi esi bnX:DWORD,valY:DWORD
	mov esi,bnX
	mov edi,valY
	mov edx,[esi].BN.dwArray[0]
	mov ecx,[esi].BN.dwSize
	test edi,edi
	jz @@DivisionByZero
	cmp ecx,1
	jne @@X_GT_Y
	test edx,edx
	je @@DivideZero
	cmp edx,edi
	jbe @@X_LE_Y
@@X_GT_Y:
	; X > Y
	xor edx,edx
	dec ecx
	.repeat
		mov eax,[esi].BN.dwArray[ecx*4]
		div dword ptr valY
		dec ecx
	.until sign?
	mov eax,edx
	ret
@@X_LE_Y:
	jnz @@DivideZero
	xor edx,edx; X = Y, fall trough
@@DivideZero:	; (X < Y) OR (X = 0)
	mov eax,edx
	ret
@@DivisionByZero: 
	mov eax,BNERR_DBZ 
	call _bn_error
	;xor edx,edx
	;div edx
	ret
bnModDw endp

bnShl proc uses edi esi ebx bn:DWORD,sc:DWORD
	mov edx,sc
	shr edx,5
	jnz @@Shl32 
@@Shlle31:	; do <32 bit shifts
	mov ecx,sc
	mov esi,bn
	and ecx,31
	jz @@Exit
	mov ebx,[esi].BN.dwSize
	xor eax,eax
	lea esi,[esi].BN.dwArray[ebx*4-2*4]
	mov edx,[esi+1*4]
	shld eax,edx,cl
	mov edi,eax
	jmp @F
	.repeat
		mov eax,[esi]
		shld edx,eax,cl
		mov [esi+1*4],edx
		mov edx,eax
		sub esi,4
@@:		dec ebx
	.until zero?
	shl edx,cl
	mov eax,edi
	mov [esi+1*4],edx
	mov edi,bn
	call _bn_add_carry_dword
@@Exit:	
	ret
@@Shl32:	; do 32 bit shifts
	mov esi,bn
	mov ebx,[esi].BN.dwSize
	lea eax,[ebx+edx]
	.if eax <= BN_MAX_DWORD
		mov [esi].BN.dwSize,eax
		lea edi,[esi].BN.dwArray[eax*4-4]
		lea esi,[esi].BN.dwArray[ebx*4-4]
		std
		mov ecx,ebx
		rep movsd
		mov ecx,edx
		xor eax,eax
		rep stosd
		cld
		jmp @@Shlle31 
	.endif
	mov eax,BNERR_OVERFLOW
	call _bn_error
	ret
bnShl endp

bnShl1 proc uses edi bn:DWORD 
	mov edi,bn
	xor eax,eax; CLC
	mov ecx,[edi].BN.dwSize
	lea edi,[edi].BN.dwArray[0*4]
	.repeat
		mov edx,[edi]
		lea edi,[edi+4]
		adc edx,edx
		dec ecx
		mov [edi-4],edx
	.until zero?
	adc eax,eax 
	mov edi,bn
	.if zero?
		ret ; most probable case
	.endif
	call _bn_add_carry_dword
	ret
bnShl1 endp

bnShr proc uses edi esi ebx bn:DWORD,sc:DWORD 
	mov edx,sc
	shr edx,5
	jnz @@Shr32
@@Shrle31:
	mov ecx,sc
	mov esi,bn
	and ecx,31
	jz @@Exit
	xor eax,eax
	mov ebx,[esi].BN.dwSize
	mov edx,[esi].BN.dwArray[0*4]
	shrd eax,edx,cl
	add esi,BN.dwArray
	mov edi,eax
	jmp @F
	.repeat
		mov eax,[esi+1*4]
		shrd edx,eax,cl
		mov [esi],edx
		mov edx,eax
		add esi,4
@@:		dec ebx
	.until zero?
	shr edx,cl
	mov eax,edi; preserved
	mov [esi],edx
	mov edi,bn
	mov ecx,[edi].BN.dwSize
	call _bn_normalize
@@Exit:
	ret
@@Shr32:	; do 32 bit shifts
	mov esi,bn
	mov ebx,[esi].BN.dwSize
	mov edi,esi
	.if (edx <= ebx) && !BN_IS_ZERO(esi)
		sub ebx,edx
		mov [edi].BN.dwSize,ebx
		lea esi,[esi].BN.dwArray[edx*4+4-4]
		add edi,BN.dwArray
		mov ecx,ebx
		rep movsd
		mov ecx,edx
		xor eax,eax
		rep stosd
		jmp @@Shrle31
	.endif
	invoke bnClear,bn
	xor eax,eax
	ret
bnShr endp

bnShr1 proc uses edi bn:DWORD
	mov edi,bn
	xor eax,eax; CLC
	mov ecx,[edi].BN.dwSize
	lea edi,[edi].BN.dwArray[ecx*4-4]
	.repeat
		mov edx,[edi]
		lea edi,[edi-4]
		rcr edx,1
		dec ecx
		mov [edi+4],edx
	.until zero?
	mov edi,bn
	adc eax,eax
	mov ecx,[edi].BN.dwSize
	call _bn_normalize
	ret
bnShr1 endp

bnSqrt proc uses edi esi ebx bnX:DWORD
	mov edi,bnX
	.if [edi].BN.bSigned
		mov eax,BNERR_SQRTNEG
		call _bn_error
		ret
	.elseif (([edi].BN.dwSize == 1) && ([edi].BN.dwArray[0] <= 1))
		ret
	.endif
	bnSCreateX edi,esi

	invoke bnBits,edi
	mov edi,esi
	mov ecx,eax
	bts [edi].BN.dwArray[0],eax; 2^n > N
	shr ecx,5
	inc ecx
	call _bn_normalize

	invoke bnInc,esi
	invoke bnBits,edi
	lea ecx,[eax+1]
	shr ecx,1
	invoke bnShl,esi,ecx
	.repeat
		invoke bnMov,edi,esi
		invoke bnDiv,bnX,edi,esi,0
		invoke bnAdd,esi,edi
		invoke bnShr1,esi
		invoke bnCmpAbs,edi,esi
	.until eax==1
	invoke bnMov,bnX,edi
	bnSDestroyX
	ret
bnSqrt endp

bnSquare proc uses ebx esi edi bnX:DWORD
	LOCAL tmpProd
	bnSCreateX tmpProd
	xor eax,eax
	mov esi,bnX
	inc eax
	mov edi,tmpProd
	mov eax,[esi]
	add eax,eax
	.if eax <= BN_MAX_DWORD
		mov [edi],eax
		call _bn_square_basecase
		mov edi,tmpProd
		mov ecx,[edi].BN.dwSize
		call _bn_normalize
	.endif
	invoke bnMov,bnX,tmpProd
	bnSDestroyX
	ret
bnSquare endp

bnSub proc uses edi esi ebx bnX:DWORD,bnY:DWORD
;----------------------;
;	+x - +y = x-y      ;
;	+x - -y = +(x+y)   ;
;	-x - +y = -(x+y)   ;
;	-x - -y = y-x      ;
;----------------------;
	mov edi,bnX
	mov esi,bnY
	mov ebx,[edi].BN.bSigned
	mov eax,[esi].BN.bSigned
	.if eax == ebx
		bnSCreateX edi,esi
		invoke bnMov,edi,bnX
		invoke bnMov,esi,bnY
		call _bn_cmp_array
		test eax,eax
		.if sign?
			xchg esi,edi
			xor ebx,1
		.endif
		mov [edi].BN.bSigned,ebx
		call _bn_sub_ignoresign
		invoke bnMov,bnX,edi
		bnSDestroyX
		ret
	.endif
	call _bn_add_ignoresign
	ret 
bnSub endp

bnSubDw proc uses edi bn:DWORD,dwVal
	mov edi,bn
	mov eax,dwVal
	call _bn_subdw_ignoresign
	ret
bnSubDw endp

bnXchg proc uses esi edi bnX:DWORD,bnY:DWORD
	mov ecx,BN_ALLOC_BYTES
	mov edi,bnX
	sub ecx,4
	mov esi,bnY 
	.repeat
		mov eax,[esi+ecx]
		mov edx,[edi+ecx]
		mov [edi+ecx],eax
		mov [esi+ecx],edx
		sub ecx,4
	.until sign?
	ret 
bnXchg endp

bnMulDw proc uses edi esi ebx bn:dword,dwVal:dword
	mov esi,bn
	mov edi,dwVal
	bnSCreateX ebx
	mov eax,[esi].BN.dwSize
	inc eax
	.if eax <= BN_MAX_DWORD
		mov [ebx],eax
		call _bn_muldw_basecase
		mov ecx,[esi].BN.dwSize
		mov edi,ebx
		inc ecx
		call _bn_normalize
		invoke bnMov,bn,ebx
	.endif
	bnSDestroyX
	ret
bnMulDw endp

bnMul proc uses ebx esi edi bnX:DWORD,bnY:DWORD,bnProd:DWORD
LOCAL tmpProd
	bnSCreateX tmpProd
	mov esi,bnX
	mov edi,bnY
;	.if !BN_IS_ZERO(esi) && !BN_IS_ZERO(edi) 
	mov eax,[esi].BN.dwSize
	mov ebx,tmpProd
	add eax,[edi].BN.dwSize; known max == size(x)+size(y)
	.if eax <= BN_MAX_DWORD
		mov [ebx],eax
		call _bn_mul_basecase
		mov edi,tmpProd
		mov ecx,[edi].BN.dwSize
		call _bn_normalize
		;---------------------;
		; sign(x) xor sign(y) ;
		;---------------------;
		mov esi,bnX
		mov eax,bnY
		mov ebx,[esi].BN.bSigned
		xor ebx,[eax].BN.bSigned
		.if ecx==1 && [edi].BN.dwArray[0] == 0 
			xor ebx,ebx
		.endif
		mov [edi].BN.bSigned,ebx;tmpProd
	.endif
	invoke bnMov,bnProd,tmpProd
	bnSDestroyX
	ret
bnMul endp

bnMovzx proc uses edi bn:DWORD,dwVal:DWORD
	mov ecx,BN_ALLOC_BYTES
	mov edi,bn  
	mov edx,dwVal
	xor eax,eax
	shr ecx,2
	rep stosd	;mov [edi].BN.bSigned,FALSE
	mov edi,bn
	inc eax
	mov [edi].BN.dwSize,eax;set size to 1
	mov [edi].BN.dwArray[0*4],edx;init it with val
	ret
bnMovzx endp

bnMovsx proc uses edi bn:DWORD,dwVal:SDWORD
	mov ecx,BN_ALLOC_BYTES
	mov edi,bn  
	xor eax,eax
	shr ecx,2
	rep stosd
	inc ecx
	mov edi,bn
	mov eax,dwVal
	cdq; ABS     \
	xor eax,edx; | 
	sub eax,edx; /
	and edx,1
	mov [edi].BN.dwSize,ecx
	mov [edi].BN.bSigned,edx
	mov [edi].BN.dwArray[0*4],eax;init it with val
	ret
bnMovsx endp

bnMov proc bn_Dest:DWORD,bn_Src:DWORD
	mov edx,edi
	mov eax,esi
	mov edi,bn_Dest
	mov ecx,BN_ALLOC_BYTES
	mov esi,bn_Src 
	shr ecx,2
	rep movsd
	mov esi,eax
	mov edi,edx
	ret 
bnMov endp

bnDiv proc uses edi esi ebx bnX:DWORD,bnY:DWORD,bnQuo:DWORD,bnRem:DWORD
LOCAL tempQuo
	mov edi,bnX
	mov ecx,1
	mov esi,bnY
	xor edx,edx
	cmp [esi].BN.dwSize,ecx ;	.if !BN_IS_ZERO(edi); DBZ
	jne @F
	cmp [esi].BN.dwArray[0],edx
	je @@DivisionByZero
@@:	cmp [edi].BN.dwSize,ecx;	.if !BN_IS_ZERO(esi); DZ
	jne @F
	cmp [edi].BN.dwArray[0],edx
	je @@DivideZero
@@:	call _bn_cmp_array;	invoke bnCmpAbs,bnX,bnY
	test eax,eax
	jle @@_X_le_Y
	; X > Y
	bnSCreateX tempQuo,esi;tempRem
	invoke bnBits,edi
	;int 1;*
	lea ebx,[eax-1]
	invoke bnBits,bnY;*
	sub ebx,eax;*
	inc ebx;*; 
	invoke bnMov,esi,edi;*
	invoke bnShr,esi,ebx;* 
	jmp @F;*
	.repeat
		invoke bnShl1,esi
		bt [edi].BN.dwArray[0],ebx
		setc al
		or byte ptr [esi].BN.dwArray[0],al
@@:;*
		invoke bnCmpAbs,esi,bnY
		test eax,eax
		.if !SIGN?
			invoke bnSub,esi,bnY
			mov eax,tempQuo
			bts [eax].BN.dwArray[0],ebx
		.endif
		dec ebx
	.until SIGN?
	mov ecx,[edi].BN.dwSize
	mov edi,tempQuo
	call _bn_normalize
	.if bnRem
		invoke bnMov,bnRem,esi
	.endif
	invoke bnMov,bnQuo,tempQuo
	mov eax,bnX
	mov ecx,bnY
	mov edx,bnRem
	mov ebx,[eax].BN.bSigned
	.if edx
		mov [edx].BN.bSigned,ebx; sign(rem)=sign(x)
	.endif
	xor ebx,[ecx].BN.bSigned
	mov eax,bnQuo
	mov [eax].BN.bSigned,ebx; sign(quo)=sign(x)^sign(y)
	bnSDestroyX
	ret
	
@@_X_le_Y:
	test eax,eax
	jnz @@_X_lt_Y
	; X = Y
	.if bnRem
		invoke bnClear,bnRem
	.endif
	invoke bnMovzx,bnQuo,1
	mov ebx,[edi].BN.bSigned
	mov eax,bnQuo
	xor ebx,[esi].BN.bSigned
	mov [eax].BN.bSigned,ebx
	ret
	
	; (X < Y) OR (X = 0)
@@_X_lt_Y:
@@DivideZero:
	.if bnRem
		invoke bnMov,bnRem,bnX
	.endif
	invoke bnClear,bnQuo
	ret
	
@@DivisionByZero:
	mov eax,BNERR_DBZ
	call _bn_error
	ret
bnDiv endp

bnDivDw proc uses edi esi ebx bnX:DWORD,valY:DWORD,bnQuo:DWORD
	mov edi,valY
	mov esi,bnX
	test edi,edi
	mov edx,[esi].BN.dwArray[0]
	jz @@DivisionByZero
	cmp [esi].BN.dwSize,1
	jne @F
	test edx,edx
	je @@DivideZero
	.if edx>edi
@@:	
 		; X > Y
		bnSCreateX edi;tempRem
		mov ecx,[esi].BN.dwSize
		xor edx,edx
		dec ecx
		.repeat
			mov eax,[esi].BN.dwArray[ecx*4]
			div dword ptr valY
			mov [edi].BN.dwArray[ecx*4],eax
			dec ecx
		.until sign?
		mov ebx,edx
		mov ecx,[esi].BN.dwSize
		call _bn_normalize
		.if bnQuo
			invoke bnMov,bnQuo,edi
		.endif
 		bnSDestroyX
 		mov eax,ebx
		ret
	.endif

	.if edx == edi 
		; X = Y
		.if bnQuo
			invoke bnMovzx,bnQuo,1
		.endif
		xor eax,eax
		ret
	.endif

	; (X < Y) OR (X = 0)
@@DivideZero:
	mov edi,edx
	.if bnQuo
		invoke bnClear,bnQuo
	.endif
	mov eax,edi
	ret

@@DivisionByZero: 
	mov eax,BNERR_DBZ 
	call _bn_error
	;xor edx,edx
	;div edx
	ret
bnDivDw endp

bnInc proc uses edi bn:DWORD
	mov edi,bn
	mov eax,1
	.if [edi].BN.bSigned
		.if ABS_BN_IS_ONE(edi) 
			and [edi].BN.bSigned,0
		.endif
		call _bn_subdw_ignoresign
		ret
	.endif
	call _bn_adddw_ignoresign
	ret
bnInc endp

bnFinish proc
	mov ecx,BN_HPROV
	jecxz @F
	;invoke CryptReleaseContext,ecx,0
@@:	mov ecx,BN_HHEAP
	jecxz @F
	invoke HeapDestroy,ecx
@@:	ret
bnFinish endp

bnDec proc uses edi bn:DWORD
	mov edi,bn
	mov eax,1
	.if BN_IS_ZERO(edi)
		or [edi].BN.bSigned,1		
	.endif
	.if [edi].BN.bSigned
		call _bn_adddw_ignoresign
		ret
	.endif
	call _bn_subdw_ignoresign
	ret
bnDec endp 

bnCmpAbs proc uses edi esi bnX:DWORD,bnY:DWORD
; 0 if |X|=|Y|      1 if |X|>|Y|      -1 if |X|<|Y|
	mov edi,bnX
	mov esi,bnY
	call _bn_cmp_array
	ret
bnCmpAbs endp

bnCmp proc uses edi esi bnX:DWORD,bnY:DWORD
;	0 if X=Y      1 if X>Y      -1 if X<Y
	mov edi,bnX
	mov esi,bnY
	mov eax,[esi].BN.bSigned; 1 or 0
	cmp eax,[edi].BN.bSigned; 1 or 0
	jne @F
	call _bn_cmp_array
	ret
@@:	sbb eax,eax
	lea eax,[eax*2+1]
	ret
bnCmp endp

bnClear proc uses edi bn:DWORD
	mov edi,bn  
	xor eax,eax
	mov [edi].BN.dwSize,1
	mov [edi].BN.bSigned,eax;FALSE
	mov ecx,BN_MAX_DWORD
	add edi,BN.dwArray
	rep stosd;clear the num
	ret
bnClear endp

bnBits proc bn:dword
	mov edx,bn
	mov ecx,[edx].BN.dwSize
	bsr eax,[edx].BN.dwArray[ecx*4-1*4]
	jz @F
	shl ecx,5
	lea eax,[eax+ecx-8*4+1]
@@:	ret
bnBits endp

bnAddDw proc uses edi bn:DWORD,dwVal
	mov edi,bn
	mov eax,dwVal
	call _bn_adddw_ignoresign
	ret
bnAddDw endp

_bn_subdw_ignoresign proc c
	lea edx,[edi].BN.dwArray[0*4]
	mov ecx,[edi].BN.dwSize
	clc
	.repeat
		sbb [edx],eax
		mov eax,0
		lea edx,[edx+4]
		jnc @F
		dec ecx
	.until zero?
@@:	mov ecx,[edi].BN.dwSize
	call _bn_normalize
	ret
_bn_subdw_ignoresign endp

_bn_sub_ignoresign proc c uses edi esi; uses eax,ecx,edx
; x = x - y , x >= y
	mov ecx,[edi].BN.dwSize
	lea esi,[esi].BN.dwArray
	lea edx,[edi].BN.dwArray
	xor eax,eax; clear carry
	.repeat
		mov eax,[esi]
		lea esi,[esi+4]
		sbb [edx],eax
		dec ecx
		lea edx,[edx+4]
	.until ZERO?
	mov ecx,[edi].BN.dwSize
	call _bn_normalize
	ret
_bn_sub_ignoresign endp

;;	esi=bnX
;;	edi=Prod
;; School boy
_bn_square_basecase proc c; uses all
	push ebp
	xor ebx,ebx
	.repeat
		mov eax,[esi].BN.dwArray[ebx*4-4+4]
		mul eax
		xor ebp,ebp
		add [edi].BN.dwArray[ebx*4-4+4],eax
		adc [edi].BN.dwArray[ebx*4-4+8],edx
		adc [edi].BN.dwArray[ebx*4-4+12],ebp
		lea ecx,[ebx+1]
		jmp @F
		.repeat
			mov eax,[esi].BN.dwArray[ebx*4-4+4]
			xor ebp,ebp
			mul [esi].BN.dwArray[ecx*4-4+4]
			add eax,eax
			adc edx,edx
			adc ebp,ebp
			add [edi].BN.dwArray[ecx*4-4+4],eax
			adc [edi].BN.dwArray[ecx*4-4+8],edx
			adc [edi].BN.dwArray[ecx*4-4+12],ebp
			inc ecx
@@:		.until ecx >= [esi].BN.dwSize
		add edi,4
		inc ebx
	.until ebx >= [esi].BN.dwSize
	pop ebp
	ret
_bn_square_basecase endp


;; ECX == predicted maximum
_bn_normalize proc c; uses ecx
	.repeat
		cmp [edi].BN.dwArray[ecx*4-1*4],0
		jnz @F
		dec ecx
	.until zero?; bn == 0
	mov [edi].BN.bSigned,ecx
	inc ecx
@@:	mov [edi].BN.dwSize,ecx
	ret
_bn_normalize endp

;;	esi=bnX
;;	edi=Prod	
;; School boy
_bn_muldw_basecase proc c
	pushad
	mov ebp,[esp+pushad_ebx]
	xor ebx,ebx
	.repeat
		xor edx,edx
		mov eax,[esi].BN.dwArray[ebx*4-4+4]
		xor ecx,ecx
		inc ebx
		mul edi
		add eax,ecx
		adc edx,0
		add [ebp].BN.dwArray[0*4-4+4],eax
		adc edx,0
		add ebp,4
		mov [ebp].BN.dwArray[1*4-4],edx
	.until ebx >= [esi].BN.dwSize
	popad
	ret
_bn_muldw_basecase endp


;;	esi=bnX
;;	edi=bnY
;;	ebx=Prod
;; School boy
_bn_mul_basecase proc c
	dwCARRY		equ dword ptr [esp+pushad_eax]	
	xor eax,eax
	pushad
	mov ebp,[esp+pushad_ebx]
	xor ebx,ebx
	.repeat
		xor ecx,ecx
		xor edx,edx
		.repeat
			mov eax,[esi].BN.dwArray[ebx*4-4+4]
			mul dword ptr [edi].BN.dwArray[ecx*4-4+4]
			add eax,dwCARRY
			adc edx,0
			add [ebp].BN.dwArray[ecx*4-4+4],eax
			adc edx,0
			inc ecx
			mov dwCARRY,edx
		.until ecx >= [edi].BN.dwSize
		mov eax,dwCARRY
		add ebp,4
		inc ebx
		mov [ebp].BN.dwArray[ecx*4-4],eax
		xor eax,eax
		mov dwCARRY,eax
	.until ebx >= [esi].BN.dwSize
	popad
	ret
_bn_mul_basecase endp

; eax = errcode
_bn_error proc c
	invoke RaiseException,eax,0,0,0
;	invoke MessageBox,0,[bnErrMsgs+eax*4],0,MB_ICONERROR
	ret
_bn_error endp

; 0 if |X|=|Y|      1 if |X|>|Y|      -1 if |X|<|Y|
; edi=x esi=y
_bn_cmp_array proc c; uses edx,ecx,eax 
	mov edx,[edi].BN.dwSize
	mov ecx,[esi].BN.dwSize
	lea eax,[edx+1]; i = size + 1
	jmp @F
	.repeat
		dec eax
		jz @@Exit; done, equal
		mov edx,[edi].BN.dwArray[eax*4-1*4];bnX[i]
		mov ecx,[esi].BN.dwArray[eax*4-1*4];bnY[i]
@@:	.until edx != ecx
	sbb eax,eax
	lea eax,[eax*2+1]
@@Exit:
	ret
_bn_cmp_array endp

_bn_adddw_ignoresign proc c; uses edi,esi,eax,ecx,edx
	lea edx,[edi].BN.dwArray[0*4]
	mov ecx,[edi].BN.dwSize
	clc
	.repeat
		adc [edx],eax
		mov eax,0
		lea edx,[edx+4]
		jnc @F
		dec ecx
	.until zero?
	adc eax,eax
	jz @F
	call _bn_add_carry_dword
@@:	ret
_bn_adddw_ignoresign endp

_bn_add_ignoresign proc c uses edi esi; uses eax,ecx,edx
	mov ecx,[edi].BN.dwSize
	cmp ecx,[esi].BN.dwSize
	cmovb ecx,[esi].BN.dwSize
	mov [edi].BN.dwSize,ecx; max
	lea esi,[esi].BN.dwArray
	lea edx,[edi].BN.dwArray
	xor eax,eax; clear carry
	.repeat
		mov eax,[esi]
		lea esi,[esi+4]
		adc [edx],eax
		dec ecx
		lea edx,[edx+4]
	.until ZERO?
	sbb eax,eax
	and eax,1
	call _bn_add_carry_dword
	ret
_bn_add_ignoresign endp

_bn_add_carry_dword proc c; uses ecx
	.if eax
		mov ecx,[edi].BN.dwSize
		inc ecx
		.if ecx <= BN_MAX_DWORD
			mov [edi].BN.dwArray[ecx*4-1*4],eax ; eax == carry
			mov [edi].BN.dwSize,ecx
			ret
		.endif
		mov eax,BNERR_OVERFLOW
		call _bn_error
	.endif
	ret
_bn_add_carry_dword endp

