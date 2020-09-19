function out = gallmAnalysis(userfilespec, Fs, numstart)
% Function out = gallmAnalysis(userfilespec, Fs)
% userfilespec is data from listentothis.m, e.g. 'EigenTest*.mat'
% Fs is the sample rate, usually 20kHz
% numstart is the first character of the hour. 

%% Setup

dataChans = [1 2 3]; % EOD recording channels in recorded files
rango = 5; % Hz around peak frequency over which to sum amplitude.

[b,a] = butter(5, 250/(Fs/2), 'high'); % Filter to eliminate 60Hz contamination

iFiles = dir(userfilespec);

%% Cycle through every file in the directory

k = 1; % Our counter.

while k <= length(iFiles)

eval(['load ' iFiles(k).name]);

% Get EOD amplitudes for each channel
for j = length(dataChans):-1:1
    
    tmp = fftmachine(filtfilt(b,a,data(:,dataChans(j))), Fs);
    [peakAmp(j), peakIDX] = max(tmp.fftdata);
    peakFreq(j) = tmp.fftfreq(peakIDX);
    sumAmp(j) = sum(tmp.fftdata(tmp.fftfreq > (peakFreq(j) - rango) & tmp.fftfreq < (peakFreq(j) + rango)));
    
end

% Crappy coding... but why not!
    out(k).Ch1peakAmp = peakAmp(1);
    out(k).Ch1peakFreq = peakFreq(1);
    out(k).Ch1sumAmp = sumAmp(1);
    out(k).Ch2peakAmp = peakAmp(2);
    out(k).Ch2peakFreq = peakFreq(2);
    out(k).Ch2sumAmp = sumAmp(2);
    out(k).Ch3peakAmp = peakAmp(3);
    out(k).Ch3peakFreq = peakFreq(3);
    out(k).Ch3sumAmp = sumAmp(3);

    out(k).light = mean(data(:,5));
    out(k).temp = mean(data(:,4));

% Add time stamps (in seconds) relative to computer midnight
    hour = str2num(iFiles(k).name(numstart:numstart+1));
    minute = str2num(iFiles(k).name(numstart+3:numstart+4));
    second = str2num(iFiles(k).name(numstart+6:numstart+7));
    
    out(k).tim = (hour*60*60) + (minute*60) + second;
    
    k = k+1;

end

%% Plot the data for fun

figure(1); clf; 
    set(gcf, 'Position', [200 400 2*560 2*420]);

subplot(311); hold on;
    plot([out.tim]/(60*60), [out.Ch1sumAmp], '.');
    plot([out.tim]/(60*60), [out.Ch2sumAmp], '.');
    plot([out.tim]/(60*60), [out.Ch3sumAmp], '.');

subplot(312); hold on;
    yyaxis right; plot([out.tim]/(60*60), -[out.temp], '.');
    yyaxis left; ylim([200 800]);
        plot([out.tim]/(60*60), [out.Ch1peakFreq], '.', 'Markersize', 8);
        plot([out.tim]/(60*60), [out.Ch2peakFreq], '.', 'Markersize', 8);
        plot([out.tim]/(60*60), [out.Ch3peakFreq], '.', 'Markersize', 8);
    
subplot(313); hold on;
    plot([out.tim]/(60*60), [out.light], '.', 'Markersize', 8);
    ylim([-1, 6]);
    

