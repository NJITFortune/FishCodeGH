function out = sinnerSin(userfilespec, Fs, numstart)
% Function out = gallmAnalysis(userfilespec, Fs)
% userfilespec is data from listentothis.m, e.g. 'EigenTest*.mat'
% Fs is the sample rate, was 20kHz but now 40kHz
% numstart is the first character of the hour. 

%% Setup

dataChans = [1 2]; % EOD recording channels in recorded files
rango = 10; % Hz around peak frequency over which to sum amplitude.


tempchan = 3; % Either 4 or 3
lightchan = 4; % Either 5 or 4

% THIS IS IMPORTANT USER DEFINED DETAILS (ddellayy, windw, highp, lowp)
    % Delay (currently 0 seconds from start)
    ddellayy = 0.002;
    % Window width (Empirically either 0.050 or 0.100 have been best)
    windw = 0.025;
    
    startidx = max([1, (ddellayy * Fs)]); % In case we want to start before 0 (max avoids zero problem)
    endidx = (windw * Fs) + startidx;
    sampidx = startidx:endidx; % Duration of sample (make sure integer!)

    % High pass filter cutoff frequency
    highp = 200;
    % Low pass filter cutoff frequency
    lowp = 2000;
    
    [b,a] = butter(5, highp/(Fs/2), 'high'); % Filter to eliminate 60Hz contamination
    [f,e] = butter(5, lowp/(Fs/2), 'low'); % Filter to eliminate high frequency contamination

iFiles = dir(userfilespec);

daycount = 0;

%% Cycle through every file in the directory

k = 1; % Our counter.

while k <= 200 %length(iFiles)

eval(['load ' iFiles(k).name]);
% Add time stamps (in seconds) relative to computer midnight
    hour = str2num(iFiles(k).name(numstart:numstart+1)); %numstart based on time stamp text location
    minute = str2num(iFiles(k).name(numstart+3:numstart+4));
    second = str2num(iFiles(k).name(numstart+6:numstart+7));

% Do something for each channel
    for j = length(dataChans):-1:1
        
        filteredata = filtfilt(b,a,data(sampidx,dataChans(j)));
        filteredata = filtfilt(f,e,filteredata);
        filteredata = filteredata(1:400);
        
        figure(j); hold on; plot3(1/Fs:1/Fs:length(filteredata)/Fs,filteredata,((hour*3600)+(minute*60)+second)*ones(1,length(filteredata)), 'b-');

    end

    k=k+2;
    
end    
figure(1); view([90 0]);
figure(2); view([90 0]);

out=0;
