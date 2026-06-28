function out = slidingWindowCoh(curfish, fishNo, neuronNo, params)
% out = slidingWindowCoh(curfish, fishNo, neuronNo, params)
%
% Tests whether local spike rate predicts local shuttle-fish velocity coherence.
%
% For each sliding window the function computes:
%   - spike rate (Hz): spikes per second in that window
%   - shuttle-fish velocity coherence: Welch's mscohere between shuttle_vel
%     (derived as error_vel + fish_vel) and fish_vel, integrated over [0, intFreq] Hz
%
% Across windows, Pearson r between spike_rate and integrated coherence is
% tested against a circular-shift shuffle baseline that preserves the
% temporal autocorrelation of the spike train.
%
% Inputs:
%   curfish   - data struct from ismailCompleatFinal2024.mat
%   fishNo    - fish index
%   neuronNo  - neuron code
%   params    - optional struct with any of:
%       .winSec      - outer window length (s)                 (default 30)
%       .stepSec     - step between windows (s)                (default 15)
%       .welchSec    - Welch segment length within window (s)  (default 5)
%       .overlapFrac - Welch segment overlap fraction          (default 0.5)
%       .intFreq     - coherence integration upper limit (Hz)  (default 5)
%       .maxFreq     - plot upper frequency (Hz)               (default 10)
%       .nShuffles   - circular-shift shuffles for baseline    (default 200)
%       .hiPrctile   - percentile threshold for "high rate"   (default 75)
%
% Output fields:
%   winCenters  - center time of each window (s)
%   spikeRate   - spike rate in each window (Hz)
%   cohInt      - integrated shuttle-fish vel coherence per window (coherence * Hz)
%   cohSpec     - per-window shuttle-fish vel coherence spectrum  [nFreq x nWin]
%   f           - frequency axis (Hz)
%   cohFull     - shuttle-fish vel coherence from the full recording
%   cohHi       - mean coherence spectrum for high-rate windows (top hiPrctile%)
%   cohRest     - mean coherence spectrum for all other windows
%   r, p        - Pearson r and two-tailed p-value (t-test)
%   shuffR      - null distribution of r  [nShuffles x 1]
%   rZ          - z-score of r vs shuffle distribution
%   rP          - fraction of shuffles with |r_shuff| >= |r|

if nargin < 4, params = struct(); end

winSec      = pget(params, 'winSec',      30);
stepSec     = pget(params, 'stepSec',     15);
welchSec    = pget(params, 'welchSec',    5);
overlapFrac = pget(params, 'overlapFrac', 0.5);
intFreq     = pget(params, 'intFreq',     5);
maxFreq     = pget(params, 'maxFreq',     10);
nShuffles   = pget(params, 'nShuffles',   200);
hiPrctile   = pget(params, 'hiPrctile',   75);

%% ---- Extract data -------------------------------------------------------
dataList_NeuronsDurationComments;
fishName = fishNames{fishNo};

spiketimes = curfish(fishNo).spikes.times(curfish(fishNo).spikes.codes == neuronNo);
tim        = curfish(fishNo).time(:);
% errVel     = curfish(fishNo).error_vel(:);
inputSignal  = curfish(fishNo).error_vel(:);
outputSignal = curfish(fishNo).fish_vel(:);

dt = median(diff(tim));
fs = 1 / dt;
N  = length(tim);

fprintf('slidingWindowCoh — Fish %d (%s), neuron %d\n', fishNo, fishName, neuronNo);
fprintf('  %.0f spikes  %.0f s recording  %.2f Hz mean rate\n', ...
    numel(spiketimes), max(tim), numel(spiketimes) / max(tim));
fprintf('  fs=%.1f Hz | win=%.0f s | step=%.0f s | welch=%.0f s | intFreq=%.0f Hz\n', ...
    fs, winSec, stepSec, welchSec, intFreq);

%% ---- Welch parameters (shared across full recording and per window) -----
welchSamp   = round(welchSec * fs);
overlapSamp = round(welchSamp * overlapFrac);
nfft        = 2^nextpow2(welchSamp);
welchWin    = hanning(welchSamp);

nWelchPerOuter = floor((round(winSec * fs) - overlapSamp) / (welchSamp - overlapSamp));
if nWelchPerOuter < 3
    warning('slidingWindowCoh: only %d Welch segments per outer window — coherence estimates will be noisy. Consider increasing winSec or decreasing welchSec.', nWelchPerOuter);
end
fprintf('  ~%d Welch segments per outer window\n', nWelchPerOuter);

%% ---- Full-recording shuttle-fish vel coherence (reference baseline) ---------------
[cohFull, f] = mscohere(outputSignal, inputSignal, welchWin, overlapSamp, nfft, fs);
fIdx    = f >= 0 & f <= maxFreq;
f       = f(fIdx);
cohFull  = cohFull(fIdx);
df       = f(2) - f(1);
intIdx   = f <= intFreq;

