@echo off
REM ============================================================
REM  Publica o repositorio usando o GitHub CLI (gh).
REM  Pre-requisitos: git e gh instalados, e "gh auth login" feito.
REM  Rode este arquivo DE DENTRO da pasta repo_github.
REM ============================================================

setlocal

REM --- ajuste estes dois valores se quiser ---
set REPO=brain-stroke-cin0209
set VISIBILIDADE=--public
REM  para repositorio privado, troque a linha acima por:  set VISIBILIDADE=--private

cd /d "%~dp0"

echo.
echo [1/5] Conferindo ferramentas...
where git >nul 2>&1 || (echo ERRO: git nao encontrado no PATH. & pause & exit /b 1)
where gh  >nul 2>&1 || (echo ERRO: gh nao encontrado. Instale o GitHub CLI. & pause & exit /b 1)

gh auth status >nul 2>&1 || (
  echo.
  echo Voce ainda nao esta autenticado. Rodando "gh auth login"...
  gh auth login || (echo ERRO na autenticacao. & pause & exit /b 1)
)

echo.
echo [2/5] Iniciando o repositorio local...
git init -b main
git add .
git -c user.useConfigOnly=false commit -m "Projeto de classificacao Brain Stroke: notebooks, relatorio e slides"
if errorlevel 1 (
  echo.
  echo ERRO no commit. Se a mensagem acima pedir nome e email, rode:
  echo    git config --global user.name  "Seu Nome"
  echo    git config --global user.email "seu@email.com"
  pause & exit /b 1
)

echo.
echo [3/5] Criando o repositorio no GitHub e enviando...
gh repo create %REPO% %VISIBILIDADE% --source=. --remote=origin --push ^
  --description "Projeto pratico de classificacao - CIN0209 Aprendizado de Maquina 1, CIn/UFPE"
if errorlevel 1 (echo ERRO ao criar/enviar. & pause & exit /b 1)

echo.
echo [4/5] Conferindo...
git remote -v
git log --oneline -1

echo.
echo [5/5] Pronto. Abrindo no navegador...
gh repo view --web

endlocal
pause
