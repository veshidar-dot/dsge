@echo off
rem Run a .mod with the bundled (patched) Dynare 5.4 under MATLAB R2023b, batch mode (no desktop, no dialogs).
rem Usage:  run_model_matlab.cmd model_T2_0 [dynare options]      e.g.  run_model_matlab.cmd model_T2_1 nograph
rem Output: console + <model>_matlab.log next to the .mod; Dynare's own <model>.log / <model>\Output\ as usual.
set MATLAB=D:\matlab\bin\matlab.exe
cd /d "%~dp0"
if "%~1"=="" (echo usage: %~nx0 model_name [dynare options] & exit /b 2)
"%MATLAB%" -batch "addpath('%~dp0dynare-5.4\matlab'); dynare %*" -logfile "%~dp0%~1_matlab.log"
