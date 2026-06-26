function smitaPlot(curfish, fishNo, neuronNo, shifty)
% Makes a plot of the time-delays for DSI calculations
% makes 1-D and 2-D histograms and calculates a map of Z-scores and
% p-values
% curfish is the structure from the final dataset ismailCompleatFinal2024.mat
% fishNo and neuronNo are from dataList_NeuronsDurationComments
% shifty are the magnitudes of shifts from 0 for sensory (shifty(1)) and motor (shifty(2)) in SECONDS

%% Look up fish name from dataList
dataList_NeuronsDurationComments;
fishName = fishNames{fishNo};

%% Extract data
spiketimes = curfish(fishNo).spikes.times(curfish(fishNo).spikes.codes == neuronNo);
tim        = curfish(fishNo).time;
errVel     = curfish(fishNo).error_vel;
errAcc     = curfish(fishNo).error_acc;
fishAcc    = curfish(fishNo).fish_acc;
fishVel    = curfish(fishNo).fish_vel;

%% USER PARAMETERS (shared)
nbins         = 18;
%errorVelRange = [-800 800];       % legacy fixed ranges
%fishAccRange  = [-1600 1600];
errorVelRange = prctile(errVel,  [1 99]);   % data-driven ranges
fishAccRange  = prctile(fishAcc, [1 99]);
fprintf('errorVelRange: [%.1f, %.1f]    fishAccRange: [%.1f, %.1f]\n', ...
    errorVelRange(1), errorVelRange(2), fishAccRange(1), fishAccRange(2));
smoothSigma   = 1;
nShuffles     = 200;

if isempty(shifty)
    spikeShift_EV    = 0;
    spikeShift_FA    = 0;
else
    spikeShift_EV = shifty(1);
    spikeShift_FA = shifty(2);
end

%% ===============================
%% ======= FIGURE SETUP ==========
%% ===============================

figure('Units', 'inches', 'Position', [0.5 0.5 8.5 11], ...
       'PaperOrientation', 'portrait', 'PaperUnits', 'inches', ...
       'PaperSize', [8.5 11], 'PaperPosition', [0 0 8.5 11]);

% Page title
annotation('textbox', [0 0.95 1 0.05], ...
    'String', sprintf('Fish %d  —  %s  —  Neuron %d', fishNo, fishName, neuronNo), ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
    'FontSize', 14, 'FontWeight', 'bold', 'EdgeColor', 'none');

%% ===============================
%% ======= DSI TIME PLOT =========
%% ===============================

axDSI = axes('Position', [0.07 0.70 0.49 0.22]);
axMI  = axes('Position', [0.07 0.52 0.49 0.16]);

dels = -1.00:0.020:1.00;

dsiEV = cell(1, length(dels));
dsiEA = cell(1, length(dels));
dsiFA = cell(1, length(dels));
dsiFV = cell(1, length(dels));
miEV  = cell(1, length(dels));
miFA  = cell(1, length(dels));

parfor j = 1:length(dels)
    localDels = -1.00:0.020:1.00;

    [dsiEV{j}, ~] = trackDSI(spiketimes, errVel,   tim, localDels(j));
    [dsiEA{j}, ~] = trackDSI(spiketimes, errAcc,   tim, localDels(j));
    [dsiFA{j}, ~] = trackDSI(spiketimes, fishAcc,  tim, localDels(j));
    [dsiFV{j}, ~] = trackDSI(spiketimes, fishVel,  tim, localDels(j));
    [miEV{j},  ~] = trackMI(spiketimes,  errVel,   tim, localDels(j));
    [miFA{j},  ~] = trackMI(spiketimes,  fishAcc,  tim, localDels(j));
end

evDSI = zeros(1, length(dels));
eaDSI = zeros(1, length(dels));
faDSI = zeros(1, length(dels));
fvDSI = zeros(1, length(dels));
evMI  = zeros(1, length(dels));
faMI  = zeros(1, length(dels));
evMIr = zeros(1, length(dels));
faMIr = zeros(1, length(dels));

for j = 1:length(dels)
    evDSI(j) = dsiEV{j}.spikes;
    eaDSI(j) = dsiEA{j}.spikes;
    faDSI(j) = dsiFA{j}.spikes;
    fvDSI(j) = dsiFV{j}.spikes;
    evMI(j)  = miEV{j}.bpspk;
    faMI(j)  = miFA{j}.bpspk;
    evMIr(j) = miEV{j}.rand_bpspk;
    faMIr(j) = miFA{j}.rand_bpspk;
end

axes(axDSI);
plot(dels, [evDSI', faDSI'], 'LineWidth', 4);
hold on;
plot(dels, [eaDSI', fvDSI'], 'LineStyle', '-.', 'LineWidth', 2);

