.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

extern	rc4keytable:DWORD

.code

rc4_clear	proc

	pushad

	xor	eax, eax
	mov	ecx, 256/4
	mov	edi, offset rc4keytable
	cld
	rep	stosd

	popad
	ret

rc4_clear	endp

end