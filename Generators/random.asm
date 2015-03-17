.686p
.mmx


random		PROTO	ptrOut:DWORD, lenByte:DWORD
	

.data?
hexTable	db	4*20 dup (?)
randHash	db	20 dup (?)
_randCount	dd	?
random_data_len	equ	$ - offset hexTable

rc4keytable	db 256 dup (?)

_temp_buffer	db 128 dup(?)
_hash_0 	dd ?
_hash_1 	dd ?
_hash_2 	dd ?
_hash_3 	dd ?
_hash_4 	dd ?
old_esp 	dd ?
_size		dd ?
_count		dd ?
_flag		dd ?
	sha_data_len	equ	$ - offset _temp_buffer
	
.code

rc4_clear	proc

	pushad

	xor	eax, eax
	mov	ecx, 256/4
	mov	edi, offset rc4keytable
	cld
	rep	stosd

	popad
	ret

rc4_clear	endp

rc4_crypt		proc	ptrData:DWORD, lData:DWORD

	pushad
	mov	edi, dword ptr [esp+20h+4+4]		;lData
	mov	esi, dword ptr [esp+20h+4]		;ptrData
	test	edi, edi
	jz	@rc4_enc_exit

	xor	eax, eax
	xor	ebx, ebx
	xor	ecx, ecx
	xor	edx, edx

@@:	inc	bl
	mov	dl, byte ptr [rc4keytable+ebx]
	add	al, dl
	mov	cl, byte ptr [rc4keytable+eax]
	mov	byte ptr [rc4keytable+ebx], cl
	mov	byte ptr [rc4keytable+eax], dl
	add	cl, dl
	mov	cl, byte ptr [rc4keytable+ecx]
	xor	byte ptr [esi], cl
	inc	esi
	dec	edi
	jnz	@B

@rc4_enc_exit:
	popad
	ret	8

rc4_crypt	endp

rc4_setkey		proc	ptrPass:DWORD, lPass:DWORD
	pushad

	mov	ebp, dword ptr [esp+20h+4+4]
	test	ebp, ebp
	jz	@done

	mov	eax, 0FFFEFDFCh
	mov	ecx, 256/4
@@:	mov	dword ptr [rc4keytable+4*ecx-4], eax
	sub	eax, 04040404h
	dec	ecx
	jnz	@B

	xor	eax, eax
	mov	edi, dword ptr [esp+20h+4]		;ptrPass

@setKey:
	xor	ebx, ebx
	mov	esi, ebp
	jmp	@new_key

@@:
	inc	bl
	dec	esi
	jz	@setKey

@new_key:
	mov	dl, byte ptr [rc4keytable+ecx]
	add	al, byte ptr [edi+ebx]
	add	al, dl
	mov	dh, byte ptr [rc4keytable+eax]
	mov	byte ptr [rc4keytable+ecx], dh
	mov	byte ptr [rc4keytable+eax], dl
	inc	cl
	jnz	@B
@done:
	popad
	ret	8
rc4_setkey	endp


Trans_0	MACRO	argument_1 , argument_2, argument_3, argument_4, argument_5, memory_ptr

	mov	esp, argument_1
	mov	edi, dword ptr [esi]
	rol	esp , 5
	bswap	edi
	add	argument_5, esp
	mov	memory_ptr, edi
	mov	esp, argument_3
	add	esi, 4
	xor	esp, argument_4
	add	argument_5, edi
	and	esp, argument_2
	xor	esp, argument_4
	ror	argument_2, 2
	lea	argument_5, [argument_5 + esp + 05A827999h]

ENDM

Trans_1	MACRO	argument_1 , argument_2, argument_3, argument_4, argument_5, memory_ptr_1, memory_ptr_2, memory_ptr_3, memory_ptr_4
	mov	esp, argument_1
	mov	edi, memory_ptr_1
	rol	esp , 5
	xor	edi, memory_ptr_2
	add	argument_5, esp
	xor	edi, memory_ptr_3
	mov	esp, argument_3
	xor	edi, memory_ptr_4
	xor	esp, argument_4
	rol	edi, 1
	and	esp, argument_2
	mov	memory_ptr_4, edi
	xor	esp, argument_4
	add	argument_5, edi
	ror	argument_2, 2
	lea	argument_5, [argument_5 + esp + 05A827999h]

ENDM

