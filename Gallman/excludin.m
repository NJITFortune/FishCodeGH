function out = excludin(userfilespec, Fs, numstart)
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

while k <= length(iFiles)

eval(['load ' iFiles(k).name]);
% Add time stamps (in seconds) relative to computer midnight
    hour = str2num(iFiles(k).name(numstart:numstart+1)); %numstart based on time stamp text location
    minute = str2num(iFiles(k).name(numstart+3:numstart+4));
    second = str2num(iFiles(k).name(numstart+6:numstart+7));


    % There are 86400 seconds in a day.
    out(k).timcont = (hour*60*60) + (minute*60) + second + (daycount*86400) ;
    out(k).tim24 = (hour*60*60) + (minute*60) + second;
    
    
    
    if k > 1 && ((hour*60*60) + (minute*60) + second) < out(k-1).tim24
        daycount = daycount + 1;
    end    
    
    
    % Do something for each channel
    for j = length(dataChans):-1:1
        
        %unfiltered mean and std
        raw(j) = data(sampidx,dataChans(j));
        
        
        %filtered mean and std
        filteredata = filtfilt(b,a,data(sampidx,dataChans(j)));
        filteredata = filtfilt(f,e,filteredata);
        filteredata = filteredata(1:length(iFiles));
        
        filtered(j) = filteredata; %not sure i did this right...
      
          
        
        
      %movingstd?
        %movestd(j) = movstd(data(sampidx,dataChans(j)), 3);
        
        %figure(j); hold on; plot3(1/Fs:1/Fs:length(filteredata)/Fs,filteredata,((hour*3600)+(minute*60)+second)*ones(1,length(filteredata)), 'b-');

    end

    
    
    %By Channel - Only know how to do crappy coding
    %Raw data
    out(k).Ch1raw = raw(1);
    out(k).Ch1raw = raw(2);
    %filtered data
    out(k).Ch1filtered = filtered(1);
    out(k).Ch2filtered = filtered(2);
   
    out(k).light = mean(data(:,lightchan));
    out(k).temp = mean(data(:,tempchan));
    
    k=k+1;
    
    
  % Smoothed trend line (20 minute duration window with 10 minute overlap)
    for ttk = 1:143   % Every ten minutes
    tt = find([out.tim24] > ((ttk-1)*10*60) & [out.tim24] < (((ttk-1)*10*60) + (20*60)) );
    
    %time vector
    avgtims(ttk) = (((ttk-1)*10*60) + (10*60));
    
    %Median
    rCh1meadian(ttk) = median([out(tt).Ch1raw]); 
    rCh2meadian(ttk) = median([out(tt).Ch2raw]);
    
    fCh1meadian(ttk) = median([out(tt).Ch1filtered]); 
    fCh2meadian(ttk) = median([out(tt).Ch2filtered]);
   
    %mean
    rCh1mean(ttk) = mean([out(tt).Ch1raw]); 
    rCh2mean(ttk) = mean([out(tt).Ch2raw]);
    
    fCh1mean(ttk) = mean([out(tt).Ch1filtered]); 
    fCh2mean(ttk) = mean([out(tt).Ch2filtered]);
    
    meantims(ttk) = (((ttk-1)*10*60) + (10*60));
    
    %Standard deviation
    rCh1std(ttk) = std([out(tt).Ch1raw]); 
    rCh2std(ttk) = std([out(tt).Ch2raw]);
    
    fCh1std(ttk) = std([out(tt).Ch1filtered]); 
    fCh2std(ttk) = std([out(tt).Ch2filtered]);
    
    end
        
end   
    %% Plot the data for fun

% Continuous data plot
figure(1); clf; 
    set(gcf, 'Position', [200 100 2*560 2*420]);


xa(1) = subplot(411); hold on;
    plot([out.tim24]/(60*60), [out.Ch1raw], '.');
    plot([out.tim24]/(60*60), [out.Ch2raw], '.');
%    plot([out.tim24]/(60*60), [out.Ch3sumAmp], '.');
    plot(mediantims/(60*60), medianCh1sumAmp, 'c-', 'Linewidth', 2);
    plot(mediantims/(60*60), medianCh2sumAmp, 'm-', 'Linewidth', 2);

xa(2) = subplot(412); hold on;
    plot([out.tim24]/(60*60), [out.Ch1zAmp], '.');
    plot([out.tim24]/(60*60), [out.Ch2zAmp], '.');
    plot(mediantims/(60*60), medianCh1zAmp, 'c-', 'Linewidth', 2);
    plot(mediantims/(60*60), medianCh2zAmp, 'm-', 'Linewidth', 2);

xa(3) = subplot(413); hold on;
    yyaxis right; plot([out.tim24]/(60*60), -[out.temp], '.');
    yyaxis left; ylim([200 800]);
        plot([out.tim24]/(60*60), [out.Ch1peakFreq], '.', 'Markersize', 8);
        plot([out.tim24]/(60*60), [out.Ch2peakFreq], '.', 'Markersize', 8);
%        plot([out.tim24]/(60*60), [out.Ch3peakFreq], '.', 'Markersize', 8);
    
xa(4) = subplot(414); hold on;
    plot([out.tim24]/(60*60), [out.light], '.', 'Markersize', 8);
    xlabel('24 Hour');
    ylim([-1, 6]);

linkaxes(xa, 'x');

    
end
