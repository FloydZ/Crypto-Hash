.686p
.mmx
;.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

PUBLIC	__mod
PUBLIC	__c

addmod		PROTO	:DWORD, :DWORD, :DWORD
adduintmod	PROTO	:DWORD, :DWORD, :DWORD
compare		PROTO	:DWORD, :DWORD
comparezero	PROTO	:DWORD
compareone	PROTO	:DWORD
converth2bmod	PROTO	:DWORD, :DWORD
copy		PROTO	:DWORD, :DWORD
div2		PROTO	:DWORD
div2mod		PROTO	:DWORD
fixmod		PROTO	:DWORD
invmod		PROTO	:DWORD
modulo		PROTO	:DWORD, :DWORD
mulmod		PROTO	:DWORD, :DWORD, :DWORD
multiply	PROTO	:DWORD, :DWORD, :DWORD
setmod		PROTO	:DWORD
submod		PROTO	:DWORD, :DWORD, :DWORD
zero		PROTO	:DWORD


.data?
__mod	BIGINT<>
__c	BIGINT<>

temp_a		BIGINT<>
temp_c		BIGINT<>
temp_u		BIGINT<>
temp_v		BIGINT<>
modSpace	VBIGINT<>

.code

addmod		proc	ptrA:DWORD, ptrB:DWORD, ptrC:DWORD

	;a+b=c mod __mod

	pushad

	mov	esi, dword ptr [esp+20h+4]
	mov	edi, dword ptr [esp+20h+8]

	xor	ebp, ebp
	mov	eax, dword ptr [esi   ]
	mov	ebx, dword ptr [esi+ 4]
	mov	ecx, dword ptr [esi+ 8]
	mov	edx, dword ptr [esi+12]
	add	eax, dword ptr [edi   ]
	adc	ebx, dword ptr [edi+ 4]
	adc	ecx, dword ptr [edi+ 8]
	adc	edx, dword ptr [edi+12]

	mov	esi, dword ptr [esp+20h+12]
	adc	ebp, ebp

@@:	mov	dword ptr [esi   ], eax
	mov	dword ptr [esi+ 4], ebx
	mov	dword ptr [esi+ 8], ecx
	mov	dword ptr [esi+12], edx

        sub     eax, dword ptr [__mod   ]
        sbb     ebx, dword ptr [__mod+ 4]
        sbb     ecx, dword ptr [__mod+ 8]
        sbb     edx, dword ptr [__mod+12]
	sbb	ebp, 0
        jnc     @B

	popad
        ret	12

addmod		endp

adduintmod		proc	ptrA:DWORD, uintB:DWORD, ptrC:DWORD

	;a+b=c mod __mod

	pushad

	mov	esi, dword ptr [esp+20h+4]

	xor	ebp, ebp
	mov	eax, dword ptr [esi   ]
	mov	ebx, dword ptr [esi+ 4]
	mov	ecx, dword ptr [esi+ 8]
	mov	edx, dword ptr [esi+12]
	add	eax, dword ptr [esp+20h+8]
	adc	ebx, 0
	adc	ecx, 0
	adc	edx, 0

	mov	esi, dword ptr [esp+20h+12]
	adc	ebp, ebp

@@:	mov	dword ptr [esi   ], eax
	mov	dword ptr [esi+ 4], ebx
	mov	dword ptr [esi+ 8], ecx
	mov	dword ptr [esi+12], edx

        sub     eax, dword ptr [__mod   ]
        sbb     ebx, dword ptr [__mod+ 4]
        sbb     ecx, dword ptr [__mod+ 8]
        sbb     edx, dword ptr [__mod+12]
	sbb	ebp, 0
        jnc     @B

	popad
        ret	12

adduintmod	endp

compare		proc	ptrA:DWORD, ptrB:DWORD

	;a==b

	pushad

	mov	esi, dword ptr [esp+20h+4]
	mov	edi, dword ptr [esp+20h+8]
	mov	ecx, 4

@@:	mov	eax, dword ptr [esi+4*ecx-4]
	cmp	eax, dword ptr [edi+4*ecx-4]
	jnz	@F
	dec	ecx
	jnz	@B

@@:
	popad
	ret	8

compare		endp

compareone	proc	ptrA:DWORD

	push	eax
	push	esi

	mov	esi, dword ptr [esp+4+8]

	mov	eax, dword ptr [esi+12]
	or	eax, dword ptr [esi+ 8]
	or	eax, dword ptr [esi+ 4]
	test	eax, eax
	jnz	@F

	cmp	dword ptr [esi], 1

