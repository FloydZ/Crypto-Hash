.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

include	..\..\lib\gfp.inc
include	..\..\lib\ecp.inc
include	..\..\lib\base64.inc
include	..\..\lib\sha1.inc
include	..\..\lib\utils.inc
include	ECDSA_Const.inc

extern	_A:DWORD
extern	_B:DWORD
extern	_N:DWORD
extern	intU1:DWORD
extern	intU2:DWORD
extern	intE:DWORD
extern	intK:DWORD
extern	signR:DWORD
extern	signS:DWORD
extern	pointH:DWORD
extern	pointI:DWORD
extern	pointJ:DWORD
extern	KEY_BASEPOINT:DWORD
extern	msgDigest:DWORD

.code
ECDSA_Verify	proc	ptrPubKey:DWORD, ptrMessage:DWORD, lenMessage:DWORD, ptrSignature:DWORD

	pushad

	invoke	getstringlen, dword ptr [esp+20h+4]
	cmp	eax, BASE64_PUBKEY_LEN
	jnz	@error

	invoke	getstringlen, dword ptr [esp+20h+16]
	cmp	eax, BASE64_SIGN_LEN
	jnz	@error			;return eax=0 => error

	assume	ebp: ptr ECPOINT
	mov	ebp, offset pointI

	lea	ebx, [ebp].X

	invoke	Base64_Decode, dword ptr [esp+20h+4 +4], ebx
					;prepare for overflow!
	cmp	eax, BASE16_PUBKEY_LEN
	jnz	@error

	mov	[ebp].INFINITY, 1

	invoke	set_P

	mov	esi, offset intU1
	mov	edi, offset intU2

	invoke	mulmod, ebx, ebx, esi		;u1 = x*x mod p
	invoke	mulmod, ebx, esi, esi		;u1 = x^3 mod p
	invoke	mulmod, ebx, offset _A, edi	;u2 = a*x mod p
	invoke	addmod, esi, edi, esi		;u1 = x^3 + a*x mod p
	invoke	addmod, esi, offset _B, esi	;u1 = x^3 + a*x + b mod p

	lea	edx, [ebp].Y

	invoke	mulmod, edx, edx, edi		;u2 = y*y mod p
	invoke	compare, esi, edi
	jnz	@error				;point on the curve ?
						
	mov	esi, offset signR
	mov	edi, offset signS
	invoke	Base64_Decode, dword ptr [esp+20h+16 +4], esi
						;ptrSignature
						;prepare for overflow!
	cmp	eax, BASE16_SIGN_LEN
	jnz	@error

	invoke	comparezero, esi
	jz	@error

	invoke	compare, esi, offset _N
	jnc	@error

	invoke	comparezero, edi
	jz	@error

	invoke	compare, edi, offset _N
	jnc	@error


	invoke	set_N
	invoke	sha1, offset msgDigest, dword ptr [esp+20h+12+4], dword ptr [esp+20h+8]
						;ptr msgDigest, lenMessage, ptrMessage

	invoke	converth2bmod, offset msgDigest, offset intE
							;convert hash to big number mod actual modulus

	invoke	invmod, edi				;s=s^-1 mod n
	invoke	mulmod, offset intE, edi, offset intU1	;u1 = c*s mod n
	invoke	mulmod, esi, edi, offset intU2		;u2 = r*s mod n

	assume	ebx: ptr ECPOINT
	mov	ebx, offset pointJ

	invoke	set_P
	invoke	ECP_Mul, offset intU1, offset KEY_BASEPOINT, offset pointH
	invoke	ECP_Mul, offset intU2, ebp, ebx
	invoke	ECP_Add, offset pointH, ebx

	mov	eax, [ebx].INFINITY
	test	eax, eax
	jz	@error

	invoke	set_N

	lea	edi, [ebx].X
	invoke	fixmod, edi

	invoke	compare, esi, edi
	jnz	@error

	;eax = 1 = [ebx].INFINITY 
@@:
	mov	dword ptr [esp+28], eax

	invoke	ECP_Zero, offset pointH
	invoke	ECP_Zero, offset pointI
	invoke	ECP_Zero, offset pointJ
	invoke	zero, offset intU1
	invoke	zero, offset intU2
	invoke	zero, offset intE
	invoke	zero, offset intK
	invoke	zero, offset signR
	invoke	zero, offset signS

	popad
	ret	4*4

@error:
	xor	eax, eax
	jmp	@B

ECDSA_Verify	endp

end