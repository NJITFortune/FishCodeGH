function out = ismailism(spikes, time, Fs, sig, nm)
% Usage out = ismailism(spikes, time, Fs, sig)
% load brown_123_smooth.mat
% Fs = 25; % Video sampling rate


isi_interval = 1.0;

% We will add a single spike at the starts and end of the sample so that our lengths
% match up better. Tricky trick.
spiketimes = [0 spikes.times', time(end)];

spikeintervals = diff(spiketimes); % Interspike interval as proxy for firing rate
spikeintervals(end+1) = spikeintervals(end); % add on fake sample at the end to match length

shuffledintervals = spikeintervals(randperm(length(spikeintervals)));
shuffledtimes(1) = 0;
for j=2:length(shuffledintervals)
    shuffledtimes(j) = shuffledtimes(j-1) + shuffledintervals(j-1);
end

resampSpikeIntervals = resample(spikeintervals, spiketimes, Fs); % Resampled to uniform rate
resampRandSpikeIntervals = resample(shuffledintervals, shuffledtimes, Fs); % Resampled to uniform rate

% Added filter to make Noah happy
[bb,aa] = butter(5, 5 / (Fs/2), 'low');
resampSpikeIntervals = filtfilt(bb,aa,resampSpikeIntervals);

if length(resampRandSpikeIntervals) ~= length(sig)
    fprintf('oops I did it again \n');
    resampRandSpikeIntervals(end+1) = resampRandSpikeIntervals(end);
end

%figure(1); clf;
%plot(time, sig / max(abs(sig)), time, resampSpikeIntervals / max(resampSpikeIntervals));

% Coherence 

figure(27); clf; 
    qw(1) = subplot(211); plot(time, resampRandSpikeIntervals)
    qw(2) = subplot(212); plot(time, sig);
    linkaxes(qw, 'x');
    
[pxyOrig,f] = mscohere(resampSpikeIntervals-mean(resampSpikeIntervals), sig,[],[],[],Fs);
[pxyShuf,~] = mscohere(resampRandSpikeIntervals-mean(resampRandSpikeIntervals), sig,[],[],[],Fs);

figure; clf; 
    ax(1) = subplot(223); hold on;
    plot(f, smooth(pxyShuf, 20));    
    plot(f, smooth(pxyOrig, 20));
    title('MS Cohere');
    
% Cross spectral density

[csdOrig,ff] = cpsd(resampSpikeIntervals-mean(resampSpikeIntervals), sig,[],[],[],Fs);
[csdShuf,~] = cpsd(resampRandSpikeIntervals-mean(resampRandSpikeIntervals), sig,[],[],[],Fs);

    ax(2) = subplot(211); hold on;
    plot(ff, smooth(abs(real(csdShuf)), 20));
    plot(ff, smooth(abs(real(csdOrig)), 20));
    title('Cross-Spectral Density');
linkaxes(ax, 'x');
xlim([0 4]); % Plot frequency range

text(3, max(smooth(abs(real(csdOrig)), 20))/3, nm);

% % Cross correlation
% 
% cc = xcorr(resampSpikeIntervals-mean(resampSpikeIntervals), sig);
% rcc = xcorr(resampRandSpikeIntervals-mean(resampRandSpikeIntervals), sig);
% 
% subplot(222); hold on;
% plot(rcc); plot(cc);

drawnow;

% Spike Triggered Average

statim = -isi_interval:1/Fs:isi_interval;

STA = zeros(1,length(statim));
RandSTA = zeros(1,length(statim));

tt = find(spiketimes > isi_interval & spiketimes < time(end)-isi_interval);
rtt = find(shuffledtimes > isi_interval & shuffledtimes < time(end)-isi_interval);

tt = tt(tt > max([tt(1) rtt(1)]) & tt < min([tt(end) rtt(end)]));

parfor idx = 1:length(tt)
    STA = STA + interp1(time, sig, spiketimes(tt(idx))-isi_interval:1/Fs:spiketimes(tt(idx))+isi_interval);      
    RandSTA = RandSTA + interp1(time, sig, shuffledtimes(tt(idx))-isi_interval:1/Fs:shuffledtimes(tt(idx))+isi_interval);      
end

STA = STA / length(tt);
RandSTA = RandSTA / length(tt);


subplot(224); plot(statim,RandSTA); hold on; plot(statim,STA); plot([0,0], [min(STA), max(STA)]);

out.STA = STA;
out.RandSTA = RandSTA;
out.Spikerate = resampSpikeIntervals;
