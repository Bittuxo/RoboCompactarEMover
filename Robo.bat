@echo OFF

REM Difinição de variaveis

REM variavel que vai ser o contador
set ID=0 

REM variavel qie vai ser o nome do que você deseja saber se existe
set CL=champs

REM comando para definir o 7zip como compactador
set sevenzip=
if "%sevenzip%"=="" if exist "%ProgramFiles%\7-zip\7z.exe" set sevenzip=%ProgramFiles%\7-zip\7z.exe
if "%sevenzip%"=="" echo 7-zip not found&pause&exit
set extension=.txt

REM lugar onde vai ser gerado o log para averiguar o que foi executado
set LogFile=E:\Temp\deucerto.log

REM Compactar arquivos e mover para pasta desejada e deletar os que ficam na pasta ondem foi efetuado a compactação após mover os arquivos compactados

FOR /r "E:\Temp\Teste" %%a IN (*%extension%) DO "%sevenzip%" a "%%~na.7z" "%%a"
move /y "E:\Temp\RoboCompactarMover\*.7z" E:\Temp\TesteMover
del /q E:\Temp\Teste\

REM chama a função verificar
Call :Verificar


REM Verifica se foi feito o backup

:Verificar

IF %ID% EQU 0 ( IF EXIST "E:\Temp\TesteMover\champs.7z" ( call :TemBackup >> %LogFile%) ELSE ( call :NaoTemBackup >> %LogFile%) )
IF %ID% EQU 1 ( IF EXIST "E:\Temp\TesteMover\feiradafruta.7z" ( call :TemBackup >> %LogFile%) ELSE ( call :NaoTemBackup >> %LogFile%) )


exit 

REM Adiciona +1 ao contador
:ID+1
Set /A ID=ID+1
Call :Verificar
exit

REM caso não tenha backup ele chama esta função e envia e-mail
:NaoTemBackup
echo Não Tem Backup 
SwithMail.exe /s /from "e-mail da qual conta vai enviar os e-mails" /name "nome" /pass "senha do e-mail" /server "smtp.live.com" /p "587" /SSL /to "para quem vai enviar o e-mail" /sub "titulo" /b "mensagem"
Call :ID+1
exit

REM Se tem backup chama essa função
:TemBackup
echo Tem Backup
Call :ID+1
exit
