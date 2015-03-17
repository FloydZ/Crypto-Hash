comment "written by drizz <1of00@gmx.net>"


DESSetKey PROTO pKey:PTR BYTE
DESSetKeyEnc PROTO pKey:PTR BYTE
DESSetKeyDec PROTO pKey:PTR BYTE
DESEncrypt PROTO pBlockIn:PTR BYTE,pBlockOut:PTR BYTE
DESDecrypt PROTO pBlockIn:PTR BYTE,pBlockOut:PTR BYTE
TwofishInit PROTO :DWORD,:DWORD
TwofishEncrypt PROTO :DWORD,:DWORD
TwofishDecrypt PROTO :DWORD,:DWORD
RC2Init proto pKey:DWORD,dwKeyLen:DWORD
RC2Encrypt proto pBlockIn:DWORD,pBlockOut:DWORD
RC2Decrypt proto pBlockIn:DWORD,pBlockOut:DWORD
RC4Init proto pKey:DWORD,:DWORD
RC4Encrypt proto pBlock:DWORD,dwBlockLen:DWORD
RC4Decrypt equ <RC4Encrypt>
RC5Init       PROTO pKeys:DWORD
RC5Encrypt    PROTO pBlockIn:DWORD,pBlockOut:DWORD
RC5Decrypt    PROTO pBlockIn:DWORD,pBlockOut:DWORD
RC6Init       PROTO :DWORD,:DWORD
RC6Encrypt    PROTO pBlockIn:DWORD,pBlockOut:DWORD
RC6Decrypt    PROTO pBlockIn:DWORD,pBlockOut:DWORD
XTEAInit	proto :DWORD,:DWORD
XTEAEncrypt	proto :DWORD,:DWORD
XTEADecrypt	proto :DWORD,:DWORD
RijndaelInit proto :DWORD,:DWORD
RijndaelEncrypt	proto :DWORD,:DWORD 
RijndaelDecrypt	proto :DWORD,:DWORD
ThreeWayInit    proto :DWORD
ThreeWayEncrypt proto :DWORD,:DWORD
ThreeWayDecrypt proto :DWORD,:DWORD
TEAInit	proto :DWORD
TEAEncrypt	proto :DWORD,:DWORD
TEADecrypt	proto :DWORD,:DWORD
BlowfishInit proto :DWORD,:DWORD
BlowfishEncrypt	proto :DWORD,:DWORD 
BlowfishDecrypt	proto :DWORD,:DWORD
Misty1Init proto :DWORD
Misty1Decrypt proto :DWORD,:DWORD
Misty1Encrypt proto :DWORD,:DWORD
q128Init proto :DWORD
q128Decrypt proto :DWORD,:DWORD
q128Encrypt proto :DWORD,:DWORD
mmbDecrypt proto :DWORD,:DWORD,:DWORD
mmbEncrypt proto :DWORD,:DWORD,:DWORD
ScopInit	proto	:DWORD,:DWORD
ScopEncrypt	proto	:DWORD,:DWORD,:DWORD
ScopDecrypt	proto	:DWORD,:DWORD,:DWORD

; CHECKSUMS
; =========

INIT_CRC32 equ 0
INIT_CRC16 equ 0
INIT_ADLER32 equ 1
CRC32 proto :DWORD,:DWORD,:DWORD; init dwCRC = 0
; for RCRC32 Data must be Readable/Writeable
RCRC32 proto pData:dword,dwDataLen:dword,dwOffset:dword,dwWantCrc:dword; reverse CRC32
CRC16 proto lpBuffer:DWORD,dwBufLen:DWORD,dwCRC:DWORD; init dwCRC = 0
Adler32 proto lpBuffer:DWORD,dwBufLen:DWORD,dwAdler:DWORD; init dwAdler = 1

; HASHES
; ======

MD5_DIGESTSIZE equ 128
MD4_DIGESTSIZE equ 128
MD2_DIGESTSIZE equ 128
RMD128_DIGESTSIZE equ 128
RMD160_DIGESTSIZE equ 160
RMD256_DIGESTSIZE equ 256
RMD320_DIGESTSIZE equ 320
SHA0_DIGESTSIZE equ 160
SHA1_DIGESTSIZE equ 160
SHA256_DIGESTSIZE equ 256
SHA384_DIGESTSIZE equ 384
SHA512_DIGESTSIZE equ 512
WHIRLPOOL_DIGESTSIZE equ 512
TIGER_DIGESTSIZE equ 192

