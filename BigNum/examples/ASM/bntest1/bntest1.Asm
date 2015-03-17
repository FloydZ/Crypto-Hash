.686
.model flat,stdcall
option casemap:none
assume fs:nothing
include windows.inc
include kernel32.inc
includelib kernel32.lib
include user32.inc
includelib user32.lib
include stdlib.inc
includelib stdlib.lib
include ..\..\..\bignum.inc
includelib ..\..\..\bignum.lib

printbn proto :dword

.data
align 4
plainbuff db 200h dup (?)
plain db 'ASM RULES!!'
db 0; so 0 doesn't get into sizeof

.code
TestBN proc
LOCAL p,q,n,e,d,phi,m,ct,z,x,y,a
	pushad
	RSATestBits equ 256  ;  > plain
	invoke bnInit,RSATestBits
	bnCreateX p,q,n,e,phi,d,m,ct,z
	
	invoke Writeln,T("generating p...")
	invoke bnRsaGenPrime,p,RSATestBits/2 
	invoke printbn,p
	invoke Writeln,T("generating q...")
	invoke bnRsaGenPrime,q,RSATestBits/2
	invoke printbn,q
	invoke Writeln,T("generating Public Modulus...")
	invoke bnMul,p,q,n
	invoke bnDec,p
	invoke bnDec,q
	invoke bnMul,p,q,phi
	invoke printbn,n
	invoke Writeln,T("Public Exponent=0x10001; generating Private Exponent...")
	invoke bnMovzx,e,10001h
	invoke bnModInv,e,phi,d
	invoke printbn,d
;	
	mov ecx,sizeof plain
	mov esi,offset plain
	mov edi,offset plainbuff
	rep movsb
;
	invoke Writeln,T(CRLF,"The Secret Message...")
	invoke Writeln,addr plainbuff
	invoke bnFromBytes,addr plainbuff,sizeof plain,m,0 
	invoke Writeln,T(CRLF,"The bn from Secret Message...")
	invoke printbn,m
	invoke bnMontyModExp,m,d,n,ct
	invoke Writeln,T(CRLF,"The Cyphered-bn...")
	invoke printbn,ct
	invoke bnMontyModExp,ct,e,n,z
	invoke Writeln,T(CRLF,"The Decrypted bn...")
	invoke printbn,z
	invoke bnToBytes,z,addr plainbuff
	invoke Writeln,T(CRLF,"The Decrypted Secret Message...")
	invoke Writeln,addr plainbuff

	bnDestroyX
	invoke bnFinish
	popad
	ret
TestBN endp

printbn proc bn:dword
LOCAL bnint[400h]:byte
	pushad
	invoke bnToHex,bn,addr bnint
	invoke Writeln,addr bnint
	popad
	ret
printbn endp

start:
	invoke InitConsole
	invoke SetConsoleTitle,T('BN Test 1')
	invoke TestBN
	invoke Getch
	invoke ExitProcess,eax
end start
