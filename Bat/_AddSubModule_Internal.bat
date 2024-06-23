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
echo ========================================================
git submodule add "%SubmoduleGitUrl%" "Godot\addons\%SubmodulePluginName%"

REM Navigate to the submodule directory
echo ========================================================
echo Navigating to submodule directory
echo ========================================================
cd "Godot\addons\%SubmodulePluginName%"

REM Enable sparse-checkout for the submodule
echo ========================================================
echo Enabling sparse-checkout for the submodule
echo ========================================================
git sparse-checkout init --cone
git sparse-checkout set "addons/%SubmodulePluginName%"

REM Update the submodule
echo ========================================================
echo Updating submodule
echo ========================================================
git submodule update --init --recursive

REM Move the contents to the correct location
echo ========================================================
echo Moving contents to the correct location
echo ========================================================
cd /d "%~dp0\.."
xcopy "Godot\addons\%SubmodulePluginName%\addons\%SubmodulePluginName%\*" "Godot\addons\%SubmodulePluginName%\" /E /H /K >nul

REM Remove the redundant directories
echo ========================================================
echo Removing redundant directories
echo ========================================================
rmdir /s /q "Godot\addons\%SubmodulePluginName%\addons" 2>nul

REM Navigate back to the root directory
echo ========================================================
echo Navigating back to the root directory
echo ========================================================
cd /d "%~dp0\.."

REM Re-enable sparse-checkout for the main repository
echo ========================================================
echo Re-enabling sparse-checkout for the main repository
echo ========================================================
git sparse-checkout init --cone
git sparse-checkout reapply 2>nul

REM Ensure cleanup of any leftover files
echo ========================================================
echo Additional cleanup
echo ========================================================
if exist "Godot\icon.svg.import" del /f "Godot\icon.svg.import"

echo ========================================================
echo Submodule added and configured successfully
echo ========================================================
pause
