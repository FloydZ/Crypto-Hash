#include <memory.h>
#include <stdlib.h>
#include <stdio.h>
#include "..\..\..\include\bignum.h"
#pragma comment(lib,"..\\..\\..\\lib\\bignum.lib")
#include "bignumplus.h"


int main(int argc,char *argv[])
{
	BIGMATH bigmath(256);
	BIGNUM a(10),b(100),c(7),d(10000);
	char buff[0x100];
	
	a=a*d-b*c;
	a.tostr(&buff);
	puts(&buff);
       
	return getchar();
}

