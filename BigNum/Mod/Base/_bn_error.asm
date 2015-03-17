.686
.model flat,stdcall
option casemap:none
include windows.inc
include .\bnlib.inc
include .\bignum.inc

.code

; eax = errcode
_bn_error proc c
	invoke RaiseException,eax,0,0,0
;	invoke MessageBox,0,[bnErrMsgs+eax*4],0,MB_ICONERROR
	ret
_bn_error endp

end