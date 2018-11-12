@echo off
cd /d %~dp0
if not exist bin mkdir bin
pushd asm
beebasm -i main.basm -o ..\bin\CH_EGG.bin
IF ERRORLEVEL 1 (
  popd
) ELSE (
  popd
  comp /M bin\CH_EGG.bin src\CH_EGG.bin
  pushd asm
  beebasm -do ..\bin\chuckie.ssd -o CHUCKIE -boot CHUCKIE -title Chuckie -i main.basm
  popd
)