@@:	pop	esi
	pop	eax
	ret	4

compareone	endp

comparezero	proc	ptrA:DWORD

	push	eax
	push	esi

	mov	esi, dword ptr [esp+4+8]
	mov	eax, dword ptr [esi   ]
	or	eax, dword ptr [esi+ 4]
	or	eax, dword ptr [esi+ 8]
	or	eax, dword ptr [esi+12]
	test	eax, eax

	pop	esi
	pop	eax
	ret	4

comparezero	endp

converth2bmod	proc	ptrHash:DWORD, ptrOut:DWORD

	pushad
	mov	esi, dword ptr [esp+20h+4]
	mov	edi, offset hashSpace
	mov	ecx, 16
	mov	ebx, edi

@@:	mov	eax, dword ptr [esi+ecx]
	bswap	eax
	mov	dword ptr [ebx], eax
	add	ebx, 4
	sub	ecx, 4
	jns	@B

	and	dword ptr [ebx], 0
	and	dword ptr [ebx+4], 0
	and	dword ptr [ebx+8], 0

	invoke	modulo, edi, dword ptr [esp+20h+8]

	xor	eax, eax
	mov	ecx, 8
	cld
	rep	stosd

	popad
	ret	8

converth2bmod	endp

copy		proc	ptrA:DWORD, ptrB:DWORD

	;b=a

	pushad
	mov	esi, dword ptr [esp+20h+4]
	mov	edi, dword ptr [esp+20h+8]

	mov	eax, dword ptr [esi   ]
	mov	ebx, dword ptr [esi+ 4]
	mov	ecx, dword ptr [esi+ 8]
	mov	edx, dword ptr [esi+12]

	mov	dword ptr [edi   ], eax
	mov	dword ptr [edi+ 4], ebx
	mov	dword ptr [edi+ 8], ecx
	mov	dword ptr [edi+12], edx

	popad
	ret	8
copy		endp

div2	proc	ptrA:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]

	mov	eax, dword ptr [esi   ]
	mov	ebx, dword ptr [esi+ 4]
	mov	ecx, dword ptr [esi+ 8]
	mov	edx, dword ptr [esi+12]
	shr	edx, 1
	rcr	ecx, 1
	rcr	ebx, 1
	rcr	eax, 1
	mov	dword ptr [esi   ], eax
	mov	dword ptr [esi+ 4], ebx
	mov	dword ptr [esi+ 8], ecx
	mov	dword ptr [esi+12], edx

	popad
	ret	4

div2	endp

div2mod		proc	ptrA:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]
	mov	eax, dword ptr [esi   ]
	mov	ebx, dword ptr [esi+ 4]
	mov	ecx, dword ptr [esi+ 8]
	mov	edx, dword ptr [esi+12]
	test	dword ptr [esi], 1
	jz	@F	

	add	eax, dword ptr [__mod   ]
	adc	ebx, dword ptr [__mod+ 4]
	adc	ecx, dword ptr [__mod+ 8]
	adc	edx, dword ptr [__mod+12]

@@:	rcr	edx, 1
	rcr	ecx, 1
	rcr	ebx, 1
	rcr	eax, 1
	mov	dword ptr [esi   ], eax
	mov	dword ptr [esi+ 4], ebx
	mov	dword ptr [esi+ 8], ecx
	mov	dword ptr [esi+12], edx

	popad
	ret	4

div2mod		endp

fixmod		proc	ptrA:DWORD

	invoke	compare, dword ptr [esp+4+4], offset __mod
	jb	@F
	invoke	submod, dword ptr [esp+4+8], offset __mod, dword ptr [esp+4]
@@:	ret	4

fixmod		endp

invmod		proc	ptrInOut:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]

	mov	eax, offset temp_u
	mov	ebx, offset temp_v
	mov	ecx, offset temp_a
	mov	edx, offset temp_c

	invoke	copy, esi, eax
	invoke	copy, offset __mod, ebx
	invoke	zero, ecx
	invoke	zero, edx

	mov	dword ptr [ecx], 1

@cmp_u_0:
	invoke	comparezero, eax
	jz	@exit

@TESTLOWBIT_u:
	test	dword ptr [eax], 1
	jnz	@TESTLOWBIT_v

		invoke	div2, eax
		invoke	div2mod, ecx
		jmp	@TESTLOWBIT_u


