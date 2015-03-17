SHA1 Validation System is a test suite prepared to informally verify
the correctness of a SHA1 algorithm implementation.

SHA_short.exe	- The Short Messages Test for Byte-Oriented Implementations,
		requires SHA1ShortMsg.txt
SHA_long.exe	- The Selected Long Messages Test for Byte-Oriented
		Implementations, requires SHA1LongMsg.txt
SHA_test.exe	- The Pseudorandomly Generated Messages Test (comparable with
		SHA1Monte.txt)

All tests are compiled with SHA-1 Library version 1.0
[SHA1(sha1.lib)		= EBC3 8F52 3416 85A6 6C64  71D7 8D8F 6904 D265 E8CB].
It also uses utils.lib
[SHA1(utils.lib)	= 6CC7 9E61 0CF1 E0FF 64C2  8B7C C9C4 13A0 A1FB 25F3].



Additional infomations about SHA available at : http://csrc.nist.gov