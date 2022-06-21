% nsb2022pulsestim(sig, Fs, centerfreq)

%% FOR GYMNOTUS 2022
% load Gymnotusmaker.mat
    sig = pulseavg;
    Fs = 40000;
    centerfreq = 50;
    gymnotus = 1;

freqrange = 20;

if iscolumn(sig); sig = sig'; end

sig = (sig / max(abs(sig))) * 0.9;

% Get the length of the signal - we will subtract this from our ISIs
    siglen = length(sig);

startlepulses = 0;
    while length(startlepulses) <= Fs
        startlepulses = [startlepulses, sig, zeros(1, round(Fs/centerfreq))];
    end
startlepulses = startlepulses(2:end);


%% Constant frequency pulses - take centerfreq and make -10, -5, 0, +5, and +10 Hz pulses

sigdur = 10; % length of stimulus in seconds

figure(1); clf;

% Our list of pulse rates
freqs = [centerfreq-10, centerfreq-5, centerfreq, centerfreq+5, centerfreq+10];

for j = 1:length(freqs)

    IPzeros = zeros(1, round(Fs/freqs(j)) - siglen); % Zeros between pulses

    pulses{j} = 0;

    while length(pulses{j}) <= sigdur * Fs
        pulses{j} = [pulses{j}, sig, IPzeros];
    end

    pulses{j} = pulses{j}(2:end);
    tim = 1/Fs:1/Fs:length(pulses{j})/Fs;
    ax(j) = subplot(length(freqs), 1, j); plot(tim, pulses{j});

end

linkaxes(ax,'x');

if gymnotus == 1
    audiowrite("gymFreqRate40.wav", pulses{1}, Fs);
    audiowrite("gymFreqRate45.wav", pulses{2}, Fs);
    audiowrite("gymFreqRate50.wav", pulses{3}, Fs);
    audiowrite("gymFreqRate55.wav", pulses{4}, Fs);
    audiowrite("gymFreqRate60.wav", pulses{5}, Fs);
end

%% Random ISIs (same range of ISIs as for the sinusoidal ISIs below (chirps)
baseintervalsamplelen = round(Fs/centerfreq) - siglen - freqrange;

    randpulses = 0;
    while length(randpulses) <= 10 * sigdur * Fs
        randpulses = [randpulses, sig, zeros(1, baseintervalsamplelen + randi(round(Fs/20)))];
    end

    randpulses = [startlepulses randpulses]; % Add startle eliminator

    figure(2); plot(1/Fs:1/Fs:length(randpulses)/Fs, randpulses);

if gymnotus == 1
    audiowrite("gymRand.wav", randpulses, Fs);
end


%% Sinusoidal AM (fish 'flyby')

IPzeros = zeros(1, round(Fs/centerfreq) - siglen); 

stimnum = 5;
sinfreqs = [0.1 0.2 0.4 0.8 1.6];

for j = 1:length(sinfreqs)
    numsamps = (stimnum * Fs) / sinfreqs(j);
    tim = 1/Fs:1/Fs:numsamps/Fs;
    ssAmp = -cos(2*pi*tim * sinfreqs(j));
        ssAmp = ssAmp + 1;  ssAmp = ssAmp/2;

    sampulses{j} = 0;
    while length(sampulses{j}) <= length(ssAmp)
        sampulses{j} = [sampulses{j}, sig, IPzeros];
    end
    sampulses{j} = sampulses{j}(2:end);
        if length(sampulses{j}) > length(ssAmp); sampulses{j} = sampulses{j}(1:length(ssAmp)); end

    sampulses{j} = sampulses{j} .* ssAmp(1:length(sampulses{j}));

    figure(3); 
        subplot(length(sinfreqs),1,j); plot(tim, sampulses{j});   

end

drawnow;

if gymnotus == 1
    audiowrite("gymSAM01.wav", sampulses{1}, Fs);
    audiowrite("gymSAM02.wav", sampulses{2}, Fs);    
    audiowrite("gymSAM04.wav", sampulses{3}, Fs);    
    audiowrite("gymSAM08.wav", sampulses{4}, Fs);
    audiowrite("gymSAM16.wav", sampulses{5}, Fs);
end


%% Sinusoidal pulse rate modulation (fish 'chirp')

minlen = baseintervalsamplelen;
    maxadd = round(Fs/20);

for j = 1:length(sinfreqs)
    numsamps = (stimnum * Fs) / sinfreqs(j);
    tim = 1/Fs:1/Fs:numsamps/Fs;

    isitim = 1/centerfreq:1/centerfreq:tim(end);
    sintims = cos(2*pi*isitim * sinfreqs(j));
        sintims = sintims + 1; sintims = sintims / 2;
        sintims = sintims * maxadd;

    chrp{j} = sig;
        for k = 1:length(sintims)
            chrp{j} = [chrp{j} zeros(1, round(sintims(k))), sig];
        end
    chrp{j} = [startlepulses, chrp{j},  zeros(1, round(sintims(1)))]; % Add startle eliminator at begining and zeros at end

    figure(4); 
        subplot(length(sinfreqs),1, j); plot(1/Fs:1/Fs:length(chrp{j})/Fs, chrp{j});

end

drawnow;

if gymnotus == 1
    audiowrite("gymPR01.wav", sampulses{1}, Fs);
    audiowrite("gymPR02.wav", sampulses{2}, Fs);    
    audiowrite("gymPR04.wav", sampulses{3}, Fs);    
    audiowrite("gymPR08.wav", sampulses{4}, Fs);
    audiowrite("gymPR16.wav", sampulses{5}, Fs);
end

