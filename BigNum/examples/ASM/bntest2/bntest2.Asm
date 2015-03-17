.686
.model flat,stdcall
option casemap:none
assume fs:nothing
WIN32_LEAN_AND_MEAN EQU <>
include windows.inc
include asmlib.inc
includelib asmlib.lib
include ..\..\..\include\bignum.inc
includelib ..\..\..\lib\bignum.lib

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
	
	invoke bnFromHex,T('0B'),p
	invoke bnDivDw,p,10,q
	invoke bnMulDw,q,10
	invoke printbn,q
	invoke ConWriteln,0
	invoke bnSub,p,q
	invoke printbn,p
	invoke ConWriteln,0
	
	invoke bnFromHex,T('0B'),p
	invoke bnFromHex,T('CCCCCCCCCCCCCCCCCCCCCCCD'),q
	invoke bnMul,p,q,e
	invoke bnShr,e,96+3
	invoke bnMulDw,e,10
	invoke bnSub,p,e
	invoke printbn,p
	invoke ConWriteln,0
	
	
	invoke ConWriteln,T("generating p...")
	
	invoke bnRsaGenPrime,p,RSATestBits/2 
	invoke printbn,p
	invoke ConWriteln,T("generating q...")
	invoke bnRsaGenPrime,q,RSATestBits/2
	invoke printbn,q
	invoke ConWriteln,T("generating Public Modulus...")
	invoke bnMul,p,q,n
	invoke bnDec,p
	invoke bnDec,q
	invoke bnMul,p,q,phi
	invoke printbn,n
	invoke ConWriteln,T("Public Exponent=0x10001; generating Private Exponent...")
	invoke bnMovzx,e,10001h
	invoke bnModInv,e,phi,d
	invoke printbn,d
;
	mov ecx,sizeof plain
	mov esi,offset plain
	mov edi,offset plainbuff
	rep movsb
;
	invoke ConWriteln,T(CRLF,"The Secret Message...")
	invoke ConWriteln,addr plainbuff
	invoke bnFromBytes,addr plainbuff,sizeof plain,m,0 
	invoke ConWriteln,T(CRLF,"The bn from Secret Message...")
	invoke printbn,m
	invoke bnMontyModExp,m,d,n,ct
	invoke ConWriteln,T(CRLF,"The Cyphered-bn...")
	invoke printbn,ct
	invoke bnMontyModExp,ct,e,n,z
	invoke ConWriteln,T(CRLF,"The Decrypted bn...")
	invoke printbn,z
	invoke bnToBytes,z,addr plainbuff
	invoke ConWriteln,T(CRLF,"The Decrypted Secret Message...")
	invoke ConWriteln,addr plainbuff

	bnDestroyX
	invoke bnFinish
	popad
	ret
TestBN endp

printbn proc bn:dword
LOCAL bnint[400h]:byte
	pushad
	invoke bnToHex,bn,addr bnint
	invoke ConWriteln,addr bnint
	popad
	ret
printbn endp

start:
	invoke ConInit
	invoke SetConsoleTitle,T('BN Test 1')
	invoke TestBN
	invoke ConGetc
	invoke ExitProcess,eax
end start
