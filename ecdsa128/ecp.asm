.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

include	gfp.inc
include	ecp.inc

public	tempInt1
public	tempInt2
public	tempInt3
public	_A
public	_B
public	_P
public	_PC
public	_N
public	_NC
public	KEY_BASEPOINT

ECP_Add		PROTO	:DWORD, :DWORD
ECP_Copy	PROTO	:DWORD, :DWORD
ECP_Dbl		PROTO	:DWORD, :DWORD
ECP_Mul		PROTO	:DWORD, :DWORD, :DWORD
ECP_A2J		PROTO	:DWORD, :DWORD
ECP_J2A		PROTO	:DWORD, :DWORD
ECP_Add_J	PROTO	:DWORD, :DWORD
ECP_Dbl_J	PROTO	:DWORD, :DWORD

set_N		PROTO
set_P		PROTO

.data
; RandomCurve1-P128-WiteG
; y^2 = x^3 - 3*x + 103744651967215942079424252318256895516 mod 340282366920938463444927863358058659863
; N = 340282366920938463450938462077435853809

_A		dd	000000014h, 000000000h, 0FFFFFFFFh, 0FFFFFFFFh
_B		dd	07C72961Ch, 082522799h, 000CE59BEh, 04E0C7E41h
_P		dd	000000017h, 000000000h, 0FFFFFFFFh, 0FFFFFFFFh
_N		dd	093E53BF1h, 05369EFB0h, 0FFFFFFFFh, 0FFFFFFFFh
KEY_BASEPOINT	dd	1
		dd	0FD79309Fh, 061174BA8h, 09A2B41A1h, 0504E0BD3h
		dd	0D469DED4h, 0BB0D8845h, 07279A790h, 09A45FA6Dh

;		dd	0F1282630h, 096298968h, 01D2AF8D7h, 0DA1E8369h
;		dd	05AD752DAh, 0C66A5335h, 0F45519DAh, 0146AE5D5h

.data?
tempInt1	BIGINT<>
tempInt2	BIGINT<>
tempInt3	BIGINT<>
_PC		BIGINT<>
_NC		BIGINT<>


.code

ECP_Add_J	proc	ptrA:DWORD, ptrB:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]
	mov	edi, dword ptr [esp+20h+8]

	assume	esi: ptr ECPOINTJ
	assume	edi: ptr ECPOINTJ

	lea	edx, [esi].Y
	lea	ecx, [esi].Z		;P

	lea	ebx, [edi].Y		;Q
	lea	ebp, [edi].Z
					;A=P: X2 = esi, Y2 = edx, Z2 = ecx
					;B=Q: X  = edi, Y  = ebx, Z  = ebp
	invoke	comparezero, ecx
	jz	@ret			;if (Z2 == 0) return B, do nothing

	invoke	comparezero, ebp
	jz	@returnA		;if (Z  == 0) return A

	invoke	compareone, ecx
	jz	@F

	invoke	mulmod, ecx, ecx, offset tempInt1			;T1 = Z2^2	
	invoke	mulmod, offset tempInt1, edi, edi			;X = X*T1
	invoke	mulmod, offset tempInt1, ecx, offset tempInt1		;T1 = Z2*T1
	invoke	mulmod, offset tempInt1, ebx, ebx			;Y = Y*T1
@@:
	invoke	mulmod, ebp, ebp, offset tempInt1			;T1 = Z^2
	invoke	mulmod, offset tempInt1, esi, offset tempInt2		;T2 = X2*T1
	invoke	mulmod, offset tempInt1, ebp, offset tempInt1		;T1 = Z*T1
	invoke	mulmod, offset tempInt1, edx, offset tempInt1		;T1 = Y2*T1
	invoke	submod, offset tempInt1, ebx, offset tempInt1		;T1 = T1 - Y
	invoke	submod, offset tempInt2, edi, offset tempInt2		;T2 = T2 - X
	invoke	comparezero, offset tempInt2
	jnz	@T2ne0

		invoke	comparezero, offset tempInt1
		jnz	@return0

			invoke	ECP_Dbl_J, esi, edi
			jmp	@ret

