.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

;;
;;	arg1 = pointer to base10 string, zero terminated
;;	arg2 = bn
;;	converts ascii string to bn
;;
;_a_ 
bnFromStr proc uses ebx edi esi ptrStr:DWORD, bn:DWORD
	mov edi,bn
	mov esi,ptrStr
	invoke bnClear,edi
	.if word ptr [esi]=='0'
		ret
	.endif
	.if byte ptr [esi]=='-'
		inc esi
		mov byte ptr [edi].BN.bSigned,1
	.endif
	.while BYTE PTR [esi]=='0' ; call StrDel0 
		inc esi
	.endw
	.while 1;<>0
		movzx ebx,byte ptr [esi]
		.break .if !ebx
		sub ebx,'0'
		add esi,1
		invoke bnMulDw,edi,10
		invoke bnAddDw,edi,ebx
	.endw  
	ret
bnFromStr endp

end
