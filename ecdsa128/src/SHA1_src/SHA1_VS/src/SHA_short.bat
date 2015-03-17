g:\masm32\bin\ml /coff /c /Cp /Gz SHA_short.asm
g:\masm32\bin\Link /SUBSYSTEM:CONSOLE SHA_short.obj ..\lib\sha1.lib ..\lib\utils.lib
pause
del *.obj
pause
SHA_short.exe
pause