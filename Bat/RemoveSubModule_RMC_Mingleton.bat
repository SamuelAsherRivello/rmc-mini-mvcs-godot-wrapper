@echo off

REM ========================================================
REM Set custom values
REM ========================================================
set SubmodulePluginName=RMC Mingleton

REM Call the internal script
call _RemoveSubmodule_Internal.bat "%SubmodulePluginName%"

pause