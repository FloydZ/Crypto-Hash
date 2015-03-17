#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "cryptohash.h"
#pragma comment(linker,"/DEFAULTLIB:cryptohash.lib")

MD5String(char *sz)
{
	char szMD5[MD5_DIGESTSIZE*2+2];
	MD5Init();
	MD5Update((BYTE *)sz,strlen(sz));
	HexEncode(MD5Final(),MD5_DIGESTSIZE,(BYTE *)szMD5);
	puts((char *)&szMD5);
}

SHA1String(char *sz)
{
	char szSHA1[SHA1_DIGESTSIZE*2+2];
	SHA1Init();
	SHA1Update((BYTE *)sz,strlen(sz));
	HexEncode(SHA1Final(),SHA1_DIGESTSIZE,(BYTE *)szSHA1);
	puts((char *)&szSHA1);
}

MD5HMAC(BYTE *pKey,DWORD dwKeyLen,BYTE *pData,DWORD dwDataLen)
{
	BYTE k_ipad[64],k_opad[64],tk[16];
	char szMD5[MD5_DIGESTSIZE*2+2];
	
	memcpy(&tk,pKey,16);
	if (dwKeyLen>64)
	{
		MD5Init();
		MD5Update(pKey,dwKeyLen);
		memcpy(&tk,MD5Final(),16); 
	}
	memset(&k_ipad,0,64);
	memset(&k_opad,0,64);
	memcpy(&k_ipad,&tk,16);
	memcpy(&k_opad,&tk,16);
	for (int i=0; i<(64/4); i++ )
	{
		*((DWORD *)((DWORD)k_ipad+i*4))^=0x36363636;
		*((DWORD *)((DWORD)k_opad+i*4))^=0x5C5C5C5C;
	}
	MD5Init();
	MD5Update((BYTE *)&k_ipad,64);
	MD5Update(pData,dwDataLen);
	memcpy(&tk,MD5Final(),16);
	MD5Init();
	MD5Update((BYTE *)&k_opad,64);
	MD5Update((BYTE *)&tk,16);
	HexEncode(MD5Final(),MD5_DIGESTSIZE,(BYTE *)szMD5);
	puts((char *)&szMD5);
}

//2. Test Cases for HMAC-MD5
//test_case  = 1;
BYTE key[]   = { 0x0b,0x0b,0x0b,0x0b,0x0b,0x0b,0x0b,0x0b,0x0b,0x0b,0x0b,0x0b,0x0b,0x0b,0x0b,0x0b };
int key_len  = 16;
char data[]  = "Hi There";
int data_len = 8;
BYTE digest[]= { 0x92,0x94,0x72,0x7a,0x36,0x38,0xbb,0x1c,0x13,0xf4,0x8e,0xf8,0x15,0x8b,0xfc,0x9d };


int main(int argc,char *argv[])
{
	MD5String("a");
	SHA1String("a");
	
	MD5HMAC((BYTE *)&key,key_len,(BYTE *)&data,data_len);
	
	char szBuff[MD5_DIGESTSIZE*2+2];
	HexEncode((BYTE *)&digest,MD5_DIGESTSIZE,(BYTE *)szBuff);
	puts((char *)&szBuff);
	return getchar();
}

