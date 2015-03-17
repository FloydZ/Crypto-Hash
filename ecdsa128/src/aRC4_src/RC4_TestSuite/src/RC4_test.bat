g:\masm32\bin\ml /coff /c /Cp /Gz RC4_test.asm
g:\masm32\bin\Link /SUBSYSTEM:CONSOLE RC4_test.obj ..\lib\rc4.lib ..\lib\utils.lib
pause
del *.obj