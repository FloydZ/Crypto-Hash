comment		*

Algorithm		: CAST-256	( Block Cipher )
Block		: 16bytes
KeySize		: 128/192/256 bits

Abstract		:  This is an independent implementation of the encryption algorithm:                                                                       
        		    CAST-256 by Carlisle Adams of Entrust Tecnhologies            
                                    which is a candidate algorithm in the Advanced Encryption Standard    
  		    programme of the US National Institute of Standards and Technology.                                                                          
		    Copyright in this implementation is held by Dr B R Gladman but I      
		    hereby give permission for its free direct or derivative use subject  
		    to acknowledgment of its origin and compliance with any conditions    
		    that the originators of the algorithm place on its exploitation.      
                                    Dr Brian Gladman (gladman@seven77.demon.co.uk) 14th January 1999
                                    
Usage		:  invoke cast256_setkey,addr ptrInkey,ptrInkey_length	( SetKey )

		   ex) invoke cast256_setkey,addr ptrInkey,16	( 128 bits )
		         invoke cast256_setkey,addr ptrInkey,24	( 192 bits )
		         invoke cast256_setkey,addr ptrInkey,32	( 256 bits )
		         
		   invoke cast256_encrypt,addr ptrIndata,addr ptrOutdata 	( 16 bytes Encrypt )
		   invoke cast256_decrypt,addr ptrIndata,addr ptrOutdata		( 16 bytes Decrypt )
		   
Coded by x3chun	(2004.03.01) 
		(  x3chun@korea.com  or  x3chun@hanyang.ac.kr ) ( http://x3chun.wo.to )
		
comment		*

f1		macro	y,x,kr,km

		mov	eax,km
		add	eax,x
		mov	ecx,kr
		rol	eax,cl		; t
		mov	ebx,eax		; t
		shr	ebx,(8*3)
		mov	ecx,[castsbox1+ebx*4]	; u
		mov	ebx,eax
		shr	ebx,(8*2)
		and	ebx,0FFh
		xor	ecx,[castsbox2+ebx*4]
		mov	ebx,eax
		shr	ebx,(8*1)
		and	ebx,0FFh
		sub	ecx,[castsbox3+ebx*4]
		mov	ebx,eax
		and	ebx,0FFh
		add	ecx,[castsbox4+ebx*4]
		xor	y,ecx
		
endm

f2		macro	y,x,kr,km

		mov	eax,km
		xor	eax,x
		mov	ecx,kr
		rol	eax,cl
		mov	ebx,eax		; t
		shr	ebx,(8*3)
		mov	ecx,[castsbox1+ebx*4]	; u
		mov	ebx,eax
		shr	ebx,(8*2)
		and	ebx,0FFh
		sub	ecx,[castsbox2+ebx*4]
		mov	ebx,eax
		shr	ebx,(8*1)
		and	ebx,0FFh
		add	ecx,[castsbox3+ebx*4]
		mov	ebx,eax
		and	ebx,0FFh
		xor	ecx,[castsbox4+ebx*4]
		xor	y,ecx
		
endm

f3		macro	y,x,kr,km

		mov	eax,km
		sub	eax,x
		mov	ecx,kr
		rol	eax,cl
		mov	ebx,eax		; t
		shr	ebx,(8*3)
		mov	ecx,[castsbox1+ebx*4]	; u
		mov	ebx,eax
		shr	ebx,(8*2)
		and	ebx,0FFh
		add	ecx,[castsbox2+ebx*4]
		mov	ebx,eax
		shr	ebx,(8*1)
		and	ebx,0FFh
		xor	ecx,[castsbox3+ebx*4]
		mov	ebx,eax
		and	ebx,0FFh
		sub	ecx,[castsbox4+ebx*4]
		xor	y,ecx
endm

k_rnd		macro	k,tr,tm

		f1	k[24],k[28],tr[0],tm[0]
		f2	k[20],k[24],tr[4],tm[4]
		f3	k[16],k[20],tr[8],tm[8]
		f1	k[12],k[16],tr[12],tm[12]
		f2	k[8],k[12],tr[16],tm[16]
		f3	k[4],k[8],tr[20],tm[20]
		f1	k[0],k[4],tr[24],tm[24]
		f2	k[28],k[0],tr[28],tm[28]
		
endm

f_rnd		macro	x,n

		f1	[edi+8],[edi+12],cast256_lkey[n*4],cast256_lkey[n*4+16]
		f2	[edi+4],[edi+8],cast256_lkey[n*4+4],cast256_lkey[n*4+20]
		f3	[edi+0],[edi+4],cast256_lkey[n*4+8],cast256_lkey[n*4+24]
		f1	[edi+12],[edi+0],cast256_lkey[n*4+12],cast256_lkey[n*4+28]
endm

i_rnd		macro	x,n

		f1	[edi+12],[edi+0],cast256_lkey[n*4+12],cast256_lkey[n*4+28]
		f3	[edi+0],[edi+4],cast256_lkey[n*4+8],cast256_lkey[n*4+24]
		f2	[edi+4],[edi+8],cast256_lkey[n*4+4],cast256_lkey[n*4+20]
		f1	[edi+8],[edi+12],cast256_lkey[n*4],cast256_lkey[n*4+16]
		
endm

cast256_setkey	proto	:DWORD, :DWORD
cast256_encrypt	proto	:DWORD, :DWORD
cast256_decrypt	proto	:DWORD, :DWORD

.data

castsbox1	dd	    030fb40d4h, 09fa0ff0bh, 06beccd2fh, 03f258c7ah, 01e213f2fh, 09C004dd3h
		dd	    06003e540h, 0cf9fc949h, 0bfd4af27h, 088bbbdb5h, 0e2034090h, 098d09675h
		dd	    06e63a0e0h, 015c361d2h, 0c2e7661dh, 022d4ff8eh, 028683b6fh, 0c07fd059h
		dd	    0ff2379c8h, 0775f50e2h, 043c340d3h, 0df2f8656h, 0887ca41ah, 0a2d2bd2dh
		dd	    0a1c9e0d6h, 0346c4819h, 061b76d87h, 022540f2fh, 02abe32e1h, 0aa54166bh
		dd	    022568e3ah, 0a2d341d0h, 066db40c8h, 0a784392fh, 0004dff2fh, 02db9d2deh
		dd	    097943fach, 04a97c1d8h, 0527644b7h, 0b5f437a7h, 0b82cbaefh, 0d751d159h
		dd	    06ff7f0edh, 05a097a1fh, 0827b68d0h, 090ecf52eh, 022b0c054h, 0bc8e5935h
		dd	    04b6d2f7fh, 050bb64a2h, 0d2664910h, 0bee5812dh, 0b7332290h, 0e93b159fh
		dd	    0b48ee411h, 04bff345dh, 0fd45c240h, 0ad31973fh, 0c4f6d02eh, 055fc8165h
		dd	    0d5b1caadh, 0a1ac2daeh, 0a2d4b76dh, 0c19b0C50h, 0882240f2h, 00c6e4f38h
		dd	    0a4e4bfd7h, 04f5ba272h, 0564c1d2fh, 0c59c5319h, 0b949e354h, 0b04669feh
		dd	    0b1b6ab8ah, 0c71358ddh, 06385c545h, 0110f935dh, 057538ad5h, 06a390493h 
		dd	    0e63d37e0h, 02a54f6b3h, 03a787d5fh, 06276a0b5h, 019a6fcdfh, 07a42206ah 
		dd	    029f9d4d5h, 0f61b1891h, 0bb72275eh, 0aa508167h, 038901091h, 0c6b505ebh 
		dd	    084c7cb8ch, 02ad75a0fh, 0874a1427h, 0a2d1936bh, 02ad286afh, 0aa56d291h
		dd	    0d7894360h, 0425c750dh, 093b39e26h, 0187184c9h, 06c00b32dh, 073e2bb14h 
		dd	    0a0bebc3ch, 054623779h, 064459eabh, 03f328b82h, 07718cf82h, 059a2cea6h
		dd	    004ee002eh, 089fe78e6h, 03fab0950h, 0325ff6C2h, 081383f05h, 06963c5c8h
		dd	    076cb5ad6h, 0d49974c9h, 0ca180dcfh, 0380782d5h, 0c7fa5cf6h, 08ac31511h
		dd	    035e79e13h, 047da91d0h, 0f40f9086h, 0a7e2419eh, 031366241h, 0051ef495h 
		dd	    0aa573b04h, 04a805d8dh, 0548300d0h, 000322a3ch, 0bf64cddfh, 0ba57a68eh
		dd	    075c6372bh, 050afd341h, 0a7c13275h, 0915a0bf5h, 06b54bfabh, 02b0b1426h 
		dd	    0ab4cc9d7h, 0449ccd82h, 0f7fbf265h, 0ab85c5f3h, 01b55db94h, 0aad4e324h 
		dd	    0cfa4bd3fh, 02deaa3e2h, 09e204d02h, 0c8bd25ach, 0eadf55b3h, 0d5bd9e98h 
		dd	    0e31231b2h, 02ad5ad6ch, 0954329deh, 0adbe4528h, 0d8710f69h, 0aa51c90fh
		dd	    0aa786bf6h, 022513f1eh, 0aa51a79bh, 02ad344cch, 07b5a41f0h, 0d37cfbadh 
		dd	    01b069505h, 041ece491h, 0b4c332e6h, 0032268d4h, 0c9600acch, 0ce387e6dh 
		dd	    0bf6bb16ch, 06a70fb78h, 00d03d9c9h, 0d4df39deh, 0e01063dah, 04736f464h 
		dd	    05ad328d8h, 0b347cc96h, 075bb0fc3h, 098511bfbh, 04ffbcc35h, 0b58bcf6ah
		dd	    0e11f0abch, 0bfc5fe4ah, 0a70aec10h, 0ac39570ah, 03f04442fh, 06188b153h 
		dd	    0e0397a2eh, 05727cb79h, 09ceb418fh, 01cacd68dh, 02ad37c96h, 00175cb9dh 
		dd	    0c69dff09h, 0c75b65f0h, 0d9db40d8h, 0ec0e7779h, 04744ead4h, 0b11c3274h 
		dd	    0dd24cb9eh, 07e1c54bdh, 0f01144f9h, 0d2240eb1h, 09675b3fdh, 0a3ac3755h
		dd	    0d47c27afh, 051c85f4dh, 056907596h, 0a5bb15e6h, 0580304f0h, 0ca042cf1h 
		dd	    0011a37eah, 08dbfaadbh, 035ba3e4ah, 03526ffa0h, 0c37b4d09h, 0bc306ed9h
		dd	    098a52666h, 05648f725h, 0ff5e569dh, 00ced63d0h, 07c63b2cfh, 0700b45e1h 
		dd	    0d5ea50f1h, 085a92872h, 0af1fbda7h, 0d4234870h, 0a7870bf3h, 02d3b4d79h
		dd	    042e04198h, 00cd0ede7h, 026470db8h, 0f881814Ch, 0474d6ad7h, 07c0c5e5ch 
		dd	    0d1231959h, 0381b7298h, 0f5d2f4dbh, 0ab838653h, 06e2f1e23h, 083719c9eh
		dd	    0bd91e046h, 09a56456eh, 0dc39200ch, 020c8c571h, 0962bda1ch, 0e1e696ffh 
		dd	    0b141ab08h, 07cca89b9h, 01a69e783h, 002cc4843h, 0a2f7c579h, 0429ef47dh 
		dd	    0427b169ch, 05ac9f049h, 0dd8f0f00h, 05c8165bfh
		
castsbox2	dd	    01f201094h, 0ef0ba75bh, 069e3cf7eh, 0393f4380h, 0fe61cf7ah, 0eec5207ah
		dd	    055889c94h, 072fc0651h, 0ada7ef79h, 04e1d7235h, 0d55a63ceh, 0de0436bah
		dd	    099c430efh, 05f0c0794h, 018dcdb7dh, 0a1d6eff3h, 0a0b52f7bh, 059e83605h
		dd	    0ee15b094h, 0e9ffd909h, 0dc440086h, 0ef944459h, 0ba83ccb3h, 0e0c3cdfbh
		dd	    0d1da4181h, 03b092ab1h, 0f997f1c1h, 0a5e6cf7bh, 001420ddbh, 0e4e7ef5bh 
		dd	    025a1ff41h, 0e180f806h, 01fc41080h, 0179bee7ah, 0d37ac6a9h, 0fe5830a4h 
		dd	    098de8b7fh, 077e83f4eh, 079929269h, 024fa9f7bh, 0e113c85bh, 0acc40083h 
		dd	    0d7503525h, 0f7ea615fh, 062143154h, 00d554b63h, 05d681121h, 0c866c359h
		dd	    03d63cf73h, 0cee234c0h, 0d4d87e87h, 05c672b21h, 0071f6181h, 039f7627fh 
		dd	    0361e3084h, 0e4eb573bh, 0602f64a4h, 0d63acd9ch, 01bbc4635h, 09e81032dh 
		dd	    02701f50ch, 099847ab4h, 0a0e3df79h, 0ba6cf38ch, 010843094h, 02537a95eh 
		dd	    0f46f6ffeh, 0a1ff3b1fh, 0208cfb6ah, 08f458c74h, 0d9e0a227h, 04ec73a34h
		dd	    0fc884f69h, 03e4de8dfh, 0ef0e0088h, 03559648dh, 08a45388ch, 01d804366h 
		dd	    0721d9bfdh, 0a58684bbh, 0e8256333h, 0844e8212h, 0128d8098h, 0fed33fb4h 
		dd	    0ce280ae1h, 027e19ba5h, 0d5a6c252h, 0e49754bdh, 0c5d655ddh, 0eb667064h 
		dd	    077840b4dh, 0a1b6a801h, 084db26a9h, 0e0b56714h, 021f043b7h, 0e5d05860h
		dd	    054f03084h, 0066ff472h, 0a31aa153h, 0dadc4755h, 0b5625dbfh, 068561be6h 
		dd	    083ca6b94h, 02d6ed23bh, 0eccf01dbh, 0a6d3d0bah, 0b6803d5ch, 0af77a709h 
		dd	    033b4a34ch, 0397bc8d6h, 05ee22b95h, 05f0e5304h, 081ed6f61h, 020e74364h 
		dd	    0b45e1378h, 0de18639bh, 0881ca122h, 0b96726d1h, 08049a7e8h, 022b7da7bh
		dd	    05e552d25h, 05272d237h, 079d2951ch, 0c60d894ch, 0488cb402h, 01ba4fe5bh 
		dd	    0a4b09f6bh, 01ca815cfh, 0a20c3005h, 08871df63h, 0b9de2fcbh, 00cc6c9e9h 
		dd	    00beeff53h, 0e3214517h, 0b4542835h, 09f63293ch, 0ee41e729h, 06e1d2d7ch 
		dd	    050045286h, 01e6685f3h, 0f33401c6h, 030a22c95h, 031a70850h, 060930f13h
		dd	    073f98417h, 0a1269859h, 0ec645c44h, 052c877a9h, 0cdff33a6h, 0a02b1741h
		dd	    07cbad9a2h, 02180036fh, 050d99c08h, 0cb3f4861h, 0c26bd765h, 064a3f6abh 
		dd	    080342676h, 025a75e7bh, 0e4e6d1fch, 020c710e6h, 0cdf0b680h, 017844d3bh 
		dd	    031eef84dh, 07e0824e4h, 02ccb49ebh, 0846a3baeh, 08ff77888h, 0ee5d60f6h
		dd	    07af75673h, 02fdd5cdbh, 0a11631c1h, 030f66f43h, 0b3faec54h, 0157fd7fah 
		dd	    0ef8579cch, 0d152de58h, 0db2ffd5eh, 08f32ce19h, 0306af97ah, 002f03ef8h 
		dd	    099319ad5h, 0c242fa0fh, 0a7e3ebb0h, 0c68e4906h, 0b8da230ch, 080823028h 
		dd	    0dcdef3c8h, 0d35fb171h, 0088a1bc8h, 0bec0c560h, 061a3c9e8h, 0bca8f54dh
		dd	    0c72feffah, 022822e99h, 082c570b4h, 0d8d94e89h, 08b1c34bch, 0301e16e6h
		dd	    0273be979h, 0b0ffeaa6h, 061d9b8c6h, 000b24869h, 0b7ffce3fh, 008dc283bh 
		dd	    043daf65ah, 0f7e19798h, 07619b72fh, 08f1c9ba4h, 0dc8637a0h, 016a7d3b1h 
		dd	    09fc393b7h, 0a7136eebh, 0c6bcc63eh, 01a513742h, 0ef6828bch, 0520365d6h
		dd	    02d6a77abh, 03527ed4bh, 0821fd216h, 0095c6e2eh, 0db92f2fbh, 05eea29cbh 
		dd	    0145892f5h, 091584f7fh, 05483697bh, 02667a8cch, 085196048h, 08c4baceah 
		dd	    0833860d4h, 00d23e0f9h, 06c387e8ah, 00ae6d249h, 0b284600ch, 0d835731dh 
		dd	    0dcb1c647h, 0ac4c56eah, 03ebd81b3h, 0230eabb0h, 06438bc87h, 0f0b5b1fah
		dd	    08f5ea2b3h, 0fc184642h, 00a036b7ah, 04fb089bdh, 0649da589h, 0a345415eh 
		dd	    05c038323h, 03e5d3bb9h, 043d79572h, 07e6dd07ch, 006dfdf1eh, 06c6cc4efh 
		dd	    07160a539h, 073bfbe70h, 083877605h, 04523ecf1h
		
castsbox3	dd	    08defc240h, 025fa5d9fh, 0eb903dbfh, 0e810c907h, 047607fffh, 0369fe44bh
		dd	    08c1fc644h, 0aececa90h, 0beb1f9bfh, 0eefbcaeah, 0e8cf1950h, 051df07aeh 
		dd	    0920e8806h, 0f0ad0548h, 0e13c8d83h, 0927010d5h, 011107d9fh, 007647db9h
		dd	    0b2e3e4d4h, 03d4f285eh, 0b9afa820h, 0fade82e0h, 0a067268bh, 08272792eh
		dd	    0553fb2c0h, 0489ae22bh, 0d4ef9794h, 0125e3fbch, 021fffceeh, 0825b1bfdh
		dd	    09255c5edh, 01257a240h, 04e1a8302h, 0bae07fffh, 0528246e7h, 08e57140eh
		dd	    03373f7bfh, 08c9f8188h, 0a6fc4ee8h, 0c982b5a5h, 0a8c01db7h, 0579fc264h
		dd	    067094f31h, 0f2bd3f5fh, 040fff7c1h, 01fb78dfch, 08e6bd2c1h, 0437be59bh
		dd	    099b03dbfh, 0b5dbc64bh, 0638dc0e6h, 055819d99h, 0a197c81ch, 04a012d6eh
		dd	    0c5884a28h, 0ccc36f71h, 0b843c213h, 06c0743f1h, 08309893ch, 00feddd5fh
		dd	    02f7fe850h, 0d7c07f7eh, 002507fbfh, 05afb9a04h, 0a747d2d0h, 01651192eh 
		dd	    0af70bf3eh, 058c31380h, 05f98302eh, 0727cc3c4h, 00a0fb402h, 00f7fef82h
		dd	    08c96fdadh, 05d2c2aaeh, 08ee99a49h, 050da88b8h, 08427f4a0h, 01eac5790h
		dd	    0796fb449h, 08252dc15h, 0efbd7d9bh, 0a672597dh, 0ada840d8h, 045f54504h 
		dd	    0fa5d7403h, 0e83ec305h, 04f91751ah, 0925669c2h, 023efe941h, 0a903f12eh 
		dd	    060270df2h, 00276e4b6h, 094fd6574h, 0927985b2h, 08276dbcbh, 002778176h
		dd	    0f8af918dh, 04e48f79eh, 08f616ddfh, 0e29d840eh, 0842f7d83h, 0340ce5c8h 
		dd	    096bbb682h, 093b4b148h, 0ef303cabh, 0984faf28h, 0779faf9bh, 092dc560dh 
		dd	    0224d1e20h, 08437aa88h, 07d29dc96h, 02756d3dch, 08b907ceeh, 0b51fd240h 
		dd	    0e7c07ce3h, 0e566b4a1h, 0c3e9615eh, 03cf8209dh, 06094d1e3h, 0cd9ca341h
		dd	    05c76460eh, 000ea983bh, 0d4d67881h, 0fd47572ch, 0f76cedd9h, 0bda8229ch 
		dd	    0127dadaah, 0438a074eh, 01f97c090h, 0081bdb8ah, 093a07ebeh, 0b938ca15h
		dd	    097b03cffh, 03dc2c0f8h, 08d1ab2ech, 064380e51h, 068cc7bfbh, 0d90f2788h 
		dd	    012490181h, 05de5ffd4h, 0dd7ef86ah, 076a2e214h, 0b9a40368h, 0925d958fh
		dd	    04b39fffah, 0ba39aee9h, 0a4ffd30bh, 0faf7933bh, 06d498623h, 0193cbcfah 
		dd	    027627545h, 0825cf47ah, 061bd8ba0h, 0d11e42d1h, 0cead04f4h, 0127ea392h 
		dd	    010428db7h, 08272a972h, 09270c4a8h, 0127de50bh, 0285ba1c8h, 03c62f44fh 
		dd	    035c0eaa5h, 0e805d231h, 0428929fbh, 0b4fcdf82h, 04fb66a53h, 00e7dc15bh
		dd	    01f081fabh, 0108618aeh, 0fcfd086dh, 0f9ff2889h, 0694bcc11h, 0236a5caeh 
		dd	    012deca4dh, 02c3f8cc5h, 0d2d02dfeh, 0f8ef5896h, 0e4cf52dah, 095155b67h 
		dd	    0494a488ch, 0b9b6a80ch, 05c8f82bch, 089d36b45h, 03a609437h, 0ec00c9a9h 
		dd	    044715253h, 00a874b49h, 0d773bc40h, 07c34671ch, 002717ef6h, 04feb5536h
		dd	    0a2d02fffh, 0d2bf60c4h, 0d43f03c0h, 050b4ef6dh, 007478cd1h, 0006e1888h 
		dd	    0a2e53f55h, 0b9e6d4bch, 0a2048016h, 097573833h, 0d7207d67h, 0de0f8f3dh 
		dd	    072f87b33h, 0abcc4f33h, 07688c55dh, 07b00a6b0h, 0947b0001h, 0570075d2h 
		dd	    0f9bb88f8h, 08942019eh, 04264a5ffh, 0856302e0h, 072dbd92bh, 0ee971b69h
		dd	    06ea22fdeh, 05f08ae2bh, 0af7a616dh, 0e5c98767h, 0cf1febd2h, 061efc8c2h 
		dd	    0f1ac2571h, 0cc8239c2h, 067214cb8h, 0b1e583d1h, 0b7dc3e62h, 07f10bdceh 
		dd	    0f90a5c38h, 00ff0443dh, 0606e6dc6h, 060543a49h, 05727c148h, 02be98a1dh 
		dd	    08ab41738h, 020e1be24h, 0af96da0fh, 068458425h, 099833be5h, 0600d457dh
		dd	    0282f9350h, 08334b362h, 0d91d1120h, 02b6d8da0h, 0642b1e31h, 09c305a00h 
		dd	    052bce688h, 01b03588ah, 0f7baefd5h, 04142ed9ch, 0a4315c11h, 083323ec5h 
		dd	    0dfef4636h, 0a133c501h, 0e9d3531ch, 0ee353783h
		
castsbox4	dd	    09db30420h, 01fb6e9deh, 0a7be7befh, 0d273a298h, 04a4f7bdbh, 064ad8c57h
		dd	    085510443h, 0fa020ed1h, 07e287affh, 0e60fb663h, 0095f35a1h, 079ebf120h
		dd	    0fd059d43h, 06497b7b1h, 0f3641f63h, 0241e4adfh, 028147f5fh, 04fa2b8cdh 
		dd	    0c9430040h, 00cc32220h, 0fdd30b30h, 0c0a5374fh, 01d2d00d9h, 024147b15h
		dd	    0ee4d111ah, 00fca5167h, 071ff904ch, 02d195ffeh, 01a05645fh, 00c13fefeh 
		dd	    0081b08cah, 005170121h, 080530100h, 0e83e5efeh, 0ac9af4f8h, 07fe72701h 
		dd	    0d2b8ee5fh, 006df4261h, 0bb9e9b8ah, 07293ea25h, 0ce84ffdfh, 0f5718801h 
		dd	    03dd64b04h, 0a26f263bh, 07ed48400h, 0547eebe6h, 0446d4ca0h, 06cf3d6f5h
		dd	    02649abdfh, 0aea0c7f5h, 036338cc1h, 0503f7e93h, 0d3772061h, 011b638e1h 
		dd	    072500e03h, 0f80eb2bbh, 0abe0502eh, 0ec8d77deh, 057971e81h, 0e14f6746h
		dd	    0c9335400h, 06920318fh, 0081dbb99h, 0ffc304a5h, 04d351805h, 07f3d5ce3h 
		dd	    0a6c866c6h, 05d5bcca9h, 0daec6feah, 09f926f91h, 09f46222fh, 03991467dh
		dd	    0a5bf6d8eh, 01143c44fh, 043958302h, 0d0214eebh, 0022083b8h, 03fb6180ch
		dd	    018f8931eh, 0281658e6h, 026486e3eh, 08bd78a70h, 07477e4c1h, 0b506e07ch
		dd	    0f32d0a25h, 079098b02h, 0e4eabb81h, 028123b23h, 069dead38h, 01574ca16h 
		dd	    0df871b62h, 0211c40b7h, 0a51a9ef9h, 00014377bh, 0041e8ac8h, 009114003h
		dd	    0bd59e4d2h, 0e3d156d5h, 04fe876d5h, 02f91a340h, 0557be8deh, 000eae4a7h
		dd	    00ce5c2ech, 04db4bba6h, 0e756bdffh, 0dd3369ach, 0ec17b035h, 006572327h 
		dd	    099afc8b0h, 056c8c391h, 06b65811ch, 05e146119h, 06e85cb75h, 0be07c002h 
		dd	    0c2325577h, 0893ff4ech, 05bbfc92dh, 0d0ec3b25h, 0b7801ab7h, 08d6d3b24h
		dd	    020c763efh, 0c366a5fch, 09c382880h, 00ace3205h, 0aac9548ah, 0eca1d7c7h 
		dd	    0041afa32h, 01d16625ah, 06701902ch, 09b757a54h, 031d477f7h, 09126b031h 
		dd	    036cc6fdbh, 0c70b8b46h, 0d9e66a48h, 056e55a79h, 0026a4cebh, 052437effh 
		dd	    02f8f76b4h, 00df980a5h, 08674cde3h, 0edda04ebh, 017a9be04h, 02c18f4dfh
		dd	    0b7747f9dh, 0ab2af7b4h, 0efc34d20h, 02e096b7ch, 01741a254h, 0e5b6a035h 
		dd	    0213d42f6h, 02c1c7c26h, 061c2f50fh, 06552daf9h, 0d2c231f8h, 025130f69h 
		dd	    0d8167fa2h, 00418f2c8h, 0001a96a6h, 00d1526abh, 063315c21h, 05e0a72ech 
		dd	    049bafefdh, 0187908d9h, 08d0dbd86h, 0311170a7h, 03e9b640ch, 0cc3e10d7h
		dd	    0d5cad3b6h, 00caec388h, 0f73001e1h, 06c728affh, 071eae2a1h, 01f9af36eh 
		dd	    0cfcbd12fh, 0c1de8417h, 0ac07be6bh, 0cb44a1d8h, 08b9b0f56h, 0013988c3h 
		dd	    0b1c52fcah, 0b4be31cdh, 0d8782806h, 012a3a4e2h, 06f7de532h, 058fd7eb6h
		dd	    0d01ee900h, 024adffc2h, 0f4990fc5h, 09711aac5h, 0001d7b95h, 082e5e7d2h
		dd	    0109873f6h, 000613096h, 0c32d9521h, 0ada121ffh, 029908415h, 07fbb977fh 
		dd	    0af9eb3dbh, 029c9ed2ah, 05ce2a465h, 0a730f32ch, 0d0aa3fe8h, 08a5cc091h 
		dd	    0d49e2ce7h, 00ce454a9h, 0d60acd86h, 0015f1919h, 077079103h, 0dea03af6h 
		dd	    078a8565eh, 0dee356dfh, 021f05cbeh, 08b75e387h, 0b3c50651h, 0b8a5c3efh
		dd	    0d8eeb6d2h, 0e523be77h, 0c2154529h, 02f69efdfh, 0afe67afbh, 0f470c4b2h
		dd	    0f3e0eb5bh, 0d6cc9876h, 039e4460ch, 01fda8538h, 01987832fh, 0ca007367h 
		dd	    0a99144f8h, 0296b299eh, 0492fc295h, 09266beabh, 0b5676e69h, 09bd3dddah
		dd	    0df7e052fh, 0db25701ch, 01b5e51eeh, 0f65324e6h, 06afce36ch, 00316cc04h
		dd	    08644213eh, 0b7dc59d0h, 07965291fh, 0ccd6fd43h, 041823979h, 0932bcdf6h
		dd	    0b657c34dh, 04edfd282h, 07ae5290ch, 03cb9536bh, 0851e20feh, 09833557eh
		dd	    013ecf0b0h, 0d3ffb372h, 03f85c5c1h, 00aef7ed2h

.data?

lk		dd	8	dup(?)
tm		dd	9	dup(?)
tr		dd	9	dup(?)
cast256_lkey	dd	96	dup(?)
_cm		dd	?
_cr		dd	?

.code

cast256_setkey	proc	ptrInkey:DWORD, ptrInkey_length:DWORD

		pushad
		mov	esi,[esp+28h]		; ptrInkey
		mov	ebp,[esp+2ch]		; ptrInkey_length
		shl	ebp,3
		shr	ebp,5
		xor	ecx,ecx
@_r1:
		mov	eax,[esi+ecx*4]
		bswap	eax
		mov	[lk+ecx*4],eax
		inc	ecx
		cmp	ecx,ebp
		jnz	@_r1
		lea	edi,[lk+ecx*4]
		mov	ecx,8
		sub	ecx,ebp
		xor	eax,eax
		rep	stosb
		xor	edi,edi
		mov	_cm,5a827999h
		mov	_cr,19
@_r4:		
		xor	ebp,ebp			; j
		mov	eax,_cm
		mov	ebx,_cr
		mov	[tm+ebp*4],eax
		mov	[tr+ebp*4],ebx
@_r2:
		mov	eax,[tm+ebp*4]
		add	eax,6ed9eba1h
		mov	_cm,eax
		mov	ebx,[tr+ebp*4]
		add	ebx,17
		mov	_cr,ebx
		inc	ebp
		mov	[tm+ebp*4],eax
		mov	[tr+ebp*4],ebx
		cmp	ebp,8
		jl	@_r2
		k_rnd	lk,tr,tm
		xor	ebp,ebp			; j
		mov	eax,_cm
		mov	ebx,_cr
		mov	[tm+ebp*4],eax
		mov	[tr+ebp*4],ebx
@_r3:
		mov	eax,[tm+ebp*4]
		add	eax,6ed9eba1h
		mov	_cm,eax
		mov	ebx,[tr+ebp*4]
		add	ebx,17
		mov	_cr,ebx
		inc	ebp
		mov	[tm+ebp*4],eax
		mov	[tr+ebp*4],ebx
		cmp	ebp,8
		jl	@_r3
		k_rnd	lk,tr,tm
		mov	eax,[lk]
		mov	ebx,[lk+8]
		mov	ecx,[lk+16]
		mov	edx,[lk+24]
		mov	[cast256_lkey+edi*4],eax
		mov	[cast256_lkey+edi*4+4],ebx
		mov	[cast256_lkey+edi*4+8],ecx
		mov	[cast256_lkey+edi*4+12],edx
		mov	eax,[lk+28]
		mov	ebx,[lk+20]
		mov	ecx,[lk+12]
		mov	edx,[lk+4]
		mov	[cast256_lkey+edi*4+16],eax
		mov	[cast256_lkey+edi*4+20],ebx
		mov	[cast256_lkey+edi*4+24],ecx
		mov	[cast256_lkey+edi*4+28],edx
		add	edi,8
		cmp	edi,96
		jl	@_r4
		popad
		ret
		
cast256_setkey	endp

cast256_encrypt	proc	ptrIndata:DWORD, ptrOutdata:DWORD

		pushad
		mov	esi,[esp+28h]		; ptrIndata
		mov	edi,[esp+2ch]		; ptrOutdata
		mov	eax,[esi]
		mov	ebx,[esi+4]
		mov	ecx,[esi+8]
		mov	edx,[esi+12]
		bswap	eax
		bswap	ebx
		bswap	ecx
		bswap	edx
		mov	[edi],eax
		mov	[edi+4],ebx
		mov	[edi+8],ecx
		mov	[edi+12],edx
		f_rnd	edi,0
		f_rnd	edi,8
		f_rnd	edi,16
		f_rnd	edi,24
		f_rnd	edi,32
		f_rnd	edi,40
		i_rnd	edi,48
		i_rnd	edi,56
		i_rnd	edi,64
		i_rnd	edi,72
		i_rnd	edi,80
		i_rnd	edi,88
		mov	eax,[edi]
		mov	ebx,[edi+4]
		mov	ecx,[edi+8]
		mov	edx,[edi+12]
		bswap	eax
		bswap	ebx
		bswap	ecx
		bswap	edx
		mov	[edi],eax
		mov	[edi+4],ebx
		mov	[edi+8],ecx
		mov	[edi+12],edx
		popad
		ret
		
cast256_encrypt	endp

cast256_decrypt	proc	ptrIndata:DWORD, ptrOutdata:DWORD

		pushad
		mov	esi,[esp+28h]		; ptrIndata
		mov	edi,[esp+2ch]		; ptrOutdata
		mov	eax,[esi]
		mov	ebx,[esi+4]
		mov	ecx,[esi+8]
		mov	edx,[esi+12]
		bswap	eax
		bswap	ebx
		bswap	ecx
		bswap	edx
		mov	[edi],eax
		mov	[edi+4],ebx
		mov	[edi+8],ecx
		mov	[edi+12],edx
		f_rnd	edi,88
		f_rnd	edi,80
		f_rnd	edi,72
		f_rnd	edi,64
		f_rnd	edi,56
		f_rnd	edi,48
		i_rnd	edi,40
		i_rnd	edi,32
		i_rnd	edi,24
		i_rnd	edi,16
		i_rnd	edi,8
		i_rnd	edi,0
		mov	eax,[edi]
		mov	ebx,[edi+4]
		mov	ecx,[edi+8]
		mov	edx,[edi+12]
		bswap	eax
		bswap	ebx
		bswap	ecx
		bswap	edx
		mov	[edi],eax
		mov	[edi+4],ebx
		mov	[edi+8],ecx
		mov	[edi+12],edx
		popad
		ret
		
cast256_decrypt	endp

