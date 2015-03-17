.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

include	..\..\lib\gfp.inc
include	..\..\lib\ecp.inc

PUBLIC	KEY_PRVKEY

PUBLIC	intE
PUBLIC	intK
PUBLIC	signR
PUBLIC	signS
PUBLIC	intU1
PUBLIC	intU2
PUBLIC	msgDigest
PUBLIC	pointH
PUBLIC	pointI
PUBLIC	pointJ

.data?
intE		BIGINT<>
intK		BIGINT<>
intU1		BIGINT<>
intU2		BIGINT<>
signR		BIGINT<>
signS		BIGINT<>
		dd	?	;SPACE FOR base64 OVERFLOW!!

KEY_PRVKEY	BIGINT<>
		dd	?	;SPACE FOR base64 OVERFLOW!!

msgDigest	db	20 dup (?)

pointH		ECPOINT<>
pointJ		ECPOINT<>

pointI		ECPOINT<>
		dd	?	;SPACE FOR base64 OVERFLOW!!
	
end