% Bias-correct full-recording coherence: C²_corr = (K*C² - 1)/(K-1)
% Under H0, E[C²] ≈ 1/K; this maps that expectation to 0.
K_full  = floor((N - overlapSamp) / (welchSamp - overlapSamp));
cohFull = max((K_full .* cohFull - 1) ./ (K_full - 1), 0);
fprintf('  Full-recording Welch segments: K_full=%d  (null bias ~%.4f → corrected to 0)\n', K_full, 1/K_full);

%% ---- Sliding windows ---------------------------------------------------
winSamp  = round(winSec  * fs);
stepSamp = round(stepSec * fs);
starts   = (1 : stepSamp : (N - winSamp + 1))';
nWin     = length(starts);
nFreq    = sum(fIdx);

fprintf('  %d windows\n', nWin);

winCenters = zeros(nWin, 1);
spikeRate  = zeros(nWin, 1);
cohInt     = zeros(nWin, 1);
cohSpec    = zeros(nFreq, nWin);

for w = 1:nWin
    idx  = starts(w) : starts(w) + winSamp - 1;
    svW  = outputSignal(idx);
    fvW  = inputSignal(idx);
    tW   = tim(idx);

    winCenters(w) = 0.5 * (tW(1) + tW(end));
    nSpk          = sum(spiketimes >= tW(1) & spiketimes <= tW(end));
    spikeRate(w)  = nSpk / winSec;

    [cw, ~]      = mscohere(svW, fvW, welchWin, overlapSamp, nfft, fs);
    cw           = cw(fIdx);
    cohSpec(:,w) = cw;
    cohInt(w)    = sum(cw(intIdx)) * df;
end

%% ---- Pearson correlation ------------------------------------------------
[r, p] = corr(spikeRate, cohInt);

%% ---- Bias-correct per-window coherence spectra -------------------------
% Each window uses K=nWelchPerOuter Welch segments, so E[C²] ≈ 1/K under H0.
% Apply the same correction as cohFull: C²_corr = (K*C² - 1)/(K-1).
% Pearson r on cohInt is unchanged (linear transform), but cohHi/cohLo become
% comparable to the bias-corrected cohFull.
K = nWelchPerOuter;
cohSpec_corr = max((K .* cohSpec - 1) ./ (K - 1), 0);
fprintf('  Per-window null bias ~%.4f → corrected to 0 (K=%d)\n', 1/K, K);

%% ---- High-rate vs rest coherence spectra --------------------------------
hiThresh = prctile(spikeRate, hiPrctile);
cohHi    = mean(cohSpec_corr(:, spikeRate >= hiThresh), 2);
cohRest  = mean(cohSpec_corr(:, spikeRate <  hiThresh), 2);

%% ---- Shuffle baseline (circular shift of binary spike train) -----------
edges    = [tim; tim(end) + dt];
spkTrain = histcounts(spiketimes, edges)';   % Nx1

shuffR = zeros(nShuffles, 1);
for s = 1:nShuffles
    spkShuff = circshift(spkTrain, round(rand * N));

    % Cumulative sum for efficient windowed spike counts across all windows
    cumSpk    = [0; cumsum(spkShuff)];
    rateShuff = zeros(nWin, 1);
    for w = 1:nWin
        i1 = starts(w);
        i2 = starts(w) + winSamp - 1;
        rateShuff(w) = (cumSpk(i2 + 1) - cumSpk(i1)) / winSec;
    end
    shuffR(s) = corr(rateShuff, cohInt);
end

rZ = (r - mean(shuffR)) / std(shuffR);
rP = mean(abs(shuffR) >= abs(r));

fprintf('  Pearson r = %.3f  (t-test p=%.4f | shuffle: z=%.2f  p=%.3f)\n', r, p, rZ, rP);

%% ---- FIGURE -------------------------------------------------------------
colHi = [0.85 0.10 0.10];
colLo = [0.20 0.55 0.85];
colSh = [0.80 0.80 0.80];

figure('Units', 'inches', 'Position', [0.5 0.5 11 8.5], ...
    'PaperOrientation', 'landscape', 'PaperUnits', 'inches', ...
    'PaperSize', [11 8.5], 'PaperPosition', [0 0 11 8.5]);

annotation('textbox', [0 0.93 1 0.07], ...
    'String', sprintf('Sliding-Window Shuttle-Fish Vel Coherence vs Spike Rate  |  Fish %d — %s — Neuron %d   (n=%d spikes, %.0f s, %.2f Hz)', ...
        fishNo, fishName, neuronNo, numel(spiketimes), max(tim), numel(spiketimes) / max(tim)), ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
    'FontSize', 12, 'FontWeight', 'bold', 'EdgeColor', 'none');

