comment *

Algo	: GOST
Block	:  8 bytes
Key	: 32 bytes (256 b)

	push	offset key		;password ptr, exactly 32 bytes readed as key !!!
	push	offset plain		;data to encrypt ptr
	push	offset encrypted_buf	;destination ptr
	call	Gost_Crypt

	push	offset key		;password ptr, exactly 32 bytes readed as key !!!
	push	offset encrypted_buf	;data to decrypt ptr
	push	offset plain		;destination ptr
	call	Gost_Decrypt

14.11.2001 WiteG//xtreeme (witeg@poczta.fm, www.witeg.prv.pl)
*

gost_core	macro

	mov	ebx, ptrKey
	mov	esi, eax
	add	eax, dword ptr [ebx+ecx]
	mov	ebx, offset sbox_1
	xlatb
	add	ebx, 256
	ror	eax, 8
	xlatb
	add	ebx, 256
	ror	eax, 8
	xlatb
	add	ebx, 256
	ror	eax, 8
	xlatb
	add	ebx, 256
	rol	eax, 3
	xor	eax, edx

endm

.code
Gost_Crypt	proc	ptrOut:DWORD, ptrIn:DWORD, ptrKey:DWORD

LOCAL	counter:DWORD

	pushad
	mov	esi, ptrIn
	mov	edi, offset keypart

	mov	edx, dword ptr [esi]
	mov	eax, dword ptr [esi+4]
	xor	ecx, ecx
	mov	counter, 32
@@:
	mov	cl, byte ptr [edi]

	gost_core		;eax, ebx, esi

	inc	edi
	mov	edx, esi
	dec	counter
	jnz	@B

	mov	edi, ptrOut
	mov	dword ptr [edi], edx
	mov	dword ptr [edi+4], eax
	popad
	ret
Gost_Crypt	endp

Gost_Decrypt	proc	ptrOut:DWORD, ptrIn:DWORD, ptrKey:DWORD

LOCAL	counter:DWORD

	pushad
	mov	esi, ptrIn
	mov	edi, offset keypart+31

	mov	eax, dword ptr [esi]
	mov	edx, dword ptr [esi+4]
	xor	ecx, ecx
	mov	counter, 32
@@:
	mov	cl, byte ptr [edi]

	gost_core		;eax, ebx, esi

	dec	edi
	mov	edx, esi
	dec	counter
	jnz	@B

	mov	edi, ptrOut
	mov	dword ptr [edi], eax
	mov	dword ptr [edi+4], edx
	popad
	ret
Gost_Decrypt	endp

.data

;S-boxes from Applied Cryptography 2nd Edition, p. 331-333

keypart	db	0,4,8,12,16,20,24,28,0,4,8,12,16,20,24,28,0,4,8,12,16,20,24,28,28,24,20,16,12,8,4,0

