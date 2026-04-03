function plotEVFAheatmaps(curfish, fishNo, neuronNo)

% fishNo = 3;
% neuronNo = 4;

spiketimes = curfish(fishNo).spikes.times(curfish(fishNo).spikes.codes == neuronNo);   
tim = curfish(fishNo).time;
errVel = curfish(fishNo).error_vel;
fishAcc = curfish(fishNo).fish_acc;

%% USER PARAMETERS
nbins         = 18;
errorVelRange = [-600 600];
fishAccRange  = [-1800 1800];
smoothSigma   = 1;          % Gaussian sigma in bins
nShuffles     = 200;        % number of shuffles
spikeShift    = 0;          % ms: sample EV this many ms before spike, FA this many ms after spike

%% Restrict waveform samples
validSamples = ...
    errVel >= errorVelRange(1) & errVel <= errorVelRange(2) & ...
    fishAcc >= fishAccRange(1) & fishAcc <= fishAccRange(2);

vErrVel = errVel(validSamples);
vFishAcc = fishAcc(validSamples);
% vTIM = tim(validSamples);

dT = median(diff(tim));

%% Bin edges
edgesEV = linspace(errorVelRange(1), errorVelRange(2), nbins+1);
edgesFA = linspace(fishAccRange(1), fishAccRange(2), nbins+1);

%% Occupancy
occCounts = histcounts2(vErrVel, vFishAcc, edgesEV, edgesFA);
occupancy = occCounts * dT;

%% Interpolate spike waveform values
spikeShift_s = spikeShift / 1000;   % convert ms to seconds
spikesEV = interp1(tim, errVel,  spiketimes - spikeShift_s, 'linear', 'extrap');
spikesFA = interp1(tim, fishAcc, spiketimes + spikeShift_s, 'linear', 'extrap');

validSpikes = ...
    spikesEV >= errorVelRange(1) & spikesEV <= errorVelRange(2) & ...
    spikesFA >= fishAccRange(1) & spikesFA <= fishAccRange(2);

spikesEVv = spikesEV(validSpikes);
spikesFAv = spikesFA(validSpikes);

%% Selectivity indices
nTotal = length(spikesEVv);
siEV = (sum(spikesEVv > 0) - sum(spikesEVv < 0)) / nTotal;
siFA = (sum(spikesFAv > 0) - sum(spikesFAv < 0)) / nTotal;

%% Spike counts
spikeCounts = histcounts2(spikesEVv, spikesFAv, edgesEV, edgesFA);

%% ---- SMOOTHING (occupancy-aware) ----

spikeCountsSmooth = imgaussfilt(spikeCounts, smoothSigma);
occupancySmooth   = imgaussfilt(occupancy,   smoothSigma);

rateMap = spikeCountsSmooth ./ occupancySmooth;
rateMap(occupancySmooth < 1e-6) = NaN;

%% ===============================
%% ===== SHUFFLE SIGNIFICANCE ====
%% ===============================

TotalTime = tim(end) - tim(1);
shuffleMaps = zeros(nbins, nbins, nShuffles);

for s = 1:nShuffles
    
    % Circular time shift
    shiftAmount = rand * TotalTime;
    shuffledSpikes = mod(spiketimes + shiftAmount - tim(1), TotalTime) + tim(1);
    
    % Interpolate shuffled waveform values
    sw1 = interp1(tim, errVel,  shuffledSpikes - spikeShift_s, 'linear', 'extrap');
    sw2 = interp1(tim, fishAcc, shuffledSpikes + spikeShift_s, 'linear', 'extrap');
    
    valid = ...
        sw1 >= errorVelRange(1) & sw1 <= errorVelRange(2) & ...
        sw2 >= fishAccRange(1) & sw2 <= fishAccRange(2);
    
    sw1 = sw1(valid);
    sw2 = sw2(valid);
    
    sc = histcounts2(sw1, sw2, edgesEV, edgesFA);
    
    scSmooth = imgaussfilt(sc, smoothSigma);
    
    shuffleMaps(:,:,s) = scSmooth ./ occupancySmooth;
end

%% Compute shuffle statistics
shuffleMean = mean(shuffleMaps, 3);
shuffleStd  = std(shuffleMaps, [], 3);

zMap = (rateMap - shuffleMean) ./ shuffleStd;

pMap = mean(shuffleMaps >= rateMap, 3);  % one-sided p-value
pMap(occupancySmooth < 1e-6) = NaN;     % mask unvisited bins (avoids -log10(0) = Inf)

%% ===============================
%% ========== PLOTTING ==========
%% ===============================

figure;

subplot(2,2,1)
imagesc(edgesEV(1:end-1), edgesFA(1:end-1), rateMap');
hold on; plot([-500, 500], [0, 0], 'k-', 'LineWidth', 2);
hold on; plot([0, 0], [-1500, 1500], 'k-', 'LineWidth', 2);

text(-500, 1000, [num2str(fishNo), ', ', num2str(neuronNo)], 'Color', 'White')
text(-500, 600, [num2str(length(spiketimes)), ', ', num2str(floor(max(tim))), ', ', num2str(round(length(spiketimes)/max(tim),2))], 'Color', 'White')
text(-500, 200, sprintf('SI_{EV} = %.2f,  SI_{FA} = %.2f', siEV, siFA), 'Color', 'White')


axis xy
colorbar
title('Smoothed Rate Map')

subplot(2,2,2)
imagesc(edgesEV(1:end-1), edgesFA(1:end-1), zMap');
hold on; plot([-500, 500], [0, 0], 'k-', 'LineWidth', 2);
plot([0, 0], [-1500, 1500], 'k-', 'LineWidth', 2);
axis xy
colorbar
title('Z-score Map')

subplot(2,2,3)
imagesc(edgesEV(1:end-1), edgesFA(1:end-1), shuffleMean');
hold on; plot([-500, 500], [0, 0], 'k-', 'LineWidth', 2);
plot([0, 0], [-1500, 1500], 'k-', 'LineWidth', 2);
axis xy
colorbar
title('Shuffle Mean')

subplot(2,2,4)
imagesc(edgesEV(1:end-1), edgesFA(1:end-1), -log10(pMap)');
hold on; plot([-500, 500], [0, 0], 'k-', 'LineWidth', 2);
plot([0, 0], [-1500, 1500], 'k-', 'LineWidth', 2);
axis xy
colorbar
title('-log10(p)')




