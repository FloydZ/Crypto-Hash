g:\masm32\bin\ml /c /coff ecdsa128dll.asm
g:\masm32\bin\cvtres /machine:ix86 version.res
g:\masm32\bin\link /DLL /DEF:ecdsa128dll.def ecdsa128dll.obj version.obj ..\..\lib\*.lib /OUT:ecdsa128.dll
del *.obj
del *.exp
pause
