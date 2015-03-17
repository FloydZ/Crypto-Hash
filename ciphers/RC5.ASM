;; RC5.ASM -- Implementation of RC5 in MASM
;; (C)opyLeft 2005 by drizz 

;; P2 533MHz
;; -----------------------------------------
;; RC5Init:     825 cycles (589 if unrolled)
;; RC5Encrypt:   99 cycles                  
;; RC5Decrypt:   91 cycles                  
;; -----------------------------------------

RC5Init       PROTO :DWORD
RC5Encrypt    PROTO :DWORD,:DWORD
RC5Decrypt    PROTO :DWORD,:DWORD

RC5UNROLL EQU <>

.const
	RC5ROUNDS equ 12
	RC5KEYLEN equ 16;bytes
	RC5KR equ (2*(RC5ROUNDS+1))
	RC5_P equ 0b7e15163h
	RC5_Q equ 09e3779b9h

.data?
	RC5_KEY dd RC5KR dup(?)

.code

; uses ecx
RC5SETUP macro A,B,kEy,_L
	add A,B
	add A,kEy
	rol A,3
	lea ecx,[A+B]
	mov kEy,A
	add B,A
	add B,_L
	rol B,cl
	mov _L,B
endm

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

RC5Init proc pKey:DWORD
	push ebp
	push edi
	push esi
	push ebx
	mov esi,[esp][1*4][4*4];pKey
	sub esp,RC5KEYLEN
	; copy to local buff
	mov eax,[esi+0*4]
	mov ebx,[esi+1*4]
	mov ecx,[esi+2*4]
	mov edx,[esi+3*4]
	mov [esp+0*4],eax
	mov [esp+1*4],ebx
	mov [esp+2*4],ecx
	mov [esp+3*4],edx
	mov eax,RC5_P
	mov edi,offset RC5_KEY
	
	;Bugfix by Floyd
	mov ecx, RC5_P
	add ecx, RC5_Q
	
	
;	mov ecx,RC5_P+RC5_Q
	xor edx,edx
	.repeat
		mov [edi][edx*4][0*4],eax
		mov [edi][edx*4][1*4],ecx
		add edx,1
		lea eax,[ecx+RC5_Q]
		add edx,1
		lea ecx,[eax+RC5_Q]
	.until edx == RC5KR
	IFDEF RC5UNROLL	
	xor eax,eax
	xor ebx,ebx
	_edx = 0
	_ebp = 0
	repeat (3*RC5KR)/2
		RC5SETUP eax,ebx,[edi][_edx*4][0*4],[esp][_ebp*4][0*4]
		RC5SETUP eax,ebx,[edi][_edx*4][1*4],[esp][_ebp*4][1*4]
		_edx = _edx + 2
		_ebp = _ebp + 2
		if _edx eq RC5KR
			_edx = 0
		endif
		_ebp = _ebp and 3
	endm
	ELSE
	xor eax,eax
	xor ebx,ebx
	xor edx,edx
	xor ebp,ebp
	xor esi,esi
	.repeat
		RC5SETUP eax,ebx,[edi+edx*4][0*4],[esp][ebp*4][0*4]
		RC5SETUP eax,ebx,[edi+edx*4][1*4],[esp][ebp*4][1*4]
		add edx,2
		add ebp,2
		cmp edx,RC5KR
		sbb ecx,ecx
		add esi,2
		and edx,ecx
		and ebp,3
	.until esi >= 3*RC5KR
	ENDIF
	add esp,RC5KEYLEN
	pop ebx
	pop esi
	pop edi
	pop ebp
	ret 1*4
RC5Init endp

RC5ENCAB macro key0,key1
	mov ecx,ebx
	xor eax,ebx
	rol eax,cl
	add eax,key0
	mov ecx,eax
	xor ebx,eax
	rol ebx,cl
	add ebx,key1
endm

RC5Encrypt proc pPlainText:DWORD,pCipherText:DWORD
	push ebp
	push edi
	push esi
	push ebx
	mov esi,[esp][1*4][4*4];pPlainText
	mov eax,[esi][0*4]
	mov ebx,[esi][1*4]
	add eax,[RC5_KEY][0*4]
	add ebx,[RC5_KEY][1*4]
	xi = 8
	REPT RC5ROUNDS/2
		mov ebp,[RC5_KEY+xi][0*4]
		mov edx,[RC5_KEY+xi][1*4]
		mov edi,[RC5_KEY+xi][2*4]
		mov esi,[RC5_KEY+xi][3*4]
		RC5ENCAB ebp,edx
		RC5ENCAB edi,esi
		xi = xi + 8*2
	ENDM
	mov edi,[esp][2*4][4*4];pCipherText
	mov [edi][0*4],eax
	mov [edi][1*4],ebx
	pop ebx
	pop esi
	pop edi
	pop ebp
	ret 2*4
RC5Encrypt endp

RC5DECAB macro key1,key0
	mov ecx,eax
	sub ebx,key1
	ror ebx,cl
	xor ebx,eax
	mov ecx,ebx
	sub eax,key0
	ror eax,cl
	xor eax,ebx
endm

RC5Decrypt proc pCipherText:DWORD,pPlainText:DWORD
	push ebp
	push edi
	push esi
	push ebx
	mov edx,[esp][1*4][4*4];pCipherText
	mov eax,[edx][0*4]
	mov ebx,[edx][1*4]
	xi = RC5ROUNDS*8
	REPT RC5ROUNDS/2
		mov ebp,[RC5_KEY+xi][1*4]
		mov edx,[RC5_KEY+xi][0*4]
		xi = xi - 8
		mov edi,[RC5_KEY+xi][1*4]
		mov esi,[RC5_KEY+xi][0*4]
		xi = xi - 8
		RC5DECAB ebp,edx
		RC5DECAB edi,esi
	ENDM
	sub eax,[RC5_KEY][0*4]
	sub ebx,[RC5_KEY][1*4]
	mov edx,[esp][2*4][4*4];pPlainText
	mov [edx][0*4],eax
	mov [edx][1*4],ebx
	pop ebx
	pop esi
	pop edi
	pop ebp
	ret 2*4
RC5Decrypt endp

OPTION PROLOGUE:PROLOGUEDEF
OPTION EPILOGUE:EPILOGUEDEF
