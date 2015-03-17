;;
;; INTERNAL INCLUDE FILE
;;

;; Init const
BN_SIZE_EXPAND equ 4; 1 extra bit (montgomery) 
BN_SIZE_HEAP equ 16 ; initial heap size 
BN_DEFAULT_BITS equ 1024
;BN_LOOP_UNROLL equ 8

;; Error Codes
BNERR_ALLOC equ 0C0000017h;STATUS_NO_MEMORY
BNERR_FREE equ 0C0000008h;STATUS_INVALID_HANDLE
BNERR_OVERFLOW equ 0C0000095h;STATUS_INTEGER_OVERFLOW
BNERR_DBZ equ 0C0000094h;STATUS_INTEGER_DIVIDE_BY_ZERO
BNERR_SQRTNEG equ -1

;; Vars
EXTERNDEF BN_HPROV:DWORD
EXTERNDEF BN_HHEAP:DWORD
EXTERNDEF BN_ALLOC_BYTES:DWORD; memory per bigy
EXTERNDEF BN_MAX_DWORD:DWORD; 32bit-PIECES of a Big
EXTERNDEF BN_PHASE1PRIMES:DWORD
EXTERNDEF BN_PHASE2PRIMES:DWORD
EXTERNDEF BN_FIRST13PRIMES:BYTE
BN_FIRST13PRIMES_SIZE equ 4; and not 13 HA HA!

;; Internal funcs
_bn_error PROTO c
_bn_cmp_array PROTO c
_bn_add_carry_dword PROTO c
_bn_normalize PROTO c
_bn_adddw_ignoresign PROTO c
_bn_subdw_ignoresign PROTO c
_bn_add_ignoresign PROTO c
_bn_sub_ignoresign PROTO c
_bn_muldw_basecase PROTO c
_bn_mul_basecase PROTO c
_bn_square_basecase PROTO c
_bn_dwrandomize PROTO c
_bn_dwrandom PROTO c

;; misc equates
pushad_size equ 8*4
pushad_eax  equ 7*4
pushad_ecx  equ 6*4
pushad_edx  equ 5*4
pushad_ebx  equ 4*4
pushad_esp  equ 3*4
pushad_ebp  equ 2*4
pushad_esi  equ 1*4
pushad_edi  equ 0*4

