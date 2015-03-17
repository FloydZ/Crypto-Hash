#include <stdlib.h>
#include <stdio.h>

#include "miracl.h"
#pragma comment(linker,"/DEFAULTLIB:miracl.lib")

#include "bignum.h"
#pragma comment(linker,"/DEFAULTLIB:bignum.lib")

int main(int argc,char *argv[])
{
	miracl *mip=mirsys(308,16);// 308=log10(2^1024)
	big x,y;
	BN *a,*b; 

	BYTE buff[0x40];
	BYTE buff2[0x100];
	
	bnInit(1024);// bits
	
	a=bnCreate();
	b=bnCreate();

	mip->IOBASE=16;
	
	x=mirvar(0);
	y=mirvar(0);
	
	bnFromHex("12345678123456781234567812345678",a);
	cinstr(x, "99AAAAAAAAAAAAAABBBBBBBBBBBBBBCC");
	
	big_to_bytes(16,x,&buff,0);
	bnFromBytesEx(&buff,16,b,0);
	
	bnToBytesEx(a,&buff);
	bytes_to_big(16,&buff,y);
	
	bnToHex(a,&buff2);
	puts(&buff2);
	bnToHex(b,&buff2);
	puts(&buff2);
	
	cotstr(y,&buff2);
	puts(&buff2);
	cotstr(x,&buff2);
	puts(&buff2);
	
	
	bnFinish();
	
	mirkill(x);mirkill(y);
	mirexit();
	return getchar();
}

