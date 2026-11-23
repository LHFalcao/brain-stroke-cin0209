@echo off
REM ============================================================
REM  Publica o repositorio usando apenas o git.
REM  ANTES de rodar: crie o repositorio VAZIO no site do GitHub
REM  (sem README, sem .gitignore, sem licenca) e copie a URL.
REM  Rode este arquivo DE DENTRO da pasta repo_github.
REM ============================================================

setlocal

cd /d "%~dp0"

where git >nul 2>&1 || (echo ERRO: git nao encontrado no PATH. & pause & exit /b 1)

echo.
set /p USUARIO=Seu usuario do GitHub:
set /p REPO=Nome do repositorio (ex: brain-stroke-cin0209):

echo.
echo [1/4] Iniciando o repositorio local...
git init -b main
git add .
git commit -m "Projeto de classificacao Brain Stroke: notebooks, relatorio e slides"
if errorlevel 1 (
  echo.
  echo ERRO no commit. Se a mensagem acima pedir nome e email, rode:
  echo    git config --global user.name  "Seu Nome"
  echo    git config --global user.email "seu@email.com"
  pause & exit /b 1
)

echo.
echo [2/4] Apontando para o GitHub...
git remote remove origin 2>nul
git remote add origin https://github.com/%USUARIO%/%REPO%.git

echo.
echo [3/4] Enviando...
echo  (o git vai abrir uma janela pedindo login do GitHub)
git push -u origin main
if errorlevel 1 (
  echo.
  echo ERRO ao enviar. Causas comuns:
  echo  - o repositorio no GitHub nao esta vazio
  echo  - o nome do usuario ou do repositorio esta errado
  echo  - a autenticacao falhou
  pause & exit /b 1
)

echo.
echo [4/4] Pronto.
git remote -v
start https://github.com/%USUARIO%/%REPO%

endlocal
pause
