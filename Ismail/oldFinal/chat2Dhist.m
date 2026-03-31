%% Inputs (example names)
% spiketimes  : [Ns x 1] spike times (sec)
% tim  : [Nt x 1] time vector for waveforms (sec)
% waveEV     : [Nt x 1] Error Velocity
% waveFA     : [Nt x 1] Fish Acceleration

%% USER PARAMETERS

fishNo = 4;
neuronNo = 6;
evOffset = 0.100;
faOffset = 0.100;

nbins      = 18;
rangeXev     = [-380 380];
rangeYfa     = [-1600 1600];
smoothSigma = 1;          % Gaussian sigma in bins
nShuffle   = 200;         % number of shuffles

%% PREPARE DATA
spiketimes = curfish(fishNo).spikes.times(curfish(fishNo).spikes.codes == neuronNo);
     evSpikes = spiketimes - evOffset; evSpikes = evSpikes(evSpikes > 0);
     faSpikes = spiketimes + faOffset; faSpikes = faSpikes(faSpikes < spiketimes(end));

tim = curfish(fishNo).time;
waveEV = curfish(fishNo).error_vel;
waveFA = curfish(fishNo).fish_acc;

%% Restrict waveform samples
validSamples = ...
    waveEV >= rangeXev(1) & waveEV <= rangeXev(2) & ...
    waveFA >= rangeYfa(1) & waveFA <= rangeYfa(2);

waveEVr = waveEV(validSamples);
waveFAr = waveFA(validSamples);
t_signal_r = tim(validSamples);

dt = median(diff(tim));

%% Bin edges
edges1 = linspace(rangeXev(1), rangeXev(2), nbins+1);
edges2 = linspace(rangeYfa(1), rangeYfa(2), nbins+1);

%% Occupancy
occCounts = histcounts2(waveEVr, waveFAr, edges1, edges2);
occupancy = occCounts * dt;

%% Interpolate spike waveform values
spike_w1 = interp1(tim, waveEV, spiketimes, 'linear', 'extrap');
spike_w2 = interp1(tim, waveFA, spiketimes, 'linear', 'extrap');

validSpikes = ...
    spike_w1 >= rangeXev(1) & spike_w1 <= rangeXev(2) & ...
    spike_w2 >= rangeYfa(1) & spike_w2 <= rangeYfa(2);

spike_w1r = spike_w1(validSpikes);
spike_w2r = spike_w2(validSpikes);

%% Spike counts
spikeCounts = histcounts2(spike_w1r, spike_w2r, edges1, edges2);

%% ---- SMOOTHING (occupancy-aware) ----

spikeCountsSmooth = imgaussfilt(spikeCounts, smoothSigma);
occupancySmooth   = imgaussfilt(occupancy,   smoothSigma);

rateMap = spikeCountsSmooth ./ occupancySmooth;
rateMap(occupancySmooth < 1e-6) = NaN;

%% ===============================
%% ===== SHUFFLE SIGNIFICANCE ====
%% ===============================

T = tim(end) - tim(1);
shuffleMaps = zeros(nbins, nbins, nShuffle);

for s = 1:nShuffle
    
    % Circular time shift
    shiftAmount = rand * T;
    shuffledSpikes = mod(spiketimes + shiftAmount - tim(1), T) + tim(1);
    
    % Interpolate shuffled waveform values
    sw1 = interp1(tim, waveEV, shuffledSpikes, 'linear', 'extrap');
    sw2 = interp1(tim, waveFA, shuffledSpikes, 'linear', 'extrap');
    
    valid = ...
        sw1 >= rangeXev(1) & sw1 <= rangeXev(2) & ...
        sw2 >= rangeYfa(1) & sw2 <= rangeYfa(2);
    
    sw1 = sw1(valid);
    sw2 = sw2(valid);
    
    sc = histcounts2(sw1, sw2, edges1, edges2);
    
    scSmooth = imgaussfilt(sc, smoothSigma);
    
    shuffleMaps(:,:,s) = scSmooth ./ occupancySmooth;
end

%% Compute shuffle statistics
shuffleMean = mean(shuffleMaps, 3);
shuffleStd  = std(shuffleMaps, [], 3);

zMap = (rateMap - shuffleMean) ./ shuffleStd;

pMap = mean(shuffleMaps >= rateMap, 3);  % one-sided p-value

%% ===============================
%% ========== PLOTTING ==========
%% ===============================

figure;

subplot(2,2,1)
imagesc(edges1(1:end-1), edges2(1:end-1), rateMap');
axis xy
colorbar
title('Smoothed Rate Map')
hold on; plot([0,0], rangeYfa, 'k-'); plot(rangeXev, [0,0], 'k-');

subplot(2,2,2)
imagesc(edges1(1:end-1), edges2(1:end-1), zMap');
axis xy
colorbar
title('Z-score Map')
hold on; plot([0,0], rangeYfa, 'k-'); plot(rangeXev, [0,0], 'k-');

subplot(2,2,3)
imagesc(edges1(1:end-1), edges2(1:end-1), -log10(pMap)');
axis xy
colorbar
title('-log10(p)')
hold on; plot([0,0], rangeYfa, 'k-'); plot(rangeXev, [0,0], 'k-');

subplot(2,2,4)
imagesc(edges1(1:end-1), edges2(1:end-1), shuffleMean');
axis xy
colorbar
title('Shuffle Mean')
hold on; plot([0,0], rangeYfa, 'k-'); plot(rangeXev, [0,0], 'k-');


