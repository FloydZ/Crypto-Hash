comment *

Algo	: Misty1
Block	: 8 bytes
Key	: 16 bytes (128 b)

	push	offset password
	call	Misty1_SetKey

	push	offset DataIn		;plaintext
	push	offset DataOut		;buffer for ciphertext
	call	Misty1_Encrypt

	push	offset DataOut		;ciphertext
	push	offset DataOut		;buffer for ciphertext
	call	Misty1_Decrypt

	call	Misty1_Clear


07.02.2002 WiteG//xtreeme (witeg@poczta.fm, www.witeg.prv.pl)
*

fl	macro	arg_dword, arg_word, k

LOCAL k0,k1,k2

k0	equ 	(k shr 1)

	movzx	eax, arg_word		;   d1 = fl_in & 0xffff;

	shr	arg_dword, 16		;   d0 = (fl_in >> 16);
	mov	edx, arg_dword		;   d0

	IFE	(k and 1)		;parzyste

	k1	equ	k0 * 2
	k2	equ	(((k0 + 6) and 7) + 8) * 2

	and	dx, word ptr [edi + k1]
	xor	ax, dx				;    d1 = d1 ^ (d0 & ek[t...]);

	mov	cx, ax
	or	cx, word ptr [edi + k2]
	xor	arg_word, cx			;    d0 = d0 ^ (d1 | ek[t...]);
	
	ELSE				;nieparzyste

	k1	equ	(((k0 + 2) and 7) + 8) * 2
	k2	equ	( (k0 + 4) and 7) * 2

	and	dx, word ptr [edi + k1]
	xor	ax, dx				;    d1 = d1 ^ (d0 & ek[t...]);

	mov	cx, ax
	or	cx, word ptr [edi + k2]
	xor	arg_word, cx			;    d0 = d0 ^ (d1 | ek[t...]);
	
	ENDIF

	shl	arg_dword, 16				;return ((d0<<16) | d1);
	or	arg_dword, eax
endm

flinv	macro	arg_dword, arg_word, k

LOCAL k0,k1,k2

k0	equ 	(k shr 1)

	movzx	eax, arg_word		;   d1 = fl_in & 0xffff;
	shr	arg_dword, 16		;   d0 = (fl_in >> 16);

	IFE	(k and 1)		;parzyste

	k1	equ	k0 * 2
	k2	equ	(((k0 + 6) and 7) + 8) * 2

	mov	cx, ax
	or	cx, word ptr [edi + k2]
	xor	arg_word, cx			;    d0 = d0 ^ (d1 | ek[t...]);

	mov	dx, arg_word			;    d0
	and	dx, word ptr [edi + k1]
	xor	ax, dx				;    d1 = d1 ^ (d0 & ek[t...]);

	
	ELSE				;nieparzyste

	k1	equ	(((k0 + 2) and 7) + 8) * 2
	k2	equ	( (k0 + 4) and 7) * 2

	mov	cx, ax
	or	cx, word ptr [edi + k2]
	xor	arg_word, cx			;    d0 = d0 ^ (d1 | ek[t...]);

	mov	dx, arg_word			;    d0
	and	dx, word ptr [edi + k1]
	xor	ax, dx				;    d1 = d1 ^ (d0 & ek[t...]);
	
	ENDIF

	shl	arg_dword, 16				;return ((d0<<16) | d1);
	or	arg_dword, eax
endm

fo	macro	result, arg_dword, k

LOCAL	k0,k1,k2,k3,k4,k5,k6

	k0 = k * 2
	k1 = (((k + 5) and 7) + 8) * 2
	k2 = ((k + 2) and 7) *2
	k3 = (((k + 1) and 7) + 8) * 2
	k4 = ((k + 7) and 7) *2
	k5 = (((k + 3) and 7) + 8) * 2
	k6 = ((k + 4) and 7) *2

	mov	eax, arg_dword
	mov	edx, arg_dword			;t1
	shr	eax, 16				;t0
	and	edx, 0FFFFh

	xor	ax, word ptr [edi + k0]		;t0 ^= ek[k];

	fi	eax, ax, word ptr [edi + k1]	;t0 = fi(t0, ek[((k+5)%8) + 8]);

	xor	ax, dx				;t0 ^= t1;
	xor	dx, word ptr [edi + k2]		;t1 ^= ek[(k+2)%8];
	
	fi	edx, dx, word ptr [edi + k3]	;t1 = fi(t1,ek[((k+1)%8) + 8]);
	
	xor	dx, ax				;t1 ^= t0;
	xor	ax, word ptr [edi + k4]		;t0 ^= ek[(k+7)%8];

	fi	eax, ax, word ptr [edi + k5]	;t0 = fi(t0, ek[((k+5)%8) + 8]);

	xor	ax, dx				;t0 ^= t1;
	xor	dx, word ptr [edi + k6]		;t1 ^=  ek[(k+4)%8;

	shl	edx, 16
	or	eax, edx			;return ( (t1<<16) | t0 );
	
	xor	result, eax
endm

fi	macro	fi_in_dword,fi_in_word, fi_key

	mov	ecx, fi_in_dword

	shr	cx, 7				;d9 = (fi_in >> 7) & 0x1ff;
	and	fi_in_dword, 7Fh		;d7 = fi_in & 0x7f;

	mov	cx, word ptr [s9 + 2*ecx]
	xor	cx, fi_in_word			;d9 = s9[d9] ^ d7;

	movzx	fi_in_word, byte ptr [s7 + fi_in_dword]
	mov	bp, fi_key
	xor	fi_in_word, cx
	shr	bp, 9
	and	fi_in_word, 7Fh			;d7 = (s7[d7] ^ d9) & 0x7f;
	xor	fi_in_word, bp			;d7 = d7 ^ ((fi_key >> 9) & 0x7f);

	mov	bp, fi_key
	and	bp, 1FFh
	xor	cx, bp				;d9 = d9 ^ (fi_key & 0x1ff);

	mov	cx, word ptr [s9 + 2*ecx]
	xor	cx, fi_in_word			;d9 = s9[d9] ^ d7;

	shl	fi_in_word, 9
	or	fi_in_word, cx			;return ((d7<<9) | d9);
endm

.code
Misty1Encrypt	proc	ptrOut :DWORD , ptrIn :DWORD
	pushad

	mov	edi, ptrIn
	mov	ebx, dword ptr [edi+0]		;d0 = p[0];
	mov	esi, dword ptr [edi+4]		;d1 = p[1];
	mov	edi, offset misty_inter_key

	push	ebp

	fl	ebx, bx, 0			;d0 = fl(d0,0);
	fl	esi, si, 1			;d1 = fl(d1,1);
	fo	esi, ebx, 0
	fo	ebx, esi, 1
	fl	ebx, bx, 2
	fl	esi, si, 3
	fo	esi, ebx, 2
	fo	ebx, esi, 3
	fl	ebx, bx, 4
	fl	esi, si, 5
	fo	esi, ebx, 4
	fo	ebx, esi, 5
	fl	ebx, bx, 6
	fl	esi, si, 7
	fo	esi, ebx, 6
	fo	ebx, esi, 7
	fl	ebx, bx, 8
	fl	esi, si, 9

	pop	ebp

	mov	edi, ptrOut
	mov	dword ptr [edi+0], esi
	mov	dword ptr [edi+4], ebx

	popad
	ret
Misty1Encrypt	endp

Misty1Decrypt	proc	ptrOut :DWORD , ptrIn :DWORD
	pushad

	mov	edi, ptrIn
	mov	ebx, dword ptr [edi+4]		;d0 = c[1];
	mov	esi, dword ptr [edi+0]		;d1 = c[0];
	mov	edi, offset misty_inter_key

	push	ebp

	flinv	ebx, bx, 8			;d0 = fl(d0,0);
	flinv	esi, si, 9			;d1 = fl(d1,1);
	fo	ebx, esi, 7
	fo	esi, ebx, 6
	flinv	ebx, bx, 6
	flinv	esi, si, 7
	fo	ebx, esi, 5
	fo	esi, ebx, 4
	flinv	ebx, bx, 4
	flinv	esi, si, 5
	fo	ebx, esi, 3
	fo	esi, ebx, 2
	flinv	ebx, bx, 2
	flinv	esi, si, 3
	fo	ebx, esi, 1
	fo	esi, ebx, 0
	flinv	ebx, bx, 0
	flinv	esi, si, 1

	pop	ebp

	mov	edi, ptrOut
	mov	dword ptr [edi+4], esi
	mov	dword ptr [edi+0], ebx

	popad
	ret
Misty1Decrypt	endp

Misty1Init		proc	ptrPass	:dword
	pushad

	mov	esi, ptrPass
	mov	edi, offset misty_inter_key
	xor	eax, eax
	mov	ecx, 4
@@:
	mov	ax, word ptr [esi+4*ecx-2]
	mov	bx, word ptr [esi+4*ecx-4]
	mov	word ptr [edi+4*ecx-2], bx
	mov	word ptr [edi+4*ecx-4], ax
	dec	ecx
	jnz	@B
  
						;ecx=0
@@:
	mov	ax, word ptr [edi+2*ecx]
	mov	ebx, eax

	shr	eax, 7				;d9 = (fi_in >> 7) & 0x1ff;
						; word >> 7 & 1FFh = word >> 7

	and	ebx, 7Fh			;d7 = fi_in & 0x7f;
	movzx	edx, word ptr [s9 + 2*eax]
	inc	ecx
	xor	dl, bl				;d9 = s9[d9] ^ d7;
	mov	esi, ecx
	movzx	eax, byte ptr [s7 + ebx]
	and	esi, 7
	mov	bx, word ptr [edi+2*esi]
	xor	eax, edx
	shr	ebx, 9

	and	eax, 7Fh			;d7 = (s7[d7] ^ d9) & 0x7f;
	xor	eax, ebx			;d7 = d7 ^ ((fi_key >> 9) & 0x7f);

	mov	bx, word ptr [edi+ 2*esi]
	and	ebx, 1FFh
	xor	edx, ebx			;d9 = d9 ^ (fi_key & 0x1ff);
	mov	dx, word ptr [s9 + 2*edx]
	xor	edx, eax			;d9 = s9[d9] ^ d7;
	shl	eax, 9
	or	eax, edx			;(d7<<9) | d9
	dec	ecx

	mov	word ptr [edi+2*ecx+8*2], ax
	mov	ebx, eax
	and	ebx, 1FFh
	shr	eax, 9
	mov	word ptr [edi+2*ecx+16*2], bx
	mov	word ptr [edi+2*ecx+24*2], ax

	inc	ecx
	cmp	ecx, 8
	jnz	@B

	popad
	ret

s7	db	01bh, 032h, 033h, 05ah, 03bh, 010h, 017h, 054h, 05bh, 01ah, 072h, 073h, 06bh, 02ch, 066h, 049h
	db	01fh, 024h, 013h, 06ch, 037h, 02eh, 03fh, 04ah, 05dh, 00fh, 040h, 056h, 025h, 051h, 01ch, 004h
	db	00bh, 046h, 020h, 00dh, 07bh, 035h, 044h, 042h, 02bh, 01eh, 041h, 014h, 04bh, 079h, 015h, 06fh
	db	00eh, 055h, 009h, 036h, 074h, 00ch, 067h, 053h, 028h, 00ah, 07eh, 038h, 002h, 007h, 060h, 029h
	db	019h, 012h, 065h, 02fh, 030h, 039h, 008h, 068h, 05fh, 078h, 02ah, 04ch, 064h, 045h, 075h, 03dh
	db	059h, 048h, 003h, 057h, 07ch, 04fh, 062h, 03ch, 01dh, 021h, 05eh, 027h, 06ah, 070h, 04dh, 03ah
	db	001h, 06dh, 06eh, 063h, 018h, 077h, 023h, 005h, 026h, 076h, 000h, 031h, 02dh, 07ah, 07fh, 061h
	db	050h, 022h, 011h, 006h, 047h, 016h, 052h, 04eh, 071h, 03eh, 069h, 043h, 034h, 05ch, 058h, 07dh

s9	dw	01c3h, 00cbh, 0153h, 019fh, 01e3h, 00e9h, 00fbh, 0035h, 0181h, 00b9h, 0117h, 01ebh, 0133h, 0009h, 002dh, 00d3h
	dw	00c7h, 014ah, 0037h, 007eh, 00ebh, 0164h, 0193h, 01d8h, 00a3h, 011eh, 0055h, 002ch, 001dh, 01a2h, 0163h, 0118h
	dw	014bh, 0152h, 01d2h, 000fh, 002bh, 0030h, 013ah, 00e5h, 0111h, 0138h, 018eh, 0063h, 00e3h, 00c8h, 01f4h, 001bh
	dw	0001h, 009dh, 00f8h, 01a0h, 016dh, 01f3h, 001ch, 0146h, 007dh, 00d1h, 0082h, 01eah, 0183h, 012dh, 00f4h, 019eh
	dw	01d3h, 00ddh, 01e2h, 0128h, 01e0h, 00ech, 0059h, 0091h, 0011h, 012fh, 0026h, 00dch, 00b0h, 018ch, 010fh, 01f7h
	dw	00e7h, 016ch, 00b6h, 00f9h, 00d8h, 0151h, 0101h, 014ch, 0103h, 00b8h, 0154h, 012bh, 01aeh, 0017h, 0071h, 000ch
	dw	0047h, 0058h, 007fh, 01a4h, 0134h, 0129h, 0084h, 015dh, 019dh, 01b2h, 01a3h, 0048h, 007ch, 0051h, 01cah, 0023h
	dw	013dh, 01a7h, 0165h, 003bh, 0042h, 00dah, 0192h, 00ceh, 00c1h, 006bh, 009fh, 01f1h, 012ch, 0184h, 00fah, 0196h
	dw	01e1h, 0169h, 017dh, 0031h, 0180h, 010ah, 0094h, 01dah, 0186h, 013eh, 011ch, 0060h, 0175h, 01cfh, 0067h, 0119h
	dw	0065h, 0068h, 0099h, 0150h, 0008h, 0007h, 017ch, 00b7h, 0024h, 0019h, 00deh, 0127h, 00dbh, 00e4h, 01a9h, 0052h
	dw	0109h, 0090h, 019ch, 01c1h, 0028h, 01b3h, 0135h, 016ah, 0176h, 00dfh, 01e5h, 0188h, 00c5h, 016eh, 01deh, 01b1h
	dw	00c3h, 01dfh, 0036h, 00eeh, 01eeh, 00f0h, 0093h, 0049h, 009ah, 01b6h, 0069h, 0081h, 0125h, 000bh, 005eh, 00b4h
	dw	0149h, 01c7h, 0174h, 003eh, 013bh, 01b7h, 008eh, 01c6h, 00aeh, 0010h, 0095h, 01efh, 004eh, 00f2h, 01fdh, 0085h
	dw	00fdh, 00f6h, 00a0h, 016fh, 0083h, 008ah, 0156h, 009bh, 013ch, 0107h, 0167h, 0098h, 01d0h, 01e9h, 0003h, 01feh
	dw	00bdh, 0122h, 0089h, 00d2h, 018fh, 0012h, 0033h, 006ah, 0142h, 00edh, 0170h, 011bh, 00e2h, 014fh, 0158h, 0131h
	dw	0147h, 005dh, 0113h, 01cdh, 0079h, 0161h, 01a5h, 0179h, 009eh, 01b4h, 00cch, 0022h, 0132h, 001ah, 00e8h, 0004h
	dw	0187h, 01edh, 0197h, 0039h, 01bfh, 01d7h, 0027h, 018bh, 00c6h, 009ch, 00d0h, 014eh, 006ch, 0034h, 01f2h, 006eh
	dw	00cah, 0025h, 00bah, 0191h, 00feh, 0013h, 0106h, 002fh, 01adh, 0172h, 01dbh, 00c0h, 010bh, 01d6h, 00f5h, 01ech
	dw	010dh, 0076h, 0114h, 01abh, 0075h, 010ch, 01e4h, 0159h, 0054h, 011fh, 004bh, 00c4h, 01beh, 00f7h, 0029h, 00a4h
	dw	000eh, 01f0h, 0077h, 004dh, 017ah, 0086h, 008bh, 00b3h, 0171h, 00bfh, 010eh, 0104h, 0097h, 015bh, 0160h, 0168h
	dw	00d7h, 00bbh, 0066h, 01ceh, 00fch, 0092h, 01c5h, 006fh, 0016h, 004ah, 00a1h, 0139h, 00afh, 00f1h, 0190h, 000ah
	dw	01aah, 0143h, 017bh, 0056h, 018dh, 0166h, 00d4h, 01fbh, 014dh, 0194h, 019ah, 0087h, 01f8h, 0123h, 00a7h, 01b8h
	dw	0141h, 003ch, 01f9h, 0140h, 002ah, 0155h, 011ah, 01a1h, 0198h, 00d5h, 0126h, 01afh, 0061h, 012eh, 0157h, 01dch
	dw	0072h, 018ah, 00aah, 0096h, 0115h, 00efh, 0045h, 007bh, 008dh, 0145h, 0053h, 005fh, 0178h, 00b2h, 002eh, 0020h
	dw	01d5h, 003fh, 01c9h, 01e7h, 01ach, 0044h, 0038h, 0014h, 00b1h, 016bh, 00abh, 00b5h, 005ah, 0182h, 01c8h, 01d4h
	dw	0018h, 0177h, 0064h, 00cfh, 006dh, 0100h, 0199h, 0130h, 015ah, 0005h, 0120h, 01bbh, 01bdh, 00e0h, 004fh, 00d6h
	dw	013fh, 01c4h, 012ah, 0015h, 0006h, 00ffh, 019bh, 00a6h, 0043h, 0088h, 0050h, 015fh, 01e8h, 0121h, 0073h, 017eh
	dw	00bch, 00c2h, 00c9h, 0173h, 0189h, 01f5h, 0074h, 01cch, 01e6h, 01a8h, 0195h, 001fh, 0041h, 000dh, 01bah, 0032h
	dw	003dh, 01d1h, 0080h, 00a8h, 0057h, 01b9h, 0162h, 0148h, 00d9h, 0105h, 0062h, 007ah, 0021h, 01ffh, 0112h, 0108h
	dw	01c0h, 00a9h, 011dh, 01b0h, 01a6h, 00cdh, 00f3h, 005ch, 0102h, 005bh, 01d9h, 0144h, 01f6h, 00adh, 00a5h, 003ah
	dw	01cbh, 0136h, 017fh, 0046h, 00e1h, 001eh, 01ddh, 00e6h, 0137h, 01fah, 0185h, 008ch, 008fh, 0040h, 01b5h, 00beh
	dw	0078h, 0000h, 00ach, 0110h, 015eh, 0124h, 0002h, 01bch, 00a2h, 00eah, 0070h, 01fch, 0116h, 015ch, 004ch, 01c2h
Misty1Init		endp

Misty1_Clear		proc
	pushad

	xor	eax, eax
	mov	ecx, 10h
	mov	edi, offset misty_inter_key
	cld
	rep	stosd

	popad
	ret
Misty1_Clear		endp

.data?
misty_inter_key		dw 20h dup (?)