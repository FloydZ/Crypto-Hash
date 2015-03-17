.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

public BN_ALLOC_BYTES
public BN_MAX_DWORD
public BN_HPROV
public BN_HHEAP

.data

ALIGN DWORD
BN_ALLOC_BYTES	dd ((BN_DEFAULT_BITS/08)*BN_SIZE_EXPAND)+BN.dwArray
BN_MAX_DWORD	dd ((BN_DEFAULT_BITS/32)*BN_SIZE_EXPAND)
BN_HPROV		dd -1
BN_HHEAP		dd -1 ; separate heap

end
