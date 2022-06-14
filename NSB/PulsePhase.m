function out = PulsePhase(ChEOD, ChSTIM, regions, dur, threshes)
% Usage: out = PulsePhase(ChEOD, ChSTIM, regions, dur)
% • ChEOD is the Spike2 channel with EOD (Ch1 for NSB)
% • ChSTIM is the Spike2 channel with STIMULUS (Ch4 for NSB)
% • regions are the start times for stimuli (could be Ch31.times)
% • dur is the duration in seconds of the stimuli
% • threshes are the voltages to get EOD and STIM spikes e.g. [0.2 1]

%% Setup
    Fs = 1/ChEOD.interval;
    tim = 1/Fs:1/Fs:ChEOD.length/Fs;

    eod = ChEOD.values;
    stim = ChSTIM.values;

% User specified the thresholds
if nargin == 5; eodthresh = threshes(1); stimthresh = threshes(2); end

% Get the thresholds via clicks
if nargin < 5 
    figure(1); clf; plot(eod(tim < 5)); title('Click Threshold for EOD');
        [~, eodthresh] = ginput(1);
        pause(1);
    figure(1); clf; plot(stim(tim < 5)); title('Click Threshold for STIMULUS');
        [~, stimthresh] = ginput(1);
        pause(1); close(1);
end
fprintf('EOD threshold is %2.4f, STIM threshold is %2.4f \n', eodthresh, stimthresh);

%% Get time stamps for the EOD and STIMULUS    
    Zeod = zeros(1,length(eod));
        Zeod(eod > eodthresh) = 1;
        Zeod = diff(Zeod); Zeod(end+1) = 0;
    Zstim = zeros(1,length(stim));
        Zstim(stim > stimthresh) = 1;
        Zstim = diff(Zstim); Zstim(end+1) = 0;

eodIDXs = find(Zeod == 1);
    eodTIMs = tim(eodIDXs);
stimIDXs = find(Zstim == 1);
    stimTIMs = tim(stimIDXs);

%% Quick plot

figure(1); clf;
    ax(1) = subplot(211); plot(tim(eodIDXs(2:end)), 1 ./ diff(tim(eodIDXs)), '.');
        meanFreq = mean(1 ./ diff(tim(eodIDXs)));
        stdFreq = std(1 ./ diff(tim(eodIDXs)));
        title(['MeanFreq: ' num2str(meanFreq) ' STD: ' num2str(stdFreq)])
        ylim([meanFreq - 40, meanFreq + 150])
    ax(2) = subplot(212); plot(tim(stimIDXs(2:end)), 1 ./ diff(tim(stimIDXs)), '.');
        ylim([meanFreq - 40, meanFreq + 150])

    linkaxes(ax, 'x')

%% Get and analyze datums

for kk = 1:length(regions)

    tt = find(stimTIMs > regions(kk) & stimTIMs < regions(kk) + dur);

    for j=length(tt):-1:1
        preTIM = eodTIMs(eodTIMs < stimTIMs(tt(j)));
            preDUR(j) = stimTIMs(tt(j)) - preTIM(end);
        postTIM = eodTIMs(eodTIMs > stimTIMs(tt(j)));
            postDUR(j) = postTIM(2) - postTIM(1);
            preISIdur(j) =  preTIM(end) - preTIM(end-1);
            siuPhase(j) = 2*pi*(preDUR(j) / (postTIM(1)-preTIM(end)));
    end

end

figure(2); clf;     
    subplot(211); plot(siuPhase, preISIdur./postDUR, '.');
        ylim([0.95 1.1]); xlim([0 2*pi]);
    subplot(212); histogram(preISIdur - postDUR); 
        xlim([-0.001 0.001]);


figure(3); clf;   
    tpre = find(siuPhase <= pi;); tpost = find(siuPhase > pi);
    preISIdur = [preISIdur(tpost) preISIdur(tpre)];
    postDUR = [postDUR(tpost) postDUR(tpre)];
    
    plot(siuPhase, preISIdur ./ postDUR, '.');
        ylim([0.95 1.1]); xlim([0 2*pi]);


    out = 0;