Trans_2	MACRO	argument_1 , argument_2, argument_3, argument_4, argument_5, memory_ptr_1, memory_ptr_2, memory_ptr_3, memory_ptr_4

	mov	esp, argument_1
	mov	edi, memory_ptr_1
	rol	esp , 5
	xor	edi, memory_ptr_2
	add	argument_5, esp
	xor	edi, memory_ptr_3
	mov	esp, argument_2
	xor	edi, memory_ptr_4
	xor	esp, argument_3
	rol	edi, 1
	xor	esp, argument_4
	mov	memory_ptr_4, edi
	add	argument_5, esp
	ror	argument_2, 2
	lea	argument_5, [argument_5 + edi + 06ED9EBA1h]

ENDM

Trans_3	MACRO	argument_1 , argument_2, argument_3, argument_4, argument_5, memory_ptr_1, memory_ptr_2, memory_ptr_3, memory_ptr_4

	mov	esp, argument_1
	mov	edi, memory_ptr_1
	rol	esp , 5
	xor	edi, memory_ptr_2
	add	argument_5, esp
	xor	edi, memory_ptr_3
	mov	esp, argument_2
	xor	edi, memory_ptr_4
	or	esp, argument_3
	rol	edi, 1
	and	esp, argument_4
	mov	memory_ptr_4, edi
	add	argument_5  , edi
	mov	edi, argument_2
	and	edi, argument_3
	or	edi, esp
	ror	argument_2, 2
	lea	argument_5, [argument_5 + edi + 08F1BBCDCh]

ENDM

Trans_4	MACRO	argument_1 , argument_2, argument_3, argument_4, argument_5, memory_ptr_1, memory_ptr_2, memory_ptr_3, memory_ptr_4

	mov	esp, argument_1
	mov	edi, memory_ptr_1
	rol	esp , 5
	xor	edi, memory_ptr_2
	add	argument_5, esp
	xor	edi, memory_ptr_3
	mov	esp, argument_2
	xor	edi, memory_ptr_4
	xor	esp, argument_3
	rol	edi, 1
	xor	esp, argument_4
	mov	memory_ptr_4, edi
	add	argument_5  , esp
	ror	argument_2, 2
	lea	argument_5, [argument_5 + edi + 0CA62C1D6h]

ENDM


sha1		proc	ptrDigest:DWORD, lenMessage:DWORD, ptrMessage:DWORD

	pushad
	mov	dword ptr [old_esp], esp
	cld
	mov	ecx, [esp+ 28h] ; dlugosc danych do hashowania w bajtach        _size
	mov	esi, [esp+ 2Ch] ; offset danych do hashowania                   _addr_INPUT
	mov	dword ptr [_size] , ecx
	or	dword ptr [_flag] , -1		; umowna flaga...
	mov	dword ptr [_count], ecx

	mov	dword ptr [_hash_0] , 067452301h
	mov	dword ptr [_hash_1] , 0EFCDAB89h
	mov	dword ptr [_hash_2] , 098BADCFEh
	mov	dword ptr [_hash_3] , 010325476h
	mov	dword ptr [_hash_4] , 0C3D2E1F0h

