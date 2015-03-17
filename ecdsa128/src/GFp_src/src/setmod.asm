.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

extern	__mod:DWORD
extern	__c:DWORD

.code
setmod		proc	ptrM:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]
	mov	edi, offset __mod

	mov	eax, dword ptr [esi   ]
	mov	ebx, dword ptr [esi+ 4]
	mov	ecx, dword ptr [esi+ 8]
	mov	edx, dword ptr [esi+12]

	mov	dword ptr [edi   ], eax
	mov	dword ptr [edi+ 4], ebx
	mov	dword ptr [edi+ 8], ecx
	mov	dword ptr [edi+12], edx

	mov	edi, offset __c

	neg	eax
	not	ebx
	not	ecx
	not	edx

;ok, ok, whats going on ? ;)
;__c = 2^128 - __mod, where __mod is prime
;1) __mod is prime => lowest dword of __mod != 0
;2) 0 - lowest dword of __mod always set a CF
;3) neg(x) = not(x)+1 => not(x) = neg(x)-1
;4) 2^128 = 1*2^128 + 0*2^96 + 0*2^64 + 0*2^32 + 0
;5) __mod = 0*2^128 + d*2^96 + c*2^64 + b*2^32 + a
;6) 2^128-__mod = 1*2^128 + 0*2^96 + 0*2^64 + 0*2^32 + 0 - 0*2^128 + d*2^96 + c*2^64 + b*2^32 + a
;
;(0-a) = neg(a) and borrow 1 (B1)
;(0-b-B1)*2^32 = (0-b-1)*2^32 = [neg(b)-1]*2^32 = not(b)*2^32 and borrow 1
;(0-c-B1)*2^32 = (0-c-1)*2^32 = [neg(c)-1]*2^32 = not(c)*2^32 and borrow 1
;(0-d-B1)*2^32 = (0-d-1)*2^32 = [neg(d)-1]*2^32 = not(d)*2^32 and borrow 1
;(1-B1)*2^32 = (1-1)*2^32 = 0

	mov	dword ptr [edi   ], eax
	mov	dword ptr [edi+ 4], ebx
	mov	dword ptr [edi+ 8], ecx
	mov	dword ptr [edi+12], edx

	popad
	ret	4

setmod		endp

end