@T2ne0:
	invoke	compareone, ecx
	jz	@F

		invoke	mulmod, ebp, ecx, ebp				;Z = Z*Z2

@@:
	invoke	mulmod, ebp, offset tempInt2, ebp			;Z = Z*T2
	invoke	mulmod, offset tempInt2, offset tempInt2, offset tempInt3
									;T3 = T2^2
	invoke	mulmod, offset tempInt2, offset tempInt3, offset tempInt2
									;T2 = T2*T3
	invoke	mulmod, offset tempInt3, edi, offset tempInt3		;T3 = X*T3
	invoke	mulmod, offset tempInt1, offset tempInt1, edi		;X = T1^2
	invoke	mulmod, offset tempInt2, ebx, ebx			;Y = T2*Y
	invoke	submod, edi, offset tempInt2, offset tempInt2		;T2 = X - T2
	invoke	addmod, offset tempInt3, offset tempInt3, edi		;X = 2*T3
	invoke	submod, offset tempInt2, edi, edi			;X = T2 - X
	invoke	submod, offset tempInt3, edi, offset tempInt2		;T2 = T3 - X
	invoke	mulmod, offset tempInt1, offset tempInt2, offset tempInt2
									;T2 = T1*T2
	invoke	submod, offset tempInt2, ebx, ebx			;Y = T2 - Y

@ret:
	invoke	zero, offset tempInt1
	invoke	zero, offset tempInt2
	invoke	zero, offset tempInt3
	popad
	ret	8

@return0:
					;A=P: X2 = esi, Y2 = edx, Z2 = ecx
					;B=Q: X  = edi, Y  = ebx, Z  = ebp
	invoke	zero, ebp
	jmp	@ret
@returnA:
	invoke	copy, esi, edi
	invoke	copy, edx, ebx
	invoke	copy, ecx, ebp

	jmp	@ret

ECP_Add_J	endp



ECP_Add		proc	ptrA:DWORD, ptrB:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]
	mov	edi, dword ptr [esp+20h+4+4]

	assume	esi: ptr ECPOINT
	assume	edi: ptr ECPOINT

	mov	eax, [esi].INFINITY
	test	eax, eax
	jz	@returnB

	mov	eax, [edi].INFINITY
	test	eax, eax
	jz	@returnA

; zaden z punktow nie jest w nieskonczonosci

	lea	ebx, [esi].X
	lea	ebp, [edi].X
	lea	eax, [esi].Y
	lea	edx, [edi].Y

	invoke	compare, ebx, ebp
	jnz	@AisntminusB

	invoke	compare, eax, edx
	jz	@doubleA

; sprawdzmy czy A = -B

	;jesli x1 == x2 musimy sprawdzic czy y2 = -y1 (modulo prime), wiemy ze y2 != y1
	;wiec mozemy pominac sytuacje kiedy y2=y1=0

	invoke	submod, offset _P, eax, offset tempInt1	;-y1 mod p
	invoke	compare, edx, offset tempInt1			;cmp y2, -y1 mod p
	jz	@return0

@AisntminusB:

; dodajemy punkty :)

	invoke	submod, edx, eax, offset tempInt1		;Int1 = y2 - y1
	invoke	submod, ebp, ebx, offset tempInt2		;Int2 = x2 - x1
	invoke	invmod, offset tempInt2				;Int2 = (x2 - x1)^(-1)
	invoke	mulmod, offset tempInt1, offset tempInt2, offset tempInt3
								;Int3 = (y2 - y1)/(x2 - x1)
	invoke	mulmod, offset tempInt3, offset tempInt3, offset tempInt1
								;Int1 = [(y2 - y1)/(x2 - x1)]^2
	invoke	submod, offset tempInt1, ebx, offset tempInt1	;Int1 = [(y2 - y1)/(x2 - x1)]^2 - x1
	invoke	submod, offset tempInt1, ebp, offset tempInt1	;Int1 = [(y2 - y1)/(x2 - x1)]^2 - x1 - x2
								;x3 = Int1

	invoke	submod, ebx, offset tempInt1, offset tempInt2	;Int2 = x1 - x3
	invoke	mulmod, offset tempInt3, offset tempInt2, offset tempInt3
								;Int3 = [(y2 - y1)/(x2 - x1)]*(x3 - x1)
	invoke	submod, offset tempInt3, eax, offset tempInt2	;Int2 = [(y2 - y1)/(x2 - x1)]*(x3 - x1) - y1
								;y3 = Int2
	invoke	copy, offset tempInt1, ebp
	invoke	copy, offset tempInt2, edx

@returnB:
	invoke	zero, offset tempInt1
	invoke	zero, offset tempInt2
	invoke	zero, offset tempInt3

	popad
	ret	8

@doubleA:
	invoke	ECP_Dbl, esi, edi
	jmp	@returnB

@return0:
	and	[edi].INFINITY , 0
	jmp	@returnB

@returnA:
	invoke	ECP_Copy, esi, edi
	jmp	@returnB

ECP_Add		endp

ECP_A2J		proc	ptrA:DWORD, ptrB:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]	;ptrA
	mov	edi, dword ptr [esp+20h+8]	;ptrB

	assume	esi: ptr ECPOINT
	assume	edi: ptr ECPOINTJ

	lea	eax, [esi].X
	lea	edx, [esi].Y

	lea	ebp, [edi].Y
	lea	ecx, [edi].Z

	cmp	[esi].INFINITY, 0
	jz	@return0

	invoke	copy, eax, edi			;X2 = X1
	invoke	copy, edx, ebp			;Y2 = Y1

	invoke	zero, ecx
	inc	dword ptr [ecx]			;Z2 = 1

@ret:	popad
	ret	8

@return0:
	invoke	zero, ecx
	jmp	@ret

ECP_A2J		endp

ECP_Copy	proc	ptrA:DWORD, ptrB:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]
	mov	edi, dword ptr [esp+20h+4+4]

	assume	esi: ptr ECPOINT
	assume	edi: ptr ECPOINT

	mov	eax, [esi].INFINITY
	mov	[edi].INFINITY, eax

	lea	ebx, [esi].X
	lea	ebp, [edi].X
	invoke	copy, ebx, ebp

	lea	ebx, [esi].Y
	lea	ebp, [edi].Y
	invoke	copy, ebx, ebp

	popad
	ret	8

ECP_Copy	endp

ECP_Dbl		proc	ptrA:DWORD, ptrB:DWORD
	pushad

	mov	esi, dword ptr [esp+20h+4]

	assume	esi: ptr ECPOINT
	assume	edi: ptr ECPOINT

	mov	eax, [esi].INFINITY
	test	eax, eax
	jz	@return0

	lea	ebx, [esi].X
	lea	ebp, [esi].Y

	invoke	comparezero, ebp
	jz	@return0

	invoke	mulmod, ebx, ebx, offset tempInt1		;Int1 = x1^2
	invoke	addmod, offset tempInt1, offset tempInt1, offset tempInt2
								;Int2 = 2*x1^2
	invoke	addmod, offset tempInt1, offset tempInt2, offset tempInt1
								;Int1 = 3*x1^2
	invoke	addmod, offset tempInt1, offset _A, offset tempInt1
								;Int1 = 3*x1^2 + a

	invoke	addmod, ebp, ebp, offset tempInt2		;Int2 = 2*y1
	invoke	invmod, offset tempInt2				;Int2 = (2*y1)^(-1)
	invoke	mulmod, offset tempInt1, offset tempInt2, offset tempInt1
								;Int1 = (3*x1^2 + a)/(2*y1)

	invoke	mulmod, offset tempInt1, offset tempInt1, offset tempInt2
								;Int2 = [(3*x1^2 + a)/(2*y1)]^2
	invoke	submod, offset tempInt2, ebx, offset tempInt2	;Int2 = [(3*x1^2 + a)/(2*y1)]^2 - x1
	invoke	submod, offset tempInt2, ebx, offset tempInt2	;Int2 = [(3*x1^2 + a)/(2*y1)]^2 - 2*x1
								;Int2 = x3