@sha1_Loop:
	cmp	dword ptr [_count] , 64
	jb	@sha1_LIPOF

	mov	eax, dword ptr [_hash_0]
	mov	ebx, dword ptr [_hash_1]
	mov	ecx, dword ptr [_hash_2]
	mov	edx, dword ptr [_hash_3]
	mov	ebp, dword ptr [_hash_4]

	Trans_0 eax,ebx,ecx,edx,ebp,dword ptr [_temp_buffer+4*0]
	Trans_0 ebp,eax,ebx,ecx,edx,dword ptr [_temp_buffer+4*1]
	Trans_0 edx,ebp,eax,ebx,ecx,dword ptr [_temp_buffer+4*2]
	Trans_0 ecx,edx,ebp,eax,ebx,dword ptr [_temp_buffer+4*3]
	Trans_0 ebx,ecx,edx,ebp,eax,dword ptr [_temp_buffer+4*4]
	Trans_0 eax,ebx,ecx,edx,ebp,dword ptr [_temp_buffer+4*5]
	Trans_0 ebp,eax,ebx,ecx,edx,dword ptr [_temp_buffer+4*6]
	Trans_0 edx,ebp,eax,ebx,ecx,dword ptr [_temp_buffer+4*7]
	Trans_0 ecx,edx,ebp,eax,ebx,dword ptr [_temp_buffer+4*8]
	Trans_0 ebx,ecx,edx,ebp,eax,dword ptr [_temp_buffer+4*9]
	Trans_0 eax,ebx,ecx,edx,ebp,dword ptr [_temp_buffer+4*10]
	Trans_0 ebp,eax,ebx,ecx,edx,dword ptr [_temp_buffer+4*11]
	Trans_0 edx,ebp,eax,ebx,ecx,dword ptr [_temp_buffer+4*12]
	Trans_0 ecx,edx,ebp,eax,ebx,dword ptr [_temp_buffer+4*13]
	Trans_0 ebx,ecx,edx,ebp,eax,dword ptr [_temp_buffer+4*14]
	Trans_0 eax,ebx,ecx,edx,ebp,dword ptr [_temp_buffer+4*15]
	Trans_1 ebp,eax,ebx,ecx,edx,dword ptr [_temp_buffer+4*13],dword ptr [_temp_buffer+4*8] ,dword ptr [_temp_buffer+4*2] ,dword ptr [_temp_buffer+4*0]
	Trans_1 edx,ebp,eax,ebx,ecx,dword ptr [_temp_buffer+4*14],dword ptr [_temp_buffer+4*9] ,dword ptr [_temp_buffer+4*3] ,dword ptr [_temp_buffer+4*1]
	Trans_1 ecx,edx,ebp,eax,ebx,dword ptr [_temp_buffer+4*15],dword ptr [_temp_buffer+4*10],dword ptr [_temp_buffer+4*4] ,dword ptr [_temp_buffer+4*2]
	Trans_1 ebx,ecx,edx,ebp,eax,dword ptr [_temp_buffer+4*0] ,dword ptr [_temp_buffer+4*11],dword ptr [_temp_buffer+4*5] ,dword ptr [_temp_buffer+4*3]
	Trans_2 eax,ebx,ecx,edx,ebp,dword ptr [_temp_buffer+4*1] ,dword ptr [_temp_buffer+4*12],dword ptr [_temp_buffer+4*6] ,dword ptr [_temp_buffer+4*4]
	Trans_2 ebp,eax,ebx,ecx,edx,dword ptr [_temp_buffer+4*2] ,dword ptr [_temp_buffer+4*13],dword ptr [_temp_buffer+4*7] ,dword ptr [_temp_buffer+4*5]
	Trans_2 edx,ebp,eax,ebx,ecx,dword ptr [_temp_buffer+4*3] ,dword ptr [_temp_buffer+4*14],dword ptr [_temp_buffer+4*8] ,dword ptr [_temp_buffer+4*6]
	Trans_2 ecx,edx,ebp,eax,ebx,dword ptr [_temp_buffer+4*4] ,dword ptr [_temp_buffer+4*15],dword ptr [_temp_buffer+4*9] ,dword ptr [_temp_buffer+4*7]
	Trans_2 ebx,ecx,edx,ebp,eax,dword ptr [_temp_buffer+4*5] ,dword ptr [_temp_buffer+4*0] ,dword ptr [_temp_buffer+4*10],dword ptr [_temp_buffer+4*8]
	Trans_2 eax,ebx,ecx,edx,ebp,dword ptr [_temp_buffer+4*6] ,dword ptr [_temp_buffer+4*1] ,dword ptr [_temp_buffer+4*11],dword ptr [_temp_buffer+4*9]
	Trans_2 ebp,eax,ebx,ecx,edx,dword ptr [_temp_buffer+4*7] ,dword ptr [_temp_buffer+4*2] ,dword ptr [_temp_buffer+4*12],dword ptr [_temp_buffer+4*10]
	Trans_2 edx,ebp,eax,ebx,ecx,dword ptr [_temp_buffer+4*8] ,dword ptr [_temp_buffer+4*3] ,dword ptr [_temp_buffer+4*13],dword ptr [_temp_buffer+4*11]
	Trans_2 ecx,edx,ebp,eax,ebx,dword ptr [_temp_buffer+4*9] ,dword ptr [_temp_buffer+4*4] ,dword ptr [_temp_buffer+4*14],dword ptr [_temp_buffer+4*12]
	Trans_2 ebx,ecx,edx,ebp,eax,dword ptr [_temp_buffer+4*10],dword ptr [_temp_buffer+4*5] ,dword ptr [_temp_buffer+4*15],dword ptr [_temp_buffer+4*13]
	Trans_2 eax,ebx,ecx,edx,ebp,dword ptr [_temp_buffer+4*11],dword ptr [_temp_buffer+4*6] ,dword ptr [_temp_buffer+4*0] ,dword ptr [_temp_buffer+4*14]
	Trans_2 ebp,eax,ebx,ecx,edx,dword ptr [_temp_buffer+4*12],dword ptr [_temp_buffer+4*7] ,dword ptr [_temp_buffer+4*1] ,dword ptr [_temp_buffer+4*15]
	Trans_2 edx,ebp,eax,ebx,ecx,dword ptr [_temp_buffer+4*13],dword ptr [_temp_buffer+4*8] ,dword ptr [_temp_buffer+4*2] ,dword ptr [_temp_buffer+4*0]
	Trans_2 ecx,edx,ebp,eax,ebx,dword ptr [_temp_buffer+4*14],dword ptr [_temp_buffer+4*9] ,dword ptr [_temp_buffer+4*3] ,dword ptr [_temp_buffer+4*1]
	Trans_2 ebx,ecx,edx,ebp,eax,dword ptr [_temp_buffer+4*15],dword ptr [_temp_buffer+4*10],dword ptr [_temp_buffer+4*4] ,dword ptr [_temp_buffer+4*2]
	Trans_2 eax,ebx,ecx,edx,ebp,dword ptr [_temp_buffer+4*0] ,dword ptr [_temp_buffer+4*11],dword ptr [_temp_buffer+4*5] ,dword ptr [_temp_buffer+4*3]
	Trans_2 ebp,eax,ebx,ecx,edx,dword ptr [_temp_buffer+4*1] ,dword ptr [_temp_buffer+4*12],dword ptr [_temp_buffer+4*6] ,dword ptr [_temp_buffer+4*4]
	Trans_2 edx,ebp,eax,ebx,ecx,dword ptr [_temp_buffer+4*2] ,dword ptr [_temp_buffer+4*13],dword ptr [_temp_buffer+4*7] ,dword ptr [_temp_buffer+4*5]
	Trans_2 ecx,edx,ebp,eax,ebx,dword ptr [_temp_buffer+4*3] ,dword ptr [_temp_buffer+4*14],dword ptr [_temp_buffer+4*8] ,dword ptr [_temp_buffer+4*6]
	Trans_2 ebx,ecx,edx,ebp,eax,dword ptr [_temp_buffer+4*4] ,dword ptr [_temp_buffer+4*15],dword ptr [_temp_buffer+4*9] ,dword ptr [_temp_buffer+4*7]
	Trans_3 eax,ebx,ecx,edx,ebp,dword ptr [_temp_buffer+4*5] ,dword ptr [_temp_buffer+4*0] ,dword ptr [_temp_buffer+4*10],dword ptr [_temp_buffer+4*8]
	Trans_3 ebp,eax,ebx,ecx,edx,dword ptr [_temp_buffer+4*6] ,dword ptr [_temp_buffer+4*1] ,dword ptr [_temp_buffer+4*11],dword ptr [_temp_buffer+4*9]
	Trans_3 edx,ebp,eax,ebx,ecx,dword ptr [_temp_buffer+4*7] ,dword ptr [_temp_buffer+4*2] ,dword ptr [_temp_buffer+4*12],dword ptr [_temp_buffer+4*10]
	Trans_3 ecx,edx,ebp,eax,ebx,dword ptr [_temp_buffer+4*8] ,dword ptr [_temp_buffer+4*3] ,dword ptr [_temp_buffer+4*13],dword ptr [_temp_buffer+4*11]
	Trans_3 ebx,ecx,edx,ebp,eax,dword ptr [_temp_buffer+4*9] ,dword ptr [_temp_buffer+4*4] ,dword ptr [_temp_buffer+4*14],dword ptr [_temp_buffer+4*12]
	Trans_3 eax,ebx,ecx,edx,ebp,dword ptr [_temp_buffer+4*10],dword ptr [_temp_buffer+4*5] ,dword ptr [_temp_buffer+4*15],dword ptr [_temp_buffer+4*13]
	Trans_3 ebp,eax,ebx,ecx,edx,dword ptr [_temp_buffer+4*11],dword ptr [_temp_buffer+4*6] ,dword ptr [_temp_buffer+4*0] ,dword ptr [_temp_buffer+4*14]
	Trans_3 edx,ebp,eax,ebx,ecx,dword ptr [_temp_buffer+4*12],dword ptr [_temp_buffer+4*7] ,dword ptr [_temp_buffer+4*1] ,dword ptr [_temp_buffer+4*15]
	Trans_3 ecx,edx,ebp,eax,ebx,dword ptr [_temp_buffer+4*13],dword ptr [_temp_buffer+4*8] ,dword ptr [_temp_buffer+4*2] ,dword ptr [_temp_buffer+4*0]
	Trans_3 ebx,ecx,edx,ebp,eax,dword ptr [_temp_buffer+4*14],dword ptr [_temp_buffer+4*9] ,dword ptr [_temp_buffer+4*3] ,dword ptr [_temp_buffer+4*1]
	Trans_3 eax,ebx,ecx,edx,ebp,dword ptr [_temp_buffer+4*15],dword ptr [_temp_buffer+4*10],dword ptr [_temp_buffer+4*4] ,dword ptr [_temp_buffer+4*2]
	Trans_3 ebp,eax,ebx,ecx,edx,dword ptr [_temp_buffer+4*0] ,dword ptr [_temp_buffer+4*11],dword ptr [_temp_buffer+4*5] ,dword ptr [_temp_buffer+4*3]
	Trans_3 edx,ebp,eax,ebx,ecx,dword ptr [_temp_buffer+4*1] ,dword ptr [_temp_buffer+4*12],dword ptr [_temp_buffer+4*6] ,dword ptr [_temp_buffer+4*4]
	Trans_3 ecx,edx,ebp,eax,ebx,dword ptr [_temp_buffer+4*2] ,dword ptr [_temp_buffer+4*13],dword ptr [_temp_buffer+4*7] ,dword ptr [_temp_buffer+4*5]
	Trans_3 ebx,ecx,edx,ebp,eax,dword ptr [_temp_buffer+4*3] ,dword ptr [_temp_buffer+4*14],dword ptr [_temp_buffer+4*8] ,dword ptr [_temp_buffer+4*6]
	Trans_3 eax,ebx,ecx,edx,ebp,dword ptr [_temp_buffer+4*4] ,dword ptr [_temp_buffer+4*15],dword ptr [_temp_buffer+4*9] ,dword ptr [_temp_buffer+4*7]
	Trans_3 ebp,eax,ebx,ecx,edx,dword ptr [_temp_buffer+4*5] ,dword ptr [_temp_buffer+4*0] ,dword ptr [_temp_buffer+4*10],dword ptr [_temp_buffer+4*8]
	Trans_3 edx,ebp,eax,ebx,ecx,dword ptr [_temp_buffer+4*6] ,dword ptr [_temp_buffer+4*1] ,dword ptr [_temp_buffer+4*11],dword ptr [_temp_buffer+4*9]
	Trans_3 ecx,edx,ebp,eax,ebx,dword ptr [_temp_buffer+4*7] ,dword ptr [_temp_buffer+4*2] ,dword ptr [_temp_buffer+4*12],dword ptr [_temp_buffer+4*10]
	Trans_3 ebx,ecx,edx,ebp,eax,dword ptr [_temp_buffer+4*8] ,dword ptr [_temp_buffer+4*3] ,dword ptr [_temp_buffer+4*13],dword ptr [_temp_buffer+4*11]
	Trans_4 eax,ebx,ecx,edx,ebp,dword ptr [_temp_buffer+4*9] ,dword ptr [_temp_buffer+4*4] ,dword ptr [_temp_buffer+4*14],dword ptr [_temp_buffer+4*12]
	Trans_4 ebp,eax,ebx,ecx,edx,dword ptr [_temp_buffer+4*10],dword ptr [_temp_buffer+4*5] ,dword ptr [_temp_buffer+4*15],dword ptr [_temp_buffer+4*13]
	Trans_4 edx,ebp,eax,ebx,ecx,dword ptr [_temp_buffer+4*11],dword ptr [_temp_buffer+4*6] ,dword ptr [_temp_buffer+4*0] ,dword ptr [_temp_buffer+4*14]
	Trans_4 ecx,edx,ebp,eax,ebx,dword ptr [_temp_buffer+4*12],dword ptr [_temp_buffer+4*7] ,dword ptr [_temp_buffer+4*1] ,dword ptr [_temp_buffer+4*15]
	Trans_4 ebx,ecx,edx,ebp,eax,dword ptr [_temp_buffer+4*13],dword ptr [_temp_buffer+4*8] ,dword ptr [_temp_buffer+4*2] ,dword ptr [_temp_buffer+4*0]
	Trans_4 eax,ebx,ecx,edx,ebp,dword ptr [_temp_buffer+4*14],dword ptr [_temp_buffer+4*9] ,dword ptr [_temp_buffer+4*3] ,dword ptr [_temp_buffer+4*1]
	Trans_4 ebp,eax,ebx,ecx,edx,dword ptr [_temp_buffer+4*15],dword ptr [_temp_buffer+4*10],dword ptr [_temp_buffer+4*4] ,dword ptr [_temp_buffer+4*2]
	Trans_4 edx,ebp,eax,ebx,ecx,dword ptr [_temp_buffer+4*0] ,dword ptr [_temp_buffer+4*11],dword ptr [_temp_buffer+4*5] ,dword ptr [_temp_buffer+4*3]
	Trans_4 ecx,edx,ebp,eax,ebx,dword ptr [_temp_buffer+4*1] ,dword ptr [_temp_buffer+4*12],dword ptr [_temp_buffer+4*6] ,dword ptr [_temp_buffer+4*4]
	Trans_4 ebx,ecx,edx,ebp,eax,dword ptr [_temp_buffer+4*2] ,dword ptr [_temp_buffer+4*13],dword ptr [_temp_buffer+4*7] ,dword ptr [_temp_buffer+4*5]
	Trans_4 eax,ebx,ecx,edx,ebp,dword ptr [_temp_buffer+4*3] ,dword ptr [_temp_buffer+4*14],dword ptr [_temp_buffer+4*8] ,dword ptr [_temp_buffer+4*6]
	Trans_4 ebp,eax,ebx,ecx,edx,dword ptr [_temp_buffer+4*4] ,dword ptr [_temp_buffer+4*15],dword ptr [_temp_buffer+4*9] ,dword ptr [_temp_buffer+4*7]
	Trans_4 edx,ebp,eax,ebx,ecx,dword ptr [_temp_buffer+4*5] ,dword ptr [_temp_buffer+4*0] ,dword ptr [_temp_buffer+4*10],dword ptr [_temp_buffer+4*8]
	Trans_4 ecx,edx,ebp,eax,ebx,dword ptr [_temp_buffer+4*6] ,dword ptr [_temp_buffer+4*1] ,dword ptr [_temp_buffer+4*11],dword ptr [_temp_buffer+4*9]
	Trans_4 ebx,ecx,edx,ebp,eax,dword ptr [_temp_buffer+4*7] ,dword ptr [_temp_buffer+4*2] ,dword ptr [_temp_buffer+4*12],dword ptr [_temp_buffer+4*10]
	Trans_4 eax,ebx,ecx,edx,ebp,dword ptr [_temp_buffer+4*8] ,dword ptr [_temp_buffer+4*3] ,dword ptr [_temp_buffer+4*13],dword ptr [_temp_buffer+4*11]
	Trans_4 ebp,eax,ebx,ecx,edx,dword ptr [_temp_buffer+4*9] ,dword ptr [_temp_buffer+4*4] ,dword ptr [_temp_buffer+4*14],dword ptr [_temp_buffer+4*12]
	Trans_4 edx,ebp,eax,ebx,ecx,dword ptr [_temp_buffer+4*10],dword ptr [_temp_buffer+4*5] ,dword ptr [_temp_buffer+4*15],dword ptr [_temp_buffer+4*13]
	Trans_4 ecx,edx,ebp,eax,ebx,dword ptr [_temp_buffer+4*11],dword ptr [_temp_buffer+4*6] ,dword ptr [_temp_buffer+4*0] ,dword ptr [_temp_buffer+4*14]
	Trans_4 ebx,ecx,edx,ebp,eax,dword ptr [_temp_buffer+4*12],dword ptr [_temp_buffer+4*7] ,dword ptr [_temp_buffer+4*1] ,dword ptr [_temp_buffer+4*15]

	add	dword ptr [_hash_0], eax
	add	dword ptr [_hash_1], ebx
	add	dword ptr [_hash_2], ecx
	add	dword ptr [_hash_3], edx
	add	dword ptr [_hash_4], ebp

	sub	dword ptr [_count], 64
	jmp	@sha1_Loop