plot([0 0], [-0.5 0.5], 'k-');
plot([-1 1], [0 0], 'k-');
text(-0.9, 0.4, ...
    sprintf('n=%d  dur=%ds  %.2f Hz', length(spiketimes), floor(max(tim)), length(spiketimes)/max(tim)), ...
    'Color', 'k', 'FontSize', 14);
legend({'EV DSI', 'FA DSI'}, 'Location', 'best');
xlabel('Delay (s)');
ylabel('DSI');
title('DSI vs. Time Delay');

%% ===============================
%% ======= MI TIME PLOT ==========
%% ===============================

axes(axMI);
h1 = plot(dels, evMI,  'LineWidth', 3); hold on;
h2 = plot(dels, faMI,  'LineWidth', 3);
     plot(dels, evMIr, '--', 'Color', h1.Color, 'LineWidth', 1.5);
     plot(dels, faMIr, '--', 'Color', h2.Color, 'LineWidth', 1.5);
miYLim = [min([0 evMI faMI evMIr faMIr]) - 0.02, ...
          max([evMI faMI]) * 1.15 + 0.01];
plot([0 0], miYLim, 'k-');
plot([-1 1], [0 0], 'k-');
ylim(miYLim);
legend({'EV MI', 'FA MI', 'EV rand', 'FA rand'}, 'Location', 'best', 'FontSize', 9);
xlabel('Delay (s)');
ylabel('bits / spike');
title('Mutual Information vs. Time Delay');

%% ===============================
%% ======= HEATMAP SETUP =========
%% ===============================

% Shift signals for occupancy calculation to match spike sampling lags
% This ensures that the "opportunity" for a spike is calculated for the same lag
shiftedEV = interp1(tim, errVel,  tim - spikeShift_EV, 'linear', 'extrap');
shiftedFA = interp1(tim, fishAcc, tim + spikeShift_FA, 'linear', 'extrap');

validSamples = ...
    shiftedEV >= errorVelRange(1) & shiftedEV <= errorVelRange(2) & ...
    shiftedFA >= fishAccRange(1)  & shiftedFA <= fishAccRange(2);

vErrVel  = shiftedEV(validSamples);
vFishAcc = shiftedFA(validSamples);
dT       = median(diff(tim));

edgesEV = linspace(errorVelRange(1), errorVelRange(2), nbins+1);
edgesFA = linspace(fishAccRange(1),  fishAccRange(2),  nbins+1);

occCounts = histcounts2(vErrVel, vFishAcc, edgesEV, edgesFA);
occupancy = occCounts * dT;

spikesEV = interp1(tim, errVel,  spiketimes - spikeShift_EV, 'linear', 'extrap');
spikesFA = interp1(tim, fishAcc, spiketimes + spikeShift_FA, 'linear', 'extrap');

validSpikes = ...
    spikesEV >= errorVelRange(1) & spikesEV <= errorVelRange(2) & ...
    spikesFA >= fishAccRange(1)  & spikesFA <= fishAccRange(2);

spikesEVv = spikesEV(validSpikes);
spikesFAv = spikesFA(validSpikes);

nTotal = length(spikesEVv);
siEV   = (sum(spikesEVv > 0) - sum(spikesEVv < 0)) / nTotal;
siFA   = (sum(spikesFAv > 0) - sum(spikesFAv < 0)) / nTotal;

spikeCounts = histcounts2(spikesEVv, spikesFAv, edgesEV, edgesFA);

spikeCountsSmooth = imgaussfilt(spikeCounts, smoothSigma);
occupancySmooth   = imgaussfilt(occupancy,   smoothSigma);

rateMap = spikeCountsSmooth ./ occupancySmooth;
rateMap(occupancySmooth < 1e-6) = NaN;

%% Shuffle
TotalTime    = tim(end) - tim(1);
shuffleMaps  = zeros(nbins, nbins, nShuffles);

for s = 1:nShuffles
    shiftAmount    = rand * TotalTime;
    shuffledSpikes = mod(spiketimes + shiftAmount - tim(1), TotalTime) + tim(1);

    sw1 = interp1(tim, errVel,  shuffledSpikes - spikeShift_EV, 'linear', 'extrap');
    sw2 = interp1(tim, fishAcc, shuffledSpikes + spikeShift_FA, 'linear', 'extrap');

    valid = ...
        sw1 >= errorVelRange(1) & sw1 <= errorVelRange(2) & ...
        sw2 >= fishAccRange(1)  & sw2 <= fishAccRange(2);

    sc       = histcounts2(sw1(valid), sw2(valid), edgesEV, edgesFA);
    scSmooth = imgaussfilt(sc, smoothSigma);
    shuffleMaps(:,:,s) = scSmooth ./ occupancySmooth;
end

