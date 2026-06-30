@echo off
setlocal

set "OPENSCAD=C:\Program Files\OpenSCAD\openscad.com"
set "SCAD_FILE=%~dp0custom_drive_shield_sign.scad"
set "OUTPUT_DIR=%~dp0..\..\out\custom_drive_shield_sign_parts"

if not exist "%OPENSCAD%" (
  echo OpenSCAD not found: "%OPENSCAD%"
  exit /b 1
)

if not exist "%SCAD_FILE%" (
  echo SCAD file not found: "%SCAD_FILE%"
  exit /b 1
)

if not exist "%OUTPUT_DIR%" (
  mkdir "%OUTPUT_DIR%"
)

call :export_part gold_base
if errorlevel 1 exit /b 1

call :export_part lower_dark_panel
if errorlevel 1 exit /b 1

call :export_part top_text
if errorlevel 1 exit /b 1

call :export_part lower_text
if errorlevel 1 exit /b 1

echo Done. STL files are in "%OUTPUT_DIR%".
exit /b 0

:export_part
set "PART_NAME=%~1"
echo Exporting %PART_NAME%.stl
"%OPENSCAD%" -o "%OUTPUT_DIR%\%PART_NAME%.stl" -Dpart=\"%PART_NAME%\" "%SCAD_FILE%"
if errorlevel 1 exit /b 1
exit /b 0
