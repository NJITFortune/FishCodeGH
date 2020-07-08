function out = iu_hist(spiketimes, randspiketimes, pos, vel, acc, Fs)
% Function out = iu_hist(spikes, randspikes, sig, Fs, wid)
% spikes are the spike times
% randspikes are shuffled spike times
% sig is the signal (e.g. error_vel) of interest. Behavior...
% Fs is the sample rate (usually 25 for these data, fs = 25
% wid is the width of the spike triggered average in seconds (1 or 2 seconds is good)%% Histogram of All Spikes as Isolated Spikes

tim = 1/Fs:1/Fs:length(pos)/Fs; % Time stamps for the duration of the signal.



% Get the signal values at spike times

    spikePOS = interp1(tim, pos, spiketimes);
    spikeVEL = interp1(tim, vel, spiketimes);
    spikeACC = interp1(tim, acc, spiketimes);

    RspikePOS = interp1(tim, pos, randspiketimes);
    RspikeVEL = interp1(tim, vel, randspiketimes);
    RspikeACC = interp1(tim, acc, randspiketimes);


    
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

    function foo = OccHist(sig, spks)
        
    % Determine edge boundaries
    meanFeature = mean(spks);
    histBound   = abs((meanFeature >= 0) * (meanFeature + std_coeff*std(spks)) + (meanFeature < 0) * (meanFeature - std_coeff*std(spks)));
    cvrg    = 100 * sum(spks > -histBound & spks < histBound) / length(spks);
    edgs  = linspace(-histBound, histBound, numOfBins+1);

    hc      = histcounts(sig, edgs);
    % hc      = hc / 25;
    
    N2      = histcounts(spks, edgs);

    occMap       = N1;     
        occMap(~isfinite(occMap)) = 0;
    allSpikes    = N2;     
        allSpikes(~isfinite(allSpikes)) = 0;
    OccCorrected = N2./N1; 
        OccCorrected(~isfinite(OccCorrected)) = 0;
    
    end


end
