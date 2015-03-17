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
include	..\..\lib\sha1.inc
include	..\..\lib\utils.inc
include	ECDSA_Const.inc

extern	KEY_PRVKEY:DWORD
extern	KEY_BASEPOINT:DWORD

extern	_N:DWORD

extern	intE:DWORD
extern	intK:DWORD
extern	signR:DWORD
extern	signS:DWORD
extern	pointH:DWORD

extern	msgDigest:DWORD

.code
ECDSA_Sign	proc	ptrPrvKey:DWORD, ptrMessage:DWORD, lenMessage:DWORD, ptrSignature:DWORD

	pushad

	xor	ecx, ecx
	mov	esi, dword ptr [esp+20h+4]

	invoke	getstringlen, esi
	xchg	eax, ecx
	cmp	ecx, BASE64_PRVKEY_LEN
	jnz	@exit			;return eax=0 => error

	xor	ecx, ecx
	invoke	Base64_Decode, esi, offset KEY_PRVKEY
					;prepare for overflow!
	xchg	eax, ecx
	cmp	ecx, BASE16_PRVKEY_LEN
	jnz	@exit
					;eax = 0

	invoke	compare, offset KEY_PRVKEY, offset _N
	jae	@exit

	mov	ebx, offset pointH
	assume	ebx: ptr ECPOINT

@@:	invoke	set_N
	invoke	random, offset intK, BASE16_PRVKEY_LEN
	invoke	fixmod, offset intK
	invoke	comparezero, offset intK
	jz	@B

	invoke	set_P
	invoke	ECP_Mul, offset intK, offset KEY_BASEPOINT, ebx

	lea	edx, [ebx].X

	invoke	set_N
	invoke	copy, edx, offset signR
	invoke	fixmod, offset signR
							;signR = (k*G).x mod N
	invoke	comparezero, offset signR
	jz	@B

	invoke	invmod, offset intK			;k=k^-1 mod N

	invoke	sha1, offset msgDigest, dword ptr [esp+20h+4+8 +4], dword ptr [esp+20h+4+4]
							;ptr msgDigest, lenMessage, ptrMessage

	invoke	converth2bmod, offset msgDigest, offset intE
							;convert hash to big number mod actual modulus

	invoke	mulmod, offset KEY_PRVKEY, offset signR, offset signS
	invoke	addmod, offset signS, offset intE, offset signS
	invoke	mulmod, offset signS, offset intK, offset signS
	invoke	comparezero, offset signS
	jz	@B

	invoke	Base64_Encode, offset signR, BASE16_SIGN_LEN, dword ptr [esp+20h+4+12]
							;offset signR, lenSignatureHexA, ptrSignature

	invoke	ECP_Zero, ebx
	invoke	zero, offset intE
	invoke	zero, offset intK
	invoke	zero, offset signR
	invoke	zero, offset signS

	xor	eax, eax
	inc	eax

@exit:
	mov	dword ptr [esp+28], eax

	invoke	zero, offset KEY_PRVKEY

	popad
	ret	4*4

ECDSA_Sign	endp

end