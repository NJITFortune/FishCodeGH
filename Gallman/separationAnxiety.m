% A new attempt at frequency tracking two Eigenmannia in the tank
clearvars -except kg kg2 rkg k
Fs = 40000;
freqs = [425 650]; %freq range of typical eigen EOD
userfilespec = 'Eigen*';

% Max frequency change
maxchange = 20; % Maximum change in Hz between samples
mindiff = 2; % Minimum frequency difference (Hz) between the two fish


clickcnt = 0;

% File handling

    numstart = 23; %1st position in file name of time stamp
    %day count starts at 0
    daycount = 0;
    
    %day count starts at 0
    daycount = 0;
    
    %Initialize nonelectrode data channels
    tempchan = 3; 
    lightchan = 4; 

% Get the list of files to be analyzed  
    iFiles = dir(userfilespec);

%% Set up the filters
    % Band pass filter in frequency range of fish
    [h,g] = butter(5, [freqs(1)/(Fs/2) freqs(2)/(Fs/2)]);

    % For the log filter thing
    [bb,aa] = butter(3, [0.02 0.4], 'bandpass');

%% first data file
      
    load(iFiles(1).name, 'data');
    e1 = filtfilt(h,g,data(:,1));
    e2 = filtfilt(h,g,data(:,2));


% Take first 5 samples and perform FFT on that for both channels

f1 = fftmachine(e1, Fs);
f2 = fftmachine(e2, Fs);


% figure(1); clf;
%     subplot(211); specgram(e1,1024*16, Fs, [], ceil(1024*16*0.95)); ylim([freqs(1) freqs(2)]); caxis([15 50])
%     subplot(212); specgram(e2,1024*16, Fs, [], ceil(1024*16*0.95)); ylim([freqs(1) freqs(2)]); caxis([15 50])
%     colormap('HOT');     


% Plot the summed FFT for the user to click
summedFFT =  f1.fftdata + f2.fftdata;

figure(2); clf; hold on;
    plot(f1.fftfreq, summedFFT);
    xlim(freqs);
   % xticks(linspace(freqs(1),freqs(2), 30));

[xfreq, ~] = ginput(1);
    
% Get intial frequencies

    % Get the lower freq peak
        lowfreqidx = find(f1.fftfreq > freqs(1) & f1.fftfreq < xfreq);
            [~, lmaxidx] = max(summedFFT(lowfreqidx));
            currlofreq = f1.fftfreq(lowfreqidx(lmaxidx));
            plot(currlofreq, summedFFT(lowfreqidx(lmaxidx)), 'c.', 'MarkerSize', 16);

    % Get the higher freq peak
        hifreqidx = find(f1.fftfreq > xfreq & f1.fftfreq < freqs(2));
            [~, hmaxidx] = max(summedFFT(hifreqidx));
            currhifreq = f1.fftfreq(hifreqidx(hmaxidx));        
            plot(currhifreq, summedFFT(hifreqidx(hmaxidx)), 'm.', 'MarkerSize', 16);

    % Get the midpoint and plot it for fun
            midpoint = currlofreq + ((currhifreq - currlofreq)/2);
            plot([midpoint, midpoint], [0 1], 'k');

    % Put the data into the output structure   
        %lower frequency fish
            out(1).lopeakamp = max([f1.fftdata(lowfreqidx(lmaxidx)) f2.fftdata(lowfreqidx(lmaxidx))]);
            out(1).lmaxidx = lowfreqidx(lmaxidx);
            out(1).lowfreqidx = lowfreqidx;
            out(1).lofreq = currlofreq;
            if f1.fftdata(lowfreqidx(lmaxidx)) > f2.fftdata(lowfreqidx(lmaxidx))
                out(1).lotube = 1; 
               [out(1).lobw, out(1).loflo, out(1).lofhi, out(1).loAmpobw] = obw(e1(lowfreqidx), Fs, [freqs(1) midpoint]);
            end 
            if f2.fftdata(lowfreqidx(lmaxidx)) > f1.fftdata(lowfreqidx(lmaxidx))
                out(1).lotube = 2; 
               [out(1).lobw, out(1).loflo, out(1).lofhi, out(1).loAmpobw] = obw(e2(lowfreqidx), Fs, [freqs(1) midpoint]);
            end 

            out(1).midpoint = midpoint;

        %higher frequency fish
            out(1).hipeakamp = max([f1.fftdata(hifreqidx(hmaxidx)) f2.fftdata(hifreqidx(hmaxidx))]);
            out(1).hmaxidx = hifreqidx(hmaxidx);
            out(1).hifreqidx = hifreqidx;
            out(1).hifreq = currhifreq;
            if f1.fftdata(hifreqidx(hmaxidx)) > f2.fftdata(hifreqidx(hmaxidx))
                out(1).hitube = 1;
               [out(1).hibw, out(1).hiflo, out(1).hifhi, out(1).hiAmpobw] = obw(e1(hifreqidx), Fs, [midpoint freqs(2)]);
            end 
            if f2.fftdata(hifreqidx(hmaxidx)) > f1.fftdata(hifreqidx(hmaxidx))
                out(1).hitube = 2; 
               [out(1).hibw, out(1).hiflo, out(1).hifhi, out(1).hiAmpobw] = obw(e2(hifreqidx), Fs, [midpoint freqs(2)]);
            end 


