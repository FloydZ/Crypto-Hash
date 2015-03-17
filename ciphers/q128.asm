;comment		*
;
;Algorithm		: Q128	( Block Cipher )
;Block		: 16 bytes
;KeySize		: 128 bits ( 16 bytes ) 
;Round		: 16
;
;Abstract		: Q128:  A block cipher for 128-bit blocks and 128-bit keys. 
;
;		This cipher has been designed to efficiently process 128-bit blocks, 
;		especially on 32-bit processors.  Using the Watcom 32-bit compiler, 
;		this algorithm was measured to process a 128-bit block in 11 usec. 
;		on a 75 MHz Pentium.  The same compiler and the same processor 
;		executes 64-bit Blowfish in 5 usec, which should be doubled to 
;		account for the smaller block size. 
;		
;		The algorithm operates on four 32-bit blocks with 16 rounds.  Each 
;		round propagates 40 of the 128 bits to other blocks, so there is 
;		complete cascading in four rounds (almost three).  Each round uses 
;		four 32-bit words of expanded key in the mix.  The complementation 
;		symmetry of DES is not present.  The basic four word key is expanded 
;		to 64 words so that every bit in the basic key can affect every bit 
;		in the expanded key.  The time it takes to expand the basic key is 
;		approximately the same as the time to encrypt one data block, so key 
;		setup time is not exceptional. 
;		
;		The heart of the algorithm is the 1024 x 32-bit fixed random lookup 
;		table.  The design of this array was carried out using general 
;		principles of uniform distribution and using Blowfish as a pseudo 
;		random number generator.  This was done in an effort to present an 
;		algorithm with no secret design (such as secret S-boxes than might 
;		be suspected of hiding a back door).  The file FTAB.C that 
;		accompanies this release is actually the main program that generated 
;		the table.  Anyone with an correct version of Blowfish should be 
;		able to run this main program and generate the table used in Q128. 
;		The comments in the FTAB.C program indicate the design principles 
;		used.
;		
;Usage		:   invoke	q128_setkey,addr ptrInkey  ; Only 128bits (16 bytes ) ( SetKey )
;		    invoke	q128_encrypt,addr ptrIndata,addr ptrOutdata   ( 16bytes  Encrypt ) 
;		    invoke	q128_decrypt,addr ptrIndata,addr ptrOutdata   ( 16bytes  Decrypt ) 
;		    
;Coded by x3chun	(2004.05.12)
;		(  x3chun@korea.com  or  x3chun@hanyang.ac.kr ) ( http://x3chun.wo.to )
;		
;comment		*


.data

ftab	dd	 0d6d92632h,05e84404dh,04f341282h,071654b06h,0d48d6a0bh,0245becc4h
	dd	 0c8f84d80h,022c620c9h,066aa8b02h,00ac697ffh,08b755a36h,02577931ch
	dd	 0438d17b6h,0bb7b1bd1h,0e0a8f51eh,0f4fd583dh,0beceeb95h,07945c1aeh
	dd	 029ce9628h,03d7965cdh,080cfbdb9h,02f535a25h,07666a9bdh,06df2324bh
	dd	 098731a06h,0e4d32444h,0265faf55h,041895427h,0f2d2c55eh,08151930fh
	dd	 077a888a3h,09cba9a32h,0a7ec629ch,055dcf904h,0b35b9179h,01ab8e42eh
	dd	 0a0ef8027h,0db4c5cdeh,09fc2a9d3h,0a9512439h,09c08cb5ch,04bfd92b6h
	dd	 0c23eda7fh,0037833e1h,040177a91h,0bae53567h,0774ad665h,03cb744d3h
	dd	 06e8a01aah,065d2b8e3h,00507a12ah,0ef69c3cbh,0230801d7h,00bbae78fh
	dd	 062630b36h,0ed6d805ah,05aaf9ebfh,0721d78e7h,0d33cd9deh,06618da6ch
	dd	 09dc6ea42h,00d272b82h,03559ef65h,0dcfdef0bh,0865271b4h,03621dc84h
	dd	 0885d667fh,092e58251h,02e9d7b3bh,0e9165100h,099bd3b18h,0b1ed8386h
	dd	 084563225h,0446cabcbh,07e462315h,0a2bbcc1eh,03be4a9c0h,0320a0276h
	dd	 0416b0ae1h,0c6a755e3h,05c8003dch,036c38242h,097e2237bh,02ae6aa61h
	dd	 08a5925eeh,03b56f8aeh,026bdf193h,096ce5ca3h,0e51d055ah,0ad2af563h
	dd	 02b9ada11h,09f70f8bdh,03f9f789ah,089934761h,0a8cf0a8fh,0c78b2a3bh
	dd	 08f5e84c4h,0b8b1795eh,0afcce834h,0d9aa4189h,0c28c8b11h,07636a615h
	dd	 0f2609430h,0eca3a144h,07869be76h,012c8612eh,0d18acb21h,0cc61c21ch
	dd	 0eddfd134h,0ad7afacbh,07f6a5ccdh,00c0b545ah,0584983e8h,004998f9ch
	dd	 0969e530bh,0e21ee7e1h,0fff5eedch,0fe3bcfc2h,097007dbdh,066fa84aah
	dd	 0a375ed00h,03509e0cdh,01b76c530h,070193b76h,086e020dah,0c9366c9eh
	dd	 049f9d127h,0ae52c682h,0260fa0fdh,0e380c957h,0ce358e25h,002044391h
	dd	 0aeb09844h,0f31ce440h,0f0d686cfh,08cc4e9e3h,0be2cb553h,01e933adch
	dd	 0c312a5a7h,01d0957fbh,0a1c3ffffh,0bd5486b2h,0e8d8701eh,06e685f6ch
	dd	 01bc4945eh,0062f9d63h,084063d8dh,0c1f4b8f0h,0a7bc6d34h,0c4f319dah
	dd	 0f81452a1h,04cae7fa5h,01dbb0695h,0aa9b46b6h,06bddaf28h,061f96611h
	dd	 09a27563fh,0c2dc84b9h,06530e625h,0e7494963h,06ff671dah,0b8532798h
	dd	 0c06a9646h,0cc839cdah,09eeed60bh,0a70e3c5ah,0f0868967h,002544c39h
	dd	 087cc5f02h,0b3b9cfbfh,0f6f91bach,0dcade0a3h,08b9704f0h,06cde4d93h
	dd	 064aec893h,03e515984h,07bf3d351h,03eb30742h,0be9ee43dh,0b15fd2e8h
	dd	 02c7b666ch,001ce211eh,03b06f706h,005e5ffech,024e9bdaah,0fda1a2e5h
	dd	 0e04aabd8h,0e9a4006eh,0019e2eb6h,08d0ac8fdh,073d359f9h,06a43819eh
	dd	 000500fa8h,0da302caeh,0c0d8c728h,062d15a58h,061a969b9h,01e216bb2h
	dd	 00892dbc6h,03a7a8776h,034259f15h,079a79f68h,0f96822d1h,07f88020bh
	dd	 0af9ce79ch,0017c7070h,0f8445d09h,0ee15b3bbh,0e3629791h,020203d9eh
	dd	 053413509h,025279cb4h,0df378d84h,08921160fh,0a89f0527h,0413b0549h
	dd	 0ad98a40dh,0fb8e3f86h,000000000h,0d717072ch,0e6353913h,0acb4dbd5h
	dd	 01f0d146ah,0c411471ch,0b9cd092eh,041d95b8fh,074d0bb42h,086027e1ch
	dd	 0da827dc0h,057d8ba95h,012986e86h,09bb97889h,0c9843df0h,0122a3fe8h
	dd	 0556ea86ah,0d8346f3fh,0693bb27fh,053113aa1h,02850b89eh,00ce90a9ch
	dd	 0fb3c6ee8h,07a6dfde7h,0917fef76h,02a54fb0fh,0e2acb68fh,0e4832bech
	dd	 02e7f25fdh,0110203a1h,0aacb491eh,018eca817h,09e5c8765h,014b7f3e5h
	dd	 0c146e99eh,02e2f2a55h,047a6c944h,023ba50b9h,0d2f2f8c0h,0fbde302eh
	dd	 0a494517dh,0b5740c1ah,072af2989h,0ee45bc13h,003283c49h,06fa67e72h
	dd	 0f767351ah,01a5abae8h,0197286a1h,0e71946cbh,00f7367bbh,0dd33ce15h
	dd	 031c060f9h,067d6fb72h,0aee097ech,028e2e9f0h,0e7ab17a5h,0ba076ba1h
	dd	 02595cddah,0d43f3b65h,025c5c272h,0c81a1346h,0177d916ah,09b5b264fh
	dd	 0e166d400h,09ebed9a3h,07ef4727bh,0611b38d7h,05dfc73ach,00c5b5bf2h
	dd	 08de8963bh,0c7db2593h,031223e3fh,0d7470884h,0606748a7h,0ffa5e174h
	dd	 0f3feba86h,040f52457h,0a3c7bc6eh,0dc4fbe65h,06233049eh,0c26ed5d7h
	dd	 04f8643ech,0468ab69ch,053a36bcfh,0558cf6ach,095043e2ch,01b26ca98h
	dd	 04867ff91h,085c81c93h,0b60c3ffbh,0897119a7h,04ad1ed6eh,07480b4eah
	dd	 00beae827h,0d0f6bb51h,058198c40h,06989e311h,05f1a6efbh,0696bbdd7h
	dd	 06847c20fh,06c6c1cfdh,01ec33574h,0f64b4ac2h,0f41f06fbh,000b2516eh
	dd	 0644c9655h,08c94e64bh,06648d5c4h,0a2ebc3b6h,04c1c2ecbh,0f7856bdch
	dd	 07adfac89h,04837f039h,0ae02c92ah,035bbb1a3h,0e461752ah,0f7d56474h
	dd	 0d210a606h,0718715c0h,0a4c45ed5h,0bab53acfh,01c252823h,0cb807e61h
	dd	 0cdafe302h,0aa791870h,00b58b949h,0a00ddee1h,060d519c9h,0e1848ac6h
	dd	 0d9481f4fh,0f148a879h,064fec73bh,03c551a15h,0e5af5434h,04d605ebbh
	dd	 0a55a7063h,03c0515bdh,01deb093dh,00d957aech,03ee308eah,0ccd39372h
	dd	 0d38e88b0h,0fa401e98h,08f0e8b6ch,0b023a298h,09207dc97h,07c126f2ch
	dd	 0d8863e51h,0cd4dbdc4h,0382ecb4fh,06a138e36h,0631f7b46h,019228909h
	dd	 01c75278bh,050db582eh,090039f06h,0a9b37affh,006cdc3a5h,0210c4246h
	dd	 08fecd5aah,0b227e109h,03d9b3b0bh,0b92f57e8h,023ea5f11h,07839b1deh
	dd	 0caac01b9h,0127a3040h,0f282caf6h,09a950751h,08e22f4b4h,0fc6f83fbh
	dd	 056f4c54dh,0bccaa804h,00f91397dh,060851661h,0807decd7h,0eadc338fh
	dd	 051457698h,09f20f715h,0e4317a82h,0d7a55642h,0f2309b98h,03f2d29f4h
	dd	 0eb121291h,0dbae0218h,099ed34b0h,0fd13f38bh,091cdbe18h,0c9666336h
	dd	 07b118d97h,0042bdef2h,0ed3d8ff2h,0179fcfach,063ad2a28h,032b85318h
	dd	 0cdffecaah,0724d774fh,021ee1c80h,042a1686eh,02a04f4a7h,095b66f42h
	dd	 0de4bfdf4h,0d240a9aeh,04a81e2c6h,0a82d5449h,07d3e10f4h,0614b377fh
	dd	 0faa2405eh,03fcf7732h,090b1ce68h,0fc8ddd3dh,08db89993h,016e3bfdch
	dd	 0b30b9ed1h,08229a0eeh,04eaa3c34h,0b10fdd40h,056a4cae5h,084e4634bh
	dd	 0d16895e7h,06e3850c4h,095543184h,058abdd2eh,0be7cbafbh,0c8a84228h
	dd	 0dad27268h,0db1c5376h,071d71a68h,0bdb6d874h,0ebf04c57h,0dfd5d342h
	dd	 0852a4255h,0d66b775ch,0b4087c6ah,0cbd071c9h,0eb421d39h,0dd819f7bh
	dd	 04fd64c44h,0305e4e4fh,07d8c419ah,0d014e597h,0dea9a332h,01c97794dh
	dd	 045a28ad5h,0628155f0h,0912fe0deh,043dd181eh,0faf24ff6h,04efa339ch
	dd	 09399f221h,00eed490dh,0b4ba2d04h,0a193f057h,0942841f4h,0e136dba8h
	dd	 0e7fb180dh,0f5337923h,030bc1089h,0bc9aa7ach,0cffbaf3bh,06560e98dh
	dd	 033942cc0h,00a969857h,05788b53dh,020703236h,031906f51h,0a75e33f2h
	dd	 05987a2f6h,06b3ff1eeh,0c5df6602h,0a25992d8h,06af1d0f0h,01651eeb2h
	dd	 05fa83f95h,0d8d631f9h,0788be0b0h,0b6be6e95h,0a121a139h,019c0d7cfh
	dd	 0095cfad8h,009bea41eh,0872e01c4h,0c7397b55h,0990f6a76h,01601e11ah
	dd	 017cfc004h,03bb4a668h,08abb7b28h,0809fb211h,094ca1f32h,0b277eea1h
	dd	 0cfaba093h,05965fc30h,09ac508f9h,07f3a5365h,0ef8b9d0dh,037effd9ah
	dd	 0949a109ah,09f92a67bh,090e1c1c0h,0f8f60c67h,08a092a46h,0f8a603cfh
	dd	 0f9382d79h,06f142f1ch,05aff9117h,0ace4d47dh,0fe899each,013564f98h
	dd	 0d2a2f768h,076d4f8d3h,0a2099d70h,008c2d46eh,042133900h,007e1bc7dh
	dd	 0f4ad5795h,0eef7ed7dh,0932ba34fh,033267daeh,0cafc0e11h,02fb104e3h
	dd	 0503906e8h,0172d9ec2h,0f61b456ah,06eda0e02h,04e4862f2h,0c56d376ch
	dd	 0526d4ad1h,0e9465ea8h,0448ef50dh,0ea3e6d49h,03952bb3fh,02ecd7493h
	dd	 0ac068abbh,059d7ad5eh,0877e0e6ch,0a397b3c6h,0069dcc0dh,0d63b78f4h
	dd	 07cf031eah,0180ef6d1h,0ca1e50d7h,0df85dceah,08c76b88dh,0ea6e62e1h
	dd	 0090cf570h,0e54d0af2h,0b2c5bfcfh,014e7fc4dh,0b7204023h,07ea47dd3h
	dd	 052df1bbfh,06582b74bh,0ecf3aeech,0c03a99eeh,07e162cbdh,03a98d9b0h
	dd	 00dc57544h,0a325e2a8h,0d5434b15h,0e687687dh,06817cda7h,06d406325h
	dd	 04714982ah,0102e7c79h,0bc28f6c2h,078dbef18h,02ab6a5c9h,0c3a0f4c9h
	dd	 07d6e1f5ch,09c58c4f4h,082cbfe28h,021be1328h,0576aebfbh,08e72fb1ch
	dd	 0a6724c2ah,04638e7f2h,02b7884d7h,040477539h,05442d7b2h,0ea8c3c27h
	dd	 01455ad23h,02773d08dh,0387ec4e7h,03ac8d618h,04b4fc3d8h,018bca7bfh
	dd	 083b78e58h,053f36467h,02723df25h,04c4c2163h,08598133bh,01fbf4504h
	dd	 02fe10b4bh,0297cc746h,046dab934h,056469423h,0641c99fdh,04cfe700dh
	dd	 08b25559eh,05d1e2d6ah,0bc78f96ah,024b9b202h,0ef39cc63h,0c116e636h
	dd	 0989144c0h,0efdb92a5h,05d4e22c2h,068a59cc9h,077f8870bh,07a3df24fh
	dd	 07ca03e42h,0fd43fc23h,070fb65b0h,0905390aeh,0443ca463h,06d106c8dh
	dd	 01529dd53h,038cc9589h,05935f398h,02f03558dh,0b8e176f6h,0b073ad30h
	dd	 05e661e8bh,011520c09h,0573ae453h,08c26b725h,0ddd190d3h,097507215h
	dd	 027c181e3h,00557ae82h,0f3aeb52eh,0d51344bdh,09d96e5eah,042f167c6h
	dd	 0a6c01d44h,0982315aeh,02b288b7fh,0a171ae91h,097b22cd3h,0919db1b0h
	dd	 013b4115eh,07684f77bh,0c342aa0fh,008208aa8h,008708500h,0e5ff5b9ch
	dd	 04e186d5ah,02800b736h,0d5a115d3h,0c4a31672h,0159b8c3dh,0fe6bc06ah
	dd	 0967c0dcdh,007b1b3d5h,0433f46d8h,0e8887fb6h,04668e85ah,045f2857dh
	dd	 02bcad5b9h,0d4dd65a3h,072ff2621h,0b99d0686h,08ec0aa72h,02de548dah
	dd	 0e01aa470h,08355d09eh,05e361123h,0e66536bbh,05f4a6153h,05dac7c04h
	dd	 023580e7fh,0b52403b2h,093c9fd89h,0b6ee613dh,0c6f75a4bh,03a2a88deh
	dd	 070ab6a18h,04d305113h,0c3f0fb61h,022247e0fh,049a9de8fh,08d5ac755h
	dd	 095e660eah,0c088c880h,0c6450b25h,0f7373ab2h,0f1aaf6bfh,03ce74b7bh
	dd	 0fdf1ad4dh,0634f74eeh,0abe736c6h,0436f4970h,04a63bc00h,094784e5ch
	dd	 027918e4bh,0300e41e7h,09be97721h,0dbfe0db0h,0ed8fde9ch,081e3c261h
	dd	 0fed99104h,033c42368h,05ed44fe5h,00753ed13h,047f6c6ech,0704934deh
	dd	 02cc93702h,002b612ffh,03f7d265ch,0a4760fbbh,01a0ab540h,009eeabb6h
	dd	 0adc8aba5h,013e41ef6h,088bf38b9h,0d91810e7h,0523d4579h,06734a5b4h
	dd	 0370da35ch,0dc1fb1cdh,004c98034h,02db54772h,04dd20fd5h,086b02f72h
	dd	 0bb994517h,0d044ea3fh,0d1dac489h,04885a157h,03902b497h,0c1a4b758h
	dd	 00fc136d5h,0ff17b01ah,05b83e167h,07a8fa321h,01579d2fbh,0eba043ffh
	dd	 050690940h,0802de37fh,0a6224382h,06b8da080h,00a74c691h,07432e584h
	dd	 0528f1417h,0a5e8210dh,088ef3711h,09a775997h,00cb90534h,0292cc8eeh
	dd	 047449782h,020c26358h,0c615048dh,0aa2917d8h,0494b8049h,084b46ce3h
	dd	 073610897h,07ba3dcf9h,04510dbbbh,068f59361h,08279af46h,0bd04891ah
	dd	 0ce87df4bh,0553ea7c2h,0cb322f0fh,05c625d1ah,04f641d2ah,0325a0ddeh
	dd	 0a50a7fcbh,011b052cfh,01d595853h,0f563768bh,098c14b68h,03d296a65h
	dd	 0de1bf25ch,03671d32ch,0e3329839h,0f581284dh,037bff232h,0def9ac9ah
	dd	 08e90a5dah,0754e95f4h,05b31b009h,0b4ea22ach,0713544aeh,0ce65818dh
	dd	 0067f92cbh,039e0ea51h,0b0c1fc5eh,0c84a1ceeh,06aa1df58h,0e9f40fc6h
	dd	 0f1faf917h,013064030h,005b5f044h,0424336a8h,00a24c939h,0c44148b4h
	dd	 06f4420b4h,0047bd15ah,039b0e5f9h,08bc70b58h,00e5f1863h,0d1389a4fh
	dd	 0af2eb6f2h,0c9d43258h,0107e73d1h,089c348c9h,09cea959ah,011e05d67h
	dd	 0bb2b1479h,073835651h,0f34cebe8h,0d36cd676h,04540d413h,05cd00c74h
	dd	 031723197h,0eea7e2d5h,00f236813h,081b3cdc9h,07fd80da3h,0d7f559eah
	dd	 003ca628fh,03dcb34a3h,033767206h,02c2b69c4h,051f727f6h,0829bf180h
	dd	 0039a6d27h,056169b8bh,04d82007dh,09d24b484h,0bde6d7dch,0389c9a21h
	dd	 069d9ecb9h,0b792114dh,044defaa5h,08fbcda02h,092b58df9h,0962c0265h
	dd	 0cf19f1fdh,07462ea2ch,0227471a7h,0c53d38c4h,09257d33fh,032e85cb0h
	dd	 0abb7396eh,030ec1f21h,058fbd286h,05b61bfa1h,0240be36ch,0b7704f8bh
	dd	 0a69012ech,01f5d1bc2h,08305df36h,0299e9980h,05ff8303dh,0c58f69aah
	dd	 07ddc4e32h,0e6d767d5h,0880d69d7h,0d46f34cdh,0ff47bfb2h,022962f61h
	dd	 0a9e37557h,0fa101130h,083e781f0h,0cf49fe55h,0fcddd295h,02d07161ch
	dd	 0e83a2ed8h,0ca4e5f7fh,075fcc49ah,07915ce06h,054f086dch,0a9012b91h
	dd	 00ebd46a5h,0df67822ch,0d9fa4e21h,0af7eb95ah,081019ca7h,0f118a7d1h
	dd	 000e25ec6h,09b0b29e7h,0e2fcb927h,0ec11f02ah,0857a4dfdh,03497ce7bh
	dd	 01b949bf6h,09d74bb2ch,0cc31cdb4h,0e3d0c6ffh,0bf00ca8bh,036938deah
	dd	 016b3b074h,0ced7d0e3h,06037470fh,0cd1db26ch,06da23de3h,0bbc94abfh
	dd	 05a1dcfd1h,0c76974fdh,0a05dd149h,0f034d809h,0a4260013h,0b091f3f6h
	dd	 0a5b82ea5h,06786f4dah,04bad9d1eh,01e71641ah,0b59652dch,0ba576409h
	dd	 0b1bd8c2eh,02d5719b4h,07331073fh,0ac568513h,0b97f5840h,0bf50c523h
	dd	 00703e2bbh,06764aa1ch,020926cf0h,0012c7fd8h,01cc776e5h,09e0c88cdh
	dd	 0995f65deh,0f44f0953h,0e86a2170h,01fef4aach,07c426084h,0771ad9cdh
	dd	 02c9938aah,0b8032830h,04a33b3a8h,0751e9a5ch,0dd63c1bdh,079f790c0h
	dd	 051157930h,0d5f11a7bh,0d8646097h,0cb6220a7h,0d689299ah,0879c50aah
	dd	 0b7c21ee5h,04b1fcc70h,00b08b6e1h,028b2e658h,0b295b067h,0ab056800h
	dd	 075accb32h,0bfb29be5h,0f5d127e5h,06c8e423bh,06b6ffe46h,0215c4deeh
	dd	 0f9da73bfh,07b41823fh,048d5aeffh,01405a28bh,0bfe2944dh,0347590bdh
	dd	 0b45873c2h,0b65c3053h,0a0bf8f8fh,0937bace7h,01ae8eb86h,040a52bffh
	dd	 0e24ee849h,0d3de8718h,06c3c1355h,01990d867h,054a08974h,0375dacf4h
	dd	 0508b5786h,063fd2580h,0f98a7c17h,034c7c1d3h,0d0a6b4f9h,03e01562ch
	dd	 0185ef979h,05412d81ah,0b5c65d74h,026edfe3bh,035ebbe0bh,002e61d57h
	dd	 015cb8395h,00e0f17cbh,0fc3f8c53h,05a4dc079h,0e0f8fab6h,05bd3eecfh
	dd	 0e1d4856eh,08aeb7480h,05c3252b2h,0ab5567a8h,0fb6c6140h,0b3e9c017h
	dd	 0ec41ff82h,0f064d7a1h,0491b8fe1h,0a87d5be1h,010cc22bfh,0f6a91404h
	dd	 00d77242ah,0da602306h,051a7285eh,0109c2d17h

.data?

expandkey	dd	64	dup(?)

.code

q128Init	proc	ptrInkey:DWORD

		pushad
		mov	esi,[esp+28h]
		mov	eax,[esi]			; b0
		mov	ebx,[esi+4]		; b1
		mov	ecx,[esi+8]		; b2
		mov	edx,[esi+12]		; b3
		xor	esi,esi
		mov	edi,19
@_r2:
		mov	ebp,eax			
		and	ebp,3FFh
		xor	ebx,[ftab+ebp*4]
		ror	eax,10
		mov	ebp,ebx			
		and	ebp,3FFh
		xor	ecx,[ftab+ebp*4]
		ror	ebx,10
		mov	ebp,ecx
		and	ebp,3FFh
		xor	edx,[ftab+ebp*4]
		ror	ecx,10
		mov	ebp,edx
		and	ebp,3FFh
		xor	eax,[ftab+ebp*4]
		ror	edx,10
		cmp	edi,16
		jg	@_r1
		mov	[expandkey+esi],eax
		mov	[expandkey+esi+4],ebx
		mov	[expandkey+esi+8],ecx
		mov	[expandkey+esi+12],edx
		add	esi,16
@_r1:
		dec 	edi
		jnz	@_r2
		popad
		ret
		
q128Init	endp

q128Encrypt	proc	ptrIndata:DWORD, ptrOutdata:DWORD

		pushad
		mov	esi,[esp+28h]		; ptrIndata
		mov	eax,[esi]			; b0
		mov	ebx,[esi+4]		; b1
		mov	ecx,[esi+8]		; b2
		mov	edx,[esi+12]		; b3
		xor	esi,esi	
		mov	edi,16
@_r1:
		mov	ebp,eax
		and	ebp,3FFh
		mov	ebp,[ftab+ebp*4]
		add	ebp,[expandkey+esi*4]
		xor	ebx,ebp
		rol	eax,10
		mov	ebp,ebx
		and	ebp,3FFh
		mov	ebp,[ftab+ebp*4]
		add	ebp,[expandkey+esi*4+4]
		xor	ecx,ebp
		rol	ebx,10
		mov	ebp,ecx
		and	ebp,3FFh
		mov	ebp,[ftab+ebp*4]
		add	ebp,[expandkey+esi*4+8]
		xor	edx,ebp
		rol	ecx,10
		mov	ebp,edx
		and	ebp,3FFh
		mov	ebp,[ftab+ebp*4]
		add	ebp,[expandkey+esi*4+12]
		xor	eax,ebp
		rol	edx,10
		add	esi,4
		dec	edi
		jnz	@_r1
		mov	edi,[esp+2ch]		; ptrOutdata
		mov	[edi],eax
		mov	[edi+4],ebx
		mov	[edi+8],ecx
		mov	[edi+12],edx
		popad
		ret
		
q128Encrypt	endp

q128Decrypt	proc	ptrIndata:DWORD, ptrOutdata:DWORD

		pushad
		mov	esi,[esp+28h]		; ptrIndata
		mov	eax,[esi]			; b0
		mov	ebx,[esi+4]		; b1
		mov	ecx,[esi+8]		; b2
		mov	edx,[esi+12]		; b3
		xor	esi,esi
		mov	edi,16
@_r1:
		ror	edx,10
		mov	ebp,edx
		and	ebp,3FFh
		mov	ebp,[ftab+ebp*4]
		add	ebp,[expandkey+esi*4+63*4]
		xor	eax,ebp
		ror	ecx,10
		mov	ebp,ecx
		and	ebp,3FFh
		mov	ebp,[ftab+ebp*4]
		add	ebp,[expandkey+esi*4+63*4-4]
		xor	edx,ebp
		ror	ebx,10
		mov	ebp,ebx
		and	ebp,3FFh
		mov	ebp,[ftab+ebp*4]
		add	ebp,[expandkey+esi*4+63*4-8]
		xor	ecx,ebp
		ror	eax,10
		mov	ebp,eax
		and	ebp,3FFh
		mov	ebp,[ftab+ebp*4]
		add	ebp,[expandkey+esi*4+63*4-12]
		xor	ebx,ebp
		sub	esi,4
		dec	edi
		jnz	@_r1
		mov	edi,[esp+2ch]		; ptrOutdata
		mov	[edi],eax
		mov	[edi+4],ebx
		mov	[edi+8],ecx
		mov	[edi+12],edx
		popad
		ret
		
q128Decrypt	endp


