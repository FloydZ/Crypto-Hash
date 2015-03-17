.686
.model flat,stdcall
.mmx
.xmm

option casemap:none
assume fs:nothing

include windows.inc
include advapi32.inc
includelib advapi32.lib
include kernel32.inc
includelib kernel32.lib
include user32.inc
includelib user32.lib
include stdlib.inc; will be used only for console i/o
includelib stdlib.lib
include cryptohash.inc

;includelib cryptohash.lib

;TODO
;Random
;rsa
;dsa
;ecc
;cfb und co
;sha3 und finalisten
.data
	testCipher  db "aes",0
	testMode db "ECB",0
	testMode2 db "CFB",0
	
	
	plain db 'ASM RULES!!'

.data?
	;align 4
	slen dd ?
	;align 16
	testKey128 db 16 dup (?)
	testIV db 16 dup (?)
	inbuffer db 128 dup (?)
	outbuffer db 128 dup (?)
	
	outbuffer2 db 1024 dup (?)
	testvar1		dd		?

.code

Main proc
;ELGAMAL
	LOCAL EPRIV, G, GG, H , _N
	
	invoke bnInit,64
	bnCreateX EPRIV, G, GG, H , _N
	
	invoke ELGAMALKeyGen, 64, EPRIV, G, GG, H, _N
	invoke Getch
	ret
	
;;RSA TEST
;	LOCAL _p,q,n,pup,priv,_c,m
;	
;	invoke bnInit,4024
;	bnCreateX _p,q,n,priv,pup,_c,m
;
;    invoke RSAKeyGen, 4024, priv, pup, _p, q, n
;    
;    mov ecx,sizeof plain
;    mov esi,offset plain
;    mov edi,offset outbuffer2
;    rep movsb
;    invoke bnFromBytes,addr outbuffer2,sizeof plain,m,0
;    
;    invoke RSAEncode, priv, n, m, _c
;    
;    invoke Writeln,T(CRLF,"The bn from Secret Message...")
;	invoke printbn,m
;	
;    invoke Writeln,T(CRLF,"The Cyphered-bn...")
;	invoke printbn,_c
;	
;    invoke RSADecode, pup, n, _c, m
;    
;    invoke Writeln,T(CRLF,"The Decrypted bn...")
;	invoke printbn,m
;	
;    invoke bnToBytes,m,addr outbuffer
;	invoke Writeln,T(CRLF,"The Decrypted Secret Message...")
;	invoke Writeln,addr outbuffer
;	
;	invoke Getch
;	ret
	
	
;CIPHER TEST
	xor ecx, ecx
	mov edx, offset testKey128
	mov ebx, offset testIV
	mov eax, offset inbuffer
test1:
	cmp ecx, 128
	jz finish1
	mov [edx + ecx], ecx
	mov [ebx + ecx], ecx
	mov [eax + ecx], ecx
	inc ecx 
	jmp test1
finish1:		
	
	invoke Cipher, addr testCipher, 0, addr inbuffer, addr outbuffer, 128, addr testKey128, 16, addr testMode, addr testIV
	invoke Writelnf,T('Test AES MOD: %s'),addr testMode
	;invoke Writelnf,T('Test AES IV : %s'),addr testIV
	invoke HexEncode,addr testKey128,16,addr outbuffer2
	invoke Writelnf,T('Test AES KEY: %s'),addr outbuffer2
	invoke HexEncode,addr inbuffer,128,addr outbuffer2
	invoke Writelnf,T('Test AES IN : %s'),addr outbuffer2
	invoke HexEncode,addr outbuffer,128,addr outbuffer2
	invoke Writelnf,T('Test AES OUT: %s'),addr outbuffer2
	
	invoke Cipher, addr testCipher, 1, addr outbuffer, addr inbuffer, 128, addr testKey128, 16, addr testMode, addr testIV
	invoke Writelnf,T('Test AES MOD: %s'),addr testMode
	;invoke Writelnf,T('Test AES IV : %s'),addr testIV
	invoke HexEncode,addr testKey128,16,addr outbuffer2
	invoke Writelnf,T('Test AES KEY: %s'),addr outbuffer2
	invoke HexEncode,addr outbuffer,128,addr outbuffer2
	invoke Writelnf,T('Test AES IN : %s'),addr outbuffer2
	invoke HexEncode,addr inbuffer,128,addr outbuffer2
	invoke Writelnf,T('Test AES OUT: %s'),addr outbuffer2
	
	invoke Cipher, addr testCipher, 0, addr inbuffer, addr outbuffer, 128, addr testKey128, 16, addr testMode2, addr testIV
	invoke Writelnf,T('Test AES MOD: %s'),addr testMode2
	;invoke Writelnf,T('Test AES IV : %s'),addr testIV
	invoke HexEncode,addr testKey128,16,addr outbuffer2
	invoke Writelnf,T('Test AES KEY: %s'),addr outbuffer2
	invoke HexEncode,addr inbuffer,128,addr outbuffer2
	invoke Writelnf,T('Test AES IN : %s'),addr outbuffer2
	invoke HexEncode,addr outbuffer,128,addr outbuffer2
	invoke Writelnf,T('Test AES OUT: %s'),addr outbuffer2
	
	invoke Cipher, addr testCipher, 1, addr outbuffer, addr inbuffer, 128, addr testKey128, 16, addr testMode2, addr testIV
	invoke Writelnf,T('Test AES MOD: %s'),addr testMode2
	;invoke Writelnf,T('Test AES IV : %s'),addr testIV
	invoke HexEncode,addr testKey128,16,addr outbuffer2
	invoke Writelnf,T('Test AES KEY: %s'),addr outbuffer2
	invoke HexEncode,addr outbuffer,128,addr outbuffer2
	invoke Writelnf,T('Test AES IN : %s'),addr outbuffer2						
	invoke HexEncode,addr inbuffer,128,addr outbuffer2
	invoke Writelnf,T('Test AES OUT: %s'),addr outbuffer2
	
	invoke Cipher, addr testCipher, 0, addr inbuffer, addr outbuffer, 128, addr testKey128, 16, addr CBC, addr testIV
	invoke Writelnf,T('Test AES MOD: %s'),addr CBC
	;invoke Writelnf,T('Test AES IV : %s'),addr testIV
	invoke HexEncode,addr testKey128,16,addr outbuffer2
	invoke Writelnf,T('Test AES KEY: %s'),addr outbuffer2
	invoke HexEncode,addr inbuffer,128,addr outbuffer2
	invoke Writelnf,T('Test AES IN : %s'),addr outbuffer2
	invoke HexEncode,addr outbuffer,128,addr outbuffer2
	invoke Writelnf,T('Test AES OUT: %s'),addr outbuffer2
	
	invoke Cipher, addr testCipher, 1, addr outbuffer, addr inbuffer, 128, addr testKey128, 16, addr CBC, addr testIV
	invoke Writelnf,T('Test AES MOD: %s'),addr CBC
	;invoke Writelnf,T('Test AES IV : %s'),addr testIV
	invoke HexEncode,addr testKey128,16,addr outbuffer2
	invoke Writelnf,T('Test AES KEY: %s'),addr outbuffer2
	invoke HexEncode,addr outbuffer,128,addr outbuffer2
	invoke Writelnf,T('Test AES IN : %s'),addr outbuffer2						
	invoke HexEncode,addr inbuffer,128,addr outbuffer2
	invoke Writelnf,T('Test AES OUT: %s'),addr outbuffer2
	
	
	invoke Getch
	ret
	

	invoke Readln,T('Enter string to hash: '),offset inbuffer,sizeof inbuffer
	invoke StrLen,offset inbuffer
	mov slen,eax
	invoke Writelnf,T('hashing "%s" length: %u',13,10),offset inbuffer,slen
	invoke CRC16,offset inbuffer,slen,INIT_CRC16
	invoke Writelnf,T('CRC16:   %.4X'),eax
	invoke CRC32,offset inbuffer,slen,INIT_CRC32
	invoke Writelnf,T('CRC32:   %.8X'),eax
	invoke Adler32,offset inbuffer,slen,INIT_ADLER32
	invoke Writelnf,T('ADLER32: %.8X'),eax
	invoke MD2Init
	invoke MD2Update,offset inbuffer,slen
	invoke MD2Final
	invoke HexEncode,eax,MD2_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('MD2:     %s'),addr outbuffer
	invoke MD4Init
	invoke MD4Update,offset inbuffer,slen
	invoke MD4Final
	invoke HexEncode,eax,MD4_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('MD4:     %s'),addr outbuffer
	invoke MD5Init
	invoke MD5Update,offset inbuffer,slen
	invoke MD5Final
	invoke HexEncode,eax,MD5_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('MD5:     %s'),addr outbuffer
	invoke RMD128Init
	invoke RMD128Update,offset inbuffer,slen
	invoke RMD128Final
	invoke HexEncode,eax,RMD128_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('RMD128:  %s'),addr outbuffer
	invoke RMD160Init
	invoke RMD160Update,offset inbuffer,slen
	invoke RMD160Final
	invoke HexEncode,eax,RMD160_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('RMD160:  %s'),addr outbuffer
	invoke RMD256Init
	invoke RMD256Update,offset inbuffer,slen
	invoke RMD256Final
	invoke HexEncode,eax,RMD256_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('RMD256:  %s'),addr outbuffer
	invoke RMD320Init
	invoke RMD320Update,offset inbuffer,slen
	invoke RMD320Final
	invoke HexEncode,eax,RMD320_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('RMD320:  %s'),addr outbuffer	
	invoke SHA1Init
	invoke SHA1Update,offset inbuffer,slen
	invoke SHA1Final
	invoke HexEncode,eax,SHA1_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('SHA1:    %s'),addr outbuffer	
	invoke SHA256Init
	invoke SHA256Update,offset inbuffer,slen
	invoke SHA256Final
	invoke HexEncode,eax,SHA256_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('SHA256:  %s'),addr outbuffer		
	invoke SHA384Init
	invoke SHA384Update,offset inbuffer,slen
	invoke SHA384Final
	invoke HexEncode,eax,SHA384_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('SHA384:  %s'),addr outbuffer		
	invoke SHA512Init
	invoke SHA512Update,offset inbuffer,slen
	invoke SHA512Final
	invoke HexEncode,eax,SHA512_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('SHA512:  %s'),addr outbuffer		
	invoke TigerInit
	invoke TigerUpdate,offset inbuffer,slen
	invoke TigerFinal
	invoke HexEncode,eax,TIGER_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('Tiger:   %s'),addr outbuffer		
;	invoke WhirlpoolInit
;	invoke WhirlpoolUpdate,offset inbuffer,slen
;	invoke WhirlpoolFinal
;	invoke HexEncode,eax,WHIRLPOOL_DIGESTSIZE/8,addr outbuffer
;	invoke Writelnf,T('Whirlpool:  %s'),addr outbuffer		
	mov esi,128;digestsize
	.repeat
		mov edi,3;pass
		.repeat
			invoke HavalInit,esi,edi
			invoke HavalUpdate,offset inbuffer,slen
			invoke HavalFinal
			mov ecx,esi
			shr ecx,3
			invoke HexEncode,eax,ecx,addr outbuffer
			invoke Writelnf,T('Haval(%u,%u): %s'),esi,edi,addr outbuffer		
			inc edi
		.until edi > 5
		add esi,32
	.until esi > 256
		
	invoke DESSetKey, addr testKey128
	invoke DESEncrypt, addr inbuffer,addr outbuffer
	invoke HexEncode,addr outbuffer,8,addr outbuffer2
	invoke Writelnf,T('Input Encrypted with DES %s'),addr outbuffer
	invoke DESDecrypt, addr outbuffer,addr outbuffer2
	invoke Writelnf,T('Input Decrypted with DES %s'),addr outbuffer2
	
	invoke RijndaelInit, addr testKey128, 16
	invoke RijndaelEncrypt, addr inbuffer,addr outbuffer
	invoke HexEncode,addr outbuffer,16,addr outbuffer2
	invoke Writelnf,T('Input Encrypted with AES %s'),addr outbuffer2
	invoke RijndaelDecrypt, addr outbuffer,addr outbuffer2
	invoke Writelnf,T('Input Decrypted with AES %s'),addr outbuffer2
	
	invoke RC2Init, addr testKey128, 16
	invoke RC2Encrypt, addr inbuffer,addr outbuffer
	invoke HexEncode,addr outbuffer,16,addr outbuffer2
	invoke Writelnf,T('Input Encrypted with RC2 %s'),addr outbuffer2
	invoke RC2Decrypt, addr outbuffer,addr outbuffer2
	invoke Writelnf,T('Input Decrypted with RC2 %s'),addr outbuffer2
	
	invoke RC4Init, addr testKey128, 16
	invoke RC4Encrypt, addr inbuffer,addr outbuffer
	invoke HexEncode,addr outbuffer,16,addr outbuffer2
	invoke Writelnf,T('Input Encrypted with RC4 %s'),addr outbuffer2
	invoke RC4Decrypt, addr outbuffer,addr outbuffer2
	invoke Writelnf,T('Input Decrypted with RC4 %s'),addr outbuffer2
	
	
	invoke RC5Init, addr testKey128
	invoke RC5Encrypt, addr inbuffer,addr outbuffer
	invoke HexEncode,addr outbuffer,16,addr outbuffer2
	invoke Writelnf,T('Input Encrypted with RC5 %s'),addr outbuffer2
	invoke RC5Decrypt, addr outbuffer,addr outbuffer2
	invoke Writelnf,T('Input Decrypted with RC5 %s'),addr outbuffer2
	
;	invoke RC6Init, addr testKey128, 16
;	invoke RC6Encrypt, addr inbuffer,addr outbuffer
;	invoke Writelnf,T('Input Encrypted with RC6 %s'),addr outbuffer
;	;invoke RC6Decrypt, addr outbuffer,addr outbuffer2
;	;invoke Writelnf,T('Input Decrypted with RC6 %s'),addr outbuffer2
	
	
	invoke Getch
	ret
Main endp

start:
	invoke InitConsole
	invoke Main
	invoke ExitProcess,eax

end start
