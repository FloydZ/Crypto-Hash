.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code
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
end
