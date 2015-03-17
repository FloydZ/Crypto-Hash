.686p
.mmx
.model flat,stdcall
option casemap:none

include g:\masm32\include\windows.inc
include g:\masm32\include\user32.inc
include g:\masm32\include\kernel32.inc
include g:\masm32\include\advapi32.inc
includelib g:\masm32\lib\user32.lib
includelib g:\masm32\lib\kernel32.lib
includelib g:\masm32\lib\oleaut32.lib
includelib g:\masm32\lib\comctl32.lib
includelib g:\masm32\lib\advapi32.lib

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

.code

DllEntry	proc hInstance:DWORD, reason:DWORD, reserved1:DWORD
	xor	eax, eax
	inc	eax
	ret	12
DllEntry	endp

end DllEntry