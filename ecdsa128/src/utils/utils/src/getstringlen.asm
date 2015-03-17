.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

.code
getstringlen	proc	ptrData:DWORD

	push	esi
	or	eax, -1
	mov	esi, dword ptr [esp+8]

@@:	inc	eax
	cmp	byte ptr [esi+eax], 0
	jnz	@B
	
	pop	esi
	ret	4

getstringlen	endp

end