shuffleMean = mean(shuffleMaps, 3);
shuffleStd  = std(shuffleMaps, [], 3);
zMap        = (rateMap - shuffleMean) ./ shuffleStd;
pMap        = mean(shuffleMaps >= rateMap, 3);
pMap(occupancySmooth < 1e-6) = NaN;

%% ===============================
%% ===== 1D MARGINAL PLOTS =======
%% ===============================

centersEV = (edgesEV(1:end-1) + edgesEV(2:end)) / 2;
centersFA = (edgesFA(1:end-1) + edgesFA(2:end)) / 2;

% Calculate independent 1D profiles with their own occupancy correction
% For EV:
occEV1D = histcounts(shiftedEV, edgesEV) * dT;
occEV1DSmooth = imgaussfilt(occEV1D, smoothSigma);
countEV1D = histcounts(spikesEV, edgesEV); % Use all spikes in range, regardless of FA
countEV1DSmooth = imgaussfilt(countEV1D, smoothSigma);
evProfile = countEV1DSmooth(:) ./ occEV1DSmooth(:);
evProfile(occEV1DSmooth < 1e-6) = NaN;

% For FA:
occFA1D = histcounts(shiftedFA, edgesFA) * dT;
occFA1DSmooth = imgaussfilt(occFA1D, smoothSigma);
countFA1D = histcounts(spikesFA, edgesFA); % Use all spikes in range, regardless of EV
countFA1DSmooth = imgaussfilt(countFA1D, smoothSigma);
faProfile = countFA1DSmooth(:) ./ occFA1DSmooth(:);
faProfile(occFA1DSmooth < 1e-6) = NaN;

axes('Position', [0.61 0.82 0.32 0.10]);
bar(centersEV, evProfile, 'FaceColor', [0.3 0.5 0.8]);
xlabel('Error Velocity'); ylabel('Mean Rate (Hz)');
title('EV Response');

axes('Position', [0.61 0.70 0.32 0.10]);
bar(centersFA, faProfile, 'FaceColor', [0.8 0.4 0.3]);
xlabel('Fish Accel'); ylabel('Mean Rate (Hz)');
title('FA Response');

%% ===============================
%% ======= HEATMAP PLOTS =========
%% ===============================

% Layout: bottom half split into 2x2
% Positions: [left, bottom, width, height] in normalized figure units
leftCol  = 0.07;
rightCol = 0.55;
colW     = 0.40;
topRow   = 0.27;
botRow   = 0.03;
rowH     = 0.22;

ev1 = edgesEV(1:end-1);
fa1 = edgesFA(1:end-1);

% Helper: shared crosshair lines
crossEV = errorVelRange;
crossFA = fishAccRange;

% --- Rate Map ---
axes('Position', [leftCol topRow colW rowH]);
imagesc(ev1, fa1, rateMap');
hold on;
plot(crossEV, [0 0], 'k-', 'LineWidth', 2);
plot([0 0], crossFA, 'k-', 'LineWidth', 2);
text(edgesEV(1)+20, edgesFA(end-2), ...
    sprintf('SI_{EV}=%.2f  SI_{FA}=%.2f', siEV, siFA), 'Color', 'w', 'FontSize', 12);
text(edgesEV(1)+20, edgesFA(end-4), ...
    sprintf('n=%d  dur=%ds  %.2f Hz', length(spiketimes), floor(max(tim)), length(spiketimes)/max(tim)), ...
    'Color', 'w', 'FontSize', 12);
clim([0 2.5 * length(spiketimes)/max(tim)]);
axis xy; colorbar;
xlabel('Error Velocity'); ylabel('Fish Accel');
title('Smoothed Rate Map');

% --- Z-score Map ---
axes('Position', [rightCol topRow colW rowH]);
imagesc(ev1, fa1, zMap');
hold on;
plot(crossEV, [0 0], 'k-', 'LineWidth', 2);
plot([0 0], crossFA, 'k-', 'LineWidth', 2);
axis xy; colorbar;
xlabel('Error Velocity'); ylabel('Fish Accel');
title('Z-score Map');

% --- Shuffle Mean ---
axes('Position', [leftCol botRow colW rowH]);
imagesc(ev1, fa1, shuffleMean');
hold on;
plot(crossEV, [0 0], 'k-', 'LineWidth', 2);
plot([0 0], crossFA, 'k-', 'LineWidth', 2);
axis xy; colorbar;
xlabel('Error Velocity'); ylabel('Fish Accel');
title('Shuffle Mean');

% --- -log10(p) Map ---
axes('Position', [rightCol botRow colW rowH]);
imagesc(ev1, fa1, -log10(pMap)');
hold on;
plot(crossEV, [0 0], 'k-', 'LineWidth', 2);
plot([0 0], crossFA, 'k-', 'LineWidth', 2);
axis xy; colorbar;
xlabel('Error Velocity'); ylabel('Fish Accel');
title('-log_{10}(p)');
