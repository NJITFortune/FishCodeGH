function out = KgallmAnalysis(userfilespec, Fs, numstart)
% Function out = gallmAnalysis(userfilespec, Fs)
% userfilespec is data from listentothis.m, e.g. 'EigenTest*.mat'
% Fs is the sample rate, was 20kHz but now 40kHz
% numstart is the first character of the hour. 

%% Setup

dataChans = [1 2]; % EOD recording channels in recorded files
rango = 10; % Hz around peak frequency over which to sum amplitude.

tempchan = 3; % Either 4 or 3
lightchan = 4; % Either 5 or 4

% DATA FILTERING
% High pass filter cutoff frequency
    highp = 200;
    % Low pass filter cutoff frequency
    lowp = 2000;
    
    [b,a] = butter(5, highp/(Fs/2), 'high'); % Filter to eliminate 60Hz contamination
    [f,e] = butter(5, lowp/(Fs/2), 'low'); % Filter to eliminate high frequency contamination

% THIS IS IMPORTANT USER DEFINED DETAILS (ddellayy, windw, highp, lowp)
    
%     %OLD METHOD - DATA WINDOW FROM START - Fs dependent
%     % Delay (currently 0 seconds from start)
%     ddellayy = 0.002;
%     % Window width (Empirically either 0.050 or 0.100 have been best)
%     windw = 0.025;
%     
%     startidx = max([1, (ddellayy * Fs)]); % In case we want to start before 0 (max avoids zero problem)
%     endidx = (windw * Fs) + startidx;
%     sampidx = startidx:endidx; % Duration of sample (make sure integer!)


    
    

    
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
    
    
% ADJUST FOR DIRECTIONALITY - NOT SURE HOW TO APPLY THIS WITHIN THE FOR
% LOOP - ERIC SAYS NO...
%     if max(filtsig) < 0
%        max(filtsig) = negmax;
%     end
%     
%     if max(filtsig) > 0
%        max(filtsig) = posmax;
%     end
%     
%     posmax + negmax = diffac;
%     negmax + diffac = adjneg;
%     adjmax = cat(1, posmax, negmax);
%     
%     adjmax(sampidx, dataChans(j));

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

% NEW FFT METHOD - obwAmp

% USER DEFINED CRITICAL NUMBERS!  Fish limit frequencies
    topFreq = 800;
    botFreq = 300;

[~,~,~,obwAmp(j)] = obw(data(sampidx,dataChans(j)), Fs, [botFreq topFreq]);

   

% Mean amplitude method
    z = zeros(1,length(sampidx)); %creat vector length of data
    z(filtsig > 0) = 1; %fill with 1s for all filtered data greater than 0
    z = diff(z); %subtract the X(2) - X(1) to find the positive zero crossings
    
    posZs = find(z == 1); 
    
    for kk = 2:length(posZs)
       amp(kk-1) = max(filtsig(posZs(kk-1):posZs(kk))) - (min(filtsig(posZs(kk-1):posZs(kk)))); % Max + min of signal for each cycle
    end
    
    zAmp(j) = mean(amp);
    
