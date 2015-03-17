

printbn PROTO bn:dword

.code



printbn proc bn:dword
LOCAL bnint[400h]:byte
	pushad
	invoke bnToHex,bn,addr bnint
	invoke Writeln,addr bnint
	popad
	ret
printbn endp