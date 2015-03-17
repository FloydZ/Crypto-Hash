.686
option casemap:none
include bnlib.inc
include bignum.inc

.data
align 4
BN_PHASE1PRIMES label dword
dd 24,  7,13,17,241,0;
dd 30,  11,31,151,331,0
dd 28,  29,43,113,127,0
dd 22,  23,89,683,0
dd 25,  601,1801,0
dd 18,  19,73,0
dd 20,  41,0
dd 23,  47,0
dd 16,  257,0
dd 21,  337,0
dd 00,  0,0
BN_PHASE2PRIMES label dword
dd 037,053,059,061,067,071,079,083,097,101,103,107,109,131,137
dd 139,149,157,163,167,173,179,181,191,193,197,199,211,223,227
dd 229,239,251,263,269,271,277,281,283,293,307,311,313,317,347
dd 349,353,359,367,373,379,383,389,397,401,409,419,421,431,433
dd 439,443,449,457,461,463,467,479,487,491,499,503,509,521,523
dd 541,547,557,563,569,571,577,587,593,599,607,613,617,619,631
dd 641,643,647,653,659,661,673,677,691,701,709,719,727,733,739
dd 743,751,757,761,769,773,787,797,809,811,821,823,827,829,839
dd 853,857,859,863,877,881,883,887,907,911,919,929,937,941,947
dd 953,967,971,977,983,991,997
dd 1009,1013,1019,1021,1031,1033,1039,1049,1051,1061,1063,1069
dd 1087,1091,1093,1097,1109,1117,1123,1129,1151,1153,1163,1171
dd 1181,1187,1193,1201,1213,1217,1223,1229,1231,1237,1249,1259
dd 1277,1279,1283,1289,1291,1297,1301,1303,1307,1319,1321,1327
dd 1361,1367,1373,1381,1399,1409,1423,1427,1429,1433,1439,1447
dd 1451,1453,1459,1471,1481,1483,1487,1489,1493,1499,1511,1523
dd 1531,1543,1549,1553,1559,1567,1571,1579,1583,1597,1601,1607
dd 1609,1613,1619,1621,1627,1637,1657,1663,1667,1669,1693,1697
dd 1699,1709,1721,1723,1733,1741,1747,1753,1759,1777,1783,1787
dd 1789,1811,1823,1831,1847,1861,1867,1871,1873,1877,1879,1889
dd 1901,1907,1913,1931,1933,1949,1951,1973,1979,1987,1993,1997
dd 1999
dd 2003,2011,2017,2027,2029,2039,2053,2063,2069,2081,2083,2087,2089
dd 2099,2111,2113,2129,2131,2137,2141,2143,2153,2161,2179,2203,2207,2213
dd 2221,2237,2239,2243,2251,2267,2269,2273,2281,2287,2293,2297,2309,2311
dd 2333,2339,2341,2347,2351,2357,2371,2377,2381,2383,2389,2393,2399,2411
dd 2417,2423,2437,2441,2447,2459,2467,2473,2477,2503,2521,2531,2539,2543
dd 2549,2551,2557,2579,2591,2593,2609,2617,2621,2633,2647,2657,2659,2663
dd 2671,2677,2683,2687,2689,2693,2699,2707,2711,2713,2719,2729,2731,2741
dd 2749,2753,2767,2777,2789,2791,2797,2801,2803,2819,2833,2837,2843,2851
dd 2857,2861,2879,2887,2897,2903,2909,2917,2927,2939,2953,2957,2963,2969
dd 2971,2999
dd 3001,3011,3019,3023,3037,3041,3049,3061,3067,3079,3083,3089
dd 3109,3119,3121,3137,3163,3167,3169,3181,3187,3191,3203,3209,3217,3221
dd 3229,3251,3253,3257,3259,3271,3299,3301,3307,3313,3319,3323,3329,3331
dd 3343,3347,3359,3361,3371,3373,3389,3391,3407,3413,3433,3449,3457,3461
dd 3463,3467,3469,3491,3499,3511,3517,3527,3529,3533,3539,3541,3547,3557
dd 3559,3571,3581,3583,3593,3607,3613,3617,3623,3631,3637,3643,3659,3671
dd 3673,3677,3691,3697,3701,3709,3719,3727,3733,3739,3761,3767,3769,3779
dd 3793,3797,3803,3821,3823,3833,3847,3851,3853,3863,3877,3881,3889,3907
dd 3911,3917,3919,3923,3929,3931,3943,3947,3967,3989
dd 4001,4003,4007,4013
dd 4019,4021,4027,4049,4051,4057,4073,4079,4091,4093,4099,4111,4127,4129
dd 4133,4139,4153,4157,4159,4177,4201,4211,4217,4219,4229,4231,4241,4243
dd 4253,4259,4261,4271,4273,4283,4289,4297,4327,4337,4339,4349,4357,4363
dd 4373,4391,4397,4409,4421,4423,4441,4447,4451,4457,4463,4481,4483,4493
dd 4507,4513,4517,4519,4523,4547,4549,4561,4567,4583,4591,4597,4603,4621
dd 4637,4639,4643,4649,4651,4657,4663,4673,4679,4691,4703,4721,4723,4729
dd 4733,4751,4759,4783,4787,4789,4793,4799,4801,4813,4817,4831,4861,4871
dd 4877,4889,4903,4909,4919,4931,4933,4937,4943,4951,4957,4967,4969,4973
dd 4987,4993,4999
dd 5003,5009,5011,5021,5023,5039,5051,5059,5077,5081,5087
dd 5099,5101,5107,5113,5119,5147,5153,5167,5171,5179,5189,5197,5209,5227
dd 5231,5233,5237,5261,5273,5279,5281,5297,5303,5309,5323,5333,5347,5351
dd 5381,5387,5393,5399,5407,5413,5417,5419,5431,5437,5441,5443,5449,5471
dd 5477,5479,5483,5501,5503,5507,5519,5521,5527,5531,5557,5563,5569,5573
dd 5581,5591,5623,5639,5641,5647,5651,5653,5657,5659,5669,5683,5689,5693
dd 5701,5711,5717,5737,5741,5743,5749,5779,5783,5791,5801,5807,5813,5821
dd 5827,5839,5843,5849,5851,5857,5861,5867,5869,5879,5881,5897,5903,5923
dd 5927,5939,5953,5981,5987
dd 6007,6011,6029,6037,6043,6047,6053,6067,6073
dd 6079,6089,6091,6101,6113,6121,6131,6133,6143,6151,6163,6173,6197,6199
dd 6203,6211,6217,6221,6229,6247,6257,6263,6269,6271,6277,6287,6299,6301
dd 6311,6317,6323,6329,6337,6343,6353,6359,6361,6367,6373,6379,6389,6397
dd 6421,6427,6449,6451,6469,6473,6481,6491,6521,6529,6547,6551,6553,6563
dd 6569,6571,6577,6581,6599,6607,6619,6637,6653,6659,6661,6673,6679,6689
dd 6691,6701,6703,6709,6719,6733,6737,6761,6763,6779,6781,6791,6793,6803
dd 6823,6827,6829,6833,6841,6857,6863,6869,6871,6883,6899,6907,6911,6917
dd 6947,6949,6959,6961,6967,6971,6977,6983,6991,6997
dd 7001,7013,7019,7027
dd 7039,7043,7057,7069,7079,7103,7109,7121,7127,7129,7151,7159,7177,7187
dd 7193,7207,7211,7213,7219,7229,7237,7243,7247,7253,7283,7297,7307,7309
dd 7321,7331,7333,7349,7351,7369,7393,7411,7417,7433,7451,7457,7459,7477
dd 7481,7487,7489,7499,7507,7517,7523,7529,7537,7541,7547,7549,7559,7561
dd 7573,7577,7583,7589,7591,7603,7607,7621,7639,7643,7649,7669,7673,7681
dd 7687,7691,7699,7703,7717,7723,7727,7741,7753,7757,7759,7789,7793,7817
dd 7823,7829,7841,7853,7867,7873,7877,7879,7883,7901,7907,7919,7927,7933
dd 7937,7949,7951,7963,7993
dd 8009,8011,8017,8039,8053,8059,8069,8081,8087
dd 8089,8093,8101,8111,8117,8123,8147,8161,8167,8171,8179,8191,8209,8219
dd 8221,8231,8233,8237,8243,8263,8269,8273,8287,8291,8293,8297,8311,8317
dd 8329,8353,8363,8369,8377,8387,8389,8419,8423,8429,8431,8443,8447,8461
dd 8467,8501,8513,8521,8527,8537,8539,8543,8563,8573,8581,8597,8599,8609
dd 8623,8627,8629,8641,8647,8663,8669,8677,8681,8689,8693,8699,8707,8713
dd 8719,8731,8737,8741,8747,8753,8761,8779,8783,8803,8807,8819,8821,8831
dd 8837,8839,8849,8861,8863,8867,8887,8893,8923,8929,8933,8941,8951,8963
dd 8969,8971,8999
dd 9001,9007,9011,9013,9029,9041,9043,9049,9059,9067,9091
dd 9103,9109,9127,9133,9137,9151,9157,9161,9173,9181,9187,9199,9203,9209
dd 9221,9227,9239,9241,9257,9277,9281,9283,9293,9311,9319,9323,9337,9341
dd 9343,9349,9371,9377,9391,9397,9403,9413,9419,9421,9431,9433,9437,9439
dd 9461,9463,9467,9473,9479,9491,9497,9511,9521,9533,9539,9547,9551,9587
dd 9601,9613,9619,9623,9629,9631,9643,9649,9661,9677,9679,9689,9697,9719
dd 9721,9733,9739,9743,9749,9767,9769,9781,9787,9791,9803,9811,9817,9829
dd 9833,9839,9851,9857,9859,9871,9883,9887,9901,9907,9923,9929,9931,9941
dd 9949,9967,9973
dd 0
BN_FIRST13PRIMES db 2,3,5,7,11,13,17,19,23,29,31,37,41

