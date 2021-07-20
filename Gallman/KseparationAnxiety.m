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
 
 figure(1); clf; 
 
    semilogy(t1.fftfreq, t1.fftdata);
    hold on;
    semilogy(t2.fftfreq, t2.fftdata);
    xlim([200 600]);

[sepfreq, ~] = ginput(1);

% Tube 1
lfreqs = t1.fftdata(t1.fftfreq < sepfreq & t1.fftfreq > 200);
    [pwrA1l, idx] = max(t1.fftdata(lfreqs));
    pwrF1l = t1.fftdata(lfreqs(idx));
    
hfreqs = t1.fftdata(t1.fftfreq > sepfreq & t1.fftfreq < 700);
    [pwrA1h, idx] = max(t1.fftdata(hfreqs));
    pwrF1h = t1.fftdata(hfreqs(idx));
        
if pwrA1h > pwrA1l
    pwr1A = pwrA1h; pwr1F = pwrF1h;
else
    pwr1A = pwrA1l; pwr1F = pwrF1l;
end
    
% Tube 2
lfreqs = t2.fftdata(t2.fftfreq < sepfreq & t2.fftfreq > 200);
    [pwrA2l, idx] = max(t2.fftdata(lfreqs));
    pwrF2l = t2.fftdata(lfreqs(idx));
    
hfreqs = t2.fftdata(t2.fftfreq > sepfreq & t2.fftfreq < 700);
    [pwrA2h, idx] = max(t2.fftdata(hfreqs));
    pwrF2h = t2.fftdata(hfreqs(idx));
        
if pwrA2h > pwrA2l
    pwr2A = pwrA2h; pwr2F = pwrF2h;
else
    pwr2A = pwrA2l; pwr2F = pwrF2l;
end
    
if pwr2F == pwr1F
    fprintf('Sucky ducky.\n');
end