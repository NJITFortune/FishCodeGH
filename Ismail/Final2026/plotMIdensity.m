function out = plotMIdensity(curfish, fishNo, neuronNo, shifty, params)
% out = plotMIdensity(curfish, fishNo, neuronNo, shifty, params)
%
% Mutual information density vs. frequency for spike train vs. error
% velocity and vs. fish acceleration.
%
% Method (Sadeghi et al., J Neurosci 2007; Chacron / Cullen group):
%   Spectral coherence between the binary spike train and each signal is
%   computed with Welch's method, then converted to MI density:
%
%       MI_density(f)  =  -log2(1 - C²(f))     [bits / Hz]
%       MI_total       =  sum(MI_density) * df  [bits / s]
%
%   where C²(f) is the ordinary magnitude-squared coherence.  A circular-
%   shift shuffle baseline is computed to correct for finite-sample bias.
%
% Inputs:
%   curfish   - data struct from ismailCompleatFinal2024.mat
%   fishNo    - fish index
%   neuronNo  - neuron code
%   shifty    - [spikeShift_EV, spikeShift_FA] in seconds (same convention
%               as smitaPlot); pass [] for no shift
%   params    - optional struct with any of:
%       .windowSec   - Welch segment length in seconds   (default 5)
%       .overlapFrac - fractional segment overlap         (default 0.5)
%       .maxFreq     - upper frequency limit to plot (Hz) (default 10)
%       .nShuffles   - circular shuffles for bias baseline(default 100)
%
% Output struct fields:
%   f, CohEV, CohFA,
%   miEV, miFA,               (raw MI density, bits/Hz)
%   miEV_corr, miFA_corr,     (bias-corrected, clamped >= 0)
%   shuffleMeanEV/FA, shuffleStdEV/FA,
%   totalMI_EV, totalMI_FA,   (integrated bits/s)
%   cumMI_EV, cumMI_FA        (cumulative bits/s vs frequency)

if nargin < 4 || isempty(shifty), shifty = [0 0]; end
if nargin < 5,                    params = struct(); end

windowSec   = pget(params, 'windowSec',   5);
overlapFrac = pget(params, 'overlapFrac', 0.5);
maxFreq     = pget(params, 'maxFreq',     10);
nShuffles   = pget(params, 'nShuffles',   100);

%% ---- Extract data -------------------------------------------------------
dataList_NeuronsDurationComments;
fishName = fishNames{fishNo};

spiketimes = curfish(fishNo).spikes.times(curfish(fishNo).spikes.codes == neuronNo);
tim        = curfish(fishNo).time;
errVel     = curfish(fishNo).error_vel;
fishAcc    = curfish(fishNo).fish_acc;

spikeShift_EV = shifty(1);
spikeShift_FA = shifty(2);

%% ---- Binary spike train at signal resolution ----------------------------
dt = median(diff(tim));
fs = 1 / dt;
edges    = [tim(:); tim(end) + dt];
spkTrain = histcounts(spiketimes, edges)';   % Nx1 column

%% ---- Apply temporal lags to signals (matches smitaPlot convention) ------
shiftedEV = interp1(tim, errVel,  tim - spikeShift_EV, 'linear', 'extrap');
shiftedFA = interp1(tim, fishAcc, tim + spikeShift_FA, 'linear', 'extrap');

%% ---- Welch parameters ---------------------------------------------------
winSamp     = round(windowSec * fs);
overlapSamp = round(winSamp * overlapFrac);
nfft        = 2^nextpow2(winSamp);
win         = hanning(winSamp);

nSeg = floor((length(tim) - overlapSamp) / (winSamp - overlapSamp));
fprintf('MI density — fs=%.1f Hz | window=%.1f s | %d segments | df=%.3f Hz\n', ...
    fs, windowSec, nSeg, fs / nfft);

%% ---- Coherence (data) ---------------------------------------------------
[CohEV, f] = mscohere(spkTrain, shiftedEV(:), win, overlapSamp, nfft, fs);
[CohFA, ~] = mscohere(spkTrain, shiftedFA(:), win, overlapSamp, nfft, fs);

% Restrict to requested frequency range
fIdx  = f >= 0 & f <= maxFreq;
f     = f(fIdx);
CohEV = min(CohEV(fIdx), 1 - 1e-9);
CohFA = min(CohFA(fIdx), 1 - 1e-9);
df    = f(2) - f(1);

miEV = -log2(1 - CohEV);
miFA = -log2(1 - CohFA);

%% ---- Shuffle baseline (circular shifts preserve ISI structure) ----------
nF           = sum(fIdx);
N            = length(spkTrain);
shuffMI_EV   = zeros(nF, nShuffles);
shuffMI_FA   = zeros(nF, nShuffles);

for s = 1:nShuffles
    spkShuff = circshift(spkTrain, round(rand * N));

    [c1, ~] = mscohere(spkShuff, shiftedEV(:), win, overlapSamp, nfft, fs);
    [c2, ~] = mscohere(spkShuff, shiftedFA(:), win, overlapSamp, nfft, fs);

    shuffMI_EV(:, s) = -log2(1 - min(c1(fIdx), 1 - 1e-9));
    shuffMI_FA(:, s) = -log2(1 - min(c2(fIdx), 1 - 1e-9));
end

