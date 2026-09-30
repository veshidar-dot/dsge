% exp_debt.m -- three experiments on the debt/tax block (MATLAB R2023b + Dynare 5.4, batch).
%  A. model_T2_0 vs model_T2_nb (a_H and the household budget constraint removed): are core IRFs identical?
%  B. model_T2_1 grid: steady-state inflation (via nu0_R) x gama_taxA -> SS, BK, std, IRFs of tax and a_H
%  C. model_T2_1 with gama_trA = 0: minimal gama_taxA that keeps debt stable (bisection on BK), at each SS inflation
here = 'D:\CCProjects\dsge'; cd(here); addpath(fullfile(here, 'dynare-5.4', 'matlab'));
fprintf('MATLAB %s, Dynare %s\n', version, dynare_version);

%% ---------------- A ----------------
fprintf('\n#### A. model_T2_0 vs model_T2_nb (no bonds, no budget constraint)\n');
dynare model_T2_0 noclearall nograph nopreprocessoroutput
A0.irf = oo_.irfs; A0.ev = oo_.dr.eigval; A0.ys = oo_.dr.ys; A0.names = M_.endo_names; A0.nfwrd = M_.nsfwrd;
dynare model_T2_nb noclearall nograph nopreprocessoroutput
A1.irf = oo_.irfs; A1.ev = oo_.dr.eigval; A1.ys = oo_.dr.ys; A1.names = M_.endo_names; A1.nfwrd = M_.nsfwrd;
fprintf('\n[A] eigenvalues |.|>1 : T2_0 = %d (jumpers %d) | T2_nb = %d (jumpers %d)\n', ...
    sum(abs(A0.ev) > 1), A0.nfwrd, sum(abs(A1.ev) > 1), A1.nfwrd);
fprintf('[A] finite eigenvalues T2_0 : %s\n', mat2str(sort(abs(A0.ev(isfinite(A0.ev))))', 4));
fprintf('[A] finite eigenvalues T2_nb: %s\n', mat2str(sort(abs(A1.ev(isfinite(A1.ev))))', 4));
% steady state of common variables
dss = 0;
for k = 1:numel(A1.names)
    i0 = find(strcmp(A0.names, A1.names{k}));
    dss = max(dss, abs(A0.ys(i0) - A1.ys(k)));
end
fprintf('[A] max |SS diff| over %d common variables = %.3e\n', numel(A1.names), dss);
% IRFs of common variables, per shock
f1 = fieldnames(A1.irf); shocks = {'er_R', 'er_YF', 'er_teta_F', 'er_tr', 'er_trY'};
for s = 1:numel(shocks)
    d = 0; worst = ''; n = 0; dtr = 0;
    for k = 1:numel(f1)
        if endsWith(f1{k}, ['_' shocks{s}]) && isfield(A0.irf, f1{k})
            dk = max(abs(A0.irf.(f1{k}) - A1.irf.(f1{k})));
            if startsWith(f1{k}, 'tr_H_'), dtr = dk; continue; end   % tr_H rule was changed on purpose
            n = n + 1;
            if dk > d, d = dk; worst = f1{k}; end
        end
    end
    fprintf('[A] shock %-9s : max |IRF diff| over %2d variables (all but tr_H) = %.3e (worst %s); tr_H itself differs by %.3e\n', shocks{s}, n, d, worst, dtr);
end
fprintf('[A] size(oo_.dr.eigval) in this Dynare build = %s (row vector => BK-failure branch of dyn_first_order_solver crashes)\n', mat2str(size(A1.ev)));
% what the removed block looked like in T2_0
fprintf('[A] T2_0 a_H IRF to er_R (t=1,12,40): %s ; tr_H: %s\n', ...
    mat2str(A0.irf.a_H_er_R([1 12 40]), 4), mat2str(A0.irf.tr_H_er_R([1 12 40]), 4));

%% ---------------- B ----------------
fprintf('\n#### B. model_T2_1: steady-state inflation x gama_taxA\n');
dynare model_T2_1 noclearall nograph nopreprocessoroutput
iR = strmatch('nu0_R', M_.param_names, 'exact'); iTA = strmatch('gama_taxA', M_.param_names, 'exact');
iTR = strmatch('gama_trA', M_.param_names, 'exact'); ibb = strmatch('bbb', M_.param_names, 'exact');
ig = strmatch('nu0_trY', M_.param_names, 'exact');
p0 = M_.params;
iv = @(n) find(strcmp(M_.endo_names, n));
vt = iv('tax'); va = iv('a_H'); vp = iv('p'); vr = iv('r_H'); vm = iv('m_H'); vw = iv('w_H'); vl = iv('l_H'); vtr = iv('tr_H');
options_.nograph = 1; options_.noprint = 1; options_.nocorr = 1; options_.nodecomposition = 1; options_.nofunctions = 1;
options_.irf = 40; options_.periods = 200; options_.drop = 50;
piA = [-4 0 4 10 20];                 % annual inflation, %
pm = log(1 + piA/100)/12;             % monthly log inflation (model is monthly: zzobs_RH = exp(12 r)-1)
nu0R = pm - p0(ibb) + p0(ig);         % Fisher in SS: p = nu0_R + bbb - nu0_trY
gTA = [0 0.001 0.005 0.02];
B = struct('piA', {}, 'gTA', {}, 'info', {}, 'ys', {}, 'sd', {}, 'irf', {});
fprintf('%6s %7s | %8s %8s %8s %8s %8s | %8s %8s %8s | %s\n', 'pi_a%', 'gTA', 'p_SS', 'r_SS', 'a_H_SS', 'm_H_SS', 'wl_SS', 'sd(tax)', 'sd(a_H)', 'sd(p)', 'tax->er_R t=1/12/40   a_H->er_R t=1/12/40   tax->er_tr t=1/12/40');
for i = 1:numel(nu0R)
    for j = 1:numel(gTA)
        M_.params = p0; M_.params(iR) = nu0R(i); M_.params(iTA) = gTA(j);
        set_dynare_seed('default');
        [info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, []);
        r = struct('piA', piA(i), 'gTA', gTA(j), 'info', info(1), 'ys', [], 'sd', [], 'irf', []);
        if info(1) ~= 0
            fprintf('%6g %7.3f | info = %d (%s)\n', piA(i), gTA(j), info(1), get_error_message(info, options_));
        else
            ys = oo_.dr.ys; Y = oo_.endo_simul(:, options_.drop+1:end); sd = std(Y, 0, 2);
            r.ys = ys; r.sd = sd; r.irf = oo_.irfs;
            fprintf('%6g %7.3f | %8.5f %8.5f %8.3f %8.3f %8.4f | %8.4f %8.3f %8.4f | %s  %s  %s\n', piA(i), gTA(j), ...
                ys(vp), ys(vr), ys(va), ys(vm), exp(ys(vw) + ys(vl)), sd(vt), sd(va), sd(vp), ...
                mat2str(oo_.irfs.tax_er_R([1 12 40]), 3), mat2str(oo_.irfs.a_H_er_R([1 12 40]), 3), mat2str(oo_.irfs.tax_er_tr([1 12 40]), 3));
        end
        B(end+1) = r; %#ok<SAGROW>
    end
end

%% ---------------- C ----------------
fprintf('\n#### C. model_T2_1 with gama_trA = 0: minimal gama_taxA for a stable (BK) solution, by SS inflation\n');
options_.periods = 0; options_.irf = 0;
thr = nan(size(nu0R));
for i = 1:numel(nu0R)
    M_.params = p0; M_.params(iR) = nu0R(i); M_.params(iTR) = 0;
    ok0 = bk_ok(M_, options_, oo_, iTA, 0); ok1 = bk_ok(M_, options_, oo_, iTA, 1);
    if ok0 || ~ok1
        fprintf('pi=%3g%%: no bracket (stable at 0: %d, stable at 1: %d)\n', piA(i), ok0, ok1); continue;
    end
    lo = 0; hi = 1;
    for it = 1:24
        mid = (lo + hi)/2;
        if bk_ok(M_, options_, oo_, iTA, mid), hi = mid; else, lo = mid; end
    end
    thr(i) = hi;
    rB = B(([B.piA] == piA(i)) & ([B.gTA] == 0)); ys = rB.ys; wl = exp(ys(vw) + ys(vl)); rr = ys(vr);
    pred = (exp(-p0(ibb)) - 1) / (exp(rr) * wl);    % long-run debt root e^{-bbb}/(1+e^r*wl*gTA) < 1
    % price of that stabilisation: std(tax) at 1.5 x threshold (transfers off)
    options_.periods = 200; options_.irf = 40;
    M_.params(iTA) = 1.5*thr(i); set_dynare_seed('default');
    [info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, []);
    Y = oo_.endo_simul(:, options_.drop+1:end); sd = std(Y, 0, 2);
    fprintf('pi=%3g%%: threshold gama_taxA = %.4f  (analytic long-run prediction %.4f, wl=%.4f, r=%.4f); at 1.5x threshold: sd(tax)=%.3f, sd(a_H)=%.2f, sd(p)=%.4f, min/max tax in sim = %.2f/%.2f\n', ...
        piA(i), thr(i), pred, wl, rr, sd(vt), sd(va), sd(vp), min(Y(vt,:)), max(Y(vt,:)));
    options_.periods = 0; options_.irf = 0;
end
% and the transfer rule's own margin for comparison (gama_taxA = 0): minimal |gama_trA|
M_.params = p0; M_.params(iTA) = 0;
lo = 0; hi = 1;
for it = 1:24
    mid = (lo + hi)/2;
    if bk_ok(M_, options_, oo_, iTR, -mid), hi = mid; else, lo = mid; end
end
fprintf('for comparison, transfers alone (gama_taxA = 0, pi = 0): minimal |gama_trA| = %.4f (model default 0.1)\n', hi);

%% ---------------- figure ----------------
fig = figure('Visible', 'off', 'Position', [100 100 1000 700]); T = 40; cols = lines(numel(piA));
subplot(2,2,1); hold on;
for i = 1:numel(piA), r = B(([B.piA] == piA(i)) & ([B.gTA] == 0.001)); if ~isempty(r.irf), plot(1:T, r.irf.tax_er_R(1:T), 'Color', cols(i,:), 'LineWidth', 1.4); end; end
title('tax -> er_R (+1 s.d.), gama_taxA = 0.001, by SS inflation', 'Interpreter', 'none'); legend(arrayfun(@(x) sprintf('%g%%/yr', x), piA, 'UniformOutput', false)); grid on;
subplot(2,2,2); hold on;
for i = 1:numel(piA), r = B(([B.piA] == piA(i)) & ([B.gTA] == 0.001)); if ~isempty(r.irf), plot(1:T, r.irf.a_H_er_R(1:T), 'Color', cols(i,:), 'LineWidth', 1.4); end; end
title('a_H -> er_R, gama_taxA = 0.001, by SS inflation', 'Interpreter', 'none'); grid on;
cols2 = lines(numel(gTA));
subplot(2,2,3); hold on;
for j = 1:numel(gTA), r = B(([B.piA] == 0) & ([B.gTA] == gTA(j))); if ~isempty(r.irf), plot(1:T, r.irf.tax_er_tr(1:T), 'Color', cols2(j,:), 'LineWidth', 1.4); end; end
title('tax -> er_tr (+1 s.d. transfers), pi = 0, by gama_taxA', 'Interpreter', 'none'); legend(arrayfun(@(x) sprintf('gTA=%g', x), gTA, 'UniformOutput', false)); grid on;
subplot(2,2,4); hold on;
for j = 1:numel(gTA), r = B(([B.piA] == 0) & ([B.gTA] == gTA(j))); if ~isempty(r.irf), plot(1:T, r.irf.a_H_er_tr(1:T), 'Color', cols2(j,:), 'LineWidth', 1.4); end; end
title('a_H -> er_tr, pi = 0, by gama_taxA', 'Interpreter', 'none'); grid on;
sgtitle('model_T2_1: tax/debt block vs steady-state inflation and tax reaction coefficient', 'Interpreter', 'none');
out = fullfile(here, 'model_T2_1', 'graphs', 'tax_debt_vs_ss_inflation.png');
print(fig, '-dpng', '-r90', out); fprintf('saved: %s\n', out);
save(fullfile(here, 'model_T2_1', 'Output', 'exp_debt_results.mat'), 'A0', 'A1', 'B', 'thr', 'piA', 'gTA', 'nu0R');
fprintf('\n#### done\n');

function ok = bk_ok(M_, options_, oo_, ip, val)
    M_.params(ip) = val;
    try
        [~, info] = resol(0, M_, options_, oo_); code = info(1);
    catch ME
        % the patched ("moe") dyn_first_order_solver crashes at `info(2) = temp'*temp` instead of
        % returning info(1) = 3/4 when the BK count is violated; that branch is only reached when nba ~= nsfwrd
        if strcmp(ME.stack(1).name, 'dyn_first_order_solver')
            code = 3;
        else
            rethrow(ME);
        end
    end
    ok = (code == 0);
end
