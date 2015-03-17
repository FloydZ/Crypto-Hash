.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

extern	_N:DWORD

include	..\..\lib\gfp.inc

.code
set_N		proc
	invoke	setmod, offset _N
	ret
set_N		endp

end