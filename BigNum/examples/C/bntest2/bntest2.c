#include <stdlib.h>
#include <stdio.h>
#include "..\..\..\include\bignum.h"
#pragma comment(lib,"..\\..\\..\\lib\\bignum.lib")

int main(int argc,char *argv[])
{
	pBN a1,a2,a3,a4;
	char buff[0x200];
	
	printf("whatever calculation\n");
	
	bnInit(64);
	a1=bnCreatei(6);
	a2=bnCreatei(6);
	a3=bnCreatei(6);
	a4=bnCreatei(10000000);
	bnToStr(a4,&buff);
	printf("a4=%s\n",&buff);
	bnMulDw(a1,100);
	bnMulDw(a2,10);
	bnMulDw(a3,1);
	bnSquare(a4);
	bnAdd(a1,a2);
	bnAdd(a1,a3);
	bnToStr(a4,&buff);
	printf("a4^2=%s\n",&buff);
	printf("bits(a4^2)=%d bits\n",bnBits(a4));
	bnToStr(a1,&buff);
	puts(&buff);
	
	bnDiv(a4,a1,a2,a3);
	bnToStr(a2,&buff);
	puts(&buff);
	bnToStr(a3,&buff);
	puts(&buff);
	bnMulDw(a2,666);
	bnAdd(a2,a3);
	bnToStr(a2,&buff);
	puts(&buff);

	bnDestroy(a4);
	bnDestroy(a3);
	bnDestroy(a2);
	bnDestroy(a1);
	bnFinish();
	
	return getchar();
}