@sha1_LIPOF:
	cmp	dword ptr [_flag], 0
	jz	@sha1_Finishing

		mov	ecx, dword ptr [_count]
		mov	dword ptr [_flag] , 0
		mov	dword ptr [_count], 64
		mov	eax, ecx
		mov	edi, offset _temp_buffer

		test	eax, eax
		jz	@only_null
	
		rep	movsb

@only_null:
		mov	ecx, eax
		mov	byte ptr [edi], 80h
		sub	ecx, 55
		inc	edi
		neg	ecx
		jz	@save_size_in_pad
		jns	@zero_mem

		add	dword ptr [_count], 64
		add	ecx, 64 	;padding rozciagnij tez na nastepne 64 bajty !

@zero_mem:
		xor	al, al
		rep	stosb

@save_size_in_pad:
		xor	edx, edx
		mov	eax, dword ptr [_size]
		shld	edx, eax, 3
		shl	eax, 3
		bswap	eax
		bswap	edx
		mov	dword ptr [edi], edx
		mov	dword ptr [edi+4], eax
		mov	esi, offset _temp_buffer

	jmp	@sha1_Loop

@sha1_Finishing:
	mov	esp, old_esp
	mov	edi, [esp+ 24h] 	; offset bufora dla wyniku _addr_OUTPUT
	mov	esi, offset _hash_0

	mov	ecx, 5
