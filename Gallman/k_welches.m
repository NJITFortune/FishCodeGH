function [freq, pwr] = k_welches(in, hourperiod)
%in = output from KatieTrialDessembler 



%% Run fft (pwelch)


%Analysis zAMp
% %fftmachine
% f = fftmachine(o.z(1).y - mean(o.z(1).y), ReFs, 3); 
%pwelch
L = length(in.zyy); 
NFFT = 2^nextpow2(L)/2;
%NFFT = 8192;
FreqRange = 0.002:0.0001:0.2;



    %generate fft
    [pxx,pf] = pwelch(in.zyy, NFFT, floor(NFFT*0.99), FreqRange, ReFs);  
    %populate values 
    zwelch = [pxx', pf'];
    colNames = {'pxx','pfreq'};
    pw(1).zAmp = array2table(zwelch,'VariableNames',colNames);
    
    %find peak at given frequency
    range = 0.002;
    xfreq(1) = 1/(2*hourperiod);
    hourpeak(1) = mean(pw(1).zAmp.pxx(pw(1).zAmp.pfreq > (1/(2*hourperiod) - range/2) & pw(1).zAmp.pfreq < ((1/(2*hourperiod) + range/2))));
        freq = xfreq(1);
        pwr = hourpeak(1);
        
        
   
    end






