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

include	..\lib\rc4.inc
include	..\lib\utils.inc

printSeparator	PROTO
printSet	PROTO	:DWORD, :DWORD, :DWORD, :DWORD
printLine	PROTO	:DWORD
printBytes	PROTO	:DWORD, :DWORD

.data
szK1	db	05ah,0a5h,012h,034h,056h,099h,088h,077h

szK2	db	0c0h,0c1h,0c2h,0c3h,0c4h,0c5h,0c6h,0c7h
	db	0c8h,0c9h,0cah,0cbh,0cch,0cdh,0ceh,0cfh

szK3	db	05bh,07bh,0a0h,0d7h,09ah,0eeh,0c2h,02eh
	db	00dh,0d1h,0a9h,014h,0bdh,0b8h,042h,030h

szK4	db	001h,023h,045h,067h,089h,0abh,0cdh,0efh

szK5	db	001h,023h,045h,067h,089h,0abh,0cdh,0efh

szK6	db	000h,000h,000h,000h,000h,000h,000h,000h

szK7	db	0efh,001h,023h,045h

szK8	db	001h,023h,045h,067h,089h,0abh,0cdh,0efh

szK9	db	061h,08ah,063h,0d2h,0fbh

szK10	db	029h,004h,019h,072h,0fbh,042h,0bah,05fh
	db	0c7h,012h,077h,012h,0f1h,038h,029h,0c9h

szP1	db	008h,001h,002h,001h,000h,006h,025h,0a7h
	db	0c4h,036h,000h,002h,02dh,049h,097h,0b4h
	db	000h,006h,025h,0a7h,0c4h,036h,0e0h,000h
	db	0aah,0aah,003h,000h,000h,000h,088h,08eh
	db	001h,001h,000h,000h,000h,000h,000h,000h
	db	000h

szP2	db	008h,003h,012h,034h,0ffh,0ffh,0ffh,0ffh
	db	0ffh,0ffh,000h,040h,096h,045h,007h,0f1h
	db	008h,000h,046h,017h,062h,03eh,050h,067h
	db	0aah,0aah,003h,000h,000h,000h,008h,000h
	db	045h,000h,000h,04eh,066h,01ah,000h,000h
	db	080h,011h,0beh,064h,00ah,000h,001h,022h
	db	00ah,0ffh,0ffh,0ffh,000h,089h,000h,089h
	db	000h,03ah,000h,000h,080h,0a6h,001h,010h
	db	000h,001h,000h,000h,000h,000h,000h,000h
	db	020h,045h,043h,045h,04ah,045h,048h,045h
	db	043h,046h,043h,045h,050h,046h,045h,045h
	db	049h,045h,046h,046h,043h,043h,041h,043h
	db	041h,043h,041h,043h,041h,043h,041h,041h
	db	041h,000h,000h,020h,000h,001h

szP3	db	0aah,0aah,003h,000h,000h,000h,008h,000h
	db	045h,000h,000h,04eh,066h,01ah,000h,000h
	db	080h,011h,0beh,064h,00ah,000h,001h,022h
	db	00ah,0ffh,0ffh,0ffh,000h,089h,000h,089h
	db	000h,03ah,000h,000h,080h,0a6h,001h,010h
	db	000h,001h,000h,000h,000h,000h,000h,099h
	db	022h,05fh,04eh

szP4	db	001h,023h,045h,067h,089h,0abh,0cdh,0efh

szP5	db	000h,000h,000h,000h,000h,000h,000h,000h

szP6	db	000h,000h,000h,000h,000h,000h,000h,000h

szP7	db	000h,000h,000h,000h,000h,000h,000h,000h
	db	000h,000h

szP8	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h

	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h

	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h

	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h
	db	001h,001h,001h,001h,001h,001h,001h,001h

szP9	db	0dch,0eeh,04ch,0f9h,02ch

szP10	db	052h,075h,069h,073h,06ch,069h,06eh,06eh
	db	075h,06eh,020h,06ch,061h,075h,06ch,075h
	db	020h,06bh,06fh,072h,076h,069h,073h,073h
	db	073h,061h,06eh,069h,02ch,020h,074h,0e4h
	db	068h,06bh,0e4h,070h,0e4h,069h,064h,065h
	db	06eh,020h,070h,0e4h,0e4h,06ch,06ch,0e4h
	db	020h,074h,0e4h,079h,073h,069h,06bh,075h
	db	075h,02eh,020h,04bh,065h,073h,0e4h,079h
	db	0f6h,06eh,020h,06fh,06eh,020h,06fh,06eh
	db	06eh,069h,020h,06fh,06dh,061h,06eh,061h
	db	06eh,069h,02ch,020h,06bh,061h,073h,06bh
	db	069h,073h,061h,076h,075h,075h,06eh,020h
	db	06ch,061h,061h,06bh,073h,06fh,074h,020h
	db	076h,065h,072h,068h,06fh,075h,075h,02eh
	db	020h,045h,06eh,020h,06dh,061h,020h,069h
	db	06ch,06fh,069h,074h,073h,065h,02ch,020h
	db	073h,075h,072h,065h,020h,068h,075h,06fh
	db	06bh,061h,061h,02ch,020h,06dh,075h,074h
	db	074h,061h,020h,06dh,065h,074h,073h,0e4h
	db	06eh,020h,074h,075h,06dh,06dh,075h,075h
	db	073h,020h,06dh,075h,06ch,06ch,065h,020h
	db	074h,075h,06fh,06bh,061h,061h,02eh,020h
	db	050h,075h,075h,06eh,074h,06fh,020h,070h
	db	069h,06ch,076h,065h,06eh,02ch,020h,06dh
	db	069h,020h,068h,075h,06bh,06bh,075h,075h
	db	02ch,020h,073h,069h,069h,06eh,074h,06fh
	db	020h,076h,061h,072h,061h,06eh,020h,074h
	db	075h,075h,06ch,069h,073h,065h,06eh,02ch
	db	020h,06dh,069h,020h,06eh,075h,06bh,06bh
	db	075h,075h,02eh,020h,054h,075h,06fh,06bh
	db	073h,075h,074h,020h,076h,061h,06eh,061h
	db	06dh,06fh,06eh,020h,06ah,061h,020h,076h
	db	061h,072h,06ah,06fh,074h,020h,076h,065h
	db	065h,06eh,02ch,020h,06eh,069h,069h,073h
	db	074h,0e4h,020h,073h,079h,064h,0e4h,06dh
	db	065h,06eh,069h,020h,06ch,061h,075h,06ch
	db	075h,06eh,020h,074h,065h,065h,06eh,02eh
	db	020h,02dh,020h,045h,069h,06eh,06fh,020h
	db	04ch,065h,069h,06eh,06fh

