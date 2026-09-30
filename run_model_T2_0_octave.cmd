@echo off
rem Run model_T2_0.mod with the patched Dynare 5.4 under portable GNU Octave 8.1.0 (console, no graphs).
rem Extra Dynare options can be passed as arguments, e.g.:  run_model_T2_0_octave.cmd nostrict
set OCTAVE=D:\Octave\octave-8.1.0-w64\mingw64\bin\octave-cli.exe
cd /d "%~dp0"
"%OCTAVE%" --no-gui --eval "addpath('%~dp0dynare-5.4\matlab'); dynare model_T2_0 nograph %*"