;-----
	invoke	submod, ebx, offset tempInt2, offset tempInt3	;Int3 = x1 - x3
	invoke	mulmod, offset tempInt1, offset tempInt3, offset tempInt3
								;Int3 = [(3*x1^2 + a)/(2*y1)](x1 - x3)
	invoke	submod, offset tempInt3, ebp, offset tempInt1	;Int1 = [(3*x1^2 + a)/(2*y1)](x1 - x3) - y1
								;Int1 = y3
;-----

	mov	edi, dword ptr [esp+20h+4+4]

	mov	[edi].INFINITY , 1
	lea	ebx, [edi].X
	lea	ebp, [edi].Y

	invoke	copy, offset tempInt2, ebx
	invoke	copy, offset tempInt1, ebp

	invoke	zero, offset tempInt1
	invoke	zero, offset tempInt2
	invoke	zero, offset tempInt3

@returnB:
	popad
	ret	8

@return0:
	mov	edi, dword ptr [esp+20h+4+4]
	and	[edi].INFINITY , 0
	jmp	@returnB

ECP_Dbl		endp

ECP_Dbl_J	proc	ptrA:DWORD, ptrB:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]
	mov	edi, dword ptr [esp+20h+8]

	assume	esi: ptr ECPOINTJ
	assume	edi: ptr ECPOINTJ

	lea	edx, [esi].Y
	lea	ecx, [esi].Z

	lea	ebx, [edi].Y
	lea	ebp, [edi].Z

	invoke	comparezero, ecx
	jz	@return0

	invoke	mulmod, ecx, ecx, offset tempInt1	;T1 = Z^2
	invoke	mulmod, edx, ecx, ebp			;Z_2 = Z*Y
	invoke	addmod, ebp, ebp, ebp			;Z = 2*Z

	invoke	adduintmod, offset _A, 3, offset tempInt2
	invoke	comparezero, offset tempInt2		;(_A == -3)

	jnz	@nm3

		invoke	submod, esi, offset tempInt1, offset tempInt2			;T2 = X - T1
		invoke	addmod, esi, offset tempInt1, offset tempInt1			;T1 = X + T1
		invoke	mulmod, offset tempInt1, offset tempInt2, offset tempInt2	;T2 = T1 * T2
		invoke	addmod, offset tempInt2, offset tempInt2, offset tempInt1	;T1 = 2*T2
		invoke	addmod, offset tempInt1, offset tempInt2, offset tempInt1	;T1 = T1 + T2
		jmp	@F

	@nm3:
		invoke	mulmod, offset tempInt1, offset tempInt1, offset tempInt1	;T1 = T1^2
		invoke	mulmod, offset _A, offset tempInt1, offset tempInt1		;T1 = A * T1
		invoke	mulmod, esi, esi, offset tempInt2				;T2 = X^2
		invoke	addmod, offset tempInt1, offset tempInt2, offset tempInt1	;T1 = T1 + T2
		invoke	addmod, offset tempInt2, offset tempInt2, offset tempInt2	;T2 = 2*T2
		invoke	addmod, offset tempInt1, offset tempInt2, offset tempInt1	;T1 = T1 + T2
