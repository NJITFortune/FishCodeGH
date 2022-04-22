% A new attempt at frequency tracking two Eigenmannia in the tank

Fs = 40000;
freqs = [300 600]; %freq range of typical eigen EOD
userfilespec = 'Eigen*';

clickcnt = 0;

% File handling

    numstart = 23; %1st position in file name of time stamp
    
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

%% Load data
      
    load(iFiles(1).name, 'data');
    e1 = filtfilt(h,g,data(:,1));
    e2 = filtfilt(h,g,data(:,2));


% Take first 5 samples and perform FFT on that for both channels

f1 = fftmachine(e1, Fs);
f2 = fftmachine(e2, Fs);

% Plot the summed FFT for the user to click
summedFFT =  f1.fftdata + f2.fftdata;

figure(1); clf; hold on;
    plot(f1.fftfreq, summedFFT);
    xlim(freqs);

[xfreq, ~] = ginput(1);
    
% Get intial frequencies

    % Get the lower freq peak
        lowfreqidx = find(f1.fftfreq > freqs(1) & f1.fftfreq < xfreq);
            [~, maxidx] = max(summedFFT(lowfreqidx));
            currlofreq = f1.fftfreq(lowfreqidx(maxidx));
            plot(currlofreq, summedFFT(lowfreqidx(maxidx)), 'c.', 'MarkerSize', 16);

    % Get the higher freq peak
        hifreqidx = find(f1.fftfreq > xfreq & f1.fftfreq < freqs(2));
            [~, maxidx] = max(summedFFT(hifreqidx));
            currhifreq = f1.fftfreq(hifreqidx(maxidx));        
            plot(currhifreq, summedFFT(hifreqidx(maxidx)), 'm.', 'MarkerSize', 16);

    % Get the midpoint and plot it for fun
            midpoint = currlofreq + ((currhifreq - currlofreq)/2);
            plot([midpoint, midpoint], [0 1], 'k');

    % Put the data into the output structure            
        out(1).loamp = max([f1.fftdata(maxidx) f2.fftdata(maxidx)]);
        out(1).lofreq = currlofreq;
        out(1).hiamp = max([f1.fftdata(maxidx) f2.fftdata(maxidx)]);
        out(1).hifreq = currhifreq;


oldmidpoint = midpoint;
oldcurrhifreq = currhifreq;
oldcurrlofreq = currlofreq;

            
for j = 2:length(iFiles)

    load(iFiles(j).name, 'data');
    f1 = fftmachine(filtfilt(h,g,data(:,1)), Fs);
    f2 = fftmachine(filtfilt(h,g,data(:,2)), Fs);

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

% Max frequency change
maxchange = 15; % Maximum change in Hz between samples
mindiff = 5; % Minimum frequency difference (Hz) between the two fish

fixme = 0;

    if abs(currhifreq-oldcurrhifreq) > maxchange; fixme = 1; end 
    if abs(currlofreq-oldcurrlofreq) > maxchange; fixme = 1; end 
    if abs(currlofreq-currhifreq) < mindiff; fixme = 1; end


if fixme == 1

    figure(1); clf; hold on;
        plot(f1.fftfreq, summedFFT);
        xlim(freqs);

    [xfreq, ~] = ginput(1);

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

end





    % Put the data into the output structure            
        out(j).loamp = max([f1.fftdata(lowfreqidx(lmaxidx)) f2.fftdata(lowfreqidx(lmaxidx))]);
        out(j).lofreq = currlofreq;
        out(j).hiamp = max([f1.fftdata(hifreqidx(hmaxidx)) f2.fftdata(hifreqidx(hmaxidx))]);
        out(j).hifreq = currhifreq;



oldmidpoint = midpoint;
oldcurrhifreq = currhifreq;
oldcurrlofreq = currlofreq;
% pause(0.3)
end