szKey	db	"Key       :",0
szPT	db	"PlainText :",0
szCT	db	"CipherText:",0

.code
start:
	pushad

	invoke	printSet, offset szK1, 8, offset szP1, 41
	invoke	printSet, offset szK2, 16, offset szP2, 110
	invoke	printSet, offset szK3, 16, offset szP3, 51
	invoke	printSet, offset szK4, 8, offset szP4, 8
	invoke	printSet, offset szK5, 8, offset szP5, 8
	invoke	printSet, offset szK6, 8, offset szP6, 8
	invoke	printSet, offset szK7, 4, offset szP7, 10
	invoke	printSet, offset szK8, 8, offset szP8, 512
	invoke	printSet, offset szK9, 5, offset szP9, 5
	invoke	printSet, offset szK10, 16, offset szP10, 309
	popad
	ret

printSet	proc	ptrKey:DWORD, lenKey:DWORD, ptrData:DWORD, lenData:DWORD
	invoke	printLine, offset szKey
	invoke	printBytes, ptrKey, lenKey
	invoke	printLine, offset szPT
	invoke	printBytes, ptrData, lenData
	invoke	rc4_setkey, ptrKey, lenKey
	invoke	rc4_crypt, ptrData, lenData
	invoke	printLine, offset szCT
	invoke	printBytes, ptrData, lenData
	invoke	printSeparator
	ret
printSet	endp

printLine	proc	ptrString:DWORD

LOCAL	_Temp : DWORD

	pushad

       	lea	esi, _Temp

	and	dword ptr [esi], 0

	invoke	GetStdHandle, STD_OUTPUT_HANDLE
	mov	ebx, eax

	invoke	getstringlen, ptrString

	push	0
	push	esi
	push	eax
	push	ptrString
	push	ebx
	call	WriteConsoleA

	invoke	printSeparator

	popad
	ret

printLine	endp

printBytes	proc	ptrData:DWORD, lenData:DWORD

LOCAL	_Temp	: DWORD
LOCAL	_HStd	: DWORD
LOCAL	_Buffer[60]:BYTE

	pushad

	invoke	GetStdHandle, STD_OUTPUT_HANDLE
	mov	_HStd, eax

	mov	ebx, lenData
	test	ebx, ebx
	jz	@done

	mov	esi, ptrData
	cld

@nextLoop:
	lea	edi, _Buffer
	xor	edx, edx
	xor	ecx, ecx
@loop:	lodsb
	mov	ah, al
	and	ax, 0FF0h
	shr	al, 4
	cmp	al, 0Ah
	jb	@F
	add	al, 27h
@@:	add	al, 30h
	stosb
	shr	ax, 8
	cmp	al, 0Ah
	jb	@F
	add	al, 27h
@@:	add	al, 30h
	stosb
	mov	al, 20h
	stosb

	add	edx, 3
	dec	ebx
	jz	@show

	inc	ecx
	and	ecx, 0Fh
	jnz	@loop

	mov	eax, edx

	push	0
       	lea	edx, _Temp
	and	dword ptr [edx], 0
	push	edx
	push	eax
	lea	edx, _Buffer
	push	edx
	push	_HStd
	call	WriteConsoleA

	invoke	printSeparator
	jmp	@nextLoop

@show:
	mov	eax, edx

	push	0
       	lea	edx, _Temp
	and	dword ptr [edx], 0
	push	edx
	push	eax
	lea	edx, _Buffer
	push	edx
	push	_HStd
	call	WriteConsoleA

	invoke	printSeparator
@done:
	popad
	ret

printBytes	endp

printSeparator	proc

LOCAL	_Temp : DWORD
LOCAL	_EOL : DWORD

	pushad

       	lea	esi, _Temp
	lea	edi, _EOL

	and	dword ptr [esi], 0
	mov	dword ptr [edi], 0A0Dh

	invoke	GetStdHandle, STD_OUTPUT_HANDLE
	mov	ebx, eax

	push	0
	push	esi
	push	2
	push	edi
	push	ebx
	call	WriteConsoleA

	popad
	ret

printSeparator	endp

end start