sbox_1	db	0E4h, 0EAh, 0E9h, 0E2h, 0EDh, 0E8h, 0E0h, 0EEh, 0E6h, 0EBh, 0E1h, 0ECh, 0E7h, 0EFh, 0E5h, 0E3h
	db	0B4h, 0BAh, 0B9h, 0B2h, 0BDh, 0B8h, 0B0h, 0BEh, 0B6h, 0BBh, 0B1h, 0BCh, 0B7h, 0BFh, 0B5h, 0B3h
	db	044h, 04Ah, 049h, 042h, 04Dh, 048h, 040h, 04Eh, 046h, 04Bh, 041h, 04Ch, 047h, 04Fh, 045h, 043h
	db	0C4h, 0CAh, 0C9h, 0C2h, 0CDh, 0C8h, 0C0h, 0CEh, 0C6h, 0CBh, 0C1h, 0CCh, 0C7h, 0CFh, 0C5h, 0C3h
	db	064h, 06Ah, 069h, 062h, 06Dh, 068h, 060h, 06Eh, 066h, 06Bh, 061h, 06Ch, 067h, 06Fh, 065h, 063h
	db	0D4h, 0DAh, 0D9h, 0D2h, 0DDh, 0D8h, 0D0h, 0DEh, 0D6h, 0DBh, 0D1h, 0DCh, 0D7h, 0DFh, 0D5h, 0D3h
	db	0F4h, 0FAh, 0F9h, 0F2h, 0FDh, 0F8h, 0F0h, 0FEh, 0F6h, 0FBh, 0F1h, 0FCh, 0F7h, 0FFh, 0F5h, 0F3h
	db	0A4h, 0AAh, 0A9h, 0A2h, 0ADh, 0A8h, 0A0h, 0AEh, 0A6h, 0ABh, 0A1h, 0ACh, 0A7h, 0AFh, 0A5h, 0A3h
	db	024h, 02Ah, 029h, 022h, 02Dh, 028h, 020h, 02Eh, 026h, 02Bh, 021h, 02Ch, 027h, 02Fh, 025h, 023h
	db	034h, 03Ah, 039h, 032h, 03Dh, 038h, 030h, 03Eh, 036h, 03Bh, 031h, 03Ch, 037h, 03Fh, 035h, 033h
	db	084h, 08Ah, 089h, 082h, 08Dh, 088h, 080h, 08Eh, 086h, 08Bh, 081h, 08Ch, 087h, 08Fh, 085h, 083h
	db	014h, 01Ah, 019h, 012h, 01Dh, 018h, 010h, 01Eh, 016h, 01Bh, 011h, 01Ch, 017h, 01Fh, 015h, 013h
	db	004h, 00Ah, 009h, 002h, 00Dh, 008h, 000h, 00Eh, 006h, 00Bh, 001h, 00Ch, 007h, 00Fh, 005h, 003h
	db	074h, 07Ah, 079h, 072h, 07Dh, 078h, 070h, 07Eh, 076h, 07Bh, 071h, 07Ch, 077h, 07Fh, 075h, 073h
	db	054h, 05Ah, 059h, 052h, 05Dh, 058h, 050h, 05Eh, 056h, 05Bh, 051h, 05Ch, 057h, 05Fh, 055h, 053h
	db	094h, 09Ah, 099h, 092h, 09Dh, 098h, 090h, 09Eh, 096h, 09Bh, 091h, 09Ch, 097h, 09Fh, 095h, 093h

sbox_2	db	075h, 078h, 071h, 07Dh, 07Ah, 073h, 074h, 072h, 07Eh, 07Fh, 07Ch, 077h, 076h, 070h, 079h, 07Bh
	db	0D5h, 0D8h, 0D1h, 0DDh, 0DAh, 0D3h, 0D4h, 0D2h, 0DEh, 0DFh, 0DCh, 0D7h, 0D6h, 0D0h, 0D9h, 0DBh
	db	0A5h, 0A8h, 0A1h, 0ADh, 0AAh, 0A3h, 0A4h, 0A2h, 0AEh, 0AFh, 0ACh, 0A7h, 0A6h, 0A0h, 0A9h, 0ABh
	db	015h, 018h, 011h, 01Dh, 01Ah, 013h, 014h, 012h, 01Eh, 01Fh, 01Ch, 017h, 016h, 010h, 019h, 01Bh
	db	005h, 008h, 001h, 00Dh, 00Ah, 003h, 004h, 002h, 00Eh, 00Fh, 00Ch, 007h, 006h, 000h, 009h, 00Bh
	db	085h, 088h, 081h, 08Dh, 08Ah, 083h, 084h, 082h, 08Eh, 08Fh, 08Ch, 087h, 086h, 080h, 089h, 08Bh
	db	095h, 098h, 091h, 09Dh, 09Ah, 093h, 094h, 092h, 09Eh, 09Fh, 09Ch, 097h, 096h, 090h, 099h, 09Bh
	db	0F5h, 0F8h, 0F1h, 0FDh, 0FAh, 0F3h, 0F4h, 0F2h, 0FEh, 0FFh, 0FCh, 0F7h, 0F6h, 0F0h, 0F9h, 0FBh
	db	0E5h, 0E8h, 0E1h, 0EDh, 0EAh, 0E3h, 0E4h, 0E2h, 0EEh, 0EFh, 0ECh, 0E7h, 0E6h, 0E0h, 0E9h, 0EBh
	db	045h, 048h, 041h, 04Dh, 04Ah, 043h, 044h, 042h, 04Eh, 04Fh, 04Ch, 047h, 046h, 040h, 049h, 04Bh
	db	065h, 068h, 061h, 06Dh, 06Ah, 063h, 064h, 062h, 06Eh, 06Fh, 06Ch, 067h, 066h, 060h, 069h, 06Bh
	db	0C5h, 0C8h, 0C1h, 0CDh, 0CAh, 0C3h, 0C4h, 0C2h, 0CEh, 0CFh, 0CCh, 0C7h, 0C6h, 0C0h, 0C9h, 0CBh
	db	0B5h, 0B8h, 0B1h, 0BDh, 0BAh, 0B3h, 0B4h, 0B2h, 0BEh, 0BFh, 0BCh, 0B7h, 0B6h, 0B0h, 0B9h, 0BBh
	db	025h, 028h, 021h, 02Dh, 02Ah, 023h, 024h, 022h, 02Eh, 02Fh, 02Ch, 027h, 026h, 020h, 029h, 02Bh
	db	055h, 058h, 051h, 05Dh, 05Ah, 053h, 054h, 052h, 05Eh, 05Fh, 05Ch, 057h, 056h, 050h, 059h, 05Bh
	db	035h, 038h, 031h, 03Dh, 03Ah, 033h, 034h, 032h, 03Eh, 03Fh, 03Ch, 037h, 036h, 030h, 039h, 03Bh

