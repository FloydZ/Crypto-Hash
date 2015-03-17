// fuck MSVC++
// cannot convert from 'DWORD' to 'pBN'
// INTELC++ rules!

#ifdef __cplusplus

class BIGNUM;
class BIGMATH;

class BIGMATH
{
	public:
		BIGMATH(DWORD MaxBits){ bnInit(MaxBits); };
		~BIGMATH(){ bnFinish(); };
};

class BIGNUM
{
	private:
		pBN Val;
	public:
		BIGNUM(){ Val=bnCreate(); };
		BIGNUM(int i){ Val=bnCreatei(i); };
		~BIGNUM(){ bnDestroy(Val); };

		BIGNUM& operator=(BIGNUM& cbn) { bnMov(Val,cbn.Val); return *this; };
		BIGNUM& operator=(BN bn) { bnMov(Val,&bn); return *this; };
		BIGNUM& operator=(pBN pbn) { bnMov(Val,pbn); return *this; };
		BIGNUM& operator=(int i) { bnMovsx(Val,i); return *this; };
		BIGNUM& operator=(DWORD j) { bnMovzx(Val,j); return *this; };
		
		BIGNUM& operator+(BIGNUM& cbn) { bnAdd(Val,cbn.Val); return *this; };
		BIGNUM& operator-(BIGNUM& cbn) { bnSub(Val,cbn.Val); return *this; };
		BIGNUM& operator*(BIGNUM& cbn) { bnMul(Val,cbn.Val,Val); return *this; };
		BIGNUM& operator/(BIGNUM& cbn) { bnDiv(Val,cbn.Val,Val,0); return *this; };
		BIGNUM& operator%(BIGNUM& cbn) { bnMod(Val,cbn.Val,Val); return *this; };

		BIGNUM& operator<<(DWORD sc) { bnShl(Val,sc); return *this; };
		BIGNUM& operator>>(DWORD sc) { bnShr(Val,sc); return *this; };

		BIGNUM& operator++(void) { bnInc(Val); return *this; };
		BIGNUM& operator--(void) { bnDec(Val); return *this; };

		BIGNUM& operator+=(DWORD i) { bnAddDw(Val,i); return *this; };
		BIGNUM& operator-=(DWORD i) { bnSubDw(Val,i); return *this; };
		BIGNUM& operator*=(DWORD i) { bnMulDw(Val,i); return *this; };
		BIGNUM& operator/=(DWORD i) { bnDivDw(Val,i,Val); return *this; };
		BIGNUM& operator%=(DWORD i) { bnModDw(Val,i,Val); return *this; };

		BIGNUM& operator+=(BIGNUM& cbn) { bnAdd(Val,cbn.Val); return *this; };
		BIGNUM& operator-=(BIGNUM& cbn) { bnSub(Val,cbn.Val); return *this; };
		BIGNUM& operator*=(BIGNUM& cbn) { bnMul(Val,cbn.Val,Val); return *this; };
		BIGNUM& operator/=(BIGNUM& cbn) { bnDiv(Val,cbn.Val,Val,0); return *this; };
		BIGNUM& operator%=(BIGNUM& cbn) { bnMod(Val,cbn.Val,Val); return *this; };

		BIGNUM& operator<<=(DWORD sc) { bnShl(Val,sc); return *this; };
		BIGNUM& operator>>=(DWORD sc) { bnShr(Val,sc); return *this; };
		
		// BOOL operators
		bool operator==(BIGNUM& cbn) { return (bnCmp(Val,cbn.Val)==0); };
		bool operator!=(BIGNUM& cbn) { return (bnCmp(Val,cbn.Val)!=0); };
		bool operator>(BIGNUM& cbn) { return (bnCmp(Val,cbn.Val)==1); };
		bool operator>=(BIGNUM& cbn) { return (bnCmp(Val,cbn.Val)>=1); };
		bool operator<(BIGNUM& cbn) { return ((int)bnCmp(Val,cbn.Val)==-1); };
		bool operator<=(BIGNUM& cbn) { return ((int)bnCmp(Val,cbn.Val)<=-1); };
		
		// CONVERT
		void movzx (DWORD j) { bnMovzx(Val,j); };
		void movsx (int i) { bnMovsx(Val,i); };
		DWORD tohex (char *pc) { bnToHex(Val,pc); };
		DWORD tostr (char *pc) { bnToStr(Val,pc); };
		void fromhex(char *pc) { bnFromHex(pc,Val); };
		void fromstr(char *pc) { bnFromStr(pc,Val); };
};
 
#endif