.data?
bn_dwrandseed dd ?

.code

;; returns offset of bn_dwrandseed so we can change it
;; if needed
_bn_dwrandomize proc c
	rdtsc
	mov bn_dwrandseed,eax
	mov eax,offset bn_dwrandseed
	ret
_bn_dwrandomize endp

; ecx = range
_bn_dwrandom proc c
	mov eax,bn_dwrandseed
	mov edx,41c64e6dh
	mul edx
	add eax,3039h
	xor edx,edx
	mov bn_dwrandseed,eax
	div ecx
	mov eax,edx
	ret
_bn_dwrandom endp



bnFermatpt proc uses esi edi ebx bn:dword
LOCAL cnt
	xor ecx,ecx; FALSE
	push ecx
	mov cnt,ecx
	bnCreateX edi,esi,ebx; tmp's
	invoke bnMov,edi,bn
	invoke bnDec,edi
	; test a^(m-1) = 1 (mod m)
	mov eax,cnt
	.repeat
		movzx eax,[BN_FIRST13PRIMES+eax]
		mov [esi].BN.dwArray[0],eax
		invoke bnModExp,esi,edi,bn,ebx		
		.if !ABS_BN_IS_ONE(ebx)
			jmp @@NotPrime
		.endif
		mov eax,cnt
		inc eax
		mov cnt,eax 
	.until eax == BN_FIRST13PRIMES_SIZE
	inc dword ptr [esp];,TRUE
