.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code
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
end
