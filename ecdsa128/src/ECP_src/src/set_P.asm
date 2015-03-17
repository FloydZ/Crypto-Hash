.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

extern	_P:DWORD

include	..\..\lib\gfp.inc

.code
set_P		proc
	invoke	setmod, offset _P
	ret
set_P		endp

end