@@:
	mov	eax, dword ptr [esi+4*ecx-4]
	bswap	eax
	mov	dword ptr [edi+4*ecx-4], eax
	dec	ecx
	jnz	@B

	xor	eax, eax
	mov	edi, offset _temp_buffer
	mov	ecx, sha_data_len/4
	cld
	rep	stosd

	popad
	ret	12
sha1		endp


random		proc	ptrOut:DWORD, lenByte:DWORD

	mov	ecx, dword ptr [esp+20h+8]
	mov	edi, dword ptr [esp+20h+4]
	jecxz	@clear

	mov	eax, dword ptr [_randCount]
	test	eax, eax
	jnz	@F

	call	randomInit
@@:
	xor	eax, eax
	mov	ebx, ecx
	mov	esi, edi
	shr	ecx, 2
	cld
	rep	stosd
	mov	ecx, ebx
	and	ecx, 3
	rep	stosb

	invoke	rc4_crypt, esi, ebx

	add	ebx, dword ptr [_randCount]
	cmp	ebx, 8000h
	cmovnc	ebx, eax	;if ebx >= 8000h reinit
	mov	dword ptr [_randCount], ebx

@done:
	ret	
	
@clear:
	xor	eax, eax
	mov	ecx, random_data_len/4	
	mov	edi, offset hexTable
	cld
	rep	stosd

	invoke	rc4_clear
	jmp	@done

