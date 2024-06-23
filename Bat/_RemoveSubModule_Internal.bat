@echo off

REM ========================================================
REM Check for proper arguments
REM ========================================================
if "%~1"=="" (
    echo Do not call this bat directly.
    pause
    exit /b
)

REM ========================================================
REM Read passed parameters
REM ========================================================
set SubmodulePluginName=%1

REM Navigate to the project root directory
echo ========================================================
echo Navigating to project root directory
echo ========================================================
cd /d %~dp0\..

REM Deinitialize the submodule
echo ========================================================
echo Deinitializing submodule %SubmodulePluginName%
echo ========================================================
git submodule deinit -f "Godot\addons\%SubmodulePluginName%" 2>nul

REM Remove the submodule
echo ========================================================
echo Removing submodule %SubmodulePluginName%
echo ========================================================
git rm -f "Godot\addons\%SubmodulePluginName%" 2>nul

REM Remove the submodule's .git directory
echo ========================================================
echo Removing submodule's .git directory
echo ========================================================
rmdir /s /q ".git\modules\Godot\addons\%SubmodulePluginName%" 2>nul

REM Remove the remaining files
echo ========================================================
echo Removing remaining files
echo ========================================================
rmdir /s /q "Godot\addons\%SubmodulePluginName%" 2>nul

REM Remove the empty submodule directory
echo ========================================================
echo Removing empty submodule directory
echo ========================================================
rmdir /s /q "Godot\addons\%SubmodulePluginName%" 2>nul

echo ========================================================
echo Submodule removed successfully
echo ========================================================
pause
