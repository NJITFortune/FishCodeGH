%% Inputs (example names)
% t_spikes  : [Ns x 1] spike times (sec)
% t_signal  : [Nt x 1] time vector for waveforms (sec)
% wave1     : [Nt x 1] first waveform
% wave2     : [Nt x 1] second waveform

fishNo = 3;
neuronNo = 4;

t_spikes = curfish(fishNo).spikes.times(curfish(fishNo).spikes.codes == neuronNo);   
t_signal = curfish(fishNo).time;
wave1 = curfish(fishNo).error_vel;
wave2 = curfish(fishNo).fish_acc;

%% USER PARAMETERS
nbins      = 18;
range1     = [-600 600];
range2     = [-1800 1800];
smoothSigma = 1;          % Gaussian sigma in bins
nShuffle   = 200;         % number of shuffles

%% Restrict waveform samples
validSamples = ...
    wave1 >= range1(1) & wave1 <= range1(2) & ...
    wave2 >= range2(1) & wave2 <= range2(2);

wave1r = wave1(validSamples);
wave2r = wave2(validSamples);
t_signal_r = t_signal(validSamples);

dt = median(diff(t_signal));

%% Bin edges
edges1 = linspace(range1(1), range1(2), nbins+1);
edges2 = linspace(range2(1), range2(2), nbins+1);

%% Occupancy
occCounts = histcounts2(wave1r, wave2r, edges1, edges2);
occupancy = occCounts * dt;

%% Interpolate spike waveform values
spike_w1 = interp1(t_signal, wave1, t_spikes, 'linear', 'extrap');
spike_w2 = interp1(t_signal, wave2, t_spikes, 'linear', 'extrap');

validSpikes = ...
    spike_w1 >= range1(1) & spike_w1 <= range1(2) & ...
    spike_w2 >= range2(1) & spike_w2 <= range2(2);

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

T = t_signal(end) - t_signal(1);
shuffleMaps = zeros(nbins, nbins, nShuffle);

for s = 1:nShuffle
    
    % Circular time shift
    shiftAmount = rand * T;
    shuffledSpikes = mod(t_spikes + shiftAmount - t_signal(1), T) + t_signal(1);
    
    % Interpolate shuffled waveform values
    sw1 = interp1(t_signal, wave1, shuffledSpikes, 'linear', 'extrap');
    sw2 = interp1(t_signal, wave2, shuffledSpikes, 'linear', 'extrap');
    
    valid = ...
        sw1 >= range1(1) & sw1 <= range1(2) & ...
        sw2 >= range2(1) & sw2 <= range2(2);
    
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

subplot(2,2,2)
imagesc(edges1(1:end-1), edges2(1:end-1), zMap');
axis xy
colorbar
title('Z-score Map')

subplot(2,2,3)
imagesc(edges1(1:end-1), edges2(1:end-1), -log10(pMap)');
axis xy
colorbar
title('-log10(p)')

subplot(2,2,4)
imagesc(edges1(1:end-1), edges2(1:end-1), shuffleMean');
axis xy
colorbar
title('Shuffle Mean')