random		endp

randomInit	proc

	pushad

	mov	esi, offset randHash
	mov	edi, offset hexTable

	invoke	GlobalMemoryStatus, edi		;requires 20h bytes

	invoke	sha1, edi, dword ptr [edi], edi			;1
	add	edi, 20

	invoke	GetCursorPos, esi
	invoke	GetCurrentProcessId
	mov	dword ptr [esi+8], eax
	invoke	GetCurrentThreadId
	mov	dword ptr [esi+12], eax

	invoke	sha1, edi, 16, esi				;2
	add	edi, 20

	invoke	GetLocalTime, esi

	invoke	sha1, edi, 16, esi				;3
	add	edi, 20

	xor	ebx, ebx
	invoke	GetVolumeInformation, ebx, ebx, ebx, esi, ebx, ebx, ebx, ebx
	invoke	GetTickCount
	mov	dword ptr [esi+4], eax
	rdtsc
	mov	dword ptr [esi+8], eax
	mov	dword ptr [esi+12], edx

	invoke	sha1, edi, 16, esi				;4

	invoke	sha1, offset randHash, 20*4, offset hexTable
	invoke	rc4_setkey, offset randHash, 20

	mov	ebx, 32
@@:	invoke	rc4_crypt, offset hexTable, 20*4
	dec	ebx
	jnz	@B

	popad
	ret

randomInit	endp