% Fs = 40000;
% 
% % Set up filters
%         % High pass filter cutoff frequency
%             highp = 200;
%             [b,a] = butter(5, highp/(Fs/2), 'high'); % Filter to eliminate 60Hz contamination
%         % Low pass filter cutoff frequency
%             lowp = 2000;    
%             [f,e] = butter(5, lowp/(Fs/2), 'low'); % Filter to eliminate high frequency contamination
            

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
lfreqs = find(t1.fftfreq < sepfreq & t1.fftfreq > 200);
    [pwrA1l, idx] = max(t1.fftdata(lfreqs));
    pwrF1l = t1.fftfreq(lfreqs(idx));
    
hfreqs = find(t1.fftfreq > sepfreq & t1.fftfreq < 700);
    [pwrA1h, idx] = max(t1.fftdata(hfreqs));
    pwrF1h = t1.fftfreq(hfreqs(idx));
    
if pwrA1h > pwrA1l
    pwr1A = pwrA1h; pwr1F = pwrF1h;
    ratio1 = pwrA1h / pwrA1l;
else
    pwr1A = pwrA1l; pwr1F = pwrF1l;
    ratio1 = pwrA1l / pwrA1h;
end
    
% Tube 2
lfreqs = find(t2.fftfreq < sepfreq & t2.fftfreq > 200);
    [pwrA2l, idx] = max(t2.fftdata(lfreqs));
    pwrF2l = t2.fftfreq(lfreqs(idx));
    
hfreqs = find(t2.fftfreq > sepfreq & t2.fftfreq < 700);
    [pwrA2h, idx] = max(t2.fftdata(hfreqs));
    pwrF2h = t2.fftfreq(hfreqs(idx));
     
    
if pwrA2h > pwrA2l
    pwr2A = pwrA2h; pwr2F = pwrF2h;
    ratio2 = pwrA2h / pwrA2l;
else
    pwr2A = pwrA2l; pwr2F = pwrF2l;
    ratio2 = pwrA2l / pwrA2h;
end
    
if pwr2F == pwr1F
    fprintf('Sucky ducky.\n');
    if ratio1 > ratio2
        if pwrA2h > pwrA2l
            pwr2A = pwrA2l; pwr2F = pwrF2l;
        else
            pwr2A = pwrA2h; pwr2F = pwrF2h;
            fprintf('Power1 %2.2f > Power2 %2.2f \n', pwrA1l, pwrA2l);
            fprintf('Power1 %2.2f < Power2 %2.2f \n', pwrA1h, pwrA2h);
        end

        
    end
    if ratio2 > ratio1
        if pwrA1h > pwrA1l
            pwr1A = pwrA1l; pwr1F = pwrF1l;
        else
            pwr1A = pwrA1h; pwr1F = pwrF1h;
        end
    end

end

% Did we get it right?

    
