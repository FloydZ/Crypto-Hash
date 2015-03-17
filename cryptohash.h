//
//	written by drizz <1of00@gmx.net>
//

#ifdef __cplusplus
extern "C" {
#endif

#ifndef _WINDOWS_
typedef unsigned long DWORD;
typedef unsigned char BYTE;
#endif

// CIPHERS
// =======

// DES
__stdcall DESSetKey       ( BYTE *pKey );
__stdcall DESSetKeyEnc    ( BYTE *pKey );
__stdcall DESSetKeyDec    ( BYTE *pKey );
__stdcall DESEncrypt      ( BYTE *pBlockIn,BYTE *pBlockOut );
__stdcall DESDecrypt      ( BYTE *pBlockIn,BYTE *pBlockOut );
// Twofish
__stdcall TwofishInit     ( BYTE *pKey,DWORD dwKeyLen);
__stdcall TwofishEncrypt  ( BYTE *pBlockIn,BYTE *pBlockOut);
__stdcall TwofishDecrypt  ( BYTE *pBlockIn,BYTE *pBlockOut);
// RC2
__stdcall RC2Init         ( BYTE *pKey,DWORD dwKeyLen );
__stdcall RC2Encrypt      ( BYTE *pBlockIn,BYTE *pBlockOut );
__stdcall RC2Decrypt      ( BYTE *pBlockIn,BYTE *pBlockOut );
// RC4
__stdcall RC4Init         ( BYTE *pKey,DWORD dwKeyLen );
__stdcall RC4Encrypt      ( BYTE *pBlock,DWORD dwBlockLen );
#define   RC4Decrypt      RC4Encrypt
// RC5
__stdcall RC5Init         ( BYTE *pKey );
__stdcall RC5Encrypt      ( BYTE *pBlockIn,BYTE *pBlockOut );
__stdcall RC5Decrypt      ( BYTE *pBlockIn,BYTE *pBlockOut );
// RC6
__stdcall RC6Init         ( BYTE *pKey,DWORD dwKeyLen );
__stdcall RC6Encrypt      ( BYTE *pBlockIn,BYTE *pBlockOut );
__stdcall RC6Decrypt      ( BYTE *pBlockIn,BYTE *pBlockOut );
// TEA
__stdcall TEAInit	      ( BYTE *pKey );
__stdcall TEAEncrypt      ( BYTE *pBlockIn,BYTE *pBlockOut );
__stdcall TEADecrypt      ( BYTE *pBlockIn,BYTE *pBlockOut );
// XTEA
__stdcall XTEAInit	      ( BYTE *pKey,DWORD dwRounds );
__stdcall XTEAEncrypt     ( BYTE *pBlockIn,BYTE *pBlockOut );
__stdcall XTEADecrypt     ( BYTE *pBlockIn,BYTE *pBlockOut );
// AES - Rijndael
__stdcall RijndaelInit    ( BYTE *pKey,DWORD dwKeyLen );
__stdcall RijndaelEncrypt ( BYTE *pBlockIn,BYTE *pBlockOut );
__stdcall RijndaelDecrypt ( BYTE *pBlockIn,BYTE *pBlockOut );
// 3-WAY
__stdcall ThreeWayInit    ( BYTE *pKey );
__stdcall ThreeWayEncrypt ( BYTE *pBlockIn,BYTE *pBlockOut );
__stdcall ThreeWayDecrypt ( BYTE *pBlockIn,BYTE *pBlockOut );
// Blowfish
__stdcall BlowfishInit    ( BYTE *pKey,DWORD dwKeyLen );
__stdcall BlowfishEncrypt ( BYTE *pBlockIn,BYTE *pBlockOut );
__stdcall BlowfishDecrypt ( BYTE *pBlockIn,BYTE *pBlockOut );

// CHECKSUMS
// =========

#define INIT_CRC32 0
#define INIT_CRC16 0
#define INIT_ADLER32 1

__stdcall CRC32   ( BYTE *lpBuffer,DWORD dwBufLen,DWORD dwCRC );   // init dwCRC = 0
__stdcall RCRC32  ( BYTE *pData,DWORD dwDataLen,DWORD dwOffset,DWORD dwWantCrc );   // reverse CRC32
__stdcall CRC16   ( BYTE *lpBuffer,DWORD dwBufLen,DWORD dwCRC );   // init dwCRC = 0
__stdcall Adler32 ( BYTE *lpBuffer,DWORD dwBufLen,DWORD dwAdler ); // init dwAdler = 1

// HASHES
// ======

#define MD5_DIGESTSIZE (128/8)
#define MD4_DIGESTSIZE (128/8)
#define MD2_DIGESTSIZE (128/8)
#define RMD128_DIGESTSIZE (128/8)
#define RMD160_DIGESTSIZE (160/8)
#define RMD256_DIGESTSIZE (256/8)
#define RMD320_DIGESTSIZE (320/8)
#define SHA0_DIGESTSIZE (160/8)
#define SHA1_DIGESTSIZE (160/8)
#define SHA256_DIGESTSIZE (256/8)
#define SHA384_DIGESTSIZE (384/8)
#define SHA512_DIGESTSIZE (512/8)
#define WHIRLPOOL_DIGESTSIZE (512/8)
#define TIGER_DIGESTSIZE (192/8)

BYTE * __stdcall MD5Init ();
       __stdcall MD5Update ( BYTE *lpBuffer,DWORD dwBufLen );
BYTE * __stdcall MD5Final ();
BYTE * __stdcall MD4Init ();
       __stdcall MD4Update ( BYTE *lpBuffer,DWORD dwBufLen );
BYTE * __stdcall MD4Final ();
BYTE * __stdcall MD2Init ();
       __stdcall MD2Update ( BYTE *lpBuffer,DWORD dwBufLen );
BYTE * __stdcall MD2Final ();
BYTE * __stdcall RMD128Init ();
       __stdcall RMD128Update ( BYTE *lpBuffer,DWORD dwBufLen );
BYTE * __stdcall RMD128Final ();
BYTE * __stdcall RMD160Init ();
       __stdcall RMD160Update ( BYTE *lpBuffer,DWORD dwBufLen );
BYTE * __stdcall RMD160Final ();
BYTE * __stdcall RMD256Init ();
       __stdcall RMD256Update ( BYTE *lpBuffer,DWORD dwBufLen );
BYTE * __stdcall RMD256Final ();
BYTE * __stdcall RMD320Init ();
       __stdcall RMD320Update ( BYTE *lpBuffer,DWORD dwBufLen );
BYTE * __stdcall RMD320Final ();
BYTE * __stdcall SHA0Init ();
       __stdcall SHA0Update ( BYTE *lpBuffer,DWORD dwBufLen );
BYTE * __stdcall SHA0Final ();
BYTE * __stdcall SHA1Init ();
       __stdcall SHA1Update ( BYTE *lpBuffer,DWORD dwBufLen );
BYTE * __stdcall SHA1Final ();
BYTE * __stdcall SHA256Init ();
       __stdcall SHA256Update ( BYTE *lpBuffer,DWORD dwBufLen );
BYTE * __stdcall SHA256Final ();
BYTE * __stdcall SHA384Init ();
       __stdcall SHA384Update ( BYTE *lpBuffer,DWORD dwBufLen );
BYTE * __stdcall SHA384Final ();
BYTE * __stdcall SHA512Init ();
       __stdcall SHA512Update ( BYTE *lpBuffer,DWORD dwBufLen );
BYTE * __stdcall SHA512Final ();
BYTE * __stdcall WhirlpoolInit ();
       __stdcall WhirlpoolUpdate ( BYTE *lpBuffer,DWORD dwBufLen );
BYTE * __stdcall WhirlpoolFinal ();
BYTE * __stdcall TigerInit ();
       __stdcall TigerUpdate ( BYTE *lpBuffer,DWORD dwBufLen );
BYTE * __stdcall TigerFinal ();
BYTE * __stdcall HavalInit ( DWORD DigestSizeBits,DWORD Passes  );// variable digest & passes !!!
       __stdcall HavalUpdate ( BYTE *lpBuffer,DWORD dwBufLen );
BYTE * __stdcall HavalFinal ();


// TEXT UTILS
// ==========

DWORD __stdcall HexEncode    ( BYTE *pBuff,DWORD dwLen,BYTE *pOutBuff );// sizeof pOutBuff must be (dwLen)*2+2
DWORD __stdcall HexDecode    ( BYTE *pHexStr,BYTE *pOutBuffer); //sizeof pOutBuff must be StrLen(pHexStr)/2+1
DWORD __stdcall Base64Encode ( BYTE *pInputData,DWORD dwDataLen,BYTE *pOutputStr );// sizeof pOutputStr must be (dwLen)*4/3
DWORD __stdcall Base64Decode ( BYTE *pInputStr,BYTE *pOutputData );// result = length
DWORD __stdcall Base2Decode  ( BYTE *pInputStr,BYTE *pOutputData);// result = length
DWORD __stdcall Base2Encode  ( BYTE *pInputData,DWORD dwDataLen,BYTE *pOutputData);// result = length

#ifdef __cplusplus
}
#endif
