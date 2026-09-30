% plot_pf.m -- 3x3 panel of the perfect-foresight path from model_T2_pf results (permanent +1% productivity).
% Usage (MATLAB/Octave, from D:\CCProjects\dsge, after `dynare model_T2_pf`):  plot_pf
here = fileparts(mfilename('fullpath')); cd(here);
S = load(fullfile(here, 'model_T2_pf', 'Output', 'model_T2_pf_results.mat'));
X = S.oo_.endo_simul; names = S.M_.endo_names;
T = 60;
vars = {'z_YF','productivity z_YF (0 -> 0.01)';'y_D','output y_D';'c_H','consumption c_H'; ...
        'l_H','labor l_H';'w_H','wage w_H';'p','inflation p'; ...
        'r_H','policy rate r_H';'a_H','assets a_H';'tr_H','transfers tr_H'};
figure('Name', 'model_T2_pf: perfect foresight, permanent +1% productivity', 'Position', [100 100 960 720]);
for i = 1:9
    subplot(3, 3, i);
    x = X(strcmp(names, vars{i,1}), 1:T+1);
    plot(0:T, x, 'b', 'LineWidth', 1.5); hold on;
    plot(0:T, x(1) * ones(1, T+1), 'k:'); plot(0:T, x(end) * ones(1, T+1), 'r:'); hold off;
    xlim([0 T]); title(vars{i,2}, 'Interpreter', 'none'); set(gca, 'FontSize', 9);
end
sgtitle('model_T2_pf: perfect foresight, permanent +1% productivity; dotted = old (black) / new (red) steady state; 400 periods solved, 60 shown', 'Interpreter', 'none', 'FontSize', 10);
out = fullfile(here, 'model_T2_pf', 'graphs', 'pf_permanent_productivity_plus1pct.png');
print(gcf, '-dpng', '-r90', out);
fprintf('saved: %s\n', out);
