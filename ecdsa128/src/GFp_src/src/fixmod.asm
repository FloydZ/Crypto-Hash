.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

extern	__mod:DWORD

include	..\..\lib\gfp.inc

.code

fixmod		proc	ptrA:DWORD

	invoke	compare, dword ptr [esp+4+4], offset __mod
	jb	@F
	invoke	submod, dword ptr [esp+4+8], offset __mod, dword ptr [esp+4]
@@:	ret	4

fixmod		endp

end