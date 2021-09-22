function [freq, pwr] = k_welches(in, hourperiod, ReFs)
%in = output from KatieTrialDessembler 

hourfreq = in.ld;

%% Run fft (pwelch)


%Analysis zAMp
% %fftmachine
% f = fftmachine(o.z(1).y - mean(o.z(1).y), ReFs, 3); 
%pwelch
L = length(in.SsumfftAmp); 
NFFT = 2^nextpow2(L)/2;
%NFFT = 8192;
FreqRange = 0.002:0.0001:0.2;



    %generate fft
    [pxx,pf] = pwelch(in.SsumfftAmp, NFFT, floor(NFFT*0.99), FreqRange, ReFs);  
    %populate values 
    zwelch = [pxx', pf'];
    colNames = {'pxx','pfreq'};
    pw(1).SsumfftAmp = array2table(zwelch,'VariableNames',colNames);
    
    %find peak at given frequency
    range = 0.002; % 
    xfreq(1) = 1/(2*hourfreq);
    hourpeak(1) = mean(pw(1).SsumfftAmp.pxx(pw(1).SsumfftAmp.pfreq > (1/(2*hourperiod) - range/2) & pw(1).SsumfftAmp.pfreq < ((1/(2*hourperiod) + range/2))));
        freq = xfreq(1);
        pwr = hourpeak(1);
        
        
  %% plot to check range
  
  figure(34); clf; hold on;
  
  plot(pxx, pf, '-', 'MarkerSize', 3);
  plot(