@TESTLOWBIT_v:
	test	dword ptr [ebx], 1
	jnz	@COMPARE_u_v

		invoke	div2, ebx
		invoke	div2mod, edx
		jmp	@TESTLOWBIT_v

@COMPARE_u_v:
	invoke	compare, eax, ebx		;u==v

	ja	@u_gt_v
	jz	@exit

		invoke	submod, ebx, eax, ebx		;v=v-u
		invoke	submod, edx, ecx, edx		;c=c-a
		jmp	@cmp_u_0

	@u_gt_v:
		invoke	submod, eax, ebx, eax		;u=u-v

	@u_gtqu_v:
		invoke	submod, ecx, edx, ecx		;a=a-c
		jmp	@cmp_u_0

@exit:
	invoke	copy, edx, esi

	invoke	zero, eax
	invoke	zero, ebx
	invoke	zero, ecx
	invoke	zero, edx

	popad
	ret	4

invmod		endp

modulo		proc	ptrA:DWORD, ptrC:DWORD

	;c=a mod __mod
	;HAC, Algorithm 14.47

	pushad

	mov	esi, dword ptr [esp+20h+4]	;ptrA
	mov	edi, offset modSpace		;8 DD
	mov	ebx, dword ptr [esp+20h+8]	;ptrC

	lea	ebp, [esi+16]
	invoke	copy, esi, ebx

@@:	invoke	comparezero, ebp
	jz	@F

	invoke	multiply, ebp, offset __c, edi
	invoke	addmod, edi, ebx, ebx		;out = r + r[i]
	lea	ebp, [edi+16]			;ptr q[i] = edi+16
	jmp	@B

@@:	invoke	compare, ebx, offset __mod
	jb	@F

	invoke	submod, ebx, offset __mod, ebx
	jmp	@B

@@:	xor	eax, eax
	mov	ecx, 8
	cld
	rep	stosd
	popad
	ret	8

modulo		endp

mulmod		proc	ptrA:DWORD, ptrB:DWORD, ptrC:DWORD

	;c=a*b mod __mod

	pushad
	mov	esi, dword ptr [esp+20h+4]	;a
	mov	ebx, dword ptr [esp+20h+8]	;b
	mov	ebp, dword ptr [esp+20h+12]	;c

	mov	edi, offset mulmodSpace

	invoke	multiply, esi, ebx, edi
	invoke	modulo, edi, ebp

	xor	eax, eax
	mov	ecx, 8
	cld
	rep	stosd

	popad
	ret	12

mulmod		endp

