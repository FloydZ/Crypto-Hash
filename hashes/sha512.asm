
.const
u64 struct
	Lo dd ?
	Hi dd ?
u64 ends

.data?
SHA512HashBuf db 128 dup(?)
SHA512Len_Lo u64 <?>
SHA512Index dd ?
SHA512Digest u64 8 dup(<?>)

.data
SHA512CHAIN label qword
dq 06A09E667F3BCC908h, 0BB67AE8584CAA73Bh, 03C6EF372FE94F82Bh, 0A54FF53A5F1D36F1h
dq 0510E527FADE682D1h, 09B05688C2B3E6C1Fh, 01F83D9ABFB41BD6Bh, 05BE0CD19137E2179h

SHA512K label qword
dq 0428A2F98D728AE22h, 07137449123EF65CDh, 0B5C0FBCFEC4D3B2Fh, 0E9B5DBA58189DBBCh
dq 03956C25BF348B538h, 059F111F1B605D019h, 0923F82A4AF194F9Bh, 0AB1C5ED5DA6D8118h
dq 0D807AA98A3030242h, 012835B0145706FBEh, 0243185BE4EE4B28Ch, 0550C7DC3D5FFB4E2h
dq 072BE5D74F27B896Fh, 080DEB1FE3B1696B1h, 09BDC06A725C71235h, 0C19BF174CF692694h
dq 0E49B69C19EF14AD2h, 0EFBE4786384F25E3h, 00FC19DC68B8CD5B5h, 0240CA1CC77AC9C65h
dq 02DE92C6F592B0275h, 04A7484AA6EA6E483h, 05CB0A9DCBD41FBD4h, 076F988DA831153B5h
dq 0983E5152EE66DFABh, 0A831C66D2DB43210h, 0B00327C898FB213Fh, 0BF597FC7BEEF0EE4h
dq 0C6E00BF33DA88FC2h, 0D5A79147930AA725h, 006CA6351E003826Fh, 0142929670A0E6E70h
dq 027B70A8546D22FFCh, 02E1B21385C26C926h, 04D2C6DFC5AC42AEDh, 053380D139D95B3DFh
dq 0650A73548BAF63DEh, 0766A0ABB3C77B2A8h, 081C2C92E47EDAEE6h, 092722C851482353Bh
dq 0A2BFE8A14CF10364h, 0A81A664BBC423001h, 0C24B8B70D0F89791h, 0C76C51A30654BE30h
dq 0D192E819D6EF5218h, 0D69906245565A910h, 0F40E35855771202Ah, 0106AA07032BBD1B8h
dq 019A4C116B8D2D0C8h, 01E376C085141AB53h, 02748774CDF8EEB99h, 034B0BCB5E19B48A8h
dq 0391C0CB3C5C95A63h, 04ED8AA4AE3418ACBh, 05B9CCA4F7763E373h, 0682E6FF3D6B2B8A3h
dq 0748F82EE5DEFB2FCh, 078A5636F43172F60h, 084C87814A1F0AB72h, 08CC702081A6439ECh
dq 090BEFFFA23631E28h, 0A4506CEBDE82BDE9h, 0BEF9A3F7B2C67915h, 0C67178F2E372532Bh
dq 0CA273ECEEA26619Ch, 0D186B8C721C0C207h, 0EADA7DD6CDE0EB1Eh, 0F57D4F7FEE6ED178h
dq 006F067AA72176FBAh, 00A637DC5A2C898A6h, 0113F9804BEF90DAEh, 01B710B35131C471Bh
dq 028DB77F523047D84h, 032CAAB7B40C72493h, 03C9EBE0A15C9BEBCh, 0431D67C49C100D4Ch
dq 04CC5D4BECB3E42B6h, 0597F299CFC657E2Ah, 05FCB6FAB3AD6FAECh, 06C44198C4A475817h


.code

MOV64 macro m2:req,m1:req
	mov eax,[m1].u64.Lo
	mov edx,[m1].u64.Hi
	mov [m2].u64.Lo,eax
	mov [m2].u64.Hi,edx
endm

ADD64 macro m2:req,m1:req
	mov eax,[m1].u64.Lo
	mov edx,[m1].u64.Hi
	add [m2].u64.Lo,eax
	adc [m2].u64.Hi,edx
endm

ROR64 macro RegLo,RegHi,N
;push ebp
if N lt 32
;	mov ebp,RegLo
	shrd RegLo,RegHi,N
	shrd RegHi,ebp,N
;elseif N eq 32
;	mov ebp,RegLo
;	mov RegLo,RegHi
;	mov RegHi,ebp
else;if N gt 32
;	mov ebp,RegLo
	shld RegLo,RegHi,64-N
	shld RegHi,ebp,64-N
endif
;pop ebp
endm

SHR64 macro RegLo,RegHi,N
	shrd RegLo,RegHi,N
	shr RegHi,N
endm

