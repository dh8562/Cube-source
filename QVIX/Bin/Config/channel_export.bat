@echo off
pushd "%~dp0"
chanexp.exe "S_" "defsysinfo.csv" "..\..\Src\uSysServer.inc"
chanexp.exe "J_" "defjobinfo.csv" "..\..\Src\uJobServer.inc"
chanexp.exe "S_" "iochannels.csv" "virtualchannels.csv" "DIOchannels.csv" "..\..\Src\uIOServer.inc"
chanexp.exe "R_" "..\Recipes\defrecipe.csv" "..\..\Src\uRecipeServer.inc"
chanexp.exe "S_" "defstatistics.csv" "..\..\Src\uStsServer.inc"
call "%~dp0channel_sync.bat"
popd
