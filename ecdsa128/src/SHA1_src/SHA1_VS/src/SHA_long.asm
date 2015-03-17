; Very simple wrapper for SHA1LongMsg.txt

.686p
.mmx
.model flat,stdcall
option casemap:none

include g:\masm32\include\windows.inc
include g:\masm32\include\user32.inc
include g:\masm32\include\kernel32.inc
include g:\masm32\include\oleaut32.inc
include g:\masm32\include\comctl32.inc
include g:\masm32\include\advapi32.inc
includelib g:\masm32\lib\user32.lib
includelib g:\masm32\lib\kernel32.lib
includelib g:\masm32\lib\oleaut32.lib
includelib g:\masm32\lib\comctl32.lib
includelib g:\masm32\lib\advapi32.lib

include	..\lib\sha1.inc
include	..\lib\utils.inc

readLine	PROTO	:DWORD, :DWORD, :DWORD
printHash	PROTO	:DWORD
printLine	PROTO	:DWORD
compareHash	PROTO	:DWORD, :DWORD

.data?
_BUFFER			db	14000h dup (?)
_HASH			db	20 dup (?)
_LEN			dd	?

.data
szErrorFile		db	"Cannot read "
szSHALongMsgFile	db	"SHA1LongMsg.txt",0
szSHAError		db	"Invalid hash found !!",0
szSHAOk			db	"All hashes are valid.",0

.code
start:
	pushad

	invoke	CreateFile, offset szSHALongMsgFile, GENERIC_READ, FILE_SHARE_READ, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov	ebx, eax
	inc	eax
	jz	@errFile

		invoke	CreateFileMapping, ebx, 0, PAGE_READONLY, 0, 0, 0
		mov	esi, eax
                invoke	MapViewOfFile, esi, FILE_MAP_READ, 0, 0, 0
		mov	edi, eax

		xor	ecx, ecx
		xor	edx, edx

		@mainLoop:

			invoke	readLine, eax, offset _BUFFER, offset _LEN	;READ MSG
			invoke	sha1, offset _HASH, dword ptr [_LEN], offset _BUFFER
			invoke	printHash, offset _HASH

			invoke	readLine, eax, offset _BUFFER, offset _LEN	;READ HASH			
			invoke	compareHash, offset _HASH, offset _BUFFER
			jz	@F
				inc	ecx
			@@:

			inc	edx
			cmp	edx, 64
			jnz	@mainLoop

		mov	_LEN, ecx

		invoke	UnmapViewOfFile, edi
		invoke	CloseHandle, esi
		invoke	CloseHandle, ebx

		cmp	_LEN, 0
		jz	@all_ok

			invoke	printLine, offset szSHAError
			jmp	@return

		@all_ok:
			invoke	printLine, offset szSHAOk
			jmp	@return	

@errFile:
	invoke	printLine, offset szErrorFile
@return:
	popad
	ret

readLine	proc	ptrStart:DWORD, ptrOut:DWORD, ptrlenOut:DWORD

	pushad
	mov	esi, ptrStart
	mov	edi, ptrOut
	xor	ebx, ebx	;flag

@tryAgain:
	cmp	byte ptr [esi], "#"
	jz	@goEOL
	cmp	word ptr [esi], 0A0Dh
	jz	@goEOL
	cmp	byte ptr [esi], "["
	jz	@goEOL
	cmp	dword ptr [esi], " neL"
	jz	@goEOL
	cmp	dword ptr [esi], " gsM"
	jz	@readMsg
	cmp	dword ptr [esi], "= DM"
	jz	@readMd

@@:	inc	esi
@goEOL:	cmp	word ptr [esi], 0A0Dh
	jnz	@B
	add	esi, 2
	test	ebx, ebx
	jz	@tryAgain

@done:
	mov	eax, ptrlenOut
	mov	dword ptr [esp+28], esi
	mov	dword ptr [eax], ebx

	popad
	ret

@readMd:
	add	esi, 5
	jmp	@readMore

@readMsg:
	add	esi, 6
	;esi = ptr Msg
	;edi = ptrOut

@readMore:
	mov	al, byte ptr [esi]
	cmp	al, 39h
	jbe	@F
	sub	al, ("a" - 0Ah - 30h)
@@:	sub	al, 30h
	shl	al, 4

	mov	ah, byte ptr [esi+1]
	cmp	ah, 39h
	jbe	@F
	sub	ah, ("a" - 0Ah - 30h)
@@:	sub	ah, 30h

	or	al, ah
	mov	byte ptr [edi], al
	inc	edi
	add	esi, 2
	inc	ebx
	cmp	word ptr [esi], 0A0Dh
	jz	@goEOL

	jmp	@readMore

readLine	endp

compareHash	proc	ptrH1:DWORD, ptrH2:DWORD

	pushad
	mov	esi, ptrH1
	mov	eax, dword ptr [esi   ]
	mov	ebx, dword ptr [esi+ 4]
	mov	ecx, dword ptr [esi+ 8]
	mov	edx, dword ptr [esi+12]
	mov	edi, dword ptr [esi+16]
	mov	esi, ptrH2

	xor	eax, dword ptr [esi   ]
	xor	ebx, dword ptr [esi+ 4]
	xor	ecx, dword ptr [esi+ 8]
	xor	edx, dword ptr [esi+12]
	xor	edi, dword ptr [esi+16]
	or	eax, ebx
	or	ecx, edx
	or	eax, edi	
	or	eax, ecx

	popad
	ret

compareHash	endp

printHash	proc	ptrHash:DWORD

LOCAL	_Temp : DWORD
LOCAL	_String[44] : BYTE

	pushad

       	lea	esi, _Temp
	lea	edi, _String
	and	dword ptr [esi], 0

	push	20
	push	ptrHash
	push	edi
	call	ConvertHexToString

	mov	dword ptr [edi+40], 0A0Dh

	invoke	GetStdHandle, STD_OUTPUT_HANDLE
	mov	ebx, eax

	push	0
	push	esi
	push	(40+2)
	push	edi
	push	ebx
	call	WriteConsoleA

	popad
	ret

printHash	endp

printLine	proc	ptrString:DWORD

LOCAL	_Temp : DWORD
LOCAL	_EOL : DWORD

	pushad

       	lea	esi, _Temp
	lea	edi, _EOL

	and	dword ptr [esi], 0
	mov	dword ptr [edi], 0A0Dh

	invoke	GetStdHandle, STD_OUTPUT_HANDLE
	mov	ebx, eax

	invoke	getstringlen, ptrString

	push	0
	push	esi
	push	eax
	push	ptrString
	push	ebx
	call	WriteConsoleA

	and	dword ptr [esi], 0

	push	0
	push	esi
	push	2
	push	edi
	push	ebx
	call	WriteConsoleA

	popad
	ret
printLine	endp

ConvertHexToString	proc	ptrOut:DWORD, ptrIn:DWORD, lIn:DWORD
	pushad
	mov	esi, ptrIn
	mov	edi, ptrOut
	mov	ecx, lIn
	cld
@loop:	lodsb
	mov	ah, al
	and	ax, 0FF0h
	shr	al, 4
	cmp	al, 0Ah
	jb	@F
	add	al, 7
@@:	add	al, 30h
	stosb
	shr	ax, 8
	cmp	al, 0Ah
	jb	@F
	add	al, 7
@@:	add	al, 30h
	stosb
	loop	@loop
	xor	al, al
	stosb
	popad
	ret
ConvertHexToString	endp

end start