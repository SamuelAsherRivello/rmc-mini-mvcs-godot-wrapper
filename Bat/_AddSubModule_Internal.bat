@echo off

REM ========================================================
REM Check for proper arguments
REM ========================================================
if "%~1"=="" (
    echo Do not call this bat directly.
    pause
    exit /b
)
if "%~2"=="" (
    echo Do not call this bat directly.
    pause
    exit /b
)

REM ========================================================
REM Read passed parameters
REM ========================================================
set SubmodulePluginName=%~1
set SubmoduleGitUrl=%~2

REM Navigate to the project root directory
echo ========================================================
echo Navigating to project root directory
echo ========================================================
cd /d "%~dp0\.."

REM Ensure addons directory exists
echo ========================================================
echo Ensuring addons directory exists
echo ========================================================
if not exist "Godot\addons" mkdir "Godot\addons"

REM Temporarily disable sparse-checkout
echo ========================================================
echo Temporarily disabling sparse-checkout
echo ========================================================
git sparse-checkout disable

REM Remove any existing submodule remnants
echo ========================================================
echo Removing existing submodule remnants
echo ========================================================
git submodule deinit -f "Godot\addons\%SubmodulePluginName%" 2>nul
git rm -f "Godot\addons\%SubmodulePluginName%" 2>nul
rmdir /s /q ".git\modules\Godot\addons\%SubmodulePluginName%" 2>nul
rmdir /s /q "Godot\addons\%SubmodulePluginName%" 2>nul

REM Add the submodule
echo ========================================================
echo Adding submodule "%SubmodulePluginName%"
echo
