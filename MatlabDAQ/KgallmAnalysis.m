function out = KgallmAnalysis(userfilespec, Fs, numstart)
% Function out = KgallmAnalysis('Eigen*', 40000, 23);
% userfilespec is data from listentothis.m, e.g. 'EigenTest*.mat'
% Fs is the sample rate, was 20kHz but now 40kHz
% numstart is the first character of the hour. 

%% Setup

rango = 10; % Hz around peak frequency over which to sum amplitude.

dataChans = [1 2];
tempchan = 3;
lightchan = 4;    

% DATA FILTERING
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

   
    % Get EOD amplitudes for each channel
    for j = length(dataChans):-1:1

    %NEW METHOD SAMPIDX - PEAK |AMP| WINDOW - not Fs dependent
       %filter data to remove noise maximums
        filtsig = filtfilt(b,a, data(:,dataChans(j))); % High pass filter
        filtsig = filtfilt(f,e,filtsig); % Low pass filter      

        windw = 0.25; %window width is 100 ms %changed to 250 ms - fixed doubling in fft


        [~, idx] = max(abs(filtsig)); %find where the amplitude of the sample is greatests

        maxtim(j) = tim(idx); %find the time index of idx

        %place the peak amplitude in the middle of the new sample time window
        startim(j) = max([0, maxtim(j)-(windw/2)]); 

        %if the peak is near the end of the sample, need to just take the last windw 
        if startim(j)+(windw/2) > tim(end)
         startim(j) = tim(end) - windw;
        end

        sampidx = find(tim > startim(j) & tim < startim(j)+windw); %duration of sample

    % ORIGINAL FFT METHOD - sumAmp
        tmpfft = fftmachine(data(sampidx,dataChans(j)), Fs);
        [peakAmp(j), peakIDX] = max(tmpfft.fftdata);
        peakFreq(j) = tmpfft.fftfreq(peakIDX);
        sumAmp(j) = sum(tmpfft.fftdata(tmpfft.fftfreq > (peakFreq(j) - rango) & tmpfft.fftfreq < (peakFreq(j) + rango)));

    % Mean amplitude method
        z = zeros(1,length(sampidx)); %creat vector length of data
        z(filtsig > 0) = 1; %fill with 1s for all filtered data greater than 0
        z = diff(z); %subtract the X(2) - X(1) to find the positive zero crossings

        posZs = find(z == 1); 

        for kk = 2:length(posZs)
           amp(kk-1) = max(filtsig(posZs(kk-1):posZs(kk))) - (min(filtsig(posZs(kk-1):posZs(kk)))); % Max + min of signal for each cycle
        end

        zAmp(j) = mean(amp);

    end % By channel

% Crappy coding... but why not!
    out(k).Ch1peakAmp = peakAmp(1);
    out(k).Ch1peakFreq = peakFreq(1);
    out(k).Ch1sumAmp = sumAmp(1);
    out(k).Ch1zAmp = zAmp(1);
   


    out(k).Ch2peakAmp = peakAmp(2);
    out(k).Ch2peakFreq = peakFreq(2);
    out(k).Ch2sumAmp = sumAmp(2);
    out(k).Ch2zAmp = zAmp(2);
    
   
        
    out(k).light = mean(data(:,lightchan));
    out(k).temp = mean(data(:,tempchan));
    
% Add time stamps (in seconds) relative to computer midnight
 
    hour = str2num(iFiles(k).name(numstart:numstart+1)); %numstart based on time stamp text location
    minute = str2num(iFiles(k).name(numstart+3:numstart+4));
    second = str2num(iFiles(k).name(numstart+6:numstart+7));

    if k > 1 && ((hour*60*60) + (minute*60) + second) < out(k-1).tim24
        daycount = daycount + 1;
    end
        % There are 86400 seconds in a day.
    out(k).timcont = (hour*60*60) + (minute*60) + second + (daycount*86400) ;
    out(k).tim24 = (hour*60*60) + (minute*60) + second;
    
    k = k+1;
    

end
    

%% Plot the data for fun

% Continuous data plot
figure(1); clf; 
    set(gcf, 'Position', [200 100 2*560 2*420]);

ax(1) = subplot(411); hold on; title('fft');
    plot([out.timcont]/(60*60), [out.Ch1sumAmp], '.');
    plot([out.timcont]/(60*60), [out.Ch2sumAmp], '.');
    %ylim([0.1, 2]);
   % plot([out.timcont]/(60*60), [out.Ch3sumAmp], '.');

ax(2) = subplot(412); hold on; title('zero xings');
    plot([out.timcont]/(60*60), [out.Ch1zAmp], '.');
    plot([out.timcont]/(60*60), [out.Ch2zAmp], '.');

ax(3) = subplot(413); hold on;
    yyaxis right; plot([out.timcont]/(60*60), -[out.temp], '.');
    yyaxis left; ylim([200 800]);
        plot([out.timcont]/(60*60), [out.Ch1peakFreq], '.', 'Markersize', 8);
        plot([out.timcont]/(60*60), [out.Ch2peakFreq], '.', 'Markersize', 8);
%        plot([out.timcont]/(60*60), [out.Ch3peakFreq], '.', 'Ma[brkersize', 8);
    
ax(4) = subplot(414); hold on;
    plot([out.timcont]/(60*60), [out.light], '.', 'Markersize', 8);
    %plot([out.luz], ztzed, '.-', 'Markersize', 8);
    ylim([-1, 6]);
    xlabel('Continuous');

linkaxes(ax, 'x');
    






   
