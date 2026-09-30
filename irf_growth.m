% irf_growth.m -- IRF panel for the TFP trend-growth shock er_trY (z_ztemp_growth = z_trY),
% two persistence values overlaid: red nu1_trY = 0 (model default, one-off growth blip),
% blue nu1_trY = 0.9 (persistent growth acceleration). Same idea as irf_persist.m for er_R.
% Usage (MATLAB/Octave, from D:\CCProjects\dsge):
%   irf_growth                       % model_T2_0
%   MODEL = 'model_T2_1'; irf_growth % any model with these variables
if ~exist('MODEL', 'var'), MODEL = 'model_T2_0'; end
here = fileparts(mfilename('fullpath')); cd(here);
addpath(fullfile(here, 'dynare-5.4', 'matlab'));
dynare(MODEL, 'nograph', 'noclearall', 'nopreprocessoroutput');
options_.periods = 0; options_.nograph = 1; options_.noprint = 1; options_.irf = 40;
options_.nomoments = 1; options_.nocorr = 1; options_.nodecomposition = 1; options_.nofunctions = 1;
iP = strmatch('nu1_trY', M_.param_names, 'exact');
SH = 'er_trY'; H = 40;
VVV = {'z_ztemp_growth', 'TFP trend growth (shock)'; 'zzobs_dY', 'GDP growth'; 'zzobs_dPC', 'inflation'; ...
       'zzobs_RH', 'interest rate, % p.a.'; 'y_D', 'output (detrended)'; 'c_H', 'consumption'; ...
       'l_H', 'labor'; 'w_H', 'wage'; 'limda_PF', 'lagrange = MC'; ...
       'a_H', 'assets'; 'tr_H', 'transfers'; 'm_H', 'money'};
if any(strcmp(M_.endo_names, 'tax')), VVV(end+1, :) = {'tax', 'tax rate'}; end
NU = [0 0.9]; COL = {'r', 'b'};
IRF = cell(1, numel(NU));
for k = 1:numel(NU)
    M_.params(iP) = NU(k);
    [info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, []);
    if info(1) ~= 0, error('stoch_simul failed, info = %d', info(1)); end
    IRF{k} = oo_.irfs;
end
% console table: impact and peak response
fprintf('\n%s, shock %s (+1 s.d. = %.3f): impact (t=1) and max |response| over %d periods\n', MODEL, SH, sqrt(M_.Sigma_e(strcmp(M_.exo_names, SH), strcmp(M_.exo_names, SH))), H);
fprintf('%-16s | %12s %12s | %12s %12s\n', 'variable', 'nu1=0: t=1', 'nu1=0: peak', 'nu1=0.9: t=1', 'nu1=0.9: peak');
for i = 1:size(VVV, 1)
    x0 = IRF{1}.([VVV{i,1} '_' SH]); x1 = IRF{2}.([VVV{i,1} '_' SH]);
    [~, j0] = max(abs(x0(1:H))); [~, j1] = max(abs(x1(1:H)));
    fprintf('%-16s | %12.4g %12.4g | %12.4g %12.4g\n', VVV{i,1}, x0(1), x0(j0), x1(1), x1(j1));
end
% figure
n = size(VVV, 1); nc = 4; nr = ceil(n / nc);
figure('Name', [MODEL ': IRF to ' SH ' (TFP growth), nu1_trY = 0 (red) vs 0.9 (blue)'], 'Position', [80 60 1100 260*nr], ...
    'PaperUnits', 'inches', 'PaperPosition', [0 0 13 3.2*nr]);
for i = 1:n
    subplot(nr, nc, i); hold on;
    for k = 1:numel(NU)
        x = IRF{k}.([VVV{i,1} '_' SH]);
        plot(1:H, x(1:H), COL{k}, 'LineWidth', 1.5);
    end
    plot(1:H, zeros(1, H), 'k:'); hold off; xlim([1 H]);
    title(VVV{i,2}, 'Interpreter', 'none'); set(gca, 'FontSize', 9);
    if i == 1, legend({['nu1_trY=' num2str(NU(1))], ['nu1_trY=' num2str(NU(2))]}, 'Interpreter', 'none', 'Location', 'northeast'); end
end
annotation('textbox', [0 0.955 1 0.045], 'String', [MODEL ': shock ' SH ' (+1 s.d. to TFP trend growth): red nu1_trY = 0 (one-off), blue nu1_trY = 0.9 (persistent)'], ...
    'HorizontalAlignment', 'center', 'EdgeColor', 'none', 'FontWeight', 'bold', 'Interpreter', 'none');
out = fullfile(here, MODEL, 'graphs', 'irf_er_trY_growth_persistence.png');
print(gcf, '-dpng', '-r100', out);
fprintf('saved: %s\n', out);