% Fit SINEWAVE Method

    [SineAmp(j), SineFreq(j)] = sinAnal(filtsig', Fs);
    
    
    
end % By channel

% Crappy coding... but why not!
    out(k).Ch1peakAmp = peakAmp(1);
    out(k).Ch1peakFreq = peakFreq(1);
    out(k).Ch1sumAmp = sumAmp(1);
    out(k).Ch1obwAmp = obwAmp(1);
    out(k).Ch1zAmp = zAmp(1);
    out(k).Ch1sAmp = SineAmp(1);
    out(k).Ch1sFreq = SineFreq(1);


    out(k).Ch2peakAmp = peakAmp(2);
    out(k).Ch2peakFreq = peakFreq(2);
    out(k).Ch2sumAmp = sumAmp(2);
    out(k).Ch2obwAmp = obwAmp(2);
    out(k).Ch2zAmp = zAmp(2);
    out(k).Ch2sAmp = SineAmp(2);
    out(k).Ch2sFreq = SineFreq(2);
   
        
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

%% Create a separate vector for exact light time changes
 
%Get the name of the current folder
%[~,folder,~]=fileparts(pwd);
%extract the light cycle info and convert to number
%timstep = str2num(folder(6:7)); %length of light cycle in hours
timstep = 24;
cyc = floor([out(end).timcont]/(timstep*60*60)); %number of cycles in data

%user defined details by light trial
timerstart = 17; %hour of the first state change
%initstate = 0; %initial state

%timz = 1:1:cyc; %to avoid for-loop

ztzed = [0 6]; %y


%luz(timz) = (timerstart) + (timstep*(timz-1)); %without for-loop

for i = 1:cyc
    luz(i)=timstep*(i-1)+timerstart;
    x1(:,i) = [luz(i), luz(i)];
    
    out(i).luz = x1(:,i);
end    


%% Plot the data for fun

% Continuous data plot
figure(1); clf; 
    set(gcf, 'Position', [200 100 2*560 2*420]);

ax(1) = subplot(411); hold on;
    plot([out.timcont]/(60*60), [out.Ch1sumAmp], '.');
    plot([out.timcont]/(60*60), [out.Ch2sumAmp], '.');
    ylim([0.1, 2]);
   % plot([out.timcont]/(60*60), [out.Ch3sumAmp], '.');

ax(2) = subplot(412); hold on;
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
    
% 24-hour data plot
figure(2); clf; 
    set(gcf, 'Position', [400 100 2*560 2*420]);

% Smoothed trend line (20 minute duration window with 10 minute overlap)
for ttk = 1:143   % Every ten minutes
    tt = find([out.tim24] > ((ttk-1)*10*60) & [out.tim24] < (((ttk-1)*10*60) + (20*60)) );
    medianCh1sumAmp(ttk) = median([out(tt).Ch1sumAmp]); %huh? %is this just a quick way to replace one with the other?
    medianCh2sumAmp(ttk) = median([out(tt).Ch2sumAmp]);
    medianCh1zAmp(ttk) = median([out(tt).Ch1zAmp]);
    medianCh2zAmp(ttk) = median([out(tt).Ch2zAmp]);
    mediantims(ttk) = (((ttk-1)*10*60) + (10*60));
end

xa(1) = subplot(411); hold on;
    plot([out.tim24]/(60*60), [out.Ch1obwAmp], '.');
    plot([out.tim24]/(60*60), [out.Ch2obwAmp], '.');
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

% Light / Dark plot

figure(3); clf;
set(gcf, 'Position', [400 100 2*560 2*420]);

    ld = [out.light];
    ldOnOff = diff(ld);
    tim = [out.timcont];
    dat1 = [out.Ch1obwAmp];
    dat2 = [out.Ch2obwAmp];
    
    Ons = find(ldOnOff > 1); % lights turned on
    Offs = find(ldOnOff < -1); % lights turned on

subplot(411); hold on; subplot(412); hold on;   
    for j = 2:length(Ons) % Synchronize at light on
    subplot(411);
        plot(tim(Ons(j-1):Ons(j))-tim(Ons(j-1)), dat1(Ons(j-1):Ons(j)), '.');
        plot(tim(Ons(j-1):Ons(j))-tim(Ons(j-1)), dat2(Ons(j-1):Ons(j)), '.');
    subplot(412);
        plot(tim(Ons(j-1):Ons(j))-tim(Ons(j-1)), ld(Ons(j-1):Ons(j)), '.');
    end

subplot(413); hold on; subplot(414); hold on;   
    for j = 2:length(Offs) % Synchronize at light off
    subplot(413);
        plot(tim(Offs(j-1):Offs(j))-tim(Offs(j-1)), dat1(Offs(j-1):Offs(j)), '.');
        plot(tim(Offs(j-1):Offs(j))-tim(Offs(j-1)), dat2(Offs(j-1):Offs(j)), '.');
    subplot(414);
        plot(tim(Offs(j-1):Offs(j))-tim(Offs(j-1)), ld(Offs(j-1):Offs(j)), '.');
    end

    
% Detrend the data

resampFs = 0.005; % May need to change this
cutfreq =  0.00001; % Low pass filter for detrend - need to adjust re resampFs

    [dat1r, newtim] = resample(dat1, tim, resampFs);
    [dat2r, ~] = resample(dat2, tim, resampFs);
    [ldr, ~] = resample(ld, tim, resampFs);

    [h,g] = butter(5,cutfreq/(resampFs/2),'low');
    
    % Filter the data
    dat1rlf = filtfilt(h,g,dat1r);
    dat2rlf = filtfilt(h,g,dat2r);

    % Remove the low frequency information
    datrend1 = dat1r-dat1rlf;
    datrend2 = dat2r-dat2rlf;
    
figure(4); clf;
set(gcf, 'Position', [400 100 2*560 2*420]);

subplot(611); hold on; subplot(612); hold on;   subplot(613); hold on;
    for j = 2:length(Ons) % Synchronize at light on
        
    ttOn = find(newtim > tim(Ons(j-1)) & newtim < tim(Ons(j)));
        
    subplot(611);
        plot(newtim(ttOn)-newtim(ttOn(1)), datrend1(ttOn), '.');
    subplot(612);
        plot(newtim(ttOn)-newtim(ttOn(1)), datrend2(ttOn), '.');
    subplot(613);
        plot(newtim(ttOn)-newtim(ttOn(1)), ldr(ttOn), '.');
    end

subplot(614); hold on; subplot(615); hold on; subplot(616); hold on;
    for j = 2:length(Offs) % Synchronize at light off
        
    ttOff = find(newtim > tim(Offs(j-1)) & newtim < tim(Offs(j)));
        
    subplot(614);
        plot(newtim(ttOff)-newtim(ttOff(1)), datrend1(ttOff), '.');
    subplot(615);
        plot(newtim(ttOff)-newtim(ttOff(1)), datrend2(ttOff), '.');
    subplot(616);
        plot(newtim(ttOff)-newtim(ttOff(1)), ldr(ttOff), '.');
    end

    
% Continuous data plot with OBW and SineAmp data
figure(5); clf; 
    set(gcf, 'Position', [200 100 2*560 2*420]);

ax(1) = subplot(411); hold on;
    plot([out.timcont]/(60*60), [out.Ch1obwAmp], '.');
    plot([out.timcont]/(60*60), [out.Ch2obwAmp], '.');
%    plot([out.timcont]/(60*60), [out.Ch3sumAmp], '.');

ax(2) = subplot(412); hold on;
    plot([out.timcont]/(60*60), [out.Ch1sAmp], '.');
    plot([out.timcont]/(60*60), [out.Ch2sAmp], '.');

ax(3) = subplot(413); hold on;
        ylim([200 800]);
        plot([out.timcont]/(60*60), [out.Ch1sFreq], '.', 'Markersize', 8);
        plot([out.timcont]/(60*60), [out.Ch2sFreq], '.', 'Markersize', 8);
%        plot([out.timcont]/(60*60), [out.Ch3peakFreq], '.', 'Markersize', 8);
    
ax(4) = subplot(414); hold on;
    plot([out.timcont]/(60*60), [out.light], '.', 'Markersize', 8);
    ylim([-1, 6]);
    xlabel('Continuous');

linkaxes(ax, 'x');   

end

function [amp, freq] = sinAnal(datums, FsF)

x = 1/FsF:1/FsF:length(datums)/FsF;

yu = max(datums);
yl = min(datums);
yr = (yu-yl);                               % Range of ‘y’
yz = datums-yu+(yr/2);
zx = x(yz .* circshift(yz,[0 1]) <= 0);     % Find zero-crossings
per = 2*mean(diff(zx));                     % Estimate period
ym = mean(datums);                               % Estimate offset

    fit = @(b,x)  b(1).*(sin(2*pi*x./b(2) + 2*pi/b(3))) + b(4);     % Function to fit
    fcn = @(b) sum((fit(b,x) - datums).^2);                            % Least-Squares cost function
    s = fminsearch(fcn, [yr;  per;  -1;  ym]);                      % Minimise Least-Squares

amp = s(1) * 1000;
freq = 1/s(2);



end



    