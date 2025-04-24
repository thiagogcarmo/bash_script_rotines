@echo off
setlocal

set "arquivo_lista_inicial=%temp%\rede_conhecida.txt"
set "intervalo=60" rem Intervalo em segundos para verificar a rede

echo Monitorando a rede... Pressione Ctrl+C para interromper.

:loop
echo Verificando dispositivos na rede...
arp -a | findstr /V "Interface" | findstr /V "enderecos" | findstr /V "^$" > "%temp%\rede_atual.txt"

if not exist "%arquivo_lista_inicial%" (
    echo Criando lista inicial de dispositivos...
    copy "%temp%\rede_atual.txt" "%arquivo_lista_inicial%" > nul
    echo Lista inicial salva.
) else (
    echo Comparando lista atual com a lista anterior...
    for /f "tokens=1-3" %%a in ('type "%temp%\rede_atual.txt"') do (
        set "ip_atual=%%a"
        set "mac_atual=%%b"
        set "tipo_atual=%%c"

        findstr /c:"%mac_atual%" "%arquivo_lista_inicial%" > nul
        if errorlevel 1 (
            echo *** NOVO DISPOSITIVO DETECTADO! ***
            echo IP: %ip_atual%
            echo MAC: %mac_atual%
            echo Tipo: %tipo_atual%
            echo Data/Hora: %date% %time%
            echo.

            :: Linha opcional para adicionar o novo dispositivo à lista conhecida
            echo %ip_atual% %mac_atual% %tipo_atual% >> "%arquivo_lista_inicial%"
        )
    )
)

del "%temp%\rede_atual.txt"

timeout /t %intervalo% /nobreak > nul
goto :loop

endlocal