;	mov [esi].BN.dwArray[0],2
;	invoke bnModExp,esi,edi,bn,ebx
;	.if ABS_BN_IS_ONE(ebx)
;		mov [esi].BN.dwArray[0],3
;		invoke bnModExp,esi,edi,bn,ebx
;		.if ABS_BN_IS_ONE(ebx) 
;			mov [esi].BN.dwArray[0],5
;			invoke bnModExp,esi,edi,bn,ebx
;			.if ABS_BN_IS_ONE(ebx)
;				mov [esi].BN.dwArray[0],7
;				invoke bnModExp,esi,edi,bn,ebx
;				.if ABS_BN_IS_ONE(ebx)
;					mov dword ptr [esp],TRUE
;				.endif
;			.endif
;		.endif
;	.endif
@@NotPrime:
	bnDestroyX
	pop eax
	ret
bnFermatpt endp

bnIsPrime proc bn
	mov eax,bn
	.if BN_IS_ODD(eax)
		invoke bnTrialDivpt,eax
		.if eax
			invoke bnFermatpt,bn
			.if eax
				invoke bnRabinMillerpt,bn,2
			.endif
		.endif
	.endif
	ret
bnIsPrime endp

bnRabinMillerpt proc uses esi edi ebx bn,iter
LOCAL b,z,w1,m
LOCAL a
	bnCreateX b,z,w1,m