SHL64 macro RegLo,RegHi,N
	shld RegHi,RegLo,N
	shl RegLo,N
endm
	
; Result in edx:eax 
; uses ebx ecx esi edi
SIGMA macro qwX, n1, n2, n3 
	mov eax,[qwX].u64.Lo
	mov edx,[qwX].u64.Hi
	mov esi,eax
	mov edi,edx
	mov ebx,eax
	mov ecx,edx
	push ebp
	mov ebp,eax
	ROR64 eax,edx,n1;np
	ROR64 ebx,ecx,n2;np
	ROR64 esi,edi,n3;np
	pop ebp
	xor eax,ebx
	xor edx,ecx
	xor eax,esi
	xor edx,edi	
endm

; Result in edx:eax 
; uses ebx ecx esi edi
SIGMA2 macro qwX, n1, n2, n3
	mov eax,[qwX].u64.Lo
	mov edx,[qwX].u64.Hi
	mov ebx,eax
	mov ecx,edx
	mov esi,eax
	mov edi,edx
	mov ebx,eax
	mov ecx,edx
	push ebp
	mov ebp,eax
	ROR64 eax,edx,n1;np
	ROR64 ebx,ecx,n2;np
	SHR64 esi,edi,n3;np
	pop ebp
	xor eax,ebx
	xor edx,ecx
	xor eax,esi
	xor edx,edi
endm

SHA512R macro qwA, qwB, qwC, qwD, qwE, qwF, qwG, qwH, Iter
;SIG1()
	SIGMA qwE, 14, 18, 41
;CH()
	mov ebx,qwF.u64.Lo
	mov ecx,qwF.u64.Hi
	mov esi,qwE.u64.Lo
	mov edi,qwE.u64.Hi
	xor ebx,qwG.u64.Lo
	xor ecx,qwG.u64.Hi
	and esi,ebx
	and edi,ecx
	xor esi,qwG.u64.Lo
	xor edi,qwG.u64.Hi
; + h + K[i] + W[i]
	add eax,qwH.u64.Lo
	adc edx,qwH.u64.Hi
	add eax,esi
	adc edx,edi
	mov esi,cnt
	shl esi,3
	add esi,Iter
	add eax,SHA512K[esi*8].u64.Lo
	adc edx,SHA512K[esi*8].u64.Hi
	add eax,SHA512W[esi*8].u64.Lo
	adc edx,SHA512W[esi*8].u64.Hi
	mov SHA512tmp.u64.Lo,eax; T1
	mov SHA512tmp.u64.Hi,edx
;SIG0
	SIGMA qwA, 28, 34, 39
;MAJ	
	mov ebx,qwA.u64.Lo
	mov ecx,qwA.u64.Hi
	or ebx,qwB.u64.Lo
	or ecx,qwB.u64.Hi
	and ebx,qwC.u64.Lo
	and ecx,qwC.u64.Hi
	mov esi,qwB.u64.Lo
	mov edi,qwB.u64.Hi
	and esi,qwA.u64.Lo
	and edi,qwA.u64.Hi
	or ebx,esi
	or ecx,edi
;
	mov esi,SHA512tmp.u64.Lo; T1
	mov edi,SHA512tmp.u64.Hi
	add eax,ebx
	adc edx,ecx
	add eax,esi
	adc edx,edi
	mov qwH.u64.Lo,eax
	mov qwH.u64.Hi,edx
;d += T1
	add qwD.u64.Lo,esi
	adc qwD.u64.Hi,edi
ENDM

