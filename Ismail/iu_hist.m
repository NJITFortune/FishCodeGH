function out = iu_hist(spiketimes, randspiketimes, pos, vel, acc, Fs)
% Function out = iu_hist(spikes, randspikes, sig, Fs, wid)
% spikes are the spike times
% randspikes are shuffled spike times
% sig is the signal (e.g. error_vel) of interest. Behavior...
% Fs is the sample rate (usually 25 for these data, fs = 25
% wid is the width of the spike triggered average in seconds (1 or 2 seconds is good)%% Histogram of All Spikes as Isolated Spikes

tim = 1/Fs:1/Fs:length(pos)/Fs; % Time stamps for the duration of the signal.



% Get the signal values

spikePOS = interp1(tim, pos, spiketimes);


% Determine edge boundaries
    meanFeature = mean(spike_features);
    histBound   = abs((meanFeature >= 0) * (meanFeature + std_coeff*std(spike_features)) + (meanFeature < 0) * (meanFeature - std_coeff*std(spike_features)));
    coverage    = 100 * sum(spike_features > -histBound & spike_features < histBound) / length(spike_features);
    edges  = linspace(-histBound, histBound, numOfBins+1);

    N1      = histcounts(occupancy, edges);
    N1      = N1 / 25;
    
    N2      = histcounts(spike_features, edges);
    N2_rand = histcounts(spike_features_rand, edges); 

    occMap       = N1;     occMap(~isfinite(occMap)) = 0;
    allSpikes    = N2;     allSpikes(~isfinite(allSpikes)) = 0;
    OccCorrected = N2./N1; 
    OccCorrected(~isfinite(OccCorrected)) = 0;
    
allSpikes_rand    = N2_rand;     allSpikes_rand(~isfinite(allSpikes_rand)) = 0;
OccCorrected_rand = N2_rand./N1; OccCorrected_rand(~isfinite(OccCorrected_rand)) = 0;

figure,

subplot 311
histogram('BinEdges',edges,'BinCounts',occMap)
title('Occupancy Map - All Spikes as Isolated')

subplot 312
histogram('BinEdges',edges,'BinCounts',allSpikes)
title('Uncorrected Spike Distribution')

subplot 313
hold on
histogram('BinEdges',edges,'BinCounts',OccCorrected)
histogram('BinEdges',edges,'BinCounts',OccCorrected_rand,'DisplayStyle','stairs','LineWidth',2)
legend('Actual', 'Randomized')
title('Occupancy Corrected Spike Rate')


end
