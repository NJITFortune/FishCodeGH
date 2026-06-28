function out = spikeJointSelectivity(curfish, fishNo, neuronNo, shifty)
% out = spikeJointSelectivity(curfish, fishNo, neuronNo, shifty)
%
% Joint Selectivity Index (JSI): spike-conditioned EV-FA Pearson correlation.
%
%   JSI(tau_EV, tau_FA) = corr( EV(t_spike - tau_EV),  FA(t_spike + tau_FA) )
%                         computed across all spikes
%
% JSI > 0  (compensatory):     the EV that drives spikes predicts same-sign FA.
% JSI < 0  (anti-compensatory):the EV that drives spikes predicts opposite-sign FA.
%
% DSI and mutual information are sign-agnostic: they measure the magnitude of
% tuning to each signal independently and cannot distinguish compensatory from
% anti-compensatory neurons.  JSI measures the JOINT SIGN relationship directly.
%
% Inputs:
%   curfish  - data struct from ismailCompleatFinal2024.mat
%   fishNo   - fish index
%   neuronNo - neuron code
%   shifty   - [tau_EV, tau_FA] in seconds (same convention as smitaPlot).
%              Used as the fixed lag when sweeping the other axis, and as
%              the point reported in jsiFixed.  Pass [] for [0, 0].
%
% Output fields:
%   dels          - delay vector for 1D sweeps (s)
%   jsiEV         - JSI vs EV lag, FA fixed at shifty(2)   [nDels x 1]
%   jsiFA         - JSI vs FA lag, EV fixed at shifty(1)   [nDels x 1]
%   jsiEV_rand    - shuffle mean of jsiEV                  [nDels x 1]
%   jsiFA_rand    - shuffle mean of jsiFA                  [nDels x 1]
%   jsiEV_randStd - shuffle SD of jsiEV                    [nDels x 1]
%   jsiFA_randStd - shuffle SD of jsiFA                    [nDels x 1]
%   dels2d        - delay vector for 2D map (coarser, s)
%   jsiMap        - 2D JSI map [nDels2d x nDels2d]
%                   rows = EV lag, cols = FA lag
%   jsiFixed      - scalar JSI at (shifty(1), shifty(2))
%   evAtSpikes    - EV values at spike times at shifty(1)
%   faAtSpikes    - FA values at spike times at shifty(2)

if nargin < 4 || isempty(shifty), shifty = [0 0]; end

nShuffles = 200;
dels      = (0 : 0.025 : 1.00)';   % causal only: EV before spike, FA after spike
dels2d    = (0 : 0.05  : 1.00)';
nDels     = length(dels);
nDels2d   = length(dels2d);

%% ---- Extract data -------------------------------------------------------
dataList_NeuronsDurationComments;
fishName = fishNames{fishNo};

spiketimes = curfish(fishNo).spikes.times(curfish(fishNo).spikes.codes == neuronNo);
tim        = curfish(fishNo).time(:);
errVel     = curfish(fishNo).error_vel(:);
fishAcc    = curfish(fishNo).fish_acc(:);

nSpk      = numel(spiketimes);
TotalTime = tim(end) - tim(1);
tauEV = shifty(1);
tauFA = shifty(2);
if tauEV < 0
    warning('spikeJointSelectivity: tauEV=%.3f s is negative — EV would follow the spike (non-causal). Set tauEV >= 0.', tauEV);
end
if tauFA < 0
    warning('spikeJointSelectivity: tauFA=%.3f s is negative — FA would precede the spike (non-causal). Set tauFA >= 0.', tauFA);
end

fprintf('spikeJointSelectivity — Fish %d (%s), neuron %d\n', fishNo, fishName, neuronNo);
fprintf('  n=%d spikes  %.0f s  %.2f Hz  |  tauEV=%.3f s  tauFA=%.3f s\n', ...
    nSpk, max(tim), nSpk/max(tim), tauEV, tauFA);

%% ---- Signal matrices at spike times for all 1D delays ------------------
% EV_mat(:,j) = EV sampled at spiketimes - dels(j)
% FA_mat(:,j) = FA sampled at spiketimes + dels(j)
EV_mat = zeros(nSpk, nDels);
FA_mat = zeros(nSpk, nDels);
for j = 1:nDels
    EV_mat(:,j) = interp1(tim, errVel,  spiketimes - dels(j), 'linear', 'extrap');
    FA_mat(:,j) = interp1(tim, fishAcc, spiketimes + dels(j), 'linear', 'extrap');
end

% Fixed-lag signals for cross-sweeps and the scalar JSI
ev_fixed = interp1(tim, errVel,  spiketimes - tauEV, 'linear', 'extrap');
fa_fixed = interp1(tim, fishAcc, spiketimes + tauFA, 'linear', 'extrap');

%% ---- 1D JSI sweeps (vectorised corr) -----------------------------------
% Sweep EV lag with FA fixed: jsiEV(j) = corr(EV_mat(:,j), fa_fixed)
jsiEV = corr(EV_mat, fa_fixed(:));    % [nDels x 1]