align dword
SHA512Transform proc
	pushad
	SHA512locals equ 8*8+1*4+1*8+80*8
	sub esp,SHA512locals
	llA equ dword ptr [esp+0*8]
	llB equ dword ptr [esp+1*8]
	llC equ dword ptr [esp+2*8]
	llD equ dword ptr [esp+3*8]
	llE equ dword ptr [esp+4*8]
	llF equ dword ptr [esp+5*8]
	llG equ dword ptr [esp+6*8]
	llH equ dword ptr [esp+7*8]
	cnt equ dword ptr [esp+16*4]
	SHA512tmp equ dword ptr [esp+17*4]
	SHA512W equ dword ptr [esp+19*4]
	mov esi,offset SHA512Digest
	mov edi,offset SHA512HashBuf	
	MOV64 llA,esi[0*8]
	MOV64 llB,esi[1*8]
	MOV64 llC,esi[2*8]
	MOV64 llD,esi[3*8]
	MOV64 llE,esi[4*8]
	MOV64 llF,esi[5*8]
	MOV64 llG,esi[6*8]
	MOV64 llH,esi[7*8]
	xor esi,esi
	.repeat
		mov eax,[edi+8*esi].u64.Lo
		mov edx,[edi+8*esi].u64.Hi
		mov ebx,[edi+8*esi+8].u64.Lo
		mov ecx,[edi+8*esi+8].u64.Hi
		bswap eax
		bswap edx
		bswap ebx
		bswap ecx
		mov [SHA512W+8*esi].u64.Lo,edx
		mov [SHA512W+8*esi].u64.Hi,eax
		mov [SHA512W+8*esi+8].u64.Lo,ecx
		mov [SHA512W+8*esi+8].u64.Hi,ebx
		add esi,2
	.until esi==16
	mov cnt,esi
	.repeat
		mov edi,cnt
		lea esi,[edi-2]
		SIGMA2 SHA512W[esi*8],19,61,6
		mov edi,cnt
		lea esi,[edi-7]
		add eax,SHA512W[esi*8].u64.Lo
		adc edx,SHA512W[esi*8].u64.Hi
		mov SHA512W[edi*8].u64.Lo,eax
		mov SHA512W[edi*8].u64.Hi,edx
		mov edi,cnt
		lea esi,[edi-15]
		SIGMA2 SHA512W[esi*8],1,8,7
		mov edi,cnt
		lea esi,[edi-16]
		add eax,SHA512W[esi*8].u64.Lo
		adc edx,SHA512W[esi*8].u64.Hi
		add SHA512W[edi*8].u64.Lo,eax
		adc SHA512W[edi*8].u64.Hi,edx
		inc cnt
	.until cnt==80
	xor edx,edx
	mov cnt,edx
	.repeat
		SHA512R llA, llB, llC, llD, llE, llF, llG, llH, 0
		SHA512R llH, llA, llB, llC, llD, llE, llF, llG, 1
		SHA512R llG, llH, llA, llB, llC, llD, llE, llF, 2
		SHA512R llF, llG, llH, llA, llB, llC, llD, llE, 3
		SHA512R llE, llF, llG, llH, llA, llB, llC, llD, 4
		SHA512R llD, llE, llF, llG, llH, llA, llB, llC, 5
		SHA512R llC, llD, llE, llF, llG, llH, llA, llB, 6
		SHA512R llB, llC, llD, llE, llF, llG, llH, llA, 7
		inc cnt
	.until cnt == 10
	ADD64 SHA512Digest[0*8],llA
	ADD64 SHA512Digest[1*8],llB
	ADD64 SHA512Digest[2*8],llC
	ADD64 SHA512Digest[3*8],llD
	ADD64 SHA512Digest[4*8],llE
	ADD64 SHA512Digest[5*8],llF
	ADD64 SHA512Digest[6*8],llG
	ADD64 SHA512Digest[7*8],llH
	add esp,SHA512locals
	popad
	ret
SHA512Transform endp

SHA512BURN macro
	xor eax,eax
	mov SHA512Index,eax
	mov edi,Offset SHA512HashBuf
	mov ecx,(sizeof SHA512HashBuf)/4
	rep stosd
endm

align dword
SHA512Init proc uses edi esi
	xor eax,eax
	mov SHA512Len_Lo.Hi,eax
	mov SHA512Len_Lo.Lo,eax
	mov edi,Offset SHA512Digest
	mov esi,Offset SHA512CHAIN
	mov ecx,64/4
	rep movsd	
	SHA512BURN
	mov eax,Offset SHA512Digest 
	ret
SHA512Init endp

align dword
SHA512Update proc uses esi edi ebx buf:dword, len:dword
	mov ebx,len
	mov eax,ebx
	xor edx,edx
	shld edx,eax,3
	shl eax,3
	add SHA512Len_Lo.Lo,eax
	add SHA512Len_Lo.Hi,edx
	.while ebx
		mov eax,SHA512Index
		mov edx,128
		sub edx,eax
		.if edx <= ebx;len
			lea edi,[SHA512HashBuf+eax]	
			mov esi,buf
			mov ecx,edx
			rep movsb
			mov buf,esi
			sub ebx,edx
			call SHA512Transform
			SHA512BURN
		.else
			lea edi,[SHA512HashBuf+eax]	
			mov esi,buf
			mov ecx,ebx
			rep movsb
			add SHA512Index,ebx
			.break
		.endif
	.endw
	ret
SHA512Update endp

align dword
SHA512Final proc uses esi edi
	mov ecx,SHA512Index
	mov byte ptr [SHA512HashBuf+ecx],80h
	.if ecx >= 112
		call SHA512Transform
		SHA512BURN
	.endif
	mov eax,SHA512Len_Lo.Lo
	mov edx,SHA512Len_Lo.Hi
	bswap eax
	bswap edx
	mov [SHA512HashBuf+120].u64.Lo,edx
	mov [SHA512HashBuf+120].u64.Hi,eax
	call SHA512Transform
	mov eax,offset SHA512Digest
	xor ecx,ecx
	.repeat; DwSWAP
		mov	esi,[eax+ecx].u64.Lo
		mov	edi,[eax+ecx].u64.Hi
		bswap edi
		bswap esi
		mov	[eax+ecx].u64.Hi,esi
		mov	[eax+ecx].u64.Lo,edi
		add ecx,8
	.until ecx==512/8
	ret
SHA512Final endp