%% Panel 1 — Time series: spike rate (left) and integrated shuttle-fish vel coherence (right)
subplot(3, 2, [1 2]);
yyaxis left
plot(winCenters, spikeRate, 'k-o', 'LineWidth', 1.5, 'MarkerSize', 4);
ylabel('Spike rate (Hz)');
ax = gca;
ax.YColor = 'k';
yyaxis right
plot(winCenters, cohInt, '-s', 'Color', [0.70 0.10 0.10], ...
    'LineWidth', 1.5, 'MarkerSize', 4);
ylabel(sprintf('Integrated shuttle-fish vel coherence (0–%.0f Hz)', intFreq));
ax.YColor = [0.70 0.10 0.10];
xlabel('Time (s)');
title(sprintf('Spike rate and shuttle-fish vel coherence over sliding windows  (%.0f s, step %.0f s)', winSec, stepSec));
legend({'Spike rate', 'shuttle-fish vel coherence'}, 'Location', 'best', 'FontSize', 9);

%% Panel 2 — Scatter: spike rate vs integrated coherence
subplot(3, 2, 3);
% Color points by window time for temporal context
scatter(spikeRate, cohInt, 45, winCenters, 'filled', 'MarkerFaceAlpha', 0.75);
colormap(gca, parula);
cb = colorbar; cb.Label.String = 'Window center (s)';
hold on;
xfit = linspace(min(spikeRate), max(spikeRate), 50);
b    = polyfit(spikeRate, cohInt, 1);
plot(xfit, polyval(b, xfit), 'r-', 'LineWidth', 2);
xlabel('Spike rate (Hz)');
ylabel(sprintf('Integrated shuttle-fish vel coherence (0–%.0f Hz)', intFreq));
title(sprintf('r = %.3f   p_{t} = %.3f   p_{shuff} = %.3f   z = %.2f', r, p, rP, rZ));

%% Panel 3 — shuttle-fish vel coherence spectrum: full recording and median split
subplot(3, 2, 4);
plot(f, cohFull, 'k-',  'LineWidth', 1.5); hold on;
plot(f, cohHi,   '-', 'Color', colHi, 'LineWidth', 2.5);
plot(f, cohRest, '-', 'Color', colLo, 'LineWidth', 2.5);
xline(intFreq, 'k--', 'LineWidth', 1);
text(intFreq + 0.1, max(cohFull) * 0.95, sprintf('%.0f Hz', intFreq), 'FontSize', 9);
plot([0 maxFreq], [0 0], 'k-', 'LineWidth', 0.75);
xlabel('Frequency (Hz)');
ylabel('Bias-corrected coherence');
title(sprintf('Shuttle-fish vel coherence (bias-corrected, K_{win}=%d, K_{full}=%d)', K, K_full));
legend({'Full recording', ...
        sprintf('High rate (≥%.0fth pct, ≥%.2f Hz)', hiPrctile, hiThresh), ...
        sprintf('Rest (<%.0fth pct)', hiPrctile)}, ...
       'Location', 'northeast', 'FontSize', 9);
xlim([0 maxFreq]);

%% Panel 4 — Shuffle distribution of r
subplot(3, 2, [5 6]);
histogram(shuffR, 50, 'FaceColor', colSh, 'EdgeColor', 'none', 'Normalization', 'probability');
hold on;
xline(r,             'r-',  'LineWidth', 2.5, ...
    'Label', sprintf('r = %.3f (z=%.2f, p=%.3f)', r, rZ, rP), ...
    'LabelVerticalAlignment', 'bottom', 'FontSize', 10);
xline(mean(shuffR),  'k--', 'LineWidth', 1.5, 'Label', 'shuffle mean');
xline(-abs(r),       'r--', 'LineWidth', 1.5);
xlabel('Pearson r  (spike rate vs. integrated shuttle-fish vel coherence)');
ylabel('Proportion');
title(sprintf('Circular-shift shuffle null distribution  (n=%d)', nShuffles));
xlim([-1 1]);

%% ---- Output struct ------------------------------------------------------
out.winCenters = winCenters;
out.spikeRate  = spikeRate;
out.cohInt     = cohInt;
out.cohSpec    = cohSpec;
out.f          = f;
out.cohFull    = cohFull;
out.cohHi      = cohHi;
out.cohRest    = cohRest;
out.r          = r;
out.p          = p;
out.shuffR     = shuffR;
out.rZ         = rZ;
out.rP         = rP;

end  % slidingWindowCoh


%% ========================================================================
function val = pget(s, field, default)
if isfield(s, field) && ~isempty(s.(field))
    val = s.(field);
else
    val = default;
end
end
