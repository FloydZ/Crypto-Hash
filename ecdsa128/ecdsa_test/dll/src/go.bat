@echo off
set file=ecdsa_test
g:\masm32\bin\rc dialog.rc
g:\masm32\bin\cvtres /machine:ix86 dialog.res
g:\masm32\bin\ml /coff /c /Cp /Gz %file%.asm
g:\masm32\bin\Link /SUBSYSTEM:WINDOWS %file%.obj dialog.obj ..\..\..\rel\dll\ecdsa128.lib
del *.obj
pause