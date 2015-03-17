;comment	*
;
;Algorithm		: MMB  (The Modular Multiplication based Block cipher )
;Block		: 16 bytes
;KeySize		: 128 bits ( 16 bytes ) 
;
;Abstract		: The Modular Multiplication based Block cipher (MMB),
;		  designed by Joan Daemen. This public domain implementation
;		  by Paulo Barreto <pbarreto@uninet.com.br>
;	
;Usage		: invoke	mmbEncrypt,addr key,addr ptrIndata,addr ptrOutput		         
;	               	  invoke	mmbDecrypt,addr key,addr ptrOutput,addr ptrIndata	( you must keep to the this regulations! )
;		
;Coded by x3chun	2004.02.01
;		( This verion of MMb is Unoptimized and modified by x3chun )
;		( x3chun@korea.com  or  x3chun@hanyang.ac.kr ) ( http://x3chun.wo.to )
;		
;comment	*
	
	
LO		macro	z

		and	z,0ffffh
	
endm

HI		macro	z

		shr	z,16
		
endm

mmbEncrypt	proto	:DWORD,:DWORD,:DWORD
mmbDecrypt	proto	:DWORD,:DWORD,:DWORD
modmult		proto	:DWORD,:DWORD
f		proto	:DWORD
g		proto	:DWORD

.const

gamma0		equ	025F1CDBh
gamma1		equ	04BE39B6h
gamma2		equ	12F8E6D8h
gamma3		equ	2F8E6D81h
ammag0		equ	0DAD4694h
ammag1		equ	06D6A34Ah
ammag2		equ	81B5A8D2h
ammag3		equ	281B5A8Dh
delta		equ	2AAAAAAAh

.data?

_temp		dd	?

.code

mmbEncrypt	proc	ptrInkey:DWORD, ptrIndata:DWORD, ptrOutdata:DWORD

		pushad
		mov	esi,[esp+28h]
		lodsd
		mov	ebx,eax		; k[0]
		lodsd
		mov	ecx,eax		; k[1]
		lodsd
		mov	edx,eax		; k[2]
		lodsd
		mov	ebp,eax		; k[3]
		mov	esi,[esp+2ch]	; ptrInkey
		mov	edi,[esp+30h]	; ptrOutdata
		mov	eax,ecx
		mov	ecx,16
		rep	movsb
		mov	ecx,eax
		sub	edi,16
		mov	esi,edi
		xor	[esi],ebx
		xor	[esi+4],ecx
		xor	[esi+8],edx
		xor	[esi+12],ebp
		invoke	f,esi
		xor	[esi],ecx
		xor	[esi+4],edx
		xor	[esi+8],ebp
		xor	[esi+12],ebx
		invoke	f,esi
		xor	[esi],edx
		xor	[esi+4],ebp
		xor	[esi+8],ebx
		xor	[esi+12],ecx
		invoke	f,esi
		xor	[esi],ebp
		xor	[esi+4],ebx
		xor	[esi+8],ecx
		xor	[esi+12],edx
		invoke	f,esi
		xor	[esi],ebx
		xor	[esi+4],ecx
		xor	[esi+8],edx
		xor	[esi+12],ebp
		invoke	f,esi
		xor	[esi],ecx
		xor	[esi+4],edx
		xor	[esi+8],ebp
		xor	[esi+12],ebx
		invoke	f,esi
		xor	[esi],edx
		xor	[esi+4],ebp
		xor	[esi+8],ebx
		xor	[esi+12],ecx
		popad
		ret
		
mmbEncrypt	endp

mmbDecrypt	proc	ptrInkey:DWORD, ptrIndata:DWORD, ptrOutdata:DWORD

		pushad
		mov	esi,[esp+28h]
		mov	edi,[esp+2ch]
		lodsd
		mov	ebx,eax		; k[0]
		lodsd	
		mov	ecx,eax		; k[1]
		lodsd
		mov	edx,eax		; k[2]
		lodsd
		mov	ebp,eax		; k[3]
		mov	esi,[esp+2ch]	; ptrInkey
		mov	edi,[esp+30h]	; ptrOutdata
		mov	eax,ecx
		mov	ecx,16
		rep	movsb
		mov	ecx,eax
		sub	edi,16
		mov	esi,edi
		xor	[esi],edx
		xor	[esi+4],ebp
		xor	[esi+8],ebx
		xor	[esi+12],ecx
		invoke	g,esi
		xor	[esi],ecx
		xor	[esi+4],edx
		xor	[esi+8],ebp
		xor	[esi+12],ebx
		invoke	g,esi
		xor	[esi],ebx
		xor	[esi+4],ecx
		xor	[esi+8],edx
		xor	[esi+12],ebp
		invoke	g,esi
		xor	[esi],ebp
		xor	[esi+4],ebx
		xor	[esi+8],ecx
		xor	[esi+12],edx
		invoke	g,esi
		xor	[esi],edx
		xor	[esi+4],ebp
		xor	[esi+8],ebx
		xor	[esi+12],ecx
		invoke	g,esi
		xor	[esi],ecx
		xor	[esi+4],edx
		xor	[esi+8],ebp
		xor	[esi+12],ebx
		invoke	g,esi
		xor	[esi],ebx
		xor	[esi+4],ecx
		xor	[esi+8],edx
		xor	[esi+12],ebp
		popad
		ret
		
mmbDecrypt	endp

modmult		proc	ptrIndata:DWORD, ptrOutdata:DWORD

		pushad
		mov	eax,[esp+28h]	; x
		mov	ebx,[esp+2ch]	; y
		push	eax
		push	ebx
		mov	ecx,eax		; x
		LO	eax		; LO(x)
		LO	ebx		; LO(y)
		mov	edx,ebx		; LO(y)
		imul	eax,ebx		; z0
		mov	ebp,eax		; z0
		HI	ecx		; HI(x)
		imul	ecx,edx		
		HI	eax
		add	ecx,eax		; z1
		mov	edi,ecx
		LO	ebp
		LO	ecx
		shl	ecx,16
		add	ecx,ebp		; q
		mov	edx,ecx		; q	
		LO	ecx
		HI	edi
		add	ecx,edi		; z0
		mov	esi,ecx
		pop	ebx
		mov	ebp,ebx		; y
		HI	ebx
		pop	eax
		mov	edi,eax		; x
		LO	eax
		imul	eax,ebx
		HI	edx
		HI	ecx
		add	eax,edx
		add	eax,ecx		; z1
		mov	ecx,eax		; z1
		LO	esi
		LO	eax
		shl	eax,16
		add	esi,eax		; q
		mov	ebx,esi			
		HI	edi
		HI	ebp
		imul	edi,ebp
		LO	esi
		HI	ecx
		add	edi,esi
		add	edi,ecx		; z0
		mov	eax,edi
		HI	ebx
		HI	edi
		add	ebx,edi		; z1
		mov	ecx,ebx
		LO	eax
		LO	ebx
		shl	ebx,16
		HI	ecx
		add	eax,ebx
		add	eax,ecx
		mov	_temp,eax	; returns ( x*y) mod ( 2 ^ 32 -1 )
		popad
		ret
	
modmult		endp

f		proc	ptrIndata:DWORD

		pushad
		mov	esi,[esp+28h]
		invoke	modmult,[esi],gamma0
		mov 	eax,_temp
		mov	[esi],eax
		invoke	modmult,[esi+4],gamma1
		mov	ebx,_temp
		mov	[esi+4],ebx
		invoke	modmult,[esi+8],gamma2
		mov	ecx,_temp
		mov	[esi+8],ecx
		invoke	modmult,[esi+12],gamma3
		mov	edx,_temp
		mov	[esi+12],edx
		
		; 	not included
		;	 if (x[0] & 1 == 1) {
		;		x[0] ^ delta;
		;	}
		;	if (x[3] & 1 == 0) {
		;		x[3] ^ delta;
		;	}
		
		xor	eax,ecx	; t0
		xor	ebx,edx	; t1
		xor	[esi],ebx
		xor	[esi+4],eax
		xor	[esi+8],ebx
		xor	[esi+12],eax
		popad
		ret

f		endp

g		proc	ptrIndata:DWORD

		pushad
		mov	esi,[esp+28h]
		mov	eax,[esi]		; x[0]
		xor	eax,[esi+8]	; t0
		mov	ebx,[esi+4]	
		xor	ebx,[esi+12]	; t1
		xor	[esi],ebx
		xor	[esi+4],eax
		xor	[esi+8],ebx
		xor	[esi+12],eax
		
		; 	not included
		;	 if (x[0] & 1 == 1) {
		;		x[0] ^ delta;
		;	}
		;	if (x[3] & 1 == 0) {
		;		x[3] ^ delta;
		;	}
		
		invoke	modmult,[esi],ammag0
		mov 	eax,_temp
		mov	[esi],eax
		invoke	modmult,[esi+4],ammag1
		mov	ebx,_temp
		mov	[esi+4],ebx
		invoke	modmult,[esi+8],ammag2
		mov	ecx,_temp
		mov	[esi+8],ecx
		invoke	modmult,[esi+12],ammag3
		mov	edx,_temp
		mov	[esi+12],edx
		popad
		ret
		
g		endp

