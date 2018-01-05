@echo off
cd "No tiene un respiro"\dev
call make.bat
copy *.tap ..\..
cd ..\..
cd "Devuelve el zafiro"\dev
call make.bat
copy *.tap ..\..
cd ..\..
cd "En el bosque del suspiro"\dev
call make.bat
copy *.tap ..\..
cd ..\..
echo DONE!