oldmidpoint = midpoint;
oldcurrhifreq = currhifreq;
oldcurrlofreq = currlofreq;

%define time for j = 1
 % Add time stamps (in seconds) relative to computer midnight (COMES FROM THE FILENAME)
    hour = str2double(iFiles(1).name(numstart:numstart+1)); %numstart based on time stamp text location
    minute = str2double(iFiles(1).name(numstart+3:numstart+4));
    second = str2double(iFiles(1).name(numstart+6:numstart+7));
    
% There are 86400 seconds in a day.
    out(1).timcont = (hour*60*60) + (minute*60) + second + (daycount*86400);
    out(1).tim24 = (hour*60*60) + (minute*60) + second;
    
%light and temp for j = 1
    out(1).temp = mean(data(1,tempchan));
    out(1).light = mean(data(1,lightchan));
%% 2:end            
for j = 2:length(iFiles)

    load(iFiles(j).name, 'data');
    f1 = fftmachine(filtfilt(h,g,data(:,1)), Fs);
    f2 = fftmachine(filtfilt(h,g,data(:,2)), Fs);

    e1 = filtfilt(h,g,data(:,1));
    e2 = filtfilt(h,g,data(:,2));

    % Add time stamps (in seconds) relative to computer midnight (COMES FROM THE FILENAME)
    hour = str2double(iFiles(j).name(numstart:numstart+1)); %numstart based on time stamp text location
    minute = str2double(iFiles(j).name(numstart+3:numstart+4));
    second = str2double(iFiles(j).name(numstart+6:numstart+7));
                
        if j > 2 && ((hour*60*60) + (minute*60) + second) < out(j-1).tim24
               daycount = daycount + 1;
        end


    % There are 86400 seconds in a day.
    out(j).timcont = (hour*60*60) + (minute*60) + second + (daycount*86400);
    out(j).tim24 = (hour*60*60) + (minute*60) + second;

    %light and temp 
    out(j).temp = mean(data(1,tempchan));
    out(j).light = mean(data(1,lightchan));

    summedFFT =  f1.fftdata + f2.fftdata;
    figure(2); clf; hold on;
        plot(f1.fftfreq, summedFFT);
        xlim(freqs);
       

    % Get the lower freq peak
        lowfreqidx = find(f1.fftfreq > freqs(1) & f1.fftfreq < oldmidpoint);
            [~, lmaxidx] = max(summedFFT(lowfreqidx));
            currlofreq = f1.fftfreq(lowfreqidx(lmaxidx));
            plot(currlofreq, summedFFT(lowfreqidx(lmaxidx)), 'c.', 'MarkerSize', 16);

    % Get the higher freq peak
        hifreqidx = find(f1.fftfreq > oldmidpoint & f1.fftfreq < freqs(2));
            [~, hmaxidx] = max(summedFFT(hifreqidx));
            currhifreq = f1.fftfreq(hifreqidx(hmaxidx));        
            plot(currhifreq, summedFFT(hifreqidx(hmaxidx)), 'm.', 'MarkerSize', 16);

    % Get the midpoint and plot it for fun          
            midpoint = currlofreq + ((currhifreq - currlofreq)/2);
            plot([midpoint, midpoint], [0 1], 'k');
            text(350, 0.5, num2str(j));
            drawnow;

