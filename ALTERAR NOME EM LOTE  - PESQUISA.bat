@echo off
setlocal EnableDelayedExpansion
for %%f in (*.pdf) do (
    set "nome_original=%%f"
    set "novo_nome=PESQUISA - %%f"
    ren "%%f" "!novo_nome!"
)
echo Processo de renomeação concluído.
pause
endlocal