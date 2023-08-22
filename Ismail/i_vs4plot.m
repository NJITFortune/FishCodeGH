function vsout = i_vs(spikesig1, spikesig2, sig1, sig2, figureTitle)
% This generates the polar plot of velocity versus amplitude (or any two signals)
% This requires data prepared by i_tim2stim. 
% In fact, you need to run i_tim2stim twice! (usually velocity and acceleration)
%
% Usage: vsout = i_vs(spikeSignal1, spikeSignal2, signal1, signal2, FigureTitleCaption)
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
    numBins = 24; % Set the number of bins you want (24 is a good choice)
    bns = 0:2*pi/numBins:2*pi; % The bins
    snb = bns(1:end-1)+pi/numBins; % Plot points in middle of bins

% Get the histograms for both spikes and stimuli using our bins    
    spikeHist = histcounts(vsout.spikeang, bns);
    sigHist = histcounts(vsout.sigang, bns);

% Calculate a normalized spike rate by dividing the number of stimulus counts
    normSigCnt = sum(spikeHist) / sum(sigHist);
    firingRatio = spikeHist ./ (sigHist * normSigCnt);
    
% % RAW PLOT (just a sanity check - never to be used)
%     figure(27); clf; 
%         % First the raw signal data
%         polarplot(vsout.sigang, log(vsout.sigmag), 'b.');
%         hold on;
%         % Second the spike data
%         polarplot(vsout.spikeang, log(vsout.spikemag), 'm.')
%         % Third the histogram data
%         polarplot(snb, log(1000*(spikeHist / max(spikeHist))), 'ko-', 'LineWidth', 2);

% Normalized polar plot and associated histograms    
%     f = figure(28); f.Name = figureTitle;
    set(gcf, 'renderer', 'painters');

subplot(221); 
% CHOOSE EITHER A polarplot OR A polarhistogram
%     polarplot([snb snb(1)], [firingRatio firingRatio(1)], 'LineWidth', 2);
    polarhistogram('BinCounts', firingRatio, 'BinEdges', bns);
    rlim([0 2.5]); 

 
%% Report to the user some values

Vsi = vv - sigvv; % Direction selectivity Index
Asi = aa - sigaa; % Acceleration selectivity Index

% Give a quick quadrant value (ratio where 1 is expected)
PvPa = (length(find(spikesig1 > 0 & spikesig2 > 0)) / length(spikesig1)) / 0.25; % +vel +acc Q1
NvPa = (length(find(spikesig1 < 0 & spikesig2 > 0)) / length(spikesig1)) / 0.25; % -vel +acc Q2
NvNa = (length(find(spikesig1 < 0 & spikesig2 < 0)) / length(spikesig1)) / 0.25; % -vel -acc Q3
PvNa = (length(find(spikesig1 > 0 & spikesig2 < 0)) / length(spikesig1)) / 0.25; % +vel -acc Q4

fprintf('VelSI=%1.2f, AccSI=%1.2f, Q1=%1.2f, Q2=%1.2f, Q3=%1.2f, Q4=%1.2f \n', Vsi, Asi, PvPa, NvPa, NvNa, PvNa);
