Fs = 40000;

% Set up filters
        % High pass filter cutoff frequency
            highp = 200;
            [b,a] = butter(5, highp/(Fs/2), 'high'); % Filter to eliminate 60Hz contamination
        % Low pass filter cutoff frequency
            lowp = 2000;    
            [f,e] = butter(5, lowp/(Fs/2), 'low'); % Filter to eliminate high frequency contamination
            

 tube1 = filtfilt(b,a,data(:,1));
 tube2 = filtfilt(b,a,data(:,2));
 
 t1 = fftmachine(tube1, Fs);
 t2 = fftmachine(tube2, Fs);
 
 figure(1); clf; hold on;
 
    semilogy(t1.fftfreq, t1.fftdata);
    semilogy(t2.fftfreq, t2.fftdata);

[sepfreq, ~] = ginput(1);


    