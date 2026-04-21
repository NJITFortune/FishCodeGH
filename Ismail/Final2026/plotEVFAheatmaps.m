function plotEVFAheatmaps(curfish, fishNo, neuronNo, spikeShiftEV, spikeShiftFA)

 % fishNo = 3;
 % neuronNo = 4;

colorScalar = 2;

spiketimes = curfish(fishNo).spikes.times(curfish(fishNo).spikes.codes == neuronNo);   
tim = curfish(fishNo).time;
errVel = curfish(fishNo).error_vel;
fishAcc = curfish(fishNo).fish_acc;

%% USER PARAMETERS
nbins         = 20;
% errorVelRange = [-600 600];       % legacy fixed ranges
% fishAccRange  = [-1800 1800];
errorVelRange = prctile(errVel,  [1 99]);   % data-driven ranges
fishAccRange  = prctile(fishAcc, [1 99]);
fprintf('errorVelRange: [%.1f, %.1f]    fishAccRange: [%.1f, %.1f]\n', ...
    errorVelRange(1), errorVelRange(2), fishAccRange(1), fishAccRange(2));
smoothSigma   = 0.75;          % Gaussian sigma in bins
nShuffles     = 200;        % number of shuffles
% spikeShift    = 500;          % ms: sample EV this many ms before spike, FA this many ms after spike

%% Restrict waveform samples
validSamples = ...
    errVel >= errorVelRange(1) & errVel <= errorVelRange(2) & ...
    fishAcc >= fishAccRange(1) & fishAcc <= fishAccRange(2);

vErrVel = errVel(validSamples);
vFishAcc = fishAcc(validSamples);

    % figure(27); clf; 
    %     foobar = find(errVel >= errorVelRange(1) & errVel <= errorVelRange(2) & ...
    %         fishAcc >= fishAccRange(1) & fishAcc <= fishAccRange(2) ); 
    %     ax(1) = subplot(211); plot(errVel); hold on; plot(foobar, vErrVel, '.-')
    %     ax(2) = subplot(212); plot(fishAcc); hold on; plot(foobar, vFishAcc, '.-');
    %     linkaxes(ax, 'x')

% vTIM = tim(validSamples);

% dT = median(diff(tim));
dT = 1 / curfish(fishNo).fs;

%% Bin edges
edgesEV = linspace(errorVelRange(1), errorVelRange(2), nbins+1);
edgesFA = linspace(fishAccRange(1), fishAccRange(2), nbins+1);

%% Occupancy
occCounts = histcounts2(vErrVel, vFishAcc, edgesEV, edgesFA);
occupancy = occCounts * dT;



%% Interpolate spike waveform values
spikeShiftEV_s = spikeShiftEV / 1000;   % convert ms to seconds
spikeShiftFA_s = spikeShiftFA / 1000;   % convert ms to seconds
spikesEV = interp1(tim, errVel,  spiketimes - spikeShiftEV_s, 'linear', 'extrap');
spikesFA = interp1(tim, fishAcc, spiketimes + spikeShiftFA_s, 'linear', 'extrap');

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
    
    % % Circular time shift
    % shiftAmount = rand * TotalTime;
    % shuffledSpikes = mod(spiketimes + shiftAmount - tim(1), TotalTime) + tim(1);

    shuffledSpikes = spiketimes;
    % Random Permutation shuffle
    spikeIntervals = diff(spiketimes);
    shuffIDX = randperm(length(spikeIntervals));
    for j=1:length(shuffIDX)        
        shuffledSpikes(j+1) = shuffledSpikes(j)+spikeIntervals(shuffIDX(j));
    end
    % Interpolate shuffled waveform values
    sw1 = interp1(tim, errVel,  shuffledSpikes - spikeShiftEV_s, 'linear', 'extrap');
    sw2 = interp1(tim, fishAcc, shuffledSpikes + spikeShiftFA_s, 'linear', 'extrap');
    
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
hold on; plot(errorVelRange, [0, 0], 'k-', 'LineWidth', 2);
hold on; plot([0, 0], fishAccRange, 'k-', 'LineWidth', 2);
clim([0 colorScalar*(length(spiketimes)/max(tim))]);

text(-500, 1000, [num2str(fishNo), ', ', num2str(neuronNo)], 'Color', 'White')
text(-500, 600, [num2str(length(spiketimes)), ', ', num2str(floor(max(tim))), ', ', num2str(round(length(spiketimes)/max(tim),2))], 'Color', 'White')
text(-500, 200, sprintf('SI_{EV} = %.2f,  SI_{FA} = %.2f', siEV, siFA), 'Color', 'White')


axis xy
colorbar
title('Smoothed Rate Map')

subplot(2,2,2)
imagesc(edgesEV(1:end-1), edgesFA(1:end-1), zMap');
hold on; plot(errorVelRange, [0, 0], 'k-', 'LineWidth', 2);
plot([0, 0], fishAccRange, 'k-', 'LineWidth', 2);
axis xy
colorbar
title('Z-score Map')

subplot(2,2,3)
imagesc(edgesEV(1:end-1), edgesFA(1:end-1), shuffleMean');
hold on; plot(errorVelRange, [0, 0], 'k-', 'LineWidth', 2);
plot([0, 0], fishAccRange, 'k-', 'LineWidth', 2);
clim([0 colorScalar*(length(spiketimes)/max(tim))]);

axis xy
colorbar
title('Shuffle Mean')

subplot(2,2,4)
imagesc(edgesEV(1:end-1), edgesFA(1:end-1), -log10(pMap)');
% imagesc(edgesEV(1:end-1), edgesFA(1:end-1), pMap');
hold on; plot(errorVelRange, [0, 0], 'k-', 'LineWidth', 2);
plot([0, 0], fishAccRange, 'k-', 'LineWidth', 2);
axis xy
colorbar
title('-log10(p)')




figure(88); clf;
imagesc(edgesEV(1:end-1), edgesFA(1:end-1), occupancy');
hold on; plot(errorVelRange, [0, 0], 'k-', 'LineWidth', 2);
hold on; plot([0, 0], fishAccRange, 'k-', 'LineWidth', 2);