@@:
	invoke	addmod, edx, edx, ebx			;Y_2 = 2*Y
	invoke	mulmod, ebx, ebx, ebx			;Y = Y^2
	invoke	mulmod, ebx, ebx, offset tempInt2	;T2 = Y^2
	invoke	mulmod, ebx, esi, ebx			;Y = Y*X

	invoke	div2mod, offset tempInt2		;T2 = T2/2
	invoke	mulmod, offset tempInt1, offset tempInt1, edi
							;X_2 = T1^2
	invoke	submod, edi, ebx, edi			;X = X - Y
	invoke	submod, edi, ebx, edi			;X = X - Y
	invoke	submod, ebx, edi, ebx			;Y = Y - X
	invoke	mulmod, ebx, offset tempInt1, ebx	;Y = Y * T1
	invoke	submod, ebx, offset tempInt2, ebx	;Y = Y - T2

	invoke	zero, offset tempInt1
	invoke	zero, offset tempInt2

@ret:	popad
	ret	8

@return0:
	invoke	zero, ebp
	jmp	@ret
ECP_Dbl_J	endp

ECP_J2A		proc	ptrA:DWORD, ptrB:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]	;ptrA
	mov	edi, dword ptr [esp+20h+8]	;ptrB

	assume	esi: ptr ECPOINTJ
	assume	edi: ptr ECPOINT

	lea	ebp, [esi].Y
	lea	ecx, [esi].Z

	lea	eax, [edi].X
	lea	edx, [edi].Y

	invoke	comparezero, ecx
	jz	@return0

	invoke	copy, ecx, offset tempInt1	;Z
	invoke	invmod, offset tempInt1		;T1 = 1/Z
	invoke	mulmod, offset tempInt1, offset tempInt1, offset tempInt2
						;T2 = (1/Z)^2
	invoke	mulmod, offset tempInt1, offset tempInt2, offset tempInt1
						;T1 = (1/Z)^3

	invoke	mulmod, ebp, offset tempInt1, edx
						;y = Y/(Z^3)
	invoke	mulmod, esi, offset tempInt2, eax
						;x = X/(Z^3)

	invoke	zero, offset tempInt1
	invoke	zero, offset tempInt2

	mov	[edi].INFINITY, 1

@ret:	popad
	ret	8

@return0:
	mov	[edi].INFINITY, 0
	jmp	@ret

ECP_J2A		endp

ECP_Mul		proc	ptrInt:DWORD, ptrA:DWORD, ptrB:DWORD

	pushad

	mov	ebp, dword ptr [esp+20h+4]	;ptrInt
	mov	esi, dword ptr [esp+20h+8]	;ptrA

	mov	edi, offset tempECMPnt1
	mov	ebx, offset tempECMInt

	invoke	copy, ebp, ebx			;n
	invoke	ECP_A2J, esi, edi		;edi = P (J)

	mov	esi, offset tempECMPnt2
	assume	esi: ptr ECPOINTJ

	lea	eax, [esi].Z
	invoke	zero, eax			;esi = Q (J) inf.

	invoke	comparezero, ebx
	jz	@done

@loop:
	invoke	div2, ebx
	jnc	@F

		invoke	ECP_Add_J, edi, esi
	@@:

	invoke	comparezero, ebx
	jz	@done
		
	invoke	ECP_Dbl_J, edi, edi
	jmp	@loop

@done:
	invoke	ECP_J2A, esi, dword ptr [esp+20h+12]

	invoke	ECP_Zero_J, esi
	invoke	ECP_Zero_J, edi

	popad
	ret	12

ECP_Mul		endp

ECP_Zero	proc	ptrA:DWORD

	pushad

	xor	eax, eax
	mov	ecx, (4+16+16)/4
	mov	edi, dword ptr [esp+20h+4]
	cld
	rep	stosd

	popad
	ret	4

ECP_Zero	endp
ECP_Zero_J	proc	ptrA:DWORD

	pushad

	xor	eax, eax
	mov	ecx, (16+16+16)/4
	mov	edi, dword ptr [esp+20h+4]
	cld
	rep	stosd

	popad
	ret	4

ECP_Zero_J	endp


set_P		proc
	invoke	setmod, offset _P
	ret
set_P		endp

set_N		proc
	invoke	setmod, offset _N
	ret
set_N		endp
