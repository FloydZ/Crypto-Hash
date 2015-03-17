g:\masm32\bin\ml /coff /c /Cp /Gz SHA_test.asm
g:\masm32\bin\Link /SUBSYSTEM:CONSOLE SHA_test.obj ..\lib\sha1.lib
pause
del *.obj
pause
SHA_test.exe
pause