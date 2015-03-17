RSAKeyGen PROTO keySize:DWORD, pKey:DWORD, pupKey:DWORD, p:DWORD, q:DWORD, n:DWORD
RSAEncode PROTO pKey:DWORD, _n:DWORD, _m:DWORD, _c:DWORD
RSADecode PROTO e:DWORD, n:DWORD, _c:DWORD, m:DWORD


.code
RSAKeyGen proc keySize:DWORD, e:DWORD, d:DWORD, p:DWORD, q:DWORD, n:DWORD
	LOCAL phi
	
	mov eax, keySize
	mov ecx, 2
	xor edx, edx
	div ecx
	
	invoke bnInit, eax
	
	invoke bnCreate
	mov p, eax
	
	invoke bnCreate
	mov q, eax
	
	invoke bnInit,keySize
	bnCreateX phi
	
	mov eax, keySize
	xor edx, edx
	mov ecx, 2
	div ecx
	invoke bnRsaGenPrime,p,eax

	mov eax, keySize
	xor edx, edx
	mov ecx, 2
	div ecx
	invoke bnRsaGenPrime,q,eax
	
	invoke bnMul,p,q,n
	
	invoke bnDec,p
	invoke bnDec,q
	invoke bnMul,p,q,phi

	invoke bnMovzx,e,10001h
	invoke bnModInv,e,phi,d
	
	;bnDestroyX
	ret
RSAKeyGen endp

RSAEncode proc d:DWORD, n:DWORD, m:DWORD, _c:DWORD
	invoke bnMontyModExp, m, d, n, _c
	ret
RSAEncode endp

RSADecode proc e:DWORD, n:DWORD, _c:DWORD, m:DWORD
	invoke bnMontyModExp,_c,e,n,m
	ret
RSADecode endp




;invoke Base64Encode, addr buffer2, keySize, addr buffer
;	
;	INVOKE  CreateFile,offset szFileName,GENERIC_WRITE,FILE_SHARE_READ,
;                NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL
;   
;	INVOKE  WriteFile, eax, offset buffer, keySize, offset buffer2, NULL