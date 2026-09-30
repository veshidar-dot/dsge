% irf_persist.m -- 3x3 IRF panel for the er_R shock, two persistence values overlaid
% (red: nu1_R = 0, blue: nu1_R = 0.9), same layout as the lecture figure.
% Usage (Octave/MATLAB, from D:\CCProjects\dsge):  irf_persist
here = fileparts(mfilename('fullpath')); cd(here);
addpath(fullfile(here, 'dynare-5.4', 'matlab'));
dynare model_T2_0 nograph noclearall nopreprocessoroutput
options_.periods = 0; options_.nograph = 1; options_.noprint = 1; options_.irf = 15;
iR = strmatch('nu1_R', M_.param_names, 'exact');
SH = 'er_R';
VVV = {'zzobs_dPC','infl';'zzobs_dY','GDP growth';'zzobs_RH','interest rate';'y_D','output-gap';'w_H','wage';'l_H','labor';'a_H','assets';'m_H','money';'limda_PF','lagrange=MC'};
NU = [0 0.9]; COL = {'r', 'b'};
IRF = cell(1, numel(NU));
for k = 1:numel(NU)
    M_.params(iR) = NU(k);
    [info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, []);
    IRF{k} = oo_.irfs;
end
disp('plot IRF');
figure('Name', ['IRF to ' SH ': nu1_R = 0 (red) vs 0.9 (blue)'], 'Position', [100 80 960 720], ...
    'PaperUnits', 'inches', 'PaperPosition', [0 0 12 9]);
for i = 1:9
    subplot(3,3,i); hold on;
    for k = 1:numel(NU)
        x = IRF{k}.([VVV{i,1} '_' SH]);
        plot(1:15, x(1:15), COL{k}, 'LineWidth', 1.5);
    end
    plot(1:15, zeros(1,15), 'k:'); hold off; xlim([1 15]);
    title(VVV{i,2}, 'Interpreter', 'none'); set(gca, 'FontSize', 9);
    if i == 2, legend({['nu1_R=' num2str(NU(1))], ['nu1_R=' num2str(NU(2))]}, 'Interpreter', 'none', 'Location', 'northeast'); end
end
annotation('textbox', [0 0.95 1 0.05], 'String', ['Shock ' SH ' (+1 s.d.): red nu1_R = 0, blue nu1_R = 0.9'], ...
    'HorizontalAlignment', 'center', 'EdgeColor', 'none', 'FontWeight', 'bold', 'Interpreter', 'none');
print(gcf, '-dpng', '-r100', fullfile(here, 'model_T2_0', 'graphs', 'irf_er_R_persistence.png'));
disp('saved: model_T2_0/graphs/irf_er_R_persistence.png');
