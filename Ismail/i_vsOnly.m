function vsout = i_vsOnly(spikesig1, spikesig2, sig1, sig2)
% This generates the polar plot of velocity versus amplitude (or any two signals)
% This requires data prepared by i_tim2stim. 
% In fact, you need to run i_tim2stim twice! (usually velocity and acceleration)
%
% Usage: vsout = i_vsOnly(spikeSignal1, spikeSignal2, signal1, signal2)
%
% spiketimes = curfish.allspikes.times(curfish.allspikes.codes == neuron);
% [evAmp, evCat] = i_tim2stim(spiketimes, curfish.error_vel, curfish.time, curfish.tracking, -0.1);
% [eaAmp, eaCat] = i_tim2stim(spiketimes, curfish.error_acc, curfish.time, curfish.tracking, -0.1);
% vsout = i_vs(evAmp(evCat == 2), eaAmp(eaCat == 2), curfish.error_vel(curfish.tracking == 2), curfish.error_acc(curfish.tracking == 2), 'Pen 3 Active -0.1');
%
% For 2023 - use sig1 as velocity and sig2 as acceleration

%% SPIKES

% Get lengths for vector for spikes [THIS IS CURRENTLY UNUSED]
    vsout.spikemag = sqrt(spikesig1.^2 + spikesig2.^2);

% Get angles for vector for spikes 
    vsout.spikeang = atan(spikesig2 ./ spikesig1); % -pi to -pi

    % Adjust our -pi to pi values to be 0 to 2pi
    for j=1:length(vsout.spikeang)
        if spikesig1(j) < 0
            vsout.spikeang(j) = pi + vsout.spikeang(j);
        end
        if spikesig1(j) > 0 && spikesig2(j) < 0
            vsout.spikeang(j) = (2*pi) + vsout.spikeang(j);
        end
    end

%% SIGNAL

% Get lengths for vector for signal [THIS IS CURRENTLY UNUSED]
    vsout.sigmag = sqrt(sig1.^2 + sig2.^2);

% Get angles for vector for signal
    vsout.sigang = atan(sig2 ./ sig1); % -pi to -pi

% Adjust our -pi to pi values to be 0 to 2pi    
    for j=1:length(vsout.sigang)
        if sig1(j) < 0
            vsout.sigang(j) =  pi + vsout.sigang(j);
        end
        if sig1(j) > 0 && sig2(j) < 0
            vsout.sigang(j) = (2*pi) + vsout.sigang(j);
        end
    end

%% CALCULATE AND PLOT

% Bins for angles 
    numBins = 12; % Set the number of bins you want (24 is a good choice)
    bns = 0:2*pi/numBins:2*pi; % The bins
    %snb = bns(1:end-1)+pi/numBins; % Plot points in middle of bins

% Get the histograms for both spikes and stimuli using our bins    
    spikeHist = histcounts(vsout.spikeang, bns);
    sigHist = histcounts(vsout.sigang, bns);
    sigHist(sigHist == 0) = 1;

% Calculate a normalized spike rate by dividing the number of stimulus counts
    normSigCnt = sum(spikeHist) / sum(sigHist);
    firingRatio = spikeHist ./ (sigHist * normSigCnt);
    
   pp = polarhistogram('BinCounts', firingRatio, 'BinEdges', bns, 'DisplayStyle', 'stairs');
 
   rlim([0 2.5]); 

   vsout.numspikes = length(spikesig1);

       VSIvelSpikes = (length(find(spikesig1 > 0)) - length(find(spikesig1 < 0))) / length(spikesig1);
       VSIvelSignal = (length(find(sig1 > 0)) - length(find(sig1 < 0))) / length(sig1);
   vsout.normVSI = (VSIvelSpikes - VSIvelSignal);

       ASIvelSpikes = (length(find(spikesig2 > 0)) - length(find(spikesig2 < 0))) / length(spikesig2);
       ASIvelSignal = (length(find(sig2 > 0)) - length(find(sig2 < 0))) / length(sig2);
   vsout.normASI = (ASIvelSpikes - ASIvelSignal);



