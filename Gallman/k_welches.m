function [freq, pwr] = k_welches(in, hourperiod, ReFs)
%in = output from KatieTrialDessembler 

hourfreq = in.ld;

%% Run fft (pwelch)

%Analysis 
fs = ReFs; %in Hz - cycles per sec
nfft = 100*length(in.SsumfftAmp);
npts = length(in.SsumfftAmp); %480;
data = in.SsumfftAmp - 1;
datalessmean = data - mean(data);

        [pxx, f] = pwelch(datalessmean, hamming(npts), [], nfft, fs);
        
        %find values for plotting - comment out if no plots
        %find the amp peak with the greatest fft power
%         [pkAmp1, pkIDX1] = max(pxx);
%         %find the freq of the max peak
%         pkfreq1 = f(pkIDX1);
% 
%         %find the lowest fft power for plotting lines
%         [btAmp1, btIDX1] = min(pxx);
        
        %find fft power of amp at a given time frequency
        range = 0.002;
        timfreq = 1/(2*hourfreq);
        hpeakIDX = f > (1/(2*hourperiod) - range/2) & f < (1/(2*hourperiod) + range/2);
        hourpeak = mean(pxx(hpeakIDX));
        %save outputs
        freq = timfreq;
        pwr = hourpeak;
    


% %fftmachine
% f = fftmachine(o.z(1).y - mean(o.z(1).y), ReFs, 3); 
%pwelch
% L = length(in.SsumfftAmp); 
% NFFT = 2^nextpow2(L)/2;
% %NFFT = 8192;
% FreqRange = 0.002:0.0001:0.2;



%     %generate fft
%     [pxx,pf] = pwelch(in.SsumfftAmp, NFFT, floor(NFFT*0.99), FreqRange, ReFs);  
%     %calculate peak freq
%     [pkAmp1, pkIDX1] = max(pxx);
%     [btAmp1, btIDX1] = min(pxx);
%     pkfrq1 = pf(pkIDX1);
%     
%     
%     %populate values 
%     zwelch = [pxx', pf'];
%     colNames = {'pxx','pfreq'};
%     pw(1).SsumfftAmp = array2table(zwelch,'VariableNames',colNames);
%     
%     %find peak at given frequency
%     range = 0.002; % 
%     xfreq(1) = 1/(2*hourfreq);
%     hourpeak(1) = mean(pw(1).SsumfftAmp.pxx(pw(1).SsumfftAmp.pfreq > (1/(2*hourperiod) - range/2) & pw(1).SsumfftAmp.pfreq < ((1/(2*hourperiod) + range/2))));
%         freq = xfreq(1);
%         pwr = hourpeak(1);
%         
%         
%   %% plot to check range
%   
%   figure(34); clf; hold on;
%   
%   plot(pxx, pf, '-', 'MarkerSize', 3);
%   plot(1/(2*hourperiod), pwr, 'b*', 'MarkerSize', 5);
%   plot(pkfrq1, pkAmp1, 'r*', 'MarkerSize', 5);
%   plot([1/(hourfreq*2) 1/(hourfreq*2)], [btAmp1, pkAmp1], 'k-', 'LineWidth', 0.25);
%   plot([(1/(2*hourperiod) - range/2), (1/(2*hourperiod) + range/2)], [btAmp1, pkAmp1], 'b-', 'LineWidth', 0.25);
%   
%     %yaxis on log scale
%      set(gca,'yscale', 'log');
% 
% 
% 
% 
% 
