% run_model_T2_0.m -- run model_T2_0.mod with the bundled Dynare 5.4 (MATLAB only).
% Usage in MATLAB:  cd D:\CCProjects\dsge;  run_model_T2_0
here = fileparts(mfilename('fullpath'));
addpath(fullfile(here, 'dynare-5.4', 'matlab'));
cd(here);
dynare model_T2_0