multiply	proc	ptrA:DWORD, ptrB:DWORD, ptrC:DWORD

	;c=ab

	pushad

	mov	esi, dword ptr [esp+20h+4]
	mov	edi, dword ptr [esp+20h+8]

	mov	eax, dword ptr [esi]
	mul	dword ptr [edi]
	xor	ecx, ecx
	mov	dword ptr [mulSpace], eax
	mov	ebp, edx

	mov	eax, dword ptr [esi+4]
	mul	dword ptr [edi]
	xor	ebx, ebx
	add	ebp, eax
	adc	ecx, edx
	mov	eax, dword ptr [esi]
	mul	dword ptr [edi+4]
	add	eax, ebp
	adc	ecx, edx
	mov	dword ptr [mulSpace+4], eax
	adc	ebx, 0

	mov	eax, dword ptr [esi+8]
	mul	dword ptr [edi]
	xor	ebp, ebp
	add	ecx, eax
	adc	ebx, edx
	mov	eax, dword ptr [esi+4]
	mul	dword ptr [edi+4]
	add	ecx, eax
	adc	ebx, edx
	adc	ebp, 0
	mov	eax, dword ptr [esi]
	mul	dword ptr [edi+8]
	add	eax, ecx
	adc	ebx, edx
	mov	dword ptr [mulSpace+8], eax
	adc	ebp, 0

	mov	eax, dword ptr [esi+12]
	mul	dword ptr [edi]
	xor	ecx, ecx
	add	ebx, eax
	adc	ebp, edx
	mov	eax, dword ptr [esi+8]
	mul	dword ptr [edi+4]
	add	ebx, eax
	adc	ebp, edx
	adc	ecx, 0
	mov	eax, dword ptr [esi+4]
	mul	dword ptr [edi+8]
	add	ebx, eax
	adc	ebp, edx
	adc	ecx, 0
	mov	eax, dword ptr [esi]
	mul	dword ptr [edi+12]
	add	eax, ebx
	adc	ebp, edx
	mov	dword ptr [mulSpace+12], eax
	adc	ecx, 0

	mov	eax, dword ptr [esi+12]
	mul	dword ptr [edi+4]
	xor	ebx, ebx
	add	ebp, eax
	adc	ecx, edx
	mov	eax, dword ptr [esi+8]
	mul	dword ptr [edi+8]
	add	ebp, eax
	adc	ecx, edx
	adc	ebx, 0
	mov	eax, dword ptr [esi+4]
	mul	dword ptr [edi+12]
	add	eax, ebp
	adc	ecx, edx
	mov	dword ptr [mulSpace+16], eax
	adc	ebx, 0

	mov	eax, dword ptr [esi+12]
	mul	dword ptr [edi+8]
	xor	ebp, ebp
	add	ecx, eax
	adc	ebx, edx
	mov	eax, dword ptr [esi+8]
	mul	dword ptr [edi+12]
	add	ecx, eax
	adc	ebx, edx
	adc	ebp, 0
	mov	eax, dword ptr [esi+12]
	mul	dword ptr [edi+12]
	add	eax, ebx
	adc	edx, ebp

					;+20=ecx, +24=eax, +28=edx
	mov	esi, dword ptr [esp+20h+12]
					;ptrOut
	mov	edi, offset mulSpace
	mov	dword ptr [esi+20], ecx
	mov	dword ptr [esi+24], eax
	mov	dword ptr [esi+28], edx

	mov	eax, dword ptr [edi]
	mov	ebx, dword ptr [edi+4]
	mov	ecx, dword ptr [edi+8]
	mov	edx, dword ptr [edi+12]
	mov	ebp, dword ptr [edi+16]

	mov	dword ptr [esi+ 0], eax
	mov	dword ptr [esi+ 4], ebx
	mov	dword ptr [esi+ 8], ecx
	mov	dword ptr [esi+12], edx
	mov	dword ptr [esi+16], ebp

	and	dword ptr [edi   ], 0
	and	dword ptr [edi+4 ], 0
	and	dword ptr [edi+8 ], 0
	and	dword ptr [edi+12], 0
	and	dword ptr [edi+16], 0

	popad
	ret	12

multiply	endp

setmod		proc	ptrM:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]
	mov	edi, offset __mod

	mov	eax, dword ptr [esi   ]
	mov	ebx, dword ptr [esi+ 4]
	mov	ecx, dword ptr [esi+ 8]
	mov	edx, dword ptr [esi+12]

	mov	dword ptr [edi   ], eax
	mov	dword ptr [edi+ 4], ebx
	mov	dword ptr [edi+ 8], ecx
	mov	dword ptr [edi+12], edx

	mov	edi, offset __c

	neg	eax
	not	ebx
	not	ecx
	not	edx

;ok, ok, whats going on ? ;)
;__c = 2^128 - __mod, where __mod is prime
;1) __mod is prime => lowest dword of __mod != 0
;2) 0 - lowest dword of __mod always set a CF
;3) neg(x) = not(x)+1 => not(x) = neg(x)-1
;4) 2^128 = 1*2^128 + 0*2^96 + 0*2^64 + 0*2^32 + 0
;5) __mod = 0*2^128 + d*2^96 + c*2^64 + b*2^32 + a
;6) 2^128-__mod = 1*2^128 + 0*2^96 + 0*2^64 + 0*2^32 + 0 - 0*2^128 + d*2^96 + c*2^64 + b*2^32 + a
;
;(0-a) = neg(a) and borrow 1 (B1)
;(0-b-B1)*2^32 = (0-b-1)*2^32 = [neg(b)-1]*2^32 = not(b)*2^32 and borrow 1
;(0-c-B1)*2^32 = (0-c-1)*2^32 = [neg(c)-1]*2^32 = not(c)*2^32 and borrow 1
;(0-d-B1)*2^32 = (0-d-1)*2^32 = [neg(d)-1]*2^32 = not(d)*2^32 and borrow 1
;(1-B1)*2^32 = (1-1)*2^32 = 0

	mov	dword ptr [edi   ], eax
	mov	dword ptr [edi+ 4], ebx
	mov	dword ptr [edi+ 8], ecx
	mov	dword ptr [edi+12], edx

	popad
	ret	4

setmod		endp

