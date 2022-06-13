Fs = 1/Ch1.interval;
tim = 1/Fs:1/Fs:Ch1.length/Fs;

eod = Ch1.values;
stim = Ch4.values;

SIU = [270, 430];
nSIU = [180 350];
dur = 70;

eodthresh = 0.2;
stimthresh = 1;

    Zeod = zeros(1,length(eod));
        Zeod(eod > eodthresh) = 1;
        Zeod = diff(Zeod); Zeod(end+1) = 0;
    Zstim = zeros(1,length(stim));
        Zstim(stim > stimthresh) = 1;
        Zstim = diff(Zstim); Zstim(end+1) = 0;

eodIDXs = find(Zeod == 1);
stimIDXs = find(Zstim == 1);

%% 

figure(1); clf;
    subplot(211); plot(tim(eodIDXs(2:end)), 1 ./ diff(tim(eodIDXs)));
        meanFreq = mean(1 ./ diff(tim(eodIDXs)));
        stdFreq = std(1 ./ diff(tim(eodIDXs)));
        title(['MeanFreq: ' num2str(meanFreq) ' STD: ' num2str(stdFreq)])
    subplot(212); plot(tim(stimIDXs(2:end)), 1 ./ diff(tim(stimIDXs)));

%%

tt = find(tim(eodIDXs) > SIU(1) & tim(eodIDXs) < SIU(1) + dur);

for j=2:length(tt)-1

    preISIdur = tim(eodIDXs(tt(j))) - tim(eodIDXs(tt(j-1)))


end