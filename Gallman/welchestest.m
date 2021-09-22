%function [freq, pwr] = k_welches(in, hourperiod, ReFs)
%in = output from KatieTrialDessembler 

start = kg(2);

ReFs = 10;

hourperiod = 12;

in = KatieTrialTrendDessembler(start, 1, 48);

for jj = 1:length(in)


hourfreq = in.ld;

%% Run fft (pwelch)


%Analysis zAMp
% %fftmachine
% f = fftmachine(o.z(1).y - mean(o.z(1).y), ReFs, 3); 
%pwelch
L = length(in(jj).SsumfftAmp); 
NFFT = 2^nextpow2(L)/2;
%NFFT = 8192;
FreqRange = 0.002:0.0001:0.2;



    %generate fft
    [pw(jj).power, pw(jj).powerfreq] = pwelch([in(jj).SsumfftAmp], NFFT, floor(NFFT*0.99), FreqRange, ReFs);  
    %calculate peak freq
    [pkAm1, pkIDX1] = max(power);
    [btAmp1, btIDX1] = min(power);
    pkfrq1 = powerfreq(pkIDX1);
    
    
    %populate values 
    zwelch = [pw(jj).power', pw(jj).powerfreq'];
    colNames = {'pxx','pfreq'};
    pw(jj).SsumfftAmp = array2table(zwelch,'VariableNames',colNames);
    
    %find peak at given frequency
    range = 0.002; % 
    xfreq(1) = 1/(2*hourfreq);
    hourpeak(1) = mean(pw(jj).SsumfftAmp.pxx(pw(jj).SsumfftAmp.pfreq > (1/(2*hourperiod) - range/2) & pw(jj).SsumfftAmp.pfreq < ((1/(2*hourperiod) + range/2))));
        freq = xfreq(1);
        pwr(jj) = hourpeak(1);
        
   
  %% plot to check range
 
 
  figure(34); clf; hold on;
  %fft
  plot(pw(jj).powerfreq, pw(jj).power, '-', 'MarkerSize', 3);
  %max power
  plot(pkfrq1, pkAmp1, 'r*', 'MarkerSize', 5); 
  
  %plot(in.Stimcont, in.SsumfftAmp, '.', 'MarkerSize', 3); 
  
  plot(1/(2*hourperiod), pwr(jj), 'b*', 'MarkerSize', 5); 
  
  %ld
  plot([1/(hourfreq*2) 1/(hourfreq*2)], [btAmp1, pkAmp1], 'k-', 'LineWidth', 0.25);
  %freq range for hour period
  plot([(1/(2*hourperiod) - range/2), (1/(2*hourperiod) - range/2)], [btAmp1, pkAmp1], 'b-', 'LineWidth', 0.25);
  plot([(1/(2*hourperiod) + range/2), (1/(2*hourperiod) + range/2)], [btAmp1, pkAmp1], 'b-', 'LineWidth', 0.25);
  

%yaxis on log scale
     set(gca,'yscale', 'log');


end

