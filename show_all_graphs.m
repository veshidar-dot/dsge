% show_all_graphs.m -- open every graph of the project as docked figure tabs in the MATLAB desktop.
% Usage:  D:\matlab\bin\matlab.exe -sd D:\CCProjects\dsge -r show_all_graphs
%   1. Dynare IRFs of model_T2_0 (7 figures) and model_T2_1 (18 figures)
%   2. irf_persist: er_R shock with nu1_R = 0 vs 0.9 (1 figure; re-runs model_T2_0 with nograph)
%   3. plot_pf: perfect-foresight path of model_T2_pf (1 figure)
%   4. tax/debt block vs steady-state inflation from exp_debt results (1 figure)
here = fileparts(mfilename('fullpath')); cd(here);
addpath(fullfile(here, 'dynare-5.4', 'matlab'));
set(0, 'DefaultFigureWindowStyle', 'docked');   % all figures as tabs in the desktop window

dynare model_T2_0 noclearall nopreprocessoroutput
dynare model_T2_1 noclearall nopreprocessoroutput
irf_persist
plot_pf

% 4. tax/debt block (same panel as exp_debt.m, from saved results)
R = load(fullfile(here, 'model_T2_1', 'Output', 'exp_debt_results.mat'), 'B', 'piA', 'gTA');
B = R.B; piA = R.piA; gTA = R.gTA; T = 40; cols = lines(numel(piA)); cols2 = lines(numel(gTA));
figure('Name', 'model_T2_1: tax/debt vs SS inflation');
subplot(2,2,1); hold on;
for i = 1:numel(piA), r = B(([B.piA] == piA(i)) & ([B.gTA] == 0.001)); if ~isempty(r.irf), plot(1:T, r.irf.tax_er_R(1:T), 'Color', cols(i,:), 'LineWidth', 1.4); end; end
title('tax -> er_R (+1 s.d.), gama_taxA = 0.001, by SS inflation', 'Interpreter', 'none'); legend(arrayfun(@(x) sprintf('%g%%/yr', x), piA, 'UniformOutput', false)); grid on;
subplot(2,2,2); hold on;
for i = 1:numel(piA), r = B(([B.piA] == piA(i)) & ([B.gTA] == 0.001)); if ~isempty(r.irf), plot(1:T, r.irf.a_H_er_R(1:T), 'Color', cols(i,:), 'LineWidth', 1.4); end; end
title('a_H -> er_R, gama_taxA = 0.001, by SS inflation', 'Interpreter', 'none'); grid on;
subplot(2,2,3); hold on;
for j = 1:numel(gTA), r = B(([B.piA] == 0) & ([B.gTA] == gTA(j))); if ~isempty(r.irf), plot(1:T, r.irf.tax_er_tr(1:T), 'Color', cols2(j,:), 'LineWidth', 1.4); end; end
title('tax -> er_tr (+1 s.d. transfers), pi = 0, by gama_taxA', 'Interpreter', 'none'); legend(arrayfun(@(x) sprintf('gTA=%g', x), gTA, 'UniformOutput', false)); grid on;
subplot(2,2,4); hold on;
for j = 1:numel(gTA), r = B(([B.piA] == 0) & ([B.gTA] == gTA(j))); if ~isempty(r.irf), plot(1:T, r.irf.a_H_er_tr(1:T), 'Color', cols2(j,:), 'LineWidth', 1.4); end; end
title('a_H -> er_tr, pi = 0, by gama_taxA', 'Interpreter', 'none'); grid on;
sgtitle('model_T2_1: tax/debt block vs steady-state inflation and tax reaction coefficient', 'Interpreter', 'none');

nfig = numel(findall(0, 'Type', 'figure'));
fprintf('\n=== %d figures open (docked tabs). Use the figure tab bar or Window menu to browse. ===\n', nfig);
fid = fopen(fullfile(tempdir, 'dsge_show_all_graphs.done'), 'w'); fprintf(fid, '%d figures\n', nfig); fclose(fid);