% FIX ERRORS


fixme = 0;

    if abs(currhifreq-oldcurrhifreq) > maxchange; fixme = 1; end 
    if abs(currlofreq-oldcurrlofreq) > maxchange; fixme = 1; end 
    if abs(currlofreq-currhifreq) < mindiff; fixme = 1; end


if fixme == 1

    fprintf('Last low was %3.1f and high was %3.1f \n', out(j-2).lofreq, out(j-2).hifreq);

    figure(1); clf; hold on;
        plot(f1.fftfreq, summedFFT);
        xlim(freqs);
         xticks(linspace(freqs(1),freqs(2), 30));

    [xfreq, ~] = ginput;

    if length(xfreq) == 1

    % Get the lower freq peak
        lowfreqidx = find(f1.fftfreq > freqs(1) & f1.fftfreq < xfreq);
            [~, lmaxidx] = max(summedFFT(lowfreqidx));
            currlofreq = f1.fftfreq(lowfreqidx(lmaxidx));
            plot(currlofreq, summedFFT(lowfreqidx(lmaxidx)), 'c.', 'MarkerSize', 16);

    % Get the higher freq peak
        hifreqidx = find(f1.fftfreq > xfreq & f1.fftfreq < freqs(2));
            [~, hmaxidx] = max(summedFFT(hifreqidx));
            currhifreq = f1.fftfreq(hifreqidx(hmaxidx));        
            plot(currhifreq, summedFFT(hifreqidx(hmaxidx)), 'm.', 'MarkerSize', 16);

    % Get the midpoint and plot it for fun          
            midpoint = currlofreq + ((currhifreq - currlofreq)/2);
            plot([midpoint, midpoint], [0 1], 'k');

            clickcnt = clickcnt + 1;

    else

        xfreq = sort(xfreq);

        lowfreqidx = find(f1.fftfreq > freqs(1) & f1.fftfreq < freqs(2));
        lmaxidx = find(f1.fftfreq(lowfreqidx) >= xfreq(1), 1);
        currlofreq = f1.fftfreq(lowfreqidx(lmaxidx));
        plot(currlofreq, summedFFT(lowfreqidx(lmaxidx)), 'c.', 'MarkerSize', 16);


        hifreqidx = find(f1.fftfreq > freqs(1) & f1.fftfreq < freqs(2));
        hmaxidx = find(f1.fftfreq(hifreqidx) >= xfreq(2), 1);
        currhifreq = f1.fftfreq(hifreqidx(hmaxidx));
        plot(currhifreq, summedFFT(hifreqidx(hmaxidx)), 'm.', 'MarkerSize', 16);

            midpoint = currlofreq + ((currhifreq - currlofreq)/2);
            plot([midpoint, midpoint], [0 1], 'k');

            clickcnt = clickcnt + 2;

        pause(1);

    end