MD5Init proto
MD5Update proto lpBuffer:DWORD,dwBufLen:DWORD
MD5Final proto
MD4Init proto
MD4Update proto lpBuffer:DWORD,dwBufLen:DWORD
MD4Final proto
MD2Init proto
MD2Update proto lpBuffer:DWORD,dwBufLen:DWORD
MD2Final proto
RMD128Init proto
RMD128Update proto lpBuffer:DWORD,dwBufLen:DWORD
RMD128Final proto
RMD160Init proto
RMD160Update proto lpBuffer:DWORD,dwBufLen:DWORD
RMD160Final proto
RMD256Init proto
RMD256Update proto lpBuffer:DWORD,dwBufLen:DWORD
RMD256Final proto
RMD320Init proto
RMD320Update proto lpBuffer:DWORD,dwBufLen:DWORD
RMD320Final proto
SHA0Init proto
SHA0Update proto lpBuffer:DWORD,dwBufLen:DWORD
SHA0Final proto
SHA1Init proto
SHA1Update proto lpBuffer:DWORD,dwBufLen:DWORD
SHA1Final proto
SHA256Init proto
SHA256Update proto lpBuffer:DWORD,dwBufLen:DWORD
SHA256Final proto
SHA384Init proto
SHA384Update proto lpBuffer:DWORD,dwBufLen:DWORD
SHA384Final proto
SHA512Init proto
SHA512Update proto lpBuffer:DWORD,dwBufLen:DWORD
SHA512Final proto
WhirlpoolInit proto
WhirlpoolUpdate proto lpBuffer:DWORD,dwBufLen:DWORD
WhirlpoolFinal proto
TigerInit proto
TigerUpdate proto lpBuffer:DWORD,dwBufLen:DWORD
TigerFinal proto
HavalInit proto DigestSizeBits:DWORD,Passes:DWORD ; variable digest & passes !!!
HavalUpdate proto lpBuffer:DWORD,dwBufLen:DWORD
HavalFinal proto

; TEXT UTILS
; ==========

include Generators/random.asm
include Generators/MWC.asm
include Generators/CMWC.asm
;include Generators/MillerRabin.asm


include BigNum/bnbase.asm
include BigNum/bnio.asm
include BigNum/bnmodarith.asm
include BigNum/bnmonty.asm
include BigNum/bnprimes.asm
include BigNum/bignum.asm
include BigNum/bnlib.inc
include BigNum/bignum.inc


;include ecdsa128/gfp.inc
;include ecdsa128/gfp.asm
;include ecdsa128/ecp.inc
;include ecdsa128/ecp.asm

include textformats/hexencode.asm
include textformats/hexdecode.asm
include textformats/Base2Decode.asm
include textformats/Base2Encode.asm
include textformats/Base64Decode.asm
include textformats/Base64Encode.asm


include checksums/adler32.asm
include checksums/crc16.asm
include checksums/crc32.asm
include checksums/rcrc32.asm

include Hashes/haval.asm
include Hashes/md2.asm
include Hashes/md4.asm
include Hashes/md5.asm

include Hashes/rmd128.asm
include Hashes/rmd160.asm
include Hashes/rmd256.asm
include Hashes/rmd320.asm

include Hashes/sha0.asm
include Hashes/sha1.asm
include Hashes/sha256.asm
include Hashes/sha384.asm
include Hashes/sha512.asm

include Hashes/tiger.asm
;include Hashes/whirlpool.asm



include ciphers/cipher.asm
include ciphers/RSA.asm
include ciphers/elgamal.asm
include ciphers/des.asm
include ciphers/rc2.asm
include ciphers/rc4.asm
include ciphers/rc5.asm
include ciphers/rc6.asm
include ciphers/rijndael.asm 
include ciphers/tea.asm 
include ciphers/twofish.asm 
include ciphers/xtea.asm 
include ciphers/misty1.asm 
include ciphers/q128.asm 
include ciphers/mmb.asm 
include ciphers/scop.asm 