% Sweep FA lag with EV fixed: jsiFA(j) = corr(FA_mat(:,j), ev_fixed)
jsiFA = corr(FA_mat, ev_fixed(:));    % [nDels x 1]

% Scalar JSI at the specified lags
jsiFixed = corr(ev_fixed(:), fa_fixed(:));
fprintf('  JSI at specified lags: r = %.4f  (%s)\n', jsiFixed, ...
    ternary(jsiFixed > 0, 'compensatory', 'anti-compensatory'));

%% ---- 2D JSI map (matrix multiply on normalised matrices) ---------------
EV_mat2d = zeros(nSpk, nDels2d);
FA_mat2d = zeros(nSpk, nDels2d);
for j = 1:nDels2d
    EV_mat2d(:,j) = interp1(tim, errVel,  spiketimes - dels2d(j), 'linear', 'extrap');
    FA_mat2d(:,j) = interp1(tim, fishAcc, spiketimes + dels2d(j), 'linear', 'extrap');
end

% Normalise columns to zero-mean / unit-variance → product gives correlation
ev_norm2d = (EV_mat2d - mean(EV_mat2d,1)) ./ std(EV_mat2d,[],1);
fa_norm2d = (FA_mat2d - mean(FA_mat2d,1)) ./ std(FA_mat2d,[],1);
jsiMap    = (ev_norm2d' * fa_norm2d) / (nSpk - 1);  % [nDels2d x nDels2d]

%% ---- Shuffle baseline for 1D sweeps ------------------------------------
jsiEV_shuff = zeros(nDels, nShuffles);
jsiFA_shuff = zeros(nDels, nShuffles);

for s = 1:nShuffles
    shiftAmt = rand * TotalTime;
    spkS     = mod(spiketimes + shiftAmt - tim(1), TotalTime) + tim(1);

    EV_S = zeros(nSpk, nDels);
    FA_S = zeros(nSpk, nDels);
    for j = 1:nDels
        EV_S(:,j) = interp1(tim, errVel,  spkS - dels(j), 'linear', 'extrap');
        FA_S(:,j) = interp1(tim, fishAcc, spkS + dels(j), 'linear', 'extrap');
    end

    fa_S_fixed = interp1(tim, fishAcc, spkS + tauFA, 'linear', 'extrap');
    ev_S_fixed = interp1(tim, errVel,  spkS - tauEV, 'linear', 'extrap');

    jsiEV_shuff(:,s) = corr(EV_S, fa_S_fixed(:));
    jsiFA_shuff(:,s) = corr(FA_S, ev_S_fixed(:));
end

jsiEV_rand    = mean(jsiEV_shuff, 2);
jsiFA_rand    = mean(jsiFA_shuff, 2);
jsiEV_randStd = std(jsiEV_shuff, [], 2);
jsiFA_randStd = std(jsiFA_shuff, [], 2);

%% ---- FIGURE -------------------------------------------------------------
colSh  = [0.75 0.75 0.75];
colPos = [0.85 0.15 0.10];   % red  (compensatory)
colNeg = [0.15 0.35 0.80];   % blue (anti-compensatory)

figure('Units', 'inches', 'Position', [0.5 0.5 10 9], ...
    'PaperOrientation', 'portrait', 'PaperUnits', 'inches', ...
    'PaperSize', [8.5 11], 'PaperPosition', [0.5 0.5 7.5 10]);

annotation('textbox', [0 0.94 1 0.06], ...
    'String', sprintf('Joint Selectivity Index  |  Fish %d — %s — Neuron %d   (n=%d spikes, %.0f s, %.2f Hz)', ...
        fishNo, fishName, neuronNo, nSpk, max(tim), nSpk/max(tim)), ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
    'FontSize', 12, 'FontWeight', 'bold', 'EdgeColor', 'none');

%% Panel 1 — JSI vs EV lag  (FA fixed at tauFA)
% Plot against -dels so x = 0 is spike time and negative x is EV in the past.
subplot(2, 2, 1);
shadeRegion(-dels, jsiEV_rand, jsiEV_randStd, colSh);
hold on;
plot(-dels, jsiEV_rand, '--', 'Color', colSh*0.55, 'LineWidth', 1.5);
plot(-dels, jsiEV, 'k-', 'LineWidth', 2.5);
plot([0 0],    [-1 1], 'k:', 'LineWidth', 0.75);
plot([-1 0],   [0 0],  'k:', 'LineWidth', 0.75);
xline(-tauEV, 'r--', 'LineWidth', 1.5, 'Label', sprintf('  fixed %.2f s', tauEV));
ylim([-1 1]);
xlim([-1 0])
xlabel('Time relative to spike (s)   ← EV precedes spike | spike = 0');
ylabel('JSI  (Pearson r)');
title(sprintf('JSI vs EV lag   (FA fixed at +%.2f s)', tauFA));
legend({'shuffle ±1SD', 'shuffle mean', 'data'}, 'Location', 'best', 'FontSize', 8);

%% Panel 2 — JSI vs FA lag  (EV fixed at tauEV)
subplot(2, 2, 2);
shadeRegion(dels, jsiFA_rand, jsiFA_randStd, colSh);
hold on;
plot(dels, jsiFA_rand, '--', 'Color', colSh*0.55, 'LineWidth', 1.5);
plot(dels, jsiFA, 'k-', 'LineWidth', 2.5);
plot([0 0],  [-1 1], 'k:', 'LineWidth', 0.75);
plot([-1 1], [0 0],  'k:', 'LineWidth', 0.75);
xline(tauFA, 'r--', 'LineWidth', 1.5, 'Label', sprintf('  fixed %.2f s', tauFA));
ylim([-1 1]);
xlim([0 1])
xlabel('FA lag \tau_{FA} (s)   [spike precedes FA →]');
ylabel('JSI  (Pearson r)');
title(sprintf('JSI vs FA lag   (EV fixed at %.2f s)', tauEV));
legend({'shuffle ±1SD', 'shuffle mean', 'data'}, 'Location', 'best', 'FontSize', 8);

%% Panel 3 — 2D JSI map
subplot(2, 2, 3);
imagesc(-dels2d, dels2d, jsiMap');
axis xy;
colormap(gca, bwrmap(256));
clim([-1 1] * max(abs(jsiMap(:))));
colorbar;
hold on;
plot(xlim, [0 0], 'k-', 'LineWidth', 0.75);
plot([0 0], ylim, 'k-', 'LineWidth', 0.75);
plot(-tauEV, tauFA, 'k+', 'MarkerSize', 12, 'LineWidth', 2);
xlabel('Time of EV relative to spike (s)   ← past | spike = 0');
ylabel('FA lag \tau_{FA} (s)   [spike precedes FA →]');
title(sprintf('2D JSI map   (+) = compensatory\nscalar JSI at (+) = %.3f', jsiFixed));

%% Panel 4 — Scatter of (EV, FA) at spike times at specified lags
subplot(2, 2, 4);
sameSign = (ev_fixed > 0 & fa_fixed > 0) | (ev_fixed < 0 & fa_fixed < 0);
scatter(ev_fixed(sameSign),  fa_fixed(sameSign),  20, colPos, 'filled', 'MarkerFaceAlpha', 0.5);
hold on;
scatter(ev_fixed(~sameSign), fa_fixed(~sameSign), 20, colNeg, 'filled', 'MarkerFaceAlpha', 0.5);
plot(xlim, [0 0], 'k-', 'LineWidth', 0.75);
plot([0 0], ylim, 'k-', 'LineWidth', 0.75);
b = polyfit(ev_fixed(:), fa_fixed(:), 1);
xfit = linspace(min(ev_fixed), max(ev_fixed), 50);
plot(xfit, polyval(b, xfit), 'k-', 'LineWidth', 2);
xlabel(sprintf('EV at spike time  (lag %.2f s)', tauEV));
ylabel(sprintf('FA at spike time  (lag %.2f s)', tauFA));
title(sprintf('EV vs FA at spikes   r = %.3f  (%s)', ...
    jsiFixed, ternary(jsiFixed > 0, 'compensatory', 'anti-compensatory')));
legend({sprintf('same sign (%d)', sum(sameSign)), ...
        sprintf('opp sign  (%d)', sum(~sameSign))}, ...
    'Location', 'best', 'FontSize', 8);

%% ---- Output struct ------------------------------------------------------
out.dels          = dels;
out.jsiEV         = jsiEV;
out.jsiFA         = jsiFA;
out.jsiEV_rand    = jsiEV_rand;
out.jsiFA_rand    = jsiFA_rand;
out.jsiEV_randStd = jsiEV_randStd;
out.jsiFA_randStd = jsiFA_randStd;
out.dels2d        = dels2d;
out.jsiMap        = jsiMap;
out.jsiFixed      = jsiFixed;
out.evAtSpikes    = ev_fixed;
out.faAtSpikes    = fa_fixed;

end  % spikeJointSelectivity


%% ========================================================================
function shadeRegion(x, mu, sigma, col)
x  = x(:);
lo = mu(:) - sigma(:);
hi = mu(:) + sigma(:);
patch([x; flipud(x)], [hi; flipud(lo)], col, ...
    'EdgeColor', 'none', 'FaceAlpha', 0.55);
end

function C = bwrmap(m)
% Blue-white-red diverging colormap centered at zero.
if nargin < 1, m = 256; end
h = floor(m/2);
r = [linspace(0,1,h)',  ones(m-h,1)];
g = [linspace(0,1,h)',  linspace(1,0,m-h)'];
b = [ones(h,1),         linspace(1,0,m-h)'];
C = [r(:), g(:), b(:)];
end

function s = ternary(cond, a, b)
if cond, s = a; else, s = b; end
end
