.686p
.MMX
.model flat,stdcall
option casemap:none

include g:\masm32\include\windows.inc
include g:\masm32\include\user32.inc
include g:\masm32\include\kernel32.inc
include g:\masm32\include\oleaut32.inc
include g:\masm32\include\comctl32.inc
include g:\masm32\include\gdi32.inc
includelib g:\masm32\lib\user32.lib
includelib g:\masm32\lib\kernel32.lib
includelib g:\masm32\lib\oleaut32.lib
includelib g:\masm32\lib\comctl32.lib
includelib g:\masm32\lib\gdi32.lib

include		ecdsa.inc

DlgProc		PROTO :DWORD,:DWORD,:DWORD,:DWORD

.const
IDD_MAIN	equ	1000
IDC_KEYS	equ	1003
IDC_SIG		equ	1004
IDC_LOG		equ	1006
IDC_EXIT	equ	1007
IDC_START	equ	1008

.data?
szBuffer	db	80h dup (?)
_buffer		db	40h dup (?)
_zero		dd	?
_ThreadId	dd	?
_counter	dd	?
hThread		dd	?
_MSG_FINISH	dd	?
szPRV		db	20h dup (?)
szPUB		db	30h dup (?)
szSIG		db	30h dup (?)

.data
szFile		db	"ecdsa_state.bin",0
szFormat	db 	"%X%.10lu",0
szLog		db	"%s",13,10,"%s",13,10,"%s",0
msgTag		db	"WiteG",0

.code
start:
        invoke	GetModuleHandle, 0
	invoke	DialogBoxParamA, eax, IDD_MAIN, 0, offset DlgProc, 0
	ret

DlgProc	proc _hWnd:DWORD, wmsg:DWORD, _wparam:DWORD, _lparam:DWORD

	movzx 	eax, word ptr [wmsg]
	cmp	eax, WM_CLOSE
	jz	_wmclose
	cmp	eax, WM_COMMAND
	jz	_wmcommand
	cmp	eax, WM_LBUTTONDOWN
	jz	_lbuttondown
	xor	eax, eax
	ret


_lbuttondown:
	invoke	SendMessageA, _hWnd, WM_SYSCOMMAND, 61458, 0
	ret

_wmclose:
	cmp	hThread, 0
	jz	@F
		mov	_MSG_FINISH, 1
		invoke	CloseHandle, hThread
@@:
	invoke	EndDialog, _hWnd, 0
	ret

_wmcommand:
	cmp	word ptr [_wparam], IDC_START
	je	_run
	cmp	word ptr [_wparam], IDC_EXIT
	je	_wmclose
	ret

_run:
	xor	eax, eax
	mov	_MSG_FINISH, eax

	push	offset _ThreadId	; lpThreadId
	push	eax		; dwCreationFlags
	push	_hWnd		; lpParameter
	push	offset _thread	; lpStartAddress
	push	eax		; dwStackSize
	push	eax		; lpThreadAttributes
	call	CreateThread

	mov	hThread, eax

	push	0FFFFFFF1h	; nPriority
	push	_ThreadId	; hThread
	call	SetThreadPriority



	invoke	GetDlgItem, _hWnd, IDC_START
	invoke	EnableWindow, eax, 0

	ret
DlgProc		endp

_thread		proc	paramT:DWORD
	pushad

@mainLoop:
	cmp	_MSG_FINISH, 1
	jz	@done

	invoke	GetTickCount

	mov	ecx, eax
	ror	ecx, 7
	or	ecx, 30h
	and	ecx, 7Fh

	or	eax, 4
	and	eax, 7
	mov	ebx, eax

	mov	esi, eax
	mov	edi, ecx

@loop:
	invoke	ECDSA_Keygen, offset szPUB, offset szPRV

	mov	ecx, edi

@@:	invoke	ECDSA_Sign, offset szPRV, offset msgTag, 5, offset szSIG
	dec	eax
	jnz	@error

	invoke	ECDSA_Verify, offset szPUB, offset msgTag, 5, offset szSIG
	dec	eax
	jnz	@error

	loop	@B

	dec	ebx
	jnz	@loop


	push	0		; hTemplateFile
	push	80h		; dwFlagsAndAttributes
	push	OPEN_ALWAYS	; dwCreationDisposition
	push	0		; lpSecurityAttributes
	push	0		; dwShareMode
	push	(GENERIC_READ + GENERIC_WRITE)
	push	offset szFile
	call	CreateFileA

	mov	ebx, eax

	push	0		; dwMoveMethod
	push	0		; lpDistanceToMoveHigh
	push	0		; lDistanceToMove
	push	ebx		; hFile
	call	SetFilePointer

	mov	dword ptr [_buffer   ], 0
	mov	dword ptr [_buffer+ 4], 0
	mov	dword ptr [_buffer+ 8], 0
	mov	dword ptr [_buffer+12], 0

	and	_zero, 0

	push	0
	push	offset _zero	
	push	16
	push	offset _buffer
	push	ebx
	call	ReadFile

	add	dword ptr [_buffer   ], esi
	adc	dword ptr [_buffer+ 4], 0

	mov	eax, esi
	mul	edi

	add	dword ptr [_buffer+ 8], eax
	adc	dword ptr [_buffer+12], edx

	and	_zero, 0

	push	0		; dwMoveMethod
	push	0		; lpDistanceToMoveHigh
	push	0		; lDistanceToMove
	push	ebx		; hFile
	call	SetFilePointer

	push	0		; lpOverlapped
	push	offset _zero	; lpNumberOfBytesWritten
	push	16		; nNumberOfBytesToWrite
	push	offset _buffer	; lpBuffer
	push	ebx		; hFile
	call	WriteFile

	push	ebx		; hObject
	call	CloseHandle


	push	offset szBuffer
	push	offset _buffer
	call	printQword

	invoke	SendDlgItemMessageA, paramT, IDC_KEYS, WM_SETTEXT, 0, offset szBuffer

	push	offset szBuffer
	push	offset _buffer+8
	call	printQword

	invoke	SendDlgItemMessageA, paramT, IDC_SIG, WM_SETTEXT, 0, offset szBuffer

	jmp	@mainLoop

@error:

	push	offset szSIG
	push	offset szPUB
	push	offset szPRV
	push	offset szLog
	push	offset szBuffer
	call	wsprintfA
	add	esp, 5*4

	invoke	SendDlgItemMessageA, paramT, IDC_LOG, WM_SETTEXT, 0, offset szBuffer
@done:
	popad
	ret
_thread		endp

printQword	proc	ptrBig:DWORD, ptrOut:DWORD

	pushad
	mov	esi, ptrBig

	push	dword ptr [esi]
	push	dword ptr [esi+4]
	push	offset szFormat
	push	ptrOut
	call	wsprintfA
	add	esp, 4*4
	
	popad
	ret

printQword	endp

end start