end



    % Put the data into the output structure   
        %lower frequency fish
            out(j).lopeakamp = max([f1.fftdata(lowfreqidx(lmaxidx)) f2.fftdata(lowfreqidx(lmaxidx))]);
            out(j).lofreq = currlofreq;
            out(j).lmaxidx = lowfreqidx(lmaxidx);
            out(j).lowfreqidx = lowfreqidx;
            
            if f1.fftdata(lowfreqidx(lmaxidx)) > f2.fftdata(lowfreqidx(lmaxidx))
                out(j).lotube = 1; 
               [out(j).lobw, out(j).loflo, out(j).lofhi, out(j).loAmpobw] = obw(e1(lowfreqidx), Fs, [freqs(1) midpoint]);
            end 
            if f2.fftdata(lowfreqidx(lmaxidx)) > f1.fftdata(lowfreqidx(lmaxidx))
                out(j).lotube = 2; 
                [out(j).lobw, out(j).loflo, out(j).lofhi, out(j).loAmpobw] = obw(e2(lowfreqidx), Fs, [freqs(1) midpoint]);
            end 

         out(j).midpoint = midpoint;

        %higher frequency fish
            out(j).hipeakamp = max([f1.fftdata(hifreqidx(hmaxidx)) f2.fftdata(hifreqidx(hmaxidx))]);
            out(j).hifreq = currhifreq;
            out(j).hmaxidx = hifreqidx(hmaxidx);
            out(j).hifreqidx = hifreqidx;
            if f1.fftdata(hifreqidx(hmaxidx)) > f2.fftdata(hifreqidx(hmaxidx))
                out(j).hitube = 1; 
               [out(j).hibw, out(j).hiflo, out(j).hifhi, out(j).hiAmpobw] = obw(e1(hifreqidx), Fs, [midpoint freqs(2)]);
            end 
            if f2.fftdata(hifreqidx(hmaxidx)) > f1.fftdata(hifreqidx(hmaxidx))
                out(j).hitube = 2; 
               [out(j).hibw, out(j).hiflo, out(j).hifhi, out(j).hiAmpobw] = obw(e2(hifreqidx), Fs, [midpoint freqs(2)]);
            end 


oldmidpoint = midpoint;
oldcurrlofreq = currlofreq;
oldcurrhifreq = currhifreq;
% pause(0.3)
end
%%
figure(4); clf; hold on; 

    ax(1) = subplot(211); title('frequency'); hold on;
        plot([out([out.lotube]==1).timcont]/3600, [out([out.lotube]==1).lofreq], 'b-o'); 
        plot([out([out.lotube]==2).timcont]/3600, [out([out.lotube]==2).lofreq], 'c-o'); 
        plot([out([out.hitube]==1).timcont]/3600, [out([out.hitube]==1).hifreq], 'r-o'); 
        plot([out([out.hitube]==2).timcont]/3600, [out([out.hitube]==2).hifreq], 'm-o');
        
    ax(2) = subplot(212); title('amplitude'); hold on; 
        plot([out([out.lotube]==1).timcont]/3600, [out([out.lotube]==1).loamp], 'b.'); 
        plot([out([out.lotube]==2).timcont]/3600, [out([out.lotube]==2).loamp], 'c.'); 
        plot([out([out.hitube]==1).timcont]/3600, [out([out.hitube]==1).hiamp], 'r.'); 
        plot([out([out.hitube]==2).timcont]/3600, [out([out.hitube]==2).hiamp], 'm.');

   linkaxes(ax, 'x');
%% 

figure(3); clf; hold on; 

    ax(1) = subplot(211); title('frequency'); hold on;
        plot([out([out.lotube]==1).timcont]/3600, [out([out.lotube]==1).loamp], 'b.'); 
        plot([out([out.lotube]==2).timcont]/3600, [out([out.lotube]==2).loamp], 'c.'); 
        
    ax(2) = subplot(212); title('amplitude'); hold on; 
      
        plot([out([out.hitube]==1).timcont]/3600, [out([out.hitube]==1).hiamp], 'r.'); 
        plot([out([out.hitube]==2).timcont]/3600, [out([out.hitube]==2).hiamp], 'm.');

   linkaxes(ax, 'x');