.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

include	..\..\lib\gfp.inc
include	..\..\lib\ecp.inc
include	..\..\lib\base64.inc
include	..\..\lib\random.inc
include	ECDSA_Const.inc

extern	KEY_PRVKEY:DWORD
extern	KEY_BASEPOINT:DWORD
extern	pointH:DWORD

.code
ECDSA_Keygen	proc	ptrPubKey:DWORD, ptrPrvKey:DWORD

	push	esi

	mov	eax, dword ptr [esp+4 +4]
	xor	eax, dword ptr [esp+8 +4]
	jz	@exit

	invoke	random, 0, 0

	invoke	set_N
@@:	invoke	random, offset KEY_PRVKEY, BASE16_PRVKEY_LEN
	invoke	fixmod, offset KEY_PRVKEY
	invoke	comparezero, offset KEY_PRVKEY
	jz	@B

	assume	esi: ptr ECPOINT

	mov	esi, offset pointH

	invoke	set_P
	invoke	ECP_Mul, offset KEY_PRVKEY, offset KEY_BASEPOINT, esi

	invoke	Base64_Encode, offset KEY_PRVKEY, BASE16_PRVKEY_LEN, dword ptr [esp+8 +4]

	lea	eax, [esi].X
	invoke	Base64_Encode, eax, BASE16_PUBKEY_LEN, dword ptr [esp+4 +4]

	invoke	ECP_Zero, esi

	invoke	zero, offset KEY_PRVKEY

	invoke	random, 0, 0

	xor	eax, eax
	inc	eax

@exit:
	pop	esi
	ret	8

ECDSA_Keygen	endp

end