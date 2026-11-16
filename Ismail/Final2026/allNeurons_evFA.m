%% allNeurons_evFA.m
% Observed firing rate of every recorded neuron as a function of
%   (A) error velocity (refuge velocity minus fish velocity), shortly BEFORE
%       each spike (sensory side), and
%   (B) fish acceleration, shortly AFTER each spike (premotor side).
%
% Each row is one neuron. Three versions are drawn, with the rows ordered by
% direction index, by fish, or by mean firing rate. Both panels list the
% neurons in the same order, so a row can be compared across panels. Colour
% is log2(observed rate in the bin / the neuron's mean rate): orange-red =
% above the mean rate (excitation), blue = below (inhibition).
% Grey = values that the fish did not reach often enough (< 2 s of data).
% Bins with no spikes are drawn at the bottom of the colour scale.
%
% Row labels: '<fish> #<unit number>'.
%   *            significant velocity tuning (see "Velocity tuning" below)
%   label colour encoding class from a Poisson GLM (see "Encoding class"):
%                green = sensory, pink = premotor, purple = mixed, grey = none
%
% DATA
%   The only input is ismailCompleatFinal2024.mat (variable 'curfish', one
%   struct per fish). Kinematics are sampled at 25 Hz (40-ms bins) and
%   positions are in camera pixels (48 px per cm). Spike times are in s.
%   Neurons with at least 2000 spikes are included.
%
% METHODS (all computed in this file)
%   Firing-rate maps (the plotted values)
%     Spikes are counted in the 40-ms kinematic bins. For each bin of the
%     kinematic variable (at the chosen latency) the observed rate is
%     (number of spikes) / (time spent in that bin). Samples clipped as
%     tracking glitches (outside the 0.5-99.5th percentiles) and the first
%     and last 21 samples of each recording are excluded.
%
%   Latency
%     Error velocity: for each neuron, the latency (20-200 ms before the
%     spike, in 20-ms steps) that gives the best in-sample fit of a Poisson
%     model of direction + speed-within-direction tuning (below).
%     Fish acceleration: the same model and rule, with latencies 20-200 ms
%     AFTER the spike (>= 20 ms allows for conduction to the motor system).
%     Half-bin (20-ms) latencies use linear interpolation between samples.
%
%   Velocity tuning (asterisk)
%     Poisson GLM, log link, ridge penalty, on error velocity scaled to unit
%     SD. Regressors: slow-drift terms (Gaussian bumps every 120 s, present in
%     every model including the null), a direction step (v > 0), and separate
%     piecewise-linear speed tuning for each direction (nodes at the 20, 40,
%     60, 80 and 98th percentiles of |v|). Information = 5-fold
%     cross-validated log-likelihood gain over the drift-only model, in
%     bits/spike (folds are whole 30-s trials, interleaved). Null: 100
%     circular shifts of velocity (>= 30 s), latency re-chosen in each.
%     Significant if p < 0.01 and information > 0.002 bits/spike.
%
%   Encoding class (label colour)
%     Poisson GLMs with a kernel on PAST error velocity (S, 0 to 800 ms
%     before), a kernel on FUTURE fish acceleration (M, 0 to 800 ms after),
%     or both (SM). Kernels use 8 raised-cosine basis functions; ridge
%     penalty 10 on z-scored columns; same drift terms and cross-validation
%     as above.
%       unique sensory information  uS = I(SM) - I(M)
%       unique premotor information uM = I(SM) - I(S)
%     Null for uM: shift only the M design (100 circular shifts >= 30 s);
%     for uS: shift only the S design. A contribution counts if p < 0.01 and
%     it exceeds 0.002 bits/spike. sensory = uS only, premotor = uM only,
%     mixed = both, none = neither.
%
%   Random seeds are fixed, so every run gives the same result.
%
% USAGE
%   Put this file and ismailCompleatFinal2024.mat in the same folder (or the
%   .mat file in the folder above), then run:
%       allNeurons_evFA
%   It makes three figures with the same panels and different row orders:
%     allNeurons_evFA             by signed error-velocity direction index
%     allNeurons_evFA_byFish      by fish, then unit number (lines between fish)
%     allNeurons_evFA_byMeanRate  by mean firing rate (rate after each label)
%   Each is saved as PDF and PNG in a 'figures' folder next to this file. Plain MATLAB only (no toolboxes). The significance tests take
%   about 25 minutes; set RUN_SIGNIFICANCE_TESTS = false for a quick plot of the
%   rate maps alone (no asterisks or class colours).

%% ------------------------------------------------------------------------
%  1. Settings
%  ------------------------------------------------------------------------

if ~exist('RUN_SIGNIFICANCE_TESTS', 'var'), RUN_SIGNIFICANCE_TESTS = true; end

% Kinematic scale correction for fish "brown" (curfish(5)). Its kinematic
% values (positions and their derivatives) are taken to be 1/10 of those of
% the other fish, so they are multiplied by this factor when the data are
% loaded (set to 1 for no correction). This only changes the physical-unit axes
% of the rate maps; every model below uses unit-SD signals, so latencies,
% significance and class do not depend on it.
BROWN_INDEX = 5;
BROWN_KINEMATIC_SCALE = 10;

% Bin edges of the rate maps (values outside them are not plotted)
EV_EDGES = -10:0.5:10;        % error velocity, cm/s
FA_EDGES = -60:4:60;          % fish acceleration, cm/s^2

% Candidate latencies in 40-ms samples. Positive = signal BEFORE the spike,
% negative = signal AFTER the spike. 0.5 sample = 20 ms.
EV_LAGS =  0.5:0.5:5;         % error velocity 20-200 ms before the spike
FA_LAGS = -0.5:-0.5:-5;       % fish acceleration 20-200 ms after the spike

COLOR_LIMIT = 1.5;            % colour scale spans +/- this many log2 units
MIN_OCCUPANCY = 50;           % samples (= 2 s) needed to show a bin

% Analysis parameters
P.fs          = 25;           % kinematic sample rate, Hz
P.pxPerCm     = 48;           % tracking scale, camera pixels per cm
P.trialLen    = 750;          % samples per 30-s refuge trial
P.minSpikes   = 2000;         % neurons with fewer spikes are excluded
P.clipPct     = 0.5;          % clip at the [0.5, 99.5] percentiles (tracking glitches)
P.nLags       = 20;           % GLM kernel length, samples (800 ms)
P.nBasis      = 8;            % raised-cosine basis functions per kernel
P.lambda      = 10;           % ridge penalty, sensory/premotor GLM
P.velLambda   = 1;            % ridge penalty, velocity-tuning model
P.velNodePct  = [20 40 60 80 98];  % speed nodes, percentiles of |v|
P.nFolds      = 5;            % cross-validation folds (whole 30-s trials)
P.driftSec    = 120;          % spacing of slow-drift regressors, s
P.edge        = P.nLags + 1;  % samples dropped at each end of a recording
P.nShuffles   = 100;          % circular shifts per significance test
P.minShiftSec = 30;           % minimum circular shift, s
P.alpha       = 0.01;         % significance level
P.minBits     = 0.002;        % minimum effect size, bits/spike
P.seed        = 1;            % random seed

% Colours of the class labels
CLASS_COLOR = struct('sensory', [0.40 0.66 0.22], 'premotor', [0.90 0.20 0.55], ...
                     'mixed',   [0.40 0.30 0.65], 'NR',       [0.72 0.72 0.72]);

% Locations of the data file and of the saved figure
scriptDir = fileparts(mfilename('fullpath'));
if isempty(scriptDir), scriptDir = pwd; end
DATA_FILE = fullfile(scriptDir, 'ismailCompleatFinal2024.mat');
if ~exist(DATA_FILE, 'file')
    DATA_FILE = fullfile(scriptDir, '..', 'ismailCompleatFinal2024.mat');
end
FIGURE_DIR = fullfile(scriptDir, 'figures');

%% ------------------------------------------------------------------------
%  2. Load the data and correct the kinematic scale of fish "brown"
%  ------------------------------------------------------------------------
fprintf('Loading %s ...\n', DATA_FILE);
S = load(DATA_FILE, 'curfish');
curfish = S.curfish;
clear S

assert(startsWith(curfish(BROWN_INDEX).name, 'brown_'), ...
    'curfish(%d) is "%s", not fish brown.', BROWN_INDEX, curfish(BROWN_INDEX).name);
kinematicFields = {'fish_pos', 'fish_vel', 'fish_acc', 'fish_jerk', ...
                   'shuttle_pos', 'shuttle_vel', 'shuttle_acc', ...
                   'error_pos', 'error_vel', 'error_acc', 'error_jerk'};
for k = 1:numel(kinematicFields)
    curfish(BROWN_INDEX).(kinematicFields{k}) = ...
        BROWN_KINEMATIC_SCALE * curfish(BROWN_INDEX).(kinematicFields{k});
end

%% ------------------------------------------------------------------------
%  3. List the neurons: every unit with at least P.minSpikes spikes
%  ------------------------------------------------------------------------
neuronFish = [];  neuronCode = [];
for fi = 1:numel(curfish)
    codes = unique(curfish(fi).spikes.codes(:))';
    for c = codes
        if sum(curfish(fi).spikes.codes == c) >= P.minSpikes
            neuronFish(end+1) = fi;  neuronCode(end+1) = c; %#ok<SAGROW>
        end
    end
end
nNeurons = numel(neuronFish);
fprintf('%d neurons with >= %d spikes in %d fish.\n', ...
    nNeurons, P.minSpikes, numel(unique(neuronFish)));

%% ------------------------------------------------------------------------
%  4. Analyse each neuron
%  ------------------------------------------------------------------------
nEvBins = numel(EV_EDGES) - 1;
nFaBins = numel(FA_EDGES) - 1;
rateMapEV = nan(nNeurons, nEvBins);   % log2(observed rate / mean rate)
rateMapFA = nan(nNeurons, nFaBins);
label     = cell(1, nNeurons);        % e.g. 'bent #3'
fishName  = cell(1, nNeurons);
meanRate  = nan(1, nNeurons);         % Hz
signedDI  = nan(1, nNeurons);         % error-velocity direction index
evLagMs   = nan(1, nNeurons);         % chosen latencies, ms (> 0 = before spike)
faLagMs   = nan(1, nNeurons);
isTuned   = false(1, nNeurons);       % significant velocity tuning
neuronClass = repmat({'NR'}, 1, nNeurons);  % encoding class

fishData = cell(1, numel(curfish));   % prepared kinematics, one cell per fish
for i = 1:nNeurons
    tStart = tic;
    fi = neuronFish(i);
    if isempty(fishData{fi}), fishData{fi} = prepareFish(curfish(fi), P); end
    F = fishData{fi};

    spikeTimes = curfish(fi).spikes.times(curfish(fi).spikes.codes == neuronCode(i));
    y = binSpikes(spikeTimes, F.n, P.fs);   % spike count in each 40-ms bin

    fishName{i} = regexprep(curfish(fi).name, '_\d{4}_\d{2}_\d{2}.*$', '');  % drop the date
    label{i}    = sprintf('%s #%d', fishName{i}, neuronCode(i));
    meanRate(i) = sum(y(F.valid)) / sum(F.valid) * P.fs;

    % Error velocity: latency, rate map and direction index
    [rate, lag, dirIndex] = observedTuning(F, y, F.raw.ev, EV_EDGES, EV_LAGS, MIN_OCCUPANCY, P);
    rateMapEV(i, :) = log2(rate / meanRate(i));
    evLagMs(i) = 1000 * lag / P.fs;
    signedDI(i) = dirIndex;

    % Fish acceleration: latency and rate map
    [rate, lag] = observedTuning(F, y, F.raw.fa, FA_EDGES, FA_LAGS, MIN_OCCUPANCY, P);
    rateMapFA(i, :) = log2(rate / meanRate(i));
    faLagMs(i) = 1000 * lag / P.fs;

    % Significance tests. Each neuron has its own fixed seed.
    if RUN_SIGNIFICANCE_TESTS
        neuronClass{i} = encodingClass(F, y, P, P.seed + i);
        isTuned(i) = velocityTuningTest(F, y, EV_LAGS, P, P.seed + 2000 + i);
    end
    fprintf('%2d/%d %-16s %5.1f Hz  EV lag %3.0f ms before, FA lag %3.0f ms after  DI %+.2f  %-8s tuned=%d  (%.0f s)\n', ...
        i, nNeurons, label{i}, meanRate(i), evLagMs(i), -faLagMs(i), signedDI(i), ...
        neuronClass{i}, isTuned(i), toc(tStart));
end
clear fishData

%% ------------------------------------------------------------------------
%  5. Figures: the same two panels, with the rows in three different orders
%  ------------------------------------------------------------------------
%   'byDirection' signed error-velocity direction index, most positive at top
%   'byFish'      by fish, then unit number, with lines between fish
%   'byMeanRate'  mean firing rate, highest at top (rate shown after each label)
[~, orderDir]  = sort(signedDI, 'descend');
[~, orderRate] = sort(meanRate, 'descend');
orderFish = 1:nNeurons;          % neurons were listed by fish, then by unit number
figures = struct( ...
    'name',   {'allNeurons_evFA',       'allNeurons_evFA_byFish',              'allNeurons_evFA_byMeanRate'}, ...
    'order',  {orderDir,                orderFish,                             orderRate}, ...
    'yLabel', {'neurons (sorted by signed error-velocity direction index)', ...
               'neurons (by fish, then unit number)', ...
               'neurons (sorted by mean firing rate)'}, ...
    'fishLines', {false, true, false}, ...
    'showRate',  {false, false, true});

cmap = divergingColormap(64);
panelPos = [0.08 0.10 0.34 0.80;    % [left bottom width height], normalised
            0.62 0.10 0.34 0.80];
figW = 7.5; figH = 8.5;             % inches
if ~exist(FIGURE_DIR, 'dir'), mkdir(FIGURE_DIR); end

for f = 1:numel(figures)
    order = figures(f).order;
    fig = figure('Units', 'inches', 'Position', [0.5 0.5 figW figH], 'Color', 'w', ...
        'PaperUnits', 'inches', 'PaperSize', [figW figH], 'PaperPosition', [0 0 figW figH], ...
        'Name', figures(f).name, 'NumberTitle', 'off');

    % Panels A (error velocity) and B (fish acceleration)
    panels = { ...
        rateMapEV(order, :), EV_EDGES, 'error velocity (cm/s)',      'A', 'error velocity (20-200 ms before spike)';
        rateMapFA(order, :), FA_EDGES, 'fish acceleration (cm/s^2)', 'B', 'fish acceleration (20-200 ms after spike)'};
    for p = 1:2
        [M, edges, xLabelText, letter, titleText] = panels{p, :};
        M(M < -COLOR_LIMIT) = -COLOR_LIMIT;          % includes bins with no spikes (-Inf)
        binCentres = (edges(1:end-1) + edges(2:end)) / 2;

        ax = axes('Position', panelPos(p, :)); hold(ax, 'on');
        set(ax, 'TickDir', 'out', 'Box', 'off', 'LineWidth', 0.75, 'FontSize', 8, ...
            'YDir', 'reverse', 'Color', [0.9 0.9 0.9], 'YTick', [], ...
            'CLim', COLOR_LIMIT * [-1 1]);
        colormap(ax, cmap);
        imagesc(ax, binCentres, 1:nNeurons, M, 'AlphaData', ~isnan(M));   % NaN -> grey background
        plot(ax, [0 0], [0.5 nNeurons + 0.5], 'k-', 'LineWidth', 0.5);   % zero line
        xlim(ax, edges([1 end])); ylim(ax, [0.5 nNeurons + 0.5]);
        xlabel(ax, xLabelText);
        title(ax, titleText, 'FontWeight', 'normal', 'FontSize', 8);
        text(ax, -0.18, 1.08, letter, 'Units', 'normalized', 'FontWeight', 'bold', ...
            'FontSize', 13, 'VerticalAlignment', 'bottom');
        if p == 1, ylabel(ax, figures(f).yLabel); end
        if figures(f).fishLines                      % lines between fish
            sortedFish = fishName(order);
            for b = find(~strcmp(sortedFish(1:end-1), sortedFish(2:end)))
                plot(ax, edges([1 end]), (b + 0.5) * [1 1], 'k-', 'LineWidth', 0.4);
            end
        end
    end

    % Row labels, in the gap between the two panels so they serve both
    labelAx = axes('Position', [panelPos(1, 1) + panelPos(1, 3), 0.10, ...
                                panelPos(2, 1) - panelPos(1, 1) - panelPos(1, 3), 0.80], ...
        'Visible', 'off', 'YDir', 'reverse', 'XLim', [0 1], 'YLim', [0.5 nNeurons + 0.5]);
    for row = 1:nNeurons
        i = order(row);
        txt = label{i};
        if isTuned(i), txt = [txt ' *']; end %#ok<AGROW>
        if figures(f).showRate, txt = sprintf('%s (%.1f Hz)', txt, meanRate(i)); end
        text(labelAx, 0.5, row, txt, 'FontSize', 5.5, 'HorizontalAlignment', 'center', ...
            'Interpreter', 'none', 'Color', CLASS_COLOR.(neuronClass{i}));
    end

    % Colour bar
    set(labelAx, 'CLim', COLOR_LIMIT * [-1 1]); colormap(labelAx, cmap);
    cb = colorbar(labelAx, 'Location', 'southoutside');
    set(cb, 'Position', [0.40 0.035 0.20 0.008], 'FontSize', 6);
    cb.Label.String = 'log_2 observed rate / mean';

    % Save as vector PDF and 300-dpi PNG
    set(fig, 'Renderer', 'painters');
    print(fig, fullfile(FIGURE_DIR, [figures(f).name '.pdf']), '-dpdf');
    print(fig, fullfile(FIGURE_DIR, [figures(f).name '.png']), '-dpng', '-r300');
    fprintf('Saved %s.pdf and .png in %s\n', figures(f).name, FIGURE_DIR);
end


%% ========================================================================
%  Local functions
%  ========================================================================

function F = prepareFish(f, P)
% PREPAREFISH  Signals, regressors and cross-validation folds for one fish.
F.n    = numel(f.time);
F.raw.ev = f.error_vel(:);     % error velocity, px/s
F.raw.fa = f.fish_acc(:);      % fish acceleration, px/s^2

% Valid samples: drop the ends, where the GLM lag designs run off the record
F.valid = true(F.n, 1);
F.valid([1:P.edge, F.n-P.edge+1:F.n]) = false;

% Folds: whole 30-s trials, interleaved (trial k -> fold mod(k, nFolds)),
% so every fold spans all refuge frequencies and the whole recording
trial  = floor((0:F.n-1)' / P.trialLen);
F.fold = mod(trial, P.nFolds) + 1;

% Slow-drift regressors: Gaussian bumps every P.driftSec seconds. They are in
% every model, including the null, so slow changes in rate are never
% credited to the kinematics.
nDrift = max(2, round(F.n / (P.driftSec * P.fs)));
t = linspace(0, 1, F.n)';
c = linspace(0, 1, nDrift);
F.D = exp(-0.5 * ((t - c) / (c(2) - c(1))).^2);

% Lagged designs for the sensory/premotor GLM, on a raised-cosine basis:
%   XS: error velocity 0..nLags samples in the PAST
%   XM: fish acceleration 0..nLags samples in the FUTURE
B = raisedCosineBasis(P.nLags, P.nBasis);
ev = clipAndStandardise(F.raw.ev, P.clipPct);
fa = clipAndStandardise(F.raw.fa, P.clipPct);
F.XS = zscoreColumns(lagDesign(ev, -(0:P.nLags)) * B);
F.XM = zscoreColumns(lagDesign(fa,  (0:P.nLags)) * B);
end

% -------------------------------------------------------------------------
function [rate, lag, dirIndex] = observedTuning(F, y, v, edges, lags, minOcc, P)
% OBSERVEDTUNING  Observed firing rate binned by a kinematic signal v (raw
% pixel units) at the latency, among LAGS, that best fits the
% direction + speed model.
%   rate     : Hz in each bin of EDGES (cm/s or cm/s^2); NaN if < minOcc samples
%   lag      : chosen latency, samples (> 0 = v before the spike)
%   dirIndex : (r+ - r-) / (r+ + r-), rates when v > 0 and v < 0 at that lag
[vz, lo, hi] = clipToUnitSD(v, P.clipPct);
nodes = speedNodes(vz, F.valid, P.velNodePct);
lag = bestLag(F, y, vz, nodes, lags, P);

% Bin the observed spike counts in physical units at the chosen latency.
% Clipped samples (tracking glitches) are left out: they would pile up at
% the clip value.
vc   = min(max(v, lo), hi);
vLag = lagShift(vc, lag) / P.pxPerCm;
notClipped = lagShift(double(v > lo & v < hi), lag) == 1;
ok   = F.valid & notClipped & vLag >= edges(1) & vLag < edges(end);
nBin = numel(edges) - 1;
bin  = discretize(vLag, edges);
occupancy = accumarray(bin(ok), 1, [nBin 1])';
rate = accumarray(bin(ok), y(ok), [nBin 1])' ./ max(occupancy, 1) * P.fs;
rate(occupancy < minOcc) = NaN;

% Direction index (all valid samples, positive vs negative direction)
vzLag = lagShift(vz, lag);
rPos = sum(y(F.valid & vzLag > 0)) / sum(F.valid & vzLag > 0);
rNeg = sum(y(F.valid & vzLag < 0)) / sum(F.valid & vzLag < 0);
dirIndex = (rPos - rNeg) / (rPos + rNeg);
end

% -------------------------------------------------------------------------
function tuned = velocityTuningTest(F, y, lags, P, seed)
% VELOCITYTUNINGTEST  Is error velocity informative about spiking?
% Cross-validated information of the direction + speed model, at the
% best-fitting latency, against circular-shift nulls in which the latency is
% re-chosen for each shift exactly as for the data.
rng(seed);
vz = clipToUnitSD(F.raw.ev, P.clipPct);
nodes = speedNodes(vz, F.valid, P.velNodePct);

lag = bestLag(F, y, vz, nodes, lags, P);
info = cvInformation(F, y, velocityDesign(vz, lag, nodes), P.velLambda);

minShift = round(P.minShiftSec * P.fs);
nullInfo = nan(P.nShuffles, 1);
for s = 1:P.nShuffles
    shift = minShift + floor(rand * (F.n - 2 * minShift));
    vs = circshift(vz, shift);
    lagS = bestLag(F, y, vs, nodes, lags, P);
    nullInfo(s) = cvInformation(F, y, velocityDesign(vs, lagS, nodes), P.velLambda);
end
p = (1 + sum(nullInfo >= info)) / (1 + P.nShuffles);
tuned = p < P.alpha && info > P.minBits;
end

% -------------------------------------------------------------------------
function cls = encodingClass(F, y, P, seed)
% ENCODINGCLASS  'sensory', 'premotor', 'mixed' or 'NR' from the unique
% information of past error velocity (uS) and future fish acceleration (uM).
rng(seed);
b  = cvInformation(F, y, {F.XS, F.XM, [F.XS F.XM]}, P.lambda);
uS = b(3) - b(2);       % beyond what future movement explains
uM = b(3) - b(1);       % beyond what past error explains

% Conditional nulls: shift ONE design relative to the spikes, keep the other
minShift = P.minShiftSec * P.fs;
nullS = nan(P.nShuffles, 1); nullM = nullS;
for s = 1:P.nShuffles
    shift = minShift + randi(F.n - 2 * minShift);
    nullM(s) = cvInformation(F, y, {[F.XS circshift(F.XM, shift)]}, P.lambda) - b(1);
    nullS(s) = cvInformation(F, y, {[circshift(F.XS, shift) F.XM]}, P.lambda) - b(2);
end
pS = (1 + sum(nullS >= uS)) / (1 + P.nShuffles);
pM = (1 + sum(nullM >= uM)) / (1 + P.nShuffles);
isS = pS < P.alpha && uS > P.minBits;
isM = pM < P.alpha && uM > P.minBits;
if isS && isM,  cls = 'mixed';
elseif isS,     cls = 'sensory';
elseif isM,     cls = 'premotor';
else,           cls = 'NR';
end
end

% -------------------------------------------------------------------------
function X = velocityDesign(vz, lag, nodes)
% VELOCITYDESIGN  Direction + speed-within-direction regressors:
%   [v > 0,  speed tents x (v > 0),  speed tents x (v < 0)]
% Speed tuning is piecewise linear on NODES (tent functions); the zero-speed
% tent is dropped so that both directions share the zero-speed baseline.
v = lagShift(vz, lag);
isPos = double(v > 0); isNeg = double(v < 0);
K = numel(nodes);
speed = min(max(abs(v), 0), nodes(end));
T = interp1(nodes(:), eye(K), speed);
T = T(:, 2:end);
X = [isPos, T .* isPos, T .* isNeg];
end

function lag = bestLag(F, y, vz, nodes, lags, P)
% BESTLAG  Latency with the best in-sample fit of the velocity model.
ok = F.valid; best = -Inf; lag = lags(1);
for L = lags
    X = velocityDesign(vz, L, nodes);
    A = [F.D(ok, :) X(ok, :)];
    w = fitPoisson(A, y(ok), P.velLambda);
    ll = poissonLogLik(A, y(ok), w);
    if ll > best, best = ll; lag = L; end
end
end

function nodes = speedNodes(vz, valid, pct)
% SPEEDNODES  0 followed by the given percentiles of |v| over valid samples.
a = sort(abs(vz(valid)));
nodes = [0 a(max(1, min(numel(a), round(numel(a) * pct / 100))))'];
end

% -------------------------------------------------------------------------
function bits = cvInformation(F, y, designs, lambda)
% CVINFORMATION  Cross-validated information (bits/spike) of each model
% [drift, designs{k}] over the drift-only null model:
%   bits(k) = sum over test folds of [LL(model k) - LL(null)] / test spikes / log(2)
if ~iscell(designs), designs = {designs}; end
nModels = numel(designs);
dLL = zeros(1, nModels);
nSpikes = 0;
for fold = unique(F.fold(:))'
    train = F.valid & F.fold ~= fold;
    test  = F.valid & F.fold == fold;
    w0 = fitPoisson(F.D(train, :), y(train), lambda);
    LL0 = poissonLogLik(F.D(test, :), y(test), w0);
    nSpikes = nSpikes + sum(y(test));
    for k = 1:nModels
        X = [F.D designs{k}];
        wStart = [w0; zeros(size(designs{k}, 2), 1)];     % start from the null fit
        w = fitPoisson(X(train, :), y(train), lambda, wStart);
        dLL(k) = dLL(k) + poissonLogLik(X(test, :), y(test), w) - LL0;
    end
end
bits = dLL / max(nSpikes, 1) / log(2);
end

function w = fitPoisson(X, y, lambda, w0)
% FITPOISSON  Ridge-penalised Poisson GLM (log link) by Newton's method with
% backtracking. X has no intercept column; w(1) is the unpenalised intercept.
n  = size(X, 1);
X1 = [ones(n, 1) X];
R  = lambda * eye(size(X1, 2)); R(1, 1) = 0;
if nargin < 4 || isempty(w0)
    w = zeros(size(X1, 2), 1); w(1) = log(mean(y) + 1e-9);
else
    w = w0;
end
objective = @(w) sum(y .* min(X1 * w, 10) - exp(min(X1 * w, 10))) - 0.5 * w' * R * w;
f = objective(w);
for iter = 1:30
    mu = exp(min(X1 * w, 10));
    g  = X1' * (y - mu) - R * w;           % gradient
    H  = X1' * (X1 .* mu) + R;             % negative Hessian
    dw = H \ g;
    step = 1;
    while step > 1e-3                      % halve the step until the fit improves
        wNew = w + step * dw; fNew = objective(wNew);
        if fNew >= f - 1e-9, break; end
        step = step / 2;
    end
    w = wNew;
    if abs(fNew - f) < 1e-7 * max(1, abs(f)), break; end
    f = fNew;
end
end

function L = poissonLogLik(X, y, w)
% POISSONLOGLIK  Poisson log-likelihood, without the constant log(y!) term.
eta = min([ones(size(X, 1), 1) X] * w, 10);
L = sum(y .* eta - exp(eta));
end

% -------------------------------------------------------------------------
function y = binSpikes(spikeTimes, n, fs)
% BINSPIKES  Spike counts in the n kinematic samples [t_k, t_k + 1/fs).
idx = floor(spikeTimes(:) * fs) + 1;
idx = idx(idx >= 1 & idx <= n);
y = accumarray(idx, 1, [n 1]);
end

function y = lagShift(x, L)
% LAGSHIFT  y(t) = x(t - L), circular. L is in samples and may be
% fractional (linear interpolation between neighbouring samples).
i = floor(L); f = L - i;
if f == 0
    y = circshift(x, i);
else
    y = (1 - f) * circshift(x, i) + f * circshift(x, i + 1);
end
end

function [vz, lo, hi] = clipToUnitSD(v, pct)
% CLIPTOUNITSD  Clip to the [pct, 100-pct] percentiles, then divide by the
% SD of the unclipped signal (zero stays at zero, so the sign is kept).
v = v(:);
[lo, hi] = clipLimits(v, pct);
vz = min(max(v, lo), hi) / std(v);
end

function y = clipAndStandardise(x, pct)
% CLIPANDSTANDARDISE  Clip to the [pct, 100-pct] percentiles, then z-score.
x = x(:);
[lo, hi] = clipLimits(x, pct);
y = min(max(x, lo), hi);
y = (y - mean(y)) / std(y);
end

function [lo, hi] = clipLimits(x, pct)
% CLIPLIMITS  The [pct, 100-pct] percentiles of x (nearest sample).
s = sort(x); n = numel(s);
lo = s(max(1, round(n * pct / 100)));
hi = s(min(n, round(n * (1 - pct / 100))));
end

function X = lagDesign(x, lags)
% LAGDESIGN  Column j holds x(t + lags(j)), zero-padded at the ends.
% Negative lags look into the past, positive lags into the future.
x = x(:); n = numel(x);
X = zeros(n, numel(lags));
for j = 1:numel(lags)
    l = lags(j);
    if l >= 0
        X(1:n-l, j) = x(1+l:n);
    else
        X(1-l:n, j) = x(1:n+l);
    end
end
end

function B = raisedCosineBasis(nLags, nBasis)
% RAISEDCOSINEBASIS  Raised-cosine bumps on a log-stretched lag axis
% (Pillow et al. 2008): narrow at short lags, wide at long lags.
% B is (nLags+1) x nBasis; row k is lag k-1 samples.
x = log((0:nLags)' + 2);
c = linspace(x(1), x(end), nBasis);
width = c(2) - c(1);
B = zeros(nLags + 1, nBasis);
for j = 1:nBasis
    d = max(-pi, min(pi, (x - c(j)) * pi / (2 * width)));
    B(:, j) = (cos(d) + 1) / 2;
end
end

function X = zscoreColumns(X)
% ZSCORECOLUMNS  z-score each column (constant columns are left at zero).
sd = std(X, 0, 1); sd(sd == 0) = 1;
X = (X - mean(X, 1)) ./ sd;
end

function cmap = divergingColormap(n)
% DIVERGINGCOLORMAP  Blue (#0072B2, most negative = inhibition) through
% near-white to orange-red (#D55E00, most positive = excitation). Both end
% colours are from the Okabe-Ito colour-blind-safe palette.
negative = hex2rgb('0072B2');
middle   = [0.97 0.97 0.97];
positive = hex2rgb('D55E00');
cmap = interp1([0 0.5 1], [negative; middle; positive], linspace(0, 1, n));
end

function rgb = hex2rgb(hex)
% HEX2RGB  'RRGGBB' -> [r g b] in the range 0-1.
rgb = hex2dec({hex(1:2), hex(3:4), hex(5:6)})' / 255;
end
