% show_growth_irf.m -- open the TFP-growth-shock panels (irf_growth for model_T2_0 and model_T2_1) as docked tabs.
% Usage:  D:\matlab\bin\matlab.exe -sd D:\CCProjects\dsge -r show_growth_irf
here = fileparts(mfilename('fullpath')); cd(here);
set(0, 'DefaultFigureWindowStyle', 'docked');
try, enableservice('AutomationServer', true); catch, end   % lets an outside script push commands into this session
MODEL = 'model_T2_0'; irf_growth
MODEL = 'model_T2_1'; irf_growth
nfig = numel(findall(0, 'Type', 'figure'));
fprintf('\n=== %d figures open (docked tabs) ===\n', nfig);
fid = fopen(fullfile(tempdir, 'dsge_show_growth_irf.done'), 'w'); fprintf(fid, '%d figures\n', nfig); fclose(fid);
