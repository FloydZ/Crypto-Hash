.386
.model flat,stdcall
option casemap:none
assume fs:nothing

include windows.inc
include kernel32.inc
includelib kernel32.lib
include user32.inc
includelib user32.lib
include stdlib.inc; will be used only for console i/o
includelib stdlib.lib
include cryptohash.inc
includelib cryptohash.lib

.data?
	align 4
	slen dd ?
	align 16
	inbuffer db 400h dup (?)
	outbuffer db 400h dup (?)

.code
ConMain proc
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
	invoke HexEncoder,eax,MD2_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('MD2:     %s'),addr outbuffer
	invoke MD4Init
	invoke MD4Update,offset inbuffer,slen
	invoke MD4Final
	invoke HexEncoder,eax,MD4_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('MD4:     %s'),addr outbuffer
	invoke MD5Init
	invoke MD5Update,offset inbuffer,slen
	invoke MD5Final
	invoke HexEncoder,eax,MD5_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('MD5:     %s'),addr outbuffer
	invoke RMD128Init
	invoke RMD128Update,offset inbuffer,slen
	invoke RMD128Final
	invoke HexEncoder,eax,RMD128_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('RMD128:  %s'),addr outbuffer
	invoke RMD160Init
	invoke RMD160Update,offset inbuffer,slen
	invoke RMD160Final
	invoke HexEncoder,eax,RMD160_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('RMD160:  %s'),addr outbuffer
	invoke RMD256Init
	invoke RMD256Update,offset inbuffer,slen
	invoke RMD256Final
	invoke HexEncoder,eax,RMD256_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('RMD256:  %s'),addr outbuffer
	invoke RMD320Init
	invoke RMD320Update,offset inbuffer,slen
	invoke RMD320Final
	invoke HexEncoder,eax,RMD320_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('RMD320:  %s'),addr outbuffer	
	invoke SHA1Init
	invoke SHA1Update,offset inbuffer,slen
	invoke SHA1Final
	invoke HexEncoder,eax,SHA1_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('SHA1:    %s'),addr outbuffer	
	invoke SHA256Init
	invoke SHA256Update,offset inbuffer,slen
	invoke SHA256Final
	invoke HexEncoder,eax,SHA256_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('SHA256:  %s'),addr outbuffer		
	invoke SHA384Init
	invoke SHA384Update,offset inbuffer,slen
	invoke SHA384Final
	invoke HexEncoder,eax,SHA384_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('SHA384:  %s'),addr outbuffer		
	invoke SHA512Init
	invoke SHA512Update,offset inbuffer,slen
	invoke SHA512Final
	invoke HexEncoder,eax,SHA512_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('SHA512:  %s'),addr outbuffer		
	invoke TigerInit
	invoke TigerUpdate,offset inbuffer,slen
	invoke TigerFinal
	invoke HexEncoder,eax,TIGER_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('Tiger:   %s'),addr outbuffer		
	invoke WhirlpoolInit
	invoke WhirlpoolUpdate,offset inbuffer,slen
	invoke WhirlpoolFinal
	invoke HexEncoder,eax,WHIRLPOOL_DIGESTSIZE/8,addr outbuffer
	invoke Writelnf,T('Whirlpool:  %s'),addr outbuffer		
	mov esi,128;digestsize
	.repeat
		mov edi,3;pass
		.repeat
			invoke HavalInit,esi,edi
			invoke HavalUpdate,offset inbuffer,slen
			invoke HavalFinal
			mov ecx,esi
			shr ecx,3
			invoke HexEncoder,eax,ecx,addr outbuffer
			invoke Writelnf,T('Haval(%u,%u): %s'),esi,edi,addr outbuffer		
			inc edi
		.until edi > 5
		add esi,32
	.until esi > 256
	invoke Getch
	ret
ConMain endp

start:
	invoke InitConsole
	invoke ConMain
	invoke ExitProcess,eax
end start
