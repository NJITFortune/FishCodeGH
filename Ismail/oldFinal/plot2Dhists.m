function plot2Dhists(dataStruct, fishNo, neuronNo, evOffset, faOffset)
% Usage plot2Dhists(dataStruct, fishNo, neuronNo, evOffset, faOffset)
% dataStruct should always be curfish (provided by load ismailCompleatFinal2024.mat)
% fishNo is the fish (range 1 to 13; if testing, use 9)
% neuronNo is the the ID of the spike waveform (range specific to each fish; if testing fish 9, use neuronNo 4)
% evOffset and faOffset are in seconds - the time before (for sensory EV) and the time after (for motor FA) to take values.  

%% USER SETTINGS
nbins        = 18;
rangeXev     = [-380 380];
rangeYfa     = [-1600 1600];   
smoothSigma  = 1;               % Gaussian sigma in bins
nShuffle     = 200;             % number of shuffles

%% PREPARE DATA
spiketimes = dataStruct(fishNo).spikes.times(dataStruct(fishNo).spikes.codes == neuronNo);
    evSpikes = spiketimes - evOffset; evIDX = find(evSpikes > 0); 
    faSpikes = spiketimes + faOffset; faIDX = find(faSpikes < spiketimes(end));
    sharedIDX = intersect(evIDX, faIDX);
    evSpikes = evSpikes(sharedIDX);
    faSpikes = faSpikes(sharedIDX);
    
tim = dataStruct(fishNo).time;
waveEV = dataStruct(fishNo).error_vel;
waveFA = dataStruct(fishNo).fish_acc;

%% Restrict waveform samples
validSamples = ...
    waveEV >= rangeXev(1) & waveEV <= rangeXev(2) & ...
    waveFA >= rangeYfa(1) & waveFA <= rangeYfa(2);

waveEVr = waveEV(validSamples);
waveFAr = waveFA(validSamples);

dt = median(diff(tim));

%% Bin edges
edges1 = linspace(rangeXev(1), rangeXev(2), nbins+1);
edges2 = linspace(rangeYfa(1), rangeYfa(2), nbins+1);

%% Occupancy
occCounts = histcounts2(waveEVr, waveFAr, edges1, edges2);
occupancy = occCounts * dt;

%% Interpolate spike waveform values and get spike counts for the histogram
spike_EV = interp1(tim, waveEV, evSpikes, 'linear', 'extrap');
spike_FA = interp1(tim, waveFA, faSpikes, 'linear', 'extrap');

validSpikes = ...
    spike_EV >= rangeXev(1) & spike_EV <= rangeXev(2) & ...
    spike_FA >= rangeYfa(1) & spike_FA <= rangeYfa(2);

spike_w1r = spike_EV(validSpikes);
spike_w2r = spike_FA(validSpikes);

spikeCounts = histcounts2(spike_w1r, spike_w2r, edges1, edges2);

%% ---- SMOOTHING 

spikeCountsSmooth = imgaussfilt(spikeCounts, smoothSigma);
occupancySmooth   = imgaussfilt(occupancy,   smoothSigma);

rateMap = spikeCountsSmooth ./ occupancySmooth;
rateMap(occupancySmooth < 1e-6) = NaN;

%% SHUFFLED data and analysis

T = tim(end) - tim(1);
shuffleMaps = zeros(nbins, nbins, nShuffle);

% Loop to get the number of shuffled maps
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

shuffleMean = mean(shuffleMaps, 3);
shuffleStd  = std(shuffleMaps, [], 3);

% Calculate the zScores for the 2D histogram 
zMap = (rateMap - shuffleMean) ./ shuffleStd; 

% Calculate p values (not particularly useful)
pMap = mean(shuffleMaps >= rateMap, 3);  % one-sided p-value

%% PLOT ==========

figure; 

ax(1) = subplot(2,2,1);
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

ax(2) = subplot(2,2,4);
imagesc(edges1(1:end-1), edges2(1:end-1), shuffleMean');
axis xy
colorbar
title('Shuffle Mean')
hold on; plot([0,0], rangeYfa, 'k-'); plot(rangeXev, [0,0], 'k-');
text(-100,-200, num2str(fishNo)); text(100,-200, num2str(neuronNo));

clim(ax, [ min([min(rateMap) min(shuffleMean)]), min([100, max([max(rateMap) max(shuffleMean)])]) ] );


