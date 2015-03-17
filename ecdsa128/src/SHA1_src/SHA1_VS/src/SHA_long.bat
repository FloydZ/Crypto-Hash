g:\masm32\bin\ml /coff /c /Cp /Gz SHA_long.asm
g:\masm32\bin\Link /SUBSYSTEM:CONSOLE SHA_long.obj ..\lib\sha1.lib ..\lib\utils.lib
pause
del *.obj
pause
SHA_long.exe
pause