sbox_3	db	046h, 04Ch, 047h, 041h, 045h, 04Fh, 04Dh, 048h, 044h, 04Ah, 049h, 04Eh, 040h, 043h, 04Bh, 042h
	db	0B6h, 0BCh, 0B7h, 0B1h, 0B5h, 0BFh, 0BDh, 0B8h, 0B4h, 0BAh, 0B9h, 0BEh, 0B0h, 0B3h, 0BBh, 0B2h
	db	0A6h, 0ACh, 0A7h, 0A1h, 0A5h, 0AFh, 0ADh, 0A8h, 0A4h, 0AAh, 0A9h, 0AEh, 0A0h, 0A3h, 0ABh, 0A2h
	db	006h, 00Ch, 007h, 001h, 005h, 00Fh, 00Dh, 008h, 004h, 00Ah, 009h, 00Eh, 000h, 003h, 00Bh, 002h
	db	076h, 07Ch, 077h, 071h, 075h, 07Fh, 07Dh, 078h, 074h, 07Ah, 079h, 07Eh, 070h, 073h, 07Bh, 072h
	db	026h, 02Ch, 027h, 021h, 025h, 02Fh, 02Dh, 028h, 024h, 02Ah, 029h, 02Eh, 020h, 023h, 02Bh, 022h
	db	016h, 01Ch, 017h, 011h, 015h, 01Fh, 01Dh, 018h, 014h, 01Ah, 019h, 01Eh, 010h, 013h, 01Bh, 012h
	db	0D6h, 0DCh, 0D7h, 0D1h, 0D5h, 0DFh, 0DDh, 0D8h, 0D4h, 0DAh, 0D9h, 0DEh, 0D0h, 0D3h, 0DBh, 0D2h
	db	036h, 03Ch, 037h, 031h, 035h, 03Fh, 03Dh, 038h, 034h, 03Ah, 039h, 03Eh, 030h, 033h, 03Bh, 032h
	db	066h, 06Ch, 067h, 061h, 065h, 06Fh, 06Dh, 068h, 064h, 06Ah, 069h, 06Eh, 060h, 063h, 06Bh, 062h
	db	086h, 08Ch, 087h, 081h, 085h, 08Fh, 08Dh, 088h, 084h, 08Ah, 089h, 08Eh, 080h, 083h, 08Bh, 082h
	db	056h, 05Ch, 057h, 051h, 055h, 05Fh, 05Dh, 058h, 054h, 05Ah, 059h, 05Eh, 050h, 053h, 05Bh, 052h
	db	096h, 09Ch, 097h, 091h, 095h, 09Fh, 09Dh, 098h, 094h, 09Ah, 099h, 09Eh, 090h, 093h, 09Bh, 092h
	db	0C6h, 0CCh, 0C7h, 0C1h, 0C5h, 0CFh, 0CDh, 0C8h, 0C4h, 0CAh, 0C9h, 0CEh, 0C0h, 0C3h, 0CBh, 0C2h
	db	0F6h, 0FCh, 0F7h, 0F1h, 0F5h, 0FFh, 0FDh, 0F8h, 0F4h, 0FAh, 0F9h, 0FEh, 0F0h, 0F3h, 0FBh, 0F2h
	db	0E6h, 0ECh, 0E7h, 0E1h, 0E5h, 0EFh, 0EDh, 0E8h, 0E4h, 0EAh, 0E9h, 0EEh, 0E0h, 0E3h, 0EBh, 0E2h

sbox_4	db	01Dh, 01Bh, 014h, 011h, 013h, 01Fh, 015h, 019h, 010h, 01Ah, 01Eh, 017h, 016h, 018h, 012h, 01Ch
	db	0FDh, 0FBh, 0F4h, 0F1h, 0F3h, 0FFh, 0F5h, 0F9h, 0F0h, 0FAh, 0FEh, 0F7h, 0F6h, 0F8h, 0F2h, 0FCh
	db	0DDh, 0DBh, 0D4h, 0D1h, 0D3h, 0DFh, 0D5h, 0D9h, 0D0h, 0DAh, 0DEh, 0D7h, 0D6h, 0D8h, 0D2h, 0DCh
	db	00Dh, 00Bh, 004h, 001h, 003h, 00Fh, 005h, 009h, 000h, 00Ah, 00Eh, 007h, 006h, 008h, 002h, 00Ch
	db	05Dh, 05Bh, 054h, 051h, 053h, 05Fh, 055h, 059h, 050h, 05Ah, 05Eh, 057h, 056h, 058h, 052h, 05Ch
	db	07Dh, 07Bh, 074h, 071h, 073h, 07Fh, 075h, 079h, 070h, 07Ah, 07Eh, 077h, 076h, 078h, 072h, 07Ch
	db	0ADh, 0ABh, 0A4h, 0A1h, 0A3h, 0AFh, 0A5h, 0A9h, 0A0h, 0AAh, 0AEh, 0A7h, 0A6h, 0A8h, 0A2h, 0ACh
	db	04Dh, 04Bh, 044h, 041h, 043h, 04Fh, 045h, 049h, 040h, 04Ah, 04Eh, 047h, 046h, 048h, 042h, 04Ch
	db	09Dh, 09Bh, 094h, 091h, 093h, 09Fh, 095h, 099h, 090h, 09Ah, 09Eh, 097h, 096h, 098h, 092h, 09Ch
	db	02Dh, 02Bh, 024h, 021h, 023h, 02Fh, 025h, 029h, 020h, 02Ah, 02Eh, 027h, 026h, 028h, 022h, 02Ch
	db	03Dh, 03Bh, 034h, 031h, 033h, 03Fh, 035h, 039h, 030h, 03Ah, 03Eh, 037h, 036h, 038h, 032h, 03Ch
	db	0EDh, 0EBh, 0E4h, 0E1h, 0E3h, 0EFh, 0E5h, 0E9h, 0E0h, 0EAh, 0EEh, 0E7h, 0E6h, 0E8h, 0E2h, 0ECh
	db	06Dh, 06Bh, 064h, 061h, 063h, 06Fh, 065h, 069h, 060h, 06Ah, 06Eh, 067h, 066h, 068h, 062h, 06Ch
	db	0BDh, 0BBh, 0B4h, 0B1h, 0B3h, 0BFh, 0B5h, 0B9h, 0B0h, 0BAh, 0BEh, 0B7h, 0B6h, 0B8h, 0B2h, 0BCh
	db	08Dh, 08Bh, 084h, 081h, 083h, 08Fh, 085h, 089h, 080h, 08Ah, 08Eh, 087h, 086h, 088h, 082h, 08Ch
	db	0CDh, 0CBh, 0C4h, 0C1h, 0C3h, 0CFh, 0C5h, 0C9h, 0C0h, 0CAh, 0CEh, 0C7h, 0C6h, 0C8h, 0C2h, 0CCh