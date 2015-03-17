comment		*

Algorithm		: MARS	( Block Cipher )
Block		: 16 bytes
KeySize		: 128/192/256 bits

Abstract		: This is an independent implementation of the encryption algorithm
	                  MARS by a team at IBM
	                  which is a candidate algorithm in the Advanced Encryption Standard    
 		  programme of the US National Institute of Standards and Technology.   
 		  Copyright in this implementation is held by Dr B R Gladman. The MARS  
 		  algorithm is covered by a pending patent application owned by IBM,    
 		  who intend to offer a royalty free license under any issued patent    
 		  that results from such application if MARS is selected as the AES     
 		  algorithm.  In the interim, you may evaluate the MARS algorithm for   
 		  your personal, lawful, non-profit purposes as an end user.              
 		  The header above modified on June 6th 1999.                      
		   Dr Brian Gladman (gladman@seven77.demon.co.uk) 14th January 1999                  
		   
Usage		: invoke	mars_setkey,addr ptrInkey, ptrInkey_length	( SetKey )

		  ex) 	128 bits : invoke mars_setkey,addr ptrInkey, 16
		  	192 bits : invoke mars_setkey,addr ptrInkey, 24
		  	256 bits : invoke mars_setkey,addr ptrInkey, 32
		  	
		  invoke	mars_encrypt,addr ptrIndata,addr ptrOutdata	( 16 bytes Encrypt )             
		  invoke	mars_decrypt,addr ptrIndata,addr ptrOutdata	( 16 bytes Decrypt )          
		  
Coded by x3chun	( 2004.05.12 ) 
		( x3chun@korea.com  or  x3chun@hanyang.ac.kr )  ( http://x3chun.wo.to )

comment		*

f_mix		macro	a,b,c,d

		mov	ebp,a
		mov	edi,a
		ror	ebp,8		; r
		and	edi,255
		xor	b,[marssbox+edi*4]
		and	ebp,255
		add	b,[marssbox+ebp*4+256*4]
		mov	ebp,a
		ror	ebp,16		; r
		ror	a,24
		mov	edi,a
		and	ebp,255
		add	c,[marssbox+ebp*4]
		and	edi,255
		xor	d,[marssbox+edi*4+256*4]

endm

b_mix		macro	a,b,c,d

		mov	ebp,a
		mov	edi,a
		rol	ebp,8			; r
		and	edi,255
		xor	b,[marssbox+edi*4+256*4]
		and	ebp,255
		sub	c,[marssbox+ebp*4]
		mov	ebp,a
		rol	ebp,16			; r
		rol	a,24
		mov	edi,a
		and	ebp,255
		sub	d,[marssbox+ebp*4+256*4]
		and	edi,255
		xor	d,[marssbox+edi*4]
		
endm


f_ktr		macro	a,b,c,d,i

		mov	edi,a
		add	edi,[l_key+i*4]		; m
		rol	a,13
		mov	ebp,a
		imul	ebp,[l_key+i*4+4]		; r
		mov	_m,edi
		and	edi,511
		mov	esi,[marssbox+edi*4]	; l
		mov	_c,ecx
		rol	ebp,5			; r
		mov	ecx,ebp
		rol	_m,cl
		mov	ecx,_c
		add	c,_m
		xor	esi,ebp			; l
		rol	ebp,5			; r
		xor	esi,ebp			; l
		xor	d,ebp	
		mov	_c,ecx
		mov	ecx,ebp	
		rol	esi,cl
		mov	ecx,_c
		add	b,esi
		
endm

r_ktr		macro	a,b,c,d,i

		mov	edi,a
		imul	edi,[l_key+i*4+4]		; r
		ror	a,13			; a
		mov	ebp,a
		add	ebp,[l_key+i*4]		; m
		mov	_m,ebp			; m
		and	ebp,511
		mov	esi,[marssbox+ebp*4]	; l
		rol	edi,5			; r
		xor	esi,edi			; l
		mov	_c,ecx
		mov	ecx,edi
		rol	_m,cl
		mov	ecx,_c
		sub	c,_m
		rol	edi,5
		xor	esi,edi			; l
		xor	d,edi
		mov	_c,ecx
		mov	ecx,edi
		rol	esi,cl
		mov	ecx,_c
		sub	b,esi
		
endm

mars_setkey	proto	:DWORD, :DWORD
mars_encrypt	proto	:DWORD, :DWORD
mars_decrypt	proto	:DWORD, :DWORD
gen_mask	proto	:DWORD

.data

marssbox		dd	 009d0c479h, 028c8ffe0h, 084aa6c39h, 09dad7287h 
   		dd	 07dff9be3h, 0d4268361h, 0c96da1d4h, 07974cc93h 
   		dd	 085d0582eh, 02a4b5705h, 01ca16a62h, 0c3bd279dh 
  		dd	 00f1f25e5h, 05160372fh, 0c695c1fbh, 04d7ff1e4h 
   		dd	 0ae5f6bf4h, 00d72ee46h, 0ff23de8ah, 0b1cf8e83h 
 		dd	 0f14902e2h, 03e981e42h, 08bf53eb6h, 07f4bf8ach 
  		dd	 083631f83h, 025970205h, 076afe784h, 03a7931d4h 
   		dd	 04f846450h, 05c64c3f6h, 0210a5f18h, 0c6986a26h 
  		dd	 028f4e826h, 03a60a81ch, 0d340a664h, 07ea820c4h 
  		dd	 0526687c5h, 07eddd12bh, 032a11d1dh, 09c9ef086h 
   		dd	 080f6e831h, 0ab6f04adh, 056fb9b53h, 08b2e095ch 
  		dd	 0b68556aeh, 0d2250b0dh, 0294a7721h, 0e21fb253h 
   		dd	 0ae136749h, 0e82aae86h, 093365104h, 099404a66h 
   		dd	 078a784dch, 0b69ba84bh, 004046793h, 023db5c1eh 
   		dd	 046cae1d6h, 02fe28134h, 05a223942h, 01863cd5bh 
   		dd	 0c190c6e3h, 007dfb846h, 06eb88816h, 02d0dcc4ah 
   		dd	 0a4ccae59h, 03798670dh, 0cbfa9493h, 04f481d45h 
		dd	 0eafc8ca8h, 0db1129d6h, 0b0449e20h, 00f5407fbh 
		dd	 06167d9a8h, 0d1f45763h, 04daa96c3h, 03bec5958h 
		dd	 0ababa014h, 0b6ccd201h, 038d6279fh, 002682215h 
		dd	 08f376cd5h, 0092c237eh, 0bfc56593h, 032889d2ch
		dd	 0854b3e95h, 005bb9b43h, 07dcd5dcdh, 0a02e926ch 
		dd	 0fae527e5h, 036a1c330h, 03412e1aeh, 0f257f462h 
		dd	 03c4f1d71h, 030a2e809h, 068e5f551h, 09c61ba44h 
		dd	 05ded0ab8h, 075ce09c8h, 09654f93eh, 0698c0ccah 
		dd	 0243cb3e4h, 02b062b97h, 00f3b8d9eh, 000e050dfh 
		dd	 0fc5d6166h, 0e35f9288h, 0c079550dh, 00591aee8h 
		dd	 08e531e74h, 075fe3578h, 02f6d829ah, 0f60b21aeh 
		dd	 095e8eb8dh, 06699486bh, 0901d7d9bh, 0fd6d6e31h 
		dd	 01090acefh, 0e0670dd8h, 0dab2e692h, 0cd6d4365h 
		dd	 0e5393514h, 03af345f0h, 06241fc4dh, 0460da3a3h 
		dd	 07bcf3729h, 08bf1d1e0h, 014aac070h, 01587ed55h 
		dd	 03afd7d3eh, 0d2f29e01h, 029a9d1f6h, 0efb10c53h 
		dd	 0cf3b870fh, 0b414935ch, 0664465edh, 0024acac7h 
		dd	 059a744c1h, 01d2936a7h, 0dc580aa6h, 0cf574ca8h 
		dd	 0040a7a10h, 06cd81807h, 08a98be4ch, 0accea063h 
		dd	 0c33e92b5h, 0d1e0e03dh, 0b322517eh, 02092bd13h 
		dd	 0386b2c4ah, 052e8dd58h, 058656dfbh, 050820371h 
		dd	 041811896h, 0e337ef7eh, 0d39fb119h, 0c97f0df6h 
		dd	 068fea01bh, 0a150a6e5h, 055258962h, 0eb6ff41bh 
		dd	 0d7c9cd7ah, 0a619cd9eh, 0bcf09576h, 02672c073h 
		dd	 0f003fb3ch, 04ab7a50bh, 01484126ah, 0487ba9b1h 
		dd	 0a64fc9c6h, 0f6957d49h, 038b06a75h, 0dd805fcdh 
		dd	 063d094cfh, 0f51c999eh, 01aa4d343h, 0b8495294h 
		dd	 0ce9f8e99h, 0bffcd770h, 0c7c275cch, 0378453a7h 
		dd	 07b21be33h, 0397f41bdh, 04e94d131h, 092cc1f98h 
		dd	 05915ea51h, 099f861b7h, 0c9980a88h, 01d74fd5fh 
		dd	 0b0a495f8h, 0614deed0h, 0b5778eeah, 05941792dh 
		dd	 0fa90c1f8h, 033f824b4h, 0c4965372h, 03ff6d550h
		dd	 04ca5fec0h, 08630e964h, 05b3fbbd6h, 07da26a48h
		dd	 0b203231ah, 004297514h, 02d639306h, 02eb13149h 
		dd	 016a45272h, 0532459a0h, 08e5f4872h, 0f966c7d9h 
		dd	 007128dc0h, 00d44db62h, 0afc8d52dh, 006316131h 
		dd	 0d838e7ceh, 01bc41d00h, 03a2e8c0fh, 0ea83837eh
		dd	 0b984737dh, 013ba4891h, 0c4f8b949h, 0a6d6acb3h 
		dd	 0a215cdceh, 08359838bh, 06bd1aa31h, 0f579dd52h 
		dd	 021b93f93h, 0f5176781h, 0187dfddeh, 0e94aeb76h 
		dd	 02b38fd54h, 0431de1dah, 0ab394825h, 09ad3048fh
		dd	 0dfea32aah, 0659473e3h, 0623f7863h, 0f3346c59h 
		dd	 0ab3ab685h, 03346a90bh, 06b56443eh, 0c6de01f8h 
		dd	 08d421fc0h, 09b0ed10ch, 088f1a1e9h, 054c1f029h
		dd	 07dead57bh, 08d7ba426h, 04cf5178ah, 0551a7ccah 
		dd	 01a9a5f08h, 0fcd651b9h, 025605182h, 0e11fc6c3h 
		dd	 0b6fd9676h, 0337b3027h, 0b7c8eb14h, 09e5fd030h		
		dd	 06b57e354h, 0ad913cf7h, 07e16688dh, 058872a69h
		dd	 02c2fc7dfh, 0e389ccc6h, 030738df1h, 00824a734h 
		dd	 0e1797a8bh, 0a4a8d57bh, 05b5d193bh, 0c8a8309bh 
		dd	 073f9a978h, 073398d32h, 00f59573eh, 0e9df2b03h 
		dd	 0e8a5b6c8h, 0848d0704h, 098df93c2h, 0720a1dc3h 
		dd	 0684f259ah, 0943ba848h, 0a6370152h, 0863b5ea3h 
		dd	 0d17b978bh, 06d9b58efh, 00a700dd4h, 0a73d36bfh 
		dd	 08e6a0829h, 08695bc14h, 0e35b3447h, 0933ac568h 
		dd	 08894b022h, 02f511c27h, 0ddfbcc3ch, 0006662b6h
		dd	 0117c83feh, 04e12b414h, 0c2bca766h, 03a2fec10h 
		dd	 0f4562420h, 055792e2ah, 046f5d857h, 0ceda25ceh 
		dd	 0c3601d3bh, 06c00ab46h, 0efac9c28h, 0b3c35047h 
		dd	 0611dfee3h, 0257c3207h, 0fdd58482h, 03b14d84fh 
		dd	 023becb64h, 0a075f3a3h, 0088f8eadh, 007adf158h 
		dd	 07796943ch, 0facabf3dh, 0c09730cdh, 0f7679969h 
		dd	 0da44e9edh, 02c854c12h, 035935fa3h, 02f057d9fh 
		dd	 0690624f8h, 01cb0bafdh, 07b0dbdc6h, 0810f23bbh 
		dd	 0fa929a1ah, 06d969a17h, 06742979bh, 074ac7d05h 
		dd	 0010e65c4h, 086a3d963h, 0f907b5a0h, 0d0042bd3h 
		dd	 0158d7d03h, 0287a8255h, 0bba8366fh, 0096edc33h 
		dd	 021916a7bh, 077b56b86h, 0951622f9h, 0a6c5e650h 
		dd	 08cea17d1h, 0cd8c62bch, 0a3d63433h, 0358a68fdh 
		dd	 00f9b9d3ch, 0d6aa295bh, 0fe33384ah, 0c000738eh 
		dd	 0cd67eb2fh, 0e2eb6dc2h, 097338b02h, 006c9f246h 
		dd	 0419cf1adh, 02b83c045h, 03723f18ah, 0cb5b3089h 
		dd	 0160bead7h, 05d494656h, 035f8a74bh, 01e4e6c9eh 
		dd	 0000399bdh, 067466880h, 0b4174831h, 0acf423b2h 
		dd	 0ca815ab3h, 05a6395e7h, 0302a67c5h, 08bdb446bh 
		dd	 0108f8fa4h, 010223edah, 092b8b48bh, 07f38d0eeh
		dd	 0ab2701d4h, 00262d415h, 0af224a30h, 0b3d88abah 
		dd	 0f8b2c3afh, 0daf7ef70h, 0cc97d3b7h, 0e9614b6ch 
		dd	 02baebff4h, 070f687cfh, 0386c9156h, 0ce092ee5h 
		dd	 001e87da6h, 06ce91e6ah, 0bb7bcc84h, 0c7922c20h 
		dd	 09d3b71fdh, 0060e41c6h, 0d7590f15h, 04e03bb47h 
		dd	 0183c198eh, 063eeb240h, 02ddbf49ah, 06d5cba54h 
		dd	 0923750afh, 0f9e14236h, 07838162bh, 059726c72h 
		dd	 081b66760h, 0bb2926c1h, 048a0ce0dh, 0a6c0496dh 
		dd	 0ad43507bh, 0718d496ah, 09df057afh, 044b1bde6h 
		dd	 0054356dch, 0de7ced35h, 0d51a138bh, 062088cc9h 
		dd	 035830311h, 0c96efca2h, 0686f86ech, 08e77cb68h 
		dd	 063e1d6b8h, 0c80f9778h, 079c491fdh, 01b4c67f2h 
		dd	 072698d7dh, 05e368c31h, 0f7d95e2eh, 0a1d3493fh
		dd	 0dcd9433eh, 0896f1552h, 04bc4ca7ah, 0a6d1baf4h 
		dd	 0a5a96dcch, 00bef8b46h, 0a169fda7h, 074df40b7h 
		dd	 04e208804h, 09a756607h, 0038e87c8h, 020211e44h
		dd	 08b7ad4bfh, 0c6403f35h, 01848e36dh, 080bdb038h 
		dd	 01e62891ch, 0643d2107h, 0bf04d6f8h, 021092c8ch 
		dd	 0f644f389h, 00778404eh, 07b78adb8h, 0a2c52d53h 
		dd	 042157abeh, 0a2253e2eh, 07bf3f4aeh, 080f594f9h 
		dd	 0953194e7h, 077eb92edh, 0b3816930h, 0da8d9336h 
		dd	 0bf447469h, 0f26d9483h, 0ee6faed5h, 071371235h 
		dd	 0de425f73h, 0b4e59f43h, 07dbe2d4eh, 02d37b185h 
		dd	 049dc9a63h, 098c39d98h, 01301c9a2h, 0389b1bbfh
		dd	 00c18588dh, 0a421c1bah, 07aa3865ch, 071e08558h 
		dd	 03c5cfcaah, 07d239ca4h, 00297d9ddh, 0d7dc2830h 
		dd	 04b37802bh, 07428ab54h, 0aeee0347h, 04b3fbb85h 
		dd	 0692f2f08h, 0134e578eh, 036d9e0bfh, 0ae8b5fcfh 
		dd	 0edb93ecfh, 02b27248eh, 0170eb1efh, 07dc57fd6h 
		dd	 01e760f16h, 0b1136601h, 0864e1b9bh, 0d7ea7319h 
		dd	 03ab871bdh, 0cfa4d76fh, 0e31bd782h, 00dbeb469h 
		dd	 0abb96061h, 05370f85dh, 0ffb07e37h, 0da30d0fbh
		dd	 0ebc977b6h, 00b98b40fh, 03a4d0fe6h, 0df4fc26bh 
		dd	 0159cf22ah, 0c298d6e2h, 02b78ef6ah, 061a94ac0h 
		dd	 0ab561187h, 014eea0f0h, 0df0d4164h, 019af70eeh
    
vk		dd	09d0c479h, 028c8ffe0h, 084aa6c39h, 09dad7287h, 07dff9be3h, 0d4268361h, 0c96da1d4h
		dd	40	dup(?)
		
.data?

l_key		dd	40	dup(?)
_m		dd	?
_c		dd	?

.code

mars_setkey	proc	ptrInkey:DWORD, ptrInkey_length:DWORD

		pushad
		mov	ebp,ptrInkey_length
		shl	ebp,3			; ptrInkey_length*8
		shr	ebp,5
		mov	[vk+46*4],ebp		; key_len/32
		lea	ebp,[ebp-1]		; m
		xor	ebx,ebx			; j
		xor	ecx,ecx			; i
		mov	esi,[esp+28h]		; ptrInkey
@_r3:
		mov	eax,[vk+ecx*4]
		xor	eax,[vk+ecx*4+20]
		rol	eax,3
		xor	eax,[esi+ebx*4]
		xor	eax,ecx
		mov	[vk+ecx*4+28],eax
		cmp	ebx,ebp
		jnz	@_r1
		xor	ebx,ebx
		jmp	@_r2
@_r1:
		inc	ebx
@_r2:
		inc	ecx
		cmp	ecx,39
		jl	@_r3	
		xor	ebx,ebx			; j
@_r5:
		mov	ecx,1			; i
@_r4:
		mov	eax,[vk+ecx*4+28]
		mov	edx,[vk+ecx*4+24]
		and	edx,511
		mov	edx,[marssbox+edx*4]
		add	eax,edx
		rol	eax,9
		mov	[vk+ecx*4+28],eax
		inc	ecx
		cmp	ecx,40
		jl	@_r4
		mov	eax,[vk+7*4]
		mov	edx,[vk+46*4]
		and	edx,511
		mov	edx,[marssbox+edx*4]
		add 	eax,edx
		rol	eax,9
		mov	[vk+7*4],eax
		inc	ebx
		cmp	ebx,7
		jl	@_r5
		xor	ebx,ebx			; j
		xor	ecx,ecx			; i
@_r8:
		mov	eax,[vk+ecx*4+28]
		mov	[l_key+ebx*4],eax
		cmp	ebx,33
		jl	@_r6
		sub	ebx,33
		jmp	@_r7
@_r6:
		add	ebx,7
@_r7:
		inc	ecx
		cmp	ecx,40
		jl	@_r8
		
		mov	edi,5			; i
@_r10:
		mov	esi,[l_key+edi*4]
		or	esi,3
		invoke	gen_mask,esi
		test	eax,eax
		jz	@_r9
		mov	edx,eax			; m
		mov	ebx,[l_key+edi*4]
		and	ebx,3
		mov	eax,[marssbox+265*4+ebx*4]
		mov	ecx,[l_key+edi*4+12]
		and	ecx,31
		rol	eax,cl
		and	eax,edx
		xor	esi,eax
@_r9:
		mov	[l_key+edi*4],esi
		add	edi,2
		cmp	edi,37*2
		jl	@_r10	
		popad
		ret
		
mars_setkey	endp

gen_mask	proc	x:DWORD

		mov	ebx,esi
		shr	ebx,1
		not	eax
		mov	edx,eax			; ~x
		xor	eax,ebx
		and	eax,7FFFFFFFh		; m
		mov	ebx,eax
		mov	ecx,ebx
		shr	eax,1
		shr	ebx,2
		and	eax,ebx
		and	ecx,eax
		mov	eax,ecx
		mov	ebx,eax
		shr	eax,3
		shr	ebx,6
		and	eax,ebx
		and	eax,ecx			; m
		jnz	@_r1
		xor	eax,eax
		ret
@_r1:
		shl	eax,1
		mov	ebx,eax
		shl	eax,1
		or	ebx,eax
		mov	ecx,ebx
		shl	ebx,2
		or	ecx,ebx
		mov	eax,ecx
		shl	ecx,4
		or	eax,ecx
		mov	ebx,eax
		shl	eax,1
		and	eax,edx
		and	eax,80000000h
		or	eax,ebx
		and	eax,0fffffffch
		ret

gen_mask	endp

mars_encrypt	proc	ptrIndata:DWORD, ptrOutdata:DWORD

		pushad
		mov	esi,[esp+28h]		; ptrIndata
		mov	eax,[esi]
		mov	ebx,[esi+4]
		mov	ecx,[esi+8]
		mov	edx,[esi+12]
		add	eax,[l_key]
		add	ebx,[l_key+4]
		add	ecx,[l_key+8]
		add	edx,[l_key+12]	
		f_mix	eax,ebx,ecx,edx
		add	eax,edx
		f_mix	ebx,ecx,edx,eax
		add	ebx,ecx
		f_mix	ecx,edx,eax,ebx
		f_mix	edx,eax,ebx,ecx
		f_mix	eax,ebx,ecx,edx
		add	eax,edx
		f_mix	ebx,ecx,edx,eax
		add	ebx,ecx
		f_mix	ecx,edx,eax,ebx
		f_mix	edx,eax,ebx,ecx	
		f_ktr	eax,ebx,ecx,edx,4
		f_ktr 	ebx,ecx,edx,eax,6
		f_ktr 	ecx,edx,eax,ebx, 8
		f_ktr 	edx,eax,ebx,ecx,10   
		f_ktr 	eax,ebx,ecx,edx,12    
		f_ktr 	ebx,ecx,edx,eax,14    
		f_ktr 	ecx,edx,eax,ebx,16   
		f_ktr 	edx,eax,ebx,ecx,18    
		f_ktr 	eax,edx,ecx,ebx,20
		f_ktr 	ebx,eax,edx,ecx,22 
		f_ktr 	ecx,ebx,eax,edx,24   
		f_ktr 	edx,ecx,ebx,eax,26 
		f_ktr 	eax,edx,ecx,ebx,28    
		f_ktr 	ebx,eax,edx,ecx,30
		f_ktr 	ecx,ebx,eax,edx,32    
		f_ktr 	edx,ecx,ebx,eax,34   
		b_mix	eax,ebx,ecx,edx
		b_mix	ebx,ecx,edx,eax
		sub	ecx,ebx
		b_mix	ecx,edx,eax,ebx
		sub	edx,eax
		b_mix	edx,eax,ebx,ecx
		b_mix	eax,ebx,ecx,edx
		b_mix	ebx,ecx,edx,eax
		sub	ecx,ebx
		b_mix	ecx,edx,eax,ebx
		sub	edx,eax
		b_mix	edx,eax,ebx,ecx
		mov	edi,[esp+2ch]		; ptrOutdata
		sub	eax,[l_key+36*4]
		sub	ebx,[l_key+37*4]
		sub	ecx,[l_key+38*4]
		sub	edx,[l_key+39*4]
		mov	[edi],eax
		mov	[edi+4],ebx
		mov	[edi+8],ecx
		mov	[edi+12],edx
		popad
		ret
		
mars_encrypt	endp

mars_decrypt	proc	ptrIndata:DWORD, ptrOutdata:DWORD

		pushad
		mov	esi,[esp+28h]		; ptrIndata
		mov	eax,[esi+12]
		mov	ebx,[esi+8]
		mov	ecx,[esi+4]
		mov	edx,[esi]
		add	eax,[l_key+39*4]
		add	ebx,[l_key+38*4]
		add	ecx,[l_key+37*4]
		add	edx,[l_key+36*4]
		f_mix	eax,ebx,ecx,edx
		add	eax,edx
		f_mix	ebx,ecx,edx,eax
		add	ebx,ecx
		f_mix	ecx,edx,eax,ebx
		f_mix	edx,eax,ebx,ecx
		f_mix	eax,ebx,ecx,edx
		add	eax,edx
		f_mix	ebx,ecx,edx,eax
		add	ebx,ecx
		f_mix	ecx,edx,eax,ebx
		f_mix	edx,eax,ebx,ecx
		r_ktr	eax,ebx,ecx,edx,34
		r_ktr	ebx,ecx,edx,eax,32
		r_ktr	ecx,edx,eax,ebx,30
		r_ktr	edx,eax,ebx,ecx,28
		r_ktr	eax,ebx,ecx,edx,26
		r_ktr	ebx,ecx,edx,eax,24
		r_ktr	ecx,edx,eax,ebx,22
		r_ktr	edx,eax,ebx,ecx,20
		r_ktr	eax,edx,ecx,ebx,18
		r_ktr	ebx,eax,edx,ecx,16
		r_ktr	ecx,ebx,eax,edx,14
		r_ktr	edx,ecx,ebx,eax,12
		r_ktr	eax,edx,ecx,ebx,10
		r_ktr	ebx,eax,edx,ecx, 8
		r_ktr	ecx,ebx,eax,edx, 6
		r_ktr	edx,ecx,ebx,eax, 4
		b_mix	eax,ebx,ecx,edx
		b_mix	ebx,ecx,edx,eax
		sub	ecx,ebx
		b_mix	ecx,edx,eax,ebx
		sub	edx,eax
		b_mix	edx,eax,ebx,ecx
		b_mix	eax,ebx,ecx,edx
		b_mix	ebx,ecx,edx,eax
		sub	ecx,ebx
		b_mix	ecx,edx,eax,ebx
		sub	edx,eax
		b_mix	edx,eax,ebx,ecx
		mov	edi,[esp+2ch]		; ptrOutdata
		sub	eax,[l_key+3*4]
		sub	ebx,[l_key+2*4]
		sub	ecx,[l_key+1*4]
		sub	edx,[l_key]
		mov	[edi],edx
		mov	[edi+4],ecx
		mov	[edi+8],ebx
		mov	[edi+12],eax	
		popad
		ret
		
mars_decrypt	endp

