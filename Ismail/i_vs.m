function vsout = i_vs(spikesig1, spikesig2, sig1, sig2, ttt)


% Get lengths for vector for spikes
    vsout.spikemag = sqrt(spikesig1.^2 + spikesig2.^2);

% Get angles for vector for spikes
    vsout.spikeang = atan(spikesig2 ./ spikesig1);

for j=1:length(vsout.spikeang)
    if spikesig1(j) < 0
        vsout.spikeang(j) =  pi + vsout.spikeang(j);
    end
    if spikesig1(j) > 0 && spikesig2(j) < 0
        vsout.spikeang(j) = (2*pi) + vsout.spikeang(j);
    end
end

% Get lengths for vector for signal
    vsout.sigmag = sqrt(sig1.^2 + sig2.^2);

% Get angles for vector for spikes
    vsout.sigang = atan(sig2 ./ sig1);

for j=1:length(vsout.sigang)
    if sig1(j) < 0
        vsout.sigang(j) =  pi + vsout.sigang(j);
    end
    if sig1(j) > 0 && sig2(j) < 0
        vsout.sigang(j) = (2*pi) + vsout.sigang(j);
    end
end

figure(27); clf;
    polarplot(vsout.sigang, log(vsout.sigmag), 'b.');
    hold on;
    polarplot(vsout.spikeang, log(vsout.spikemag), 'm.')

bns = 0:2*pi/24:2*pi; snb = bns(1:end-1)+pi/24;
    spikeHist = histcounts(vsout.spikeang, bns);
    sigHist = histcounts(vsout.sigang, bns);

polarplot(snb, log(1000*(spikeHist / max(spikeHist))), 'ko-', 'LineWidth', 2);


f = figure(28); f.Name = ttt;
set(gcf, 'renderer', 'painters');
subplot(121); 

normSigCnt = sum(spikeHist) / sum(sigHist);

    firingRatio = spikeHist ./ (sigHist * normSigCnt);
    polarplot([snb snb(1)], [firingRatio firingRatio(1)], 'LineWidth', 2);
    hold on;

% polarhistogram('BinCounts', firingRatio, 'BinEdges', bns);
% hold on;

rlim([0 2.5]); 

rawvelbns = -500:50:500;
rawaccbns = -3000:300:3000;
    subplot(222); cla; histogram(spikesig1, rawvelbns); tmp = ylim;
        hold on; plot([0 0], tmp, 'r-'); text(-500, tmp(2)/2, 'Vel');

        vv = (length(find(spikesig1 > 0)) - length(find(spikesig1 < 0))) / length(spikesig1);
        sigvv = (length(find(sig1 > 0)) - length(find(sig1 < 0))) / length(sig1);
        
        text(-500, tmp(2)/4, num2str(vv - sigvv));
        text(-500, (tmp(2)/4)*3, num2str(length(spikesig1)));

    subplot(224); cla; histogram(spikesig2, rawaccbns); tmp = ylim;
        hold on; plot([0 0], tmp, 'r-'); text(-3000, tmp(2)/2, 'Acc')

        aa = (length(find(spikesig2 > 0)) - length(find(spikesig2 < 0))) / length(spikesig2);
        sigaa = (length(find(sig2 > 0)) - length(find(sig2 < 0))) / length(sig2);
        
        text(-3000, tmp(2)/4, num2str(aa - sigaa))

% Quadrent Selectivity Index

Vsi = vv - sigvv;
Asi = aa - sigaa;

PvPa = (length(find(spikesig1 > 0 & spikesig2 > 0)) / length(spikesig1)) / 0.25;
PvNa = (length(find(spikesig1 > 0 & spikesig2 < 0)) / length(spikesig1)) / 0.25;
NvNa = (length(find(spikesig1 < 0 & spikesig2 < 0)) / length(spikesig1)) / 0.25;
NvPa = (length(find(spikesig1 < 0 & spikesig2 > 0)) / length(spikesig1)) / 0.25;



fprintf('Vsi=%1.2f, Asi=%1.2f, Q1=%1.2f, Q2=%1.2f, Q3=%1.2f, Q4=%1.2f \n', Vsi, Asi, PvPa, NvPa, NvNa, PvNa);
