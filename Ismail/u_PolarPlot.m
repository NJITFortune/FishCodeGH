function vsout = u_PolarPlot(spiketimes, sig1, sig2, tim, delt, rango, figureTitle)
% Usage: vsout = u_PolarPlot(spiketimes, sig1, sig2, Fs, delt, figureTitle)
% This generates the polar plot of velocity versus amplitude (or any two signals)
%
% spiketimes = curfish.allspikes.times(curfish.allspikes.codes == neuron);
% vsout = i_vs(spiketimes, curfish.error_vel, curfish.error_acc, -0.1, 'Pen 3 Active -0.1');
%
% For 2024 - use sig1 as velocity and sig2 as acceleration

%% SPIKES
spikesig1orig = u_tim2stim(spiketimes, sig1, tim, delt);
spikesig2orig = u_tim2stim(spiketimes, sig2, tim, delt);

if ~isempty(rango)
    spikesig1 = spikesig1orig(abs(spikesig1orig) > rango(1) & abs(spikesig1orig) < rango(2) & abs(spikesig2orig) > rango(3) & abs(spikesig2orig) < rango(4));
    spikesig2 = spikesig2orig(abs(spikesig2orig) > rango(3) & abs(spikesig2orig) < rango(4) & abs(spikesig1orig) > rango(1) & abs(spikesig1orig) < rango(2));
else
    spikesig1 = spikesig1orig;
    spikesig2 = spikesig2orig;
end

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

%% Random Spikes

randspikes = u_randspikegen(spiketimes);

rspikesig1 = u_tim2stim(randspikes, sig1, tim, 0);
rspikesig2 = u_tim2stim(randspikes, sig2, tim, 0);

% Get lengths for vector for spikes [THIS IS CURRENTLY UNUSED]
    vsout.rspikemag = sqrt(rspikesig1.^2 + rspikesig2.^2);

% Get angles for vector for spikes 
    vsout.rspikeang = atan(rspikesig2 ./ rspikesig1); % -pi to -pi

    % Adjust our -pi to pi values to be 0 to 2pi
    for j=1:length(vsout.rspikeang)
        if rspikesig1(j) < 0
            vsout.rspikeang(j) = pi + vsout.rspikeang(j);
        end
        if rspikesig1(j) > 0 && rspikesig2(j) < 0
            vsout.rspikeang(j) = (2*pi) + vsout.rspikeang(j);
        end
    end


%% CALCULATE AND PLOT

% Bins for angles 
    numBins = 24; % Set the number of bins you want (24 is a good choice)
    bns = 0:2*pi/numBins:2*pi; % The bins
    snb = bns(1:end-1)+pi/numBins; % Plot points in middle of bins

% Get the histograms for both spikes and stimuli using our bins    
    spikeHist = histcounts(vsout.spikeang, bns);
    rspikeHist = histcounts(vsout.rspikeang, bns);
    sigHist = histcounts(vsout.sigang, bns);

% Calculate a normalized spike rate by dividing the number of stimulus counts
    normSigCnt = sum(spikeHist) / sum(sigHist);
    firingRatio = spikeHist ./ (sigHist * normSigCnt);

    rnormSigCnt = sum(spikeHist) / sum(rspikeHist);
    rfiringRatio = spikeHist ./ (rspikeHist * rnormSigCnt);
    rbaselinefiringRatio = rspikeHist ./ (rspikeHist * rnormSigCnt);
    
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
    f = figure(28); f.Name = figureTitle;
    set(gcf, 'renderer', 'painters');

subplot(121); 
% CHOOSE EITHER A polarplot OR A polarhistogram
%     polarplot([snb snb(1)], [firingRatio firingRatio(1)], 'LineWidth', 2);
   polarhistogram('BinCounts', firingRatio, 'BinEdges', bns);

    hold on;
    rlim([0 2.5]); 
    
% Add 1D histograms

    % For now, we are using a standard set of bins for Vel and Acc
    rawvelbns = -500:50:500;
    rawaccbns = -3000:300:3000;

    subplot(222); cla; 
        % histogram(spikesig1, rawvelbns); tmp = ylim;
        % hold on; plot([0 0], tmp, 'r-'); 
        sig1hist = histcounts(spikesig1, rawvelbns); 
        rsig1hist = histcounts(rspikesig1, rawvelbns);
        bar(rawvelbns(2:end)-25, (sig1hist - rsig1hist) / sum(spikeHist));
        tmp = ylim;
        hold on; xline(0, 'r'); 
        ylim([-0.05 0.05])
        
        vv = (length(find(spikesig1 > 0)) - length(find(spikesig1 < 0))) / length(spikesig1);
        sigvv = (length(find(sig1 > 0)) - length(find(sig1 < 0))) / length(sig1);
        
        text(-500, tmp(2)/2, ['VSI = ' num2str(vv) 'rVSI = ' num2str(sigvv)]);
        text(-500, (tmp(2)/4)*3, ['Spike Count = ' num2str(length(spikesig1))]);
        title('Velocity')

    subplot(224); cla; 
        % histogram(spikesig2, rawaccbns); tmp = ylim;
        % hold on; plot([0 0], tmp, 'r-'); 
        sig2hist = histcounts(spikesig2, rawaccbns); 
        rsig2hist = histcounts(rspikesig2, rawaccbns);
        bar(rawaccbns(2:end)-150, (sig2hist - rsig2hist) / sum(spikeHist));
        hold on; plot([0 0], tmp, 'r-');
        xlim([-3000, 3000])
        ylim([-0.05 0.05])

        aa = (length(find(spikesig2 > 0)) - length(find(spikesig2 < 0))) / length(spikesig2);
        sigaa = (length(find(sig2 > 0)) - length(find(sig2 < 0))) / length(sig2);
        
        text(-2500, tmp(2)/2, ['ASI = ' num2str(aa) ' rASI == ', num2str(sigaa)])
        title('Acceleration')
 
figure(23); clf; 
% CHOOSE EITHER A polarplot OR A polarhistogram
%     polarplot([snb snb(1)], [firingRatio firingRatio(1)], 'LineWidth', 2);
   polarhistogram('BinCounts', rfiringRatio, 'BinEdges', bns);

    hold on;
    rlim([0 2.5]); 

figure(24); clf; 
% CHOOSE EITHER A polarplot OR A polarhistogram
%     polarplot([snb snb(1)], [firingRatio firingRatio(1)], 'LineWidth', 2);
   polarhistogram('BinCounts', rbaselinefiringRatio, 'BinEdges', bns);

    hold on;
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