;	int 1
	mov edi,bn
	mov esi,w1
	invoke bnMov,esi,edi
	invoke bnDec,esi
	mov ecx,[esi].BN.dwSize
	xor edx,edx
	.repeat 
		mov eax,[esi].BN.dwArray[edx*4]
		inc edx
		test eax,eax
		.if !zero?
			bsf ecx,eax
			.break
		.endif
		dec ecx
	.until zero?
	mov a,ecx
	invoke bnMov,m,esi
	invoke bnShr,m,a; w-1 / 2^a
	mov esi,z
	;---------------------------------------------------
	call _bn_dwrandomize
	.repeat
		mov ecx,100
		call _bn_dwrandom
		mov edx,b
		mov eax,[eax*4+BN_PHASE2PRIMES]
		mov [edx].BN.dwArray[0],eax
;		mov eax,[edi].BN.dwSize
;		shl eax,5
;		invoke bnRandom,b,eax
;		invoke bnShr1,b
;		mov eax,b
;		or [eax].BN.dwArray[0],1
		xor ebx,ebx; J = 0
		invoke bnModExp,b,m,edi,esi
		.repeat
			invoke bnCmpAbs,esi,w1
			.if ( ebx==0 && ABS_BN_IS_ONE(esi) ) || (eax==0)
				jmp @@Cont
			.endif
			inc ebx
			.if ( ebx>0 && ABS_BN_IS_ONE(esi) )
				jmp @@NotPrime
			.endif
			.if ebx<a
				invoke bnSquare,esi
				invoke bnMod,esi,edi,esi
			.endif
		.until ebx >= a
		jmp @@NotPrime
	@@Cont:	
		dec iter
	.until zero?
	bnDestroyX	
	mov eax,1;TRUE
	ret
@@NotPrime:		
	bnDestroyX
	xor eax,eax
	ret
bnRabinMillerpt endp

bnRandom proc uses edi bn,nbit
LOCAL hProv,Result
	xor eax,eax
	mov ecx,nbit
	mov edi,bn
	shr ecx,5
	mov Result,eax
	.if ecx<=BN_MAX_DWORD
		mov [edi].BN.dwSize,ecx
		mov [edi].BN.bSigned,eax
		;invoke random, addr[edi].BN.dwArray, ecx
		invoke CryptGenRandom,BN_HPROV,addr[ecx*4],addr[edi].BN.dwArray
		inc Result
	.endif
	mov eax,Result
	ret
bnRandom endp

bnRsaGenPrime proc bn:dword, nbit:dword
	call _bn_dwrandomize
	invoke bnRandom,bn,nbit
;	int 1
	mov eax,bn
	mov ecx,[eax].BN.dwSize
	or [eax].BN.dwArray[000*4-0],00000000000000000000000000000001b
	or [eax].BN.dwArray[ecx*4-4],11000000000000000000000000000000b
	jmp @@Test
@@:	invoke bnAddDw,bn,2
	@@Test:
	invoke bnTrialDivpt,bn
	test eax,eax
	jz @B
;	invoke bnLehmanpt,bn
;	test eax,eax
;	jz @B
	invoke bnFermatpt,bn
	test eax,eax
	jz @B
	invoke bnRabinMillerpt,bn,1
	test eax,eax
	jz @B
;	invoke printbn,bn
	ret
bnRsaGenPrime endp


