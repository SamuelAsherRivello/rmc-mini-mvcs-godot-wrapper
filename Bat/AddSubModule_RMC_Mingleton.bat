@echo off

REM ========================================================
REM Set custom values
REM ========================================================
set SubmodulePluginName=RMC Mingleton
set SubmoduleGitUrl=https://github.com/SamuelAsherRivello/rmc-mingleton-godot.git

REM Call the internal script
call _AddSubmodule_Internal.bat "%SubmodulePluginName%" "%SubmoduleGitUrl%"

pause
