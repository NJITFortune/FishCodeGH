%% Preparations

% Users get to choose the following
Fs = 20000; % Sample rate [Default = 20000]
EndTime = 2; % Length of signals in seconds [Default = 2]
S1f = 250; % Frequency in Hz of first fish [Default = 250; between 200 and 1000 Hz]
S2f = 260; % Frequency in Hz of second fish [Default = S1f +10]

% Make the sinewaves
tim = 1/Fs:1/Fs:EndTime; % time stamps for EndTime seconds of sampling
S1 = sin(tim*S1f*2*pi); % Fish #1 - 250 Hz
S2 = sin(tim*S2f*2*pi) * 0.8; % Fish #2 - 260 Hz and 80% of amplitude of fish #1

%% Two fish EOD example
figure(1); clf; % Raw and AM plots

% Raw signals
    ax(1) = subplot(211); hold on;
    plot(tim, S1, 'b'); plot(tim, S2, 'm');

% Summed signal with AM
    ax(2) = subplot(212); hold on;
    plot(tim, S1+S2, 'k');
    
    % One way to calculate amplitude envelope
    [PKS, LOCS] = findpeaks(abs(S1+S2));
    plot(tim(LOCS), PKS, 'r.-'); 

    linkaxes(ax,'x'); xlim([0 0.15]);

figure(2); clf; % Raw and S1+S2 and Zero-crossing plots

% Raw fish #1 signal with summed signal
    xa(1) = subplot(211); hold on;
    
    % Box to highlight AM increase (relative phase delay, black lines AFTER blue)
        h = fill([0.0501,0.0999,0.0999,0.0501],[2,2,-2,-2], 'cyan');
        h.FaceAlpha = 0.3; h.EdgeColor='cyan';
    
    plot([0 10], [0 0], 'k'); % zero line
    plot(tim, S1, 'b'); % Fish #1
    plot(tim, S1+S2, 'k'); % Combined signal of Fish #1 and #2
    
        S1x = zeros(1,length(S1));
        Cx = S1x;
        S1x(S1 > 0) = 1;
        Cx((S1+S2) > 0) = 1;
        
        S1xIDX = find(diff(S1x) == 1);
        CxIDX = find(diff(Cx) == 1);
        
% Zero crossings plot
    xa(2) = subplot(212); hold on;

    % Box to highlight AM increase (relative phase delay, black lines AFTER blue)
        g = fill([0.0501,0.0999,0.0999,0.0501],[1,1,-1,-1], 'cyan');
        g.FaceAlpha = 0.3; g.EdgeColor='cyan';
        
    plot([0 10], [0 0], 'k'); % zero line
     
     for j = 1:length(S1xIDX)
         plot([tim(S1xIDX(j)) tim(S1xIDX(j))], [-1 1], 'b', 'LineWidth', 0.5);
     end
     for j = 1:length(CxIDX)
         plot([tim(CxIDX(j)) tim(CxIDX(j))], [-0.75 0.75], 'k', 'LineWidth', 1);
     end
    
         linkaxes(xa,'x'); xlim([0.03 0.14]);

%% AMs: SAMs, RAMs   

% SINUSOIDAL SIGNAL
SSFreq = 20; % Modulation rate in Hz [Default = 20]

    SineSignal = (0.5*sin(tim*2*pi*SSFreq)) + 0.5;


% RANDOM SIGNAL
RR = 100;
    [b,a] = butter(3, RR/(Fs/2), 'low');
    
    RandomSignal = rand(1,length(S1)); % Use rand to make a random signal

    RandomSignal(1:round(Fs*(1/RR))) = 0.5; %%% ARGH. Theoretically, filtfilt should not have an artefact at the start. But it does, and this elinimates it.
    RandomSignal = filtfilt(b,a,RandomSignal);

    RandomSignal = RandomSignal - min(RandomSignal);
    RandomSignal = RandomSignal / max(RandomSignal);
     
% SUM OF SINES SIGNAL    
 
SoSFreqs = [1.13 5.55 17 29.12 55.13 82.07];

SoS = zeros(1,length(tim));

    for j = 1:length(SoSFreqs)
        SoS = SoS + sin(2*pi*tim*SoSFreqs(j));        
    end
    
    SoS = SoS - min(SoS);
    SoS = SoS / max(SoS);

% PLOT!!
    
    figure(3); clf; 
        xx(1) = subplot(311); hold on;
            plot(tim, S1.*SineSignal);
            plot(tim, SineSignal, 'r');
        xx(2) = subplot(312); hold on;
            plot(tim, S1.*RandomSignal);
            plot(tim, RandomSignal, 'r');
        xx(3) = subplot(313); hold on;
            plot(tim, S1.*SoS);
            plot(tim, SoS, 'r');
            
    linkaxes(xx,'x');
    
%% ENVELOPES!!!

% MULTIPLY ENVELOPE
EnvFreq = 1; % Envelope frequency in Hz [Default = 1]

EnvSig = (0.5*sin(2*pi*tim*EnvFreq)) + 0.5;

figure(4); clf;
    aa(1) = subplot(211); hold on;
        plot(tim, S1 .* SineSignal);
        plot(tim, SineSignal, 'r', 'LineWidth', 2);
    aa(2) = subplot(212); hold on;
        plot(tim, S1 .* SineSignal .* EnvSig);
        plot(tim, SineSignal .* EnvSig, 'r', 'LineWidth', 1);
        plot(tim, EnvSig, 'g', 'LineWidth', 2);
        
% FISH MOVEMENT EVNELOPE

figure(5); clf;

    subplot(411); plot(tim, S1);
    subplot(412); plot(tim, S2 .* EnvSig);
    subplot(413); hold on; 
        plot(tim, S1);
        plot(tim, S1 + (S2 .* EnvSig), 'c');
    
    [AMpks, AMlocs] = findpeaks(abs( S1 + (S2 .* EnvSig)));
    plot(tim(AMlocs), AMpks, '-r');
    
    subplot(414); hold on;
    plot(tim(AMlocs), AMpks, '.-r');
    [ENVpks, ENVlocs] = findpeaks(AMpks);
    plot(tim(AMlocs(ENVlocs)), ENVpks, '.-g');
    
    
 %% Three fish envelope
 
 figure(6); clf; hold on;

 hS1 = sin(tim*300*2*pi) * 0.9; % Fish #3 - 355 Hz and 75% of amplitude of fish #1
 hS2 = sin(tim*350*2*pi) * 0.9; % Fish #3 - 355 Hz and 75% of amplitude of fish #1
 hS3 = sin(tim*395*2*pi) * 0.9; % Fish #3 - 355 Hz and 75% of amplitude of fish #1

    plot(tim, hS1+hS2+hS3);
     [RealAMpks, RealAMlocs] = findpeaks(hS1+hS2+hS3);
    plot(tim(RealAMlocs), RealAMpks, '-r') 
     [RealENVpks, RealENVlocs] = findpeaks(RealAMpks);
    plot(tim(RealAMlocs(RealENVlocs)), RealENVpks, '-g');
    