shuffMeanEV = mean(shuffMI_EV, 2);
shuffMeanFA = mean(shuffMI_FA, 2);
shuffStdEV  = std(shuffMI_EV,  [], 2);
shuffStdFA  = std(shuffMI_FA,  [], 2);

%% ---- Bias-corrected MI density (subtract shuffle mean, clamp ≥ 0) ------
miEV_corr = max(miEV - shuffMeanEV, 0);
miFA_corr = max(miFA - shuffMeanFA, 0);

totalMI_EV = sum(miEV_corr) * df;
totalMI_FA = sum(miFA_corr) * df;

cumMI_EV = cumsum(miEV_corr) * df;
cumMI_FA = cumsum(miFA_corr) * df;

%% ---- FIGURE -------------------------------------------------------------
colEV = [0.20 0.45 0.75];
colFA = [0.85 0.33 0.10];
colSh = [0.75 0.75 0.75];

figure('Units', 'inches', 'Position', [0.5 1 9 7.5], ...
    'PaperOrientation', 'landscape', 'PaperUnits', 'inches', ...
    'PaperSize', [11 8.5], 'PaperPosition', [0 0 11 8.5]);

annotation('textbox', [0 0.93 1 0.07], ...
    'String', sprintf('MI Density  |  Fish %d — %s — Neuron %d   (n=%d spikes, %.0f s, %.2f Hz)', ...
        fishNo, fishName, neuronNo, numel(spiketimes), max(tim), numel(spiketimes)/max(tim)), ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
    'FontSize', 12, 'FontWeight', 'bold', 'EdgeColor', 'none');

%% Panel 1 — EV: raw MI density with shuffle
subplot(2, 2, 1);
shadeRegion(f, shuffMeanEV, shuffStdEV, colSh);
hold on;
plot(f, shuffMeanEV, '--', 'Color', colSh * 0.55, 'LineWidth', 1.5);
plot(f, miEV, 'Color', colEV, 'LineWidth', 2.5);
xlabel('Frequency (Hz)');
ylabel('MI density (bits/Hz)');
title(sprintf('Error Velocity   raw MI'));
legend({'shuffle ±1 SD', 'shuffle mean', 'data'}, 'Location', 'best', 'FontSize', 9);
xlim([0 maxFreq]);

%% Panel 2 — FA: raw MI density with shuffle
subplot(2, 2, 2);
shadeRegion(f, shuffMeanFA, shuffStdFA, colSh);
hold on;
plot(f, shuffMeanFA, '--', 'Color', colSh * 0.55, 'LineWidth', 1.5);
plot(f, miFA, 'Color', colFA, 'LineWidth', 2.5);
xlabel('Frequency (Hz)');
ylabel('MI density (bits/Hz)');
title(sprintf('Fish Acceleration   raw MI'));
legend({'shuffle ±1 SD', 'shuffle mean', 'data'}, 'Location', 'best', 'FontSize', 9);
xlim([0 maxFreq]);

%% Panel 3 — Bias-corrected MI density, both signals
subplot(2, 2, 3);
plot(f, miEV_corr, 'Color', colEV, 'LineWidth', 2.5); hold on;
plot(f, miFA_corr, 'Color', colFA, 'LineWidth', 2.5);
plot([0 maxFreq], [0 0], 'k-', 'LineWidth', 0.75);
xlabel('Frequency (Hz)');
ylabel('Corrected MI density (bits/Hz)');
title('Bias-corrected MI density');
legend({sprintf('EV  %.4f bits/s', totalMI_EV), ...
        sprintf('FA  %.4f bits/s', totalMI_FA)}, ...
       'Location', 'best');
xlim([0 maxFreq]);

%% Panel 4 — Cumulative MI rate
subplot(2, 2, 4);
plot(f, cumMI_EV, 'Color', colEV, 'LineWidth', 2.5); hold on;
plot(f, cumMI_FA, 'Color', colFA, 'LineWidth', 2.5);
xlabel('Frequency (Hz)');
ylabel('Cumulative MI (bits/s)');
title('Cumulative MI rate');
legend({sprintf('EV  %.4f bits/s total', totalMI_EV), ...
        sprintf('FA  %.4f bits/s total', totalMI_FA)}, ...
       'Location', 'best');
xlim([0 maxFreq]);

%% ---- Output struct ------------------------------------------------------
out.f           = f;
out.CohEV       = CohEV;
out.CohFA       = CohFA;
out.miEV        = miEV;
out.miFA        = miFA;
out.miEV_corr   = miEV_corr;
out.miFA_corr   = miFA_corr;
out.shuffMeanEV = shuffMeanEV;
out.shuffMeanFA = shuffMeanFA;
out.shuffStdEV  = shuffStdEV;
out.shuffStdFA  = shuffStdFA;
out.totalMI_EV  = totalMI_EV;
out.totalMI_FA  = totalMI_FA;
out.cumMI_EV    = cumMI_EV;
out.cumMI_FA    = cumMI_FA;

end  % plotMIdensity


%% ========================================================================
function shadeRegion(x, mu, sigma, col)
% Filled ±1 SD band; lower bound clamped at 0.
x  = x(:);
lo = max(mu(:) - sigma(:), 0);
hi = mu(:) + sigma(:);
patch([x; flipud(x)], [hi; flipud(lo)], col, ...
    'EdgeColor', 'none', 'FaceAlpha', 0.55);
end

function val = pget(s, field, default)
if isfield(s, field) && ~isempty(s.(field))
    val = s.(field);
else
    val = default;
end
end
