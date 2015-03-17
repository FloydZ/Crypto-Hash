comment *

Algorithm		: SCOP ( Stream Cipher )

Abstract 		: SCOP is a stream cipher specially designed for
		  optimal software performance on the Intel Pentium processor. The
		  computational cost of SCOP on this processor is 1.5 clock cycles
		  per byte of text. The cipher is designed around one key-dependent
		  S-box, one part of which dynamically changes during the encryption
		  process and the other part is static. The cipher works in internal-
		  feedback mode (IFB). The keystream consist of 32-bit words and is
		  generated independently from the encrypted message.

Usage		: invoke	init_key,addr ptrInkey,ptrInkey_size				; ( SetKey )
		  invoke	scop_encrypt,addr ptrInkey,ptrInkey_length,addr ptrOutdata	; ( Encrypt )
		  invoke	scop_decrypt,addr ptrInkey,ptrInkey_length,addr ptrOutdata	; ( Decrypt )
		
Coded by x3chun 	( 2004.05.06 )	
		( x3chun@korea.com  or  x3chun@hanyang.ac.kr ) ( http://x3chun.wo.to )
		
comment	*

ST_KEY		struct

v		db	1536	dup(?)
i		db	?
j		db	?
t3		db	?

ST_KEY		ends

expand_key	proto	:DWORD,:DWORD
gp8		proto	:DWORD

.data

st_key		ST_KEY	<>
st_key_mov_	ST_KEY	<>
st_key_mov__	ST_KEY	<>

.data?

p		dd	12	dup(?)
t		db	16	dup(?)
newx		dd	4	dup(?)
ii		dd	?
_t2		dd	?
_loopscop	dd	?

.code

ScopInit		proc	ptrInkey:DWORD,	ptrInkey_size:DWORD

		pushad	
		invoke	expand_key,ptrInkey,ptrInkey_size	
		xor	ecx,ecx
@_l1:
		invoke	gp8,addr t
		inc	ecx
		cmp	ecx,8
		jl	@_l1
		
		lea	esi,st_key.v
		mov	ebx,12
@_l3:		
		mov	ecx,8
@_l2:
		invoke	gp8,esi
		add	esi,10h
		loop	@_l2
		
		invoke	gp8,addr t
		dec	ebx
		jnz	@_l3	
		invoke	gp8,addr t
		mov	eax, dword ptr [t+12]
		mov	ebx,eax
		mov	ecx,eax
		mov	edx,eax
		shr	eax,24
		shr	ebx,16
		shr	ecx,8
		mov	[st_key.i],al
		mov	[st_key.j],bl
		mov	[st_key.t3],cl
		and	edx,7fh
		mov	ecx,dword ptr [edx*4+st_key.v]
		or	ecx,1
		mov	dword ptr [edx*4+st_key.v],ecx
		call	st_key_copy	
		popad
		ret
		
ScopInit		endp

expand_key	proc	ptrInkey:DWORD,	ptrInkey_size:DWORD

		mov	esi,ptrInkey
		mov	edi,offset p
		mov	ecx,ptrInkey_size
		cld
		rep	movsb
		
		mov	ebx,ptrInkey_size
		mov	ecx,48
		sub	ecx,ebx
		xor	edx,edx
@_r1:
		mov	al,byte ptr [p+edx]
		mov	bl,byte ptr [p+edx+1]
		add	al,bl
		stosb
		inc	edx
		loop	@_r1
		
		mov	ecx,20
		xor	edx,edx
		mov	bl,1
@_r3:
		mov	al,byte ptr [p+edx]
		test	eax,eax
		jnz	@_r2
		mov	byte ptr [p+edx],bl
		inc	bl
@_r2:
		inc	edx
		loop	@_r3		
		ret
		
expand_key	endp

gp8		proc	ptrOutdata:DWORD

		pushad
		xor	edx,edx
		xor	ebx,ebx	; i
		mov	ii,ebx
@_r1:
		sar	ebx,1
		mov	ecx,dword ptr [p+32+ebx*4]
		shr	ecx,10h	; x_1
		mov	edi,ecx
		imul	edi,ecx	; x_2
		mov	ebp,edi
		imul	ebp,ecx	; x_3
		mov	eax,ebp
		imul	eax,ecx	; x_4	
		mov	dl, byte ptr [p+ebx*8]
		imul	eax,edx
		mov	dl,byte ptr [p+ebx*8+1]
		imul	ebp,edx
		mov	dl,byte ptr [p+ebx*8+2]
		imul	edi,edx
		mov	dl,byte ptr [p+ebx*8+3]
		imul	ecx,edx
		add	eax,ebp
		add	eax,edi
		lea	eax,[eax+ecx+1]	; y1
		mov	esi,eax	
		mov	ecx,dword ptr [p+32+ebx*4]
		and	ecx,0ffffh	  ; x_1
		mov	edi,ecx
		imul	edi,ecx	; x_2
		mov	ebp,edi
		imul	ebp,ecx	; x_3
		mov	eax,ebp
		imul	eax,ecx	;x_4	
		mov	dl,byte ptr [p+ebx*8+4]
		imul	eax,edx
		mov	dl,byte ptr [p+ebx*8+5]
		imul	ebp,edx
		mov	dl,byte ptr [p+ebx*8+6]
		imul	edi,edx
		mov	dl,byte ptr [p+ebx*8+7]
		imul	ecx,edx
		add	eax,ebp
		add	eax,edi
		lea	eax,[eax+ecx+1]	; y2	
		mov	edi,esi	; y1
		mov	ecx,eax	; y2	
		shl	esi,10h
		and	eax,0ffffh
		or	esi,eax	; out[]	
		and	edi,0ffff0000h
		shr	ecx,10h
		or	edi,ecx	; newx[]	
		mov	ecx,[esp+28h]
		mov	[ecx+ebx*4],esi   ;esp+28h = ptrOutdata
		mov	[newx+ebx*4],edi
		mov	ebx,ii
		add	ebx,2
		mov	ii,ebx
		cmp	ebx,8
		jl	@_r1	
		mov	eax,[newx]	; newx[0]
		mov	ebx,eax
		shr	eax,10h
		shl	ebx,10h
		mov	ecx,[newx+4]	; newx[1]
		mov	edx,ecx
		shr	ecx,10h
		shl	edx,10h
		mov	esi,[newx+8]	; newx[2]
		mov	edi,esi
		shr	esi,10h
		shl	edi,10h
		or	ebx,ecx		;[p+36]
		or	edx,esi		;[p+40]
		mov	esi,[newx+12]	; newx[3]
		mov	ecx,esi
		shr	esi,10h
		shl	ecx,10h
		or	eax,ecx		;[p+32]
		or	edi,esi		; [p+44]	
		mov	[p+32],eax
		mov	[p+36],ebx
		mov	[p+40],edx
		mov	[p+44],edi	
		popad
		ret
		
gp8		endp

ScopEncrypt	proc	ptrIndata:DWORD,	ptrIndata_length:DWORD, ptrOutdata:DWORD	

		pushad	
		mov	esi,[esp+28h]	; ptrIndata
		mov	edi,[esp+30h]	; ptrOutdata
		mov	ecx,[esp+2ch]	; ptrIndata_length
		mov	_loopscop,ecx
		rep	movsb	
		xor	eax,eax
		xor	ebx,ebx
		mov	al,st_key.i
		mov	bl,st_key.j
		mov	cl,st_key.t3
		mov	esi,offset st_key_mov_.v
		mov	edx,[esp+30h]	; ptrOutdata
@loop:
		push	edx
		mov	ebp,[esi+200h+ebx*4]  ; t1
		mov	edi,[esi+eax*4]	; t
		add	bl,cl	; j
		and	ebx,0ffh
		mov	edx,[esi+200h+ebx*4]  ; t2
		mov	_t2,edx
		inc	al
		add	edi,_t2	; t3=t2+t
		mov	ecx,edi
		mov	[esi+200h+ebx*4],edi
		add	ebp,_t2
		add	bl,byte ptr [_t2]
		pop	edx
		add	[edx],ebp
		add	edx,4
		sub	_loopscop,4
		jnz	@loop		
		popad
		ret
		
ScopEncrypt	endp


ScopDecrypt	proc	ptrIndata:DWORD,	ptrIndata_length:DWORD, ptrOutdata:DWORD	

		pushad	
		mov	esi,[esp+28h]	; ptrIndata
		mov	edi,[esp+30h]	; ptrOutdata
		mov	ecx,[esp+2ch]	; ptrIndata_length
		mov	_loopscop,ecx
		rep	movsb	
		xor	eax,eax
		xor	ebx,ebx
		mov	al,st_key.i
		mov	bl,st_key.j
		mov	cl,st_key.t3
		mov	esi,offset st_key_mov__.v
		mov	edx,[esp+30h]	; ptrOutdata
@loop:
		push	edx
		mov	ebp,[esi+200h+ebx*4]  ; t1
		mov	edi,[esi+eax*4]	; t
		add	bl,cl	; j
		and	ebx,0ffh
		mov	edx,[esi+200h+ebx*4]  ; t2
		mov	_t2,edx
		inc	al
		add	edi,_t2	; t3=t2+t
		mov	ecx,edi
		mov	[esi+200h+ebx*4],edi
		add	ebp,_t2
		add	bl,byte ptr [_t2]
		pop	edx
		sub	[edx],ebp
		add	edx,4
		sub	_loopscop,4
		jnz	@loop		
		popad
		ret
		
ScopDecrypt	endp

st_key_copy	proc

		lea	esi,st_key.v
		lea	edi,st_key_mov_.v
		mov	ecx,sizeof st_key.v
		cld
		rep	movsb
		lea	esi,st_key.v
		lea	edi,st_key_mov__.v
		mov	ecx,sizeof st_key.v
		rep	movsb
		ret
		
st_key_copy	endp