phase1 proc private uses edi esi ebx bn:dword
LOCAL isum[2]:DWORD
LOCAL tmp,shrN,Prim
;	int 1
	bnSCreateX tmp
	lea esi,BN_PHASE1PRIMES
	mov edi,bn
	jmp @@Nextp
	.repeat
		mov shrN,ecx
		xor eax,eax
		mov isum[0],eax
		mov isum[4],eax
		.repeat
			invoke bnShr,tmp,shrN
			add isum[0],eax 
			mov eax,tmp
			adc isum[4],0 
		.until BN_IS_ZERO(eax)
	@@SameSum:
		mov eax,[esi]
		add esi,4
		test eax,eax
		jz @@Nextp
		mov Prim,eax
		xor edx,edx
		.if isum[4]==edx
			mov eax,isum[0]
			div Prim
			mov Prim,edx
			mov eax,edx
			jmp @@Sum32
		.endif
		fild qword ptr isum
		fld st 
		fidiv Prim
		push 1F320000h
		fnstcw [esp];CW_ORG
		fldcw [esp+2];CW_TRUNC
		frndint
		fldcw [esp];CW_ORG	
		fimul Prim
		fsub
		fistp Prim
		mov eax,Prim
		add esp,4
	@@Sum32:
		test eax,eax
		jz @@NotPrime
		jmp @@SameSum
	@@Nextp:	
		invoke bnMov,tmp,edi
		mov ecx,[esi]
		add esi,4
		test ecx,ecx
	.until zero? 
	mov Prim,1;TRUE
@@NotPrime:
	bnSDestroyX
	mov eax,Prim
	ret
phase1 endp

; ~Trial Division Based Primality Testing
bnTrialDivpt proc uses esi edi ebx bn:dword
	fninit
	fclex
	mov edi,bn
	xor ebx,ebx
	mov ecx,[edi].BN.dwSize
	xor eax,eax
	.repeat
		adc ebx,[edi].BN.dwArray[ecx*4-4]
		dec ecx
	.until zero?
	adc ebx,eax
	; div 3
	mov eax,ebx
	mov edx,0AAAAAAABh
	mul edx
	shr edx,1
	mov eax,ebx
	; edx*3
	lea edx,[edx*2+edx]
	;
	sub eax,edx
	jz @F
	; div 5
	mov eax,ebx
	mov edx,0CCCCCCCDh
	mul edx
	shr edx,2
	mov eax,ebx
	; edx*5
	lea edx,[edx*4+edx]
	;
	sub eax,edx
	jz @F
if 0
	; div 17
	mov eax,ebx
	mov edx,0F0F0F0F1h
	mul edx
	shr edx,4
	mov eax,ebx
	; edx*17
	mov ecx,edx
	shl edx,4
	add edx,ecx
	;
	sub eax,edx
	jz @F
	; div 257
	mov eax,ebx
	mov edx,0FF00FF01h
	mul edx
	shr edx,8
	mov eax,ebx
	; edx*17
	mov ecx,edx
	shl edx,8
	add edx,ecx
	;
	sub eax,edx
	jz @F
endif
	invoke phase1,bn
	test eax,eax
	jz @F
	xor esi,esi
	jmp @@Nextp
	.repeat
		invoke bnModDw,bn,eax
		test eax,eax
		jz @F
	@@Nextp:	
		mov eax,BN_PHASE2PRIMES[esi*4]
		inc esi
		test eax,eax
	.until zero?
	invoke bnCreate
	mov esi,eax
	mov ecx,100
	call _bn_dwrandom
	mov eax,[eax*4+BN_PHASE2PRIMES]
	mov [esi].BN.dwArray[0],eax
;	mov eax,bn
;	mov ecx,[eax].BN.dwSize
;	shl ecx,5
;	invoke bnRandom,esi,ecx
;	invoke bnShr1,esi
;	or [esi].BN.dwArray[0],1
	invoke bnGCD,bn,esi,esi
	.if !ABS_BN_IS_ONE(esi)
		invoke bnDestroy,esi
		xor eax,eax
		jmp @F
	.endif
	invoke bnDestroy,esi
	mov eax,1;TRUE
@@:	ret
bnTrialDivpt endp
