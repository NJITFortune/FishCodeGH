%function [freq, pwr] = k_welches(in, hourperiod, ReFs)
%in = output from KatieTrialDessembler 

clearvars -except kg

start = kg(2);

ReFs = 10;

hourperiod = 12;

in = KatieTrialTrendDessembler(start, 1, 48, ReFs);

in = in(1);

%%

for jj = 1%1:length(in)


hourfreq = in.ld;

%% Run fft (pwelch)


%Analysis zAMp
% %fftmachine
% f = fftmachine(o.z(1).y - mean(o.z(1).y), ReFs, 3); 
ReFs = 10;


%pwelch eric
L = length(in(jj).SsumfftAmp); 
NFFT = 2^nextpow2(L)/2;
%NFFT = 8192;
% FreqRange = 0.002:0.0001:0.2;
FreqRange = 0.002:0.002:0.2;


    %generate fft
    [pw(jj).power, pw(jj).powerfreq] = pwelch([in(jj).SsumfftAmp]-mean([in(jj).SsumfftAmp]), NFFT, floor(NFFT*0.99), FreqRange, ReFs);  
    %calculate peak freq
    [pw(jj).pkAmp1, pkIDX1] = max(pw(jj).power);
    [btAmp1, btIDX1] = min(pw(jj).power);
    pw(jj).pkfrq1 = pw(jj).powerfreq(pkIDX1);
    
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
    
%pwelch mama
fs = length(in(jj).SsumfftAmp); %480;
nfft = length(in(jj).SsumfftAmp); %480;
npts = length(in(jj).SsumfftAmp); %480;
data = in(1);
x = data; %this gets rid of the dc offset
[pxx,f] = pwelch(x,hamming(npts),[],nfft,fs);


%values for plotting peaks at points of interest    
    %find the amp peak with the greatest fft power
    [pkAmp1, pkIDX1] = max(pxx);
    %find the freq of the max peak
    pkfreq1 = f(pkIDX1);
    
    %find the lowest fft power for plotting lines
    [btAmp1, btIDX1] = min(pxx);
    
    
    %find fft power of amp at a given time frequency
    range = 0.002;
    timfreq = 1/(2*hourfreq);
    hpeakIDX = f > (1/(2*hourperiod) - range/2) & f < (1/(2*hourperiod) + range/2);
    hourpeak = mean(pxx(hpeakIDX));
    
    
 %% plot to check mama
 
 figure(33); clf; hold on;
 
    %fft created by pwelch
    plot(f, pxx, '-', 'MarkerSize', 3);
    %peak amp fft power
    plot(pkfreq1, pkAmp1, 'r*', 'MarkerSize', 5); 
    %24 hour power
    plot(1/(2*hourperiod), hourpeak, 'b*', 'MarkerSize', 5); 
    %line at hour freq of interest
    plot([1/(hourfreq*2) 1/(hourfreq*2)], [btAmp1, pkAmp1], 'k-', 'LineWidth', 0.25);
    
    
    
 
 
    
    

    
    
        
   
  %% plot to check range eric
 
 
  figure(34); clf; hold on;
  %fft
  plot(pw(jj).powerfreq, pw(jj).power, '-', 'MarkerSize', 3); hold on;
  %max power
  plot(pw(jj).pkfrq1, pw(jj).pkAmp1, 'r*', 'MarkerSize', 5); 
  
  %plot(in.Stimcont, in.SsumfftAmp, '.', 'MarkerSize', 3); 
  
  plot(1/(2*hourperiod), pwr(jj), 'b*', 'MarkerSize', 5); 
  
  %ld
  plot([1/(hourfreq*2) 1/(hourfreq*2)], [btAmp1, pw(jj).pkAmp1], 'k-', 'LineWidth', 0.25);
  %freq range for hour period
  plot([(1/(2*hourperiod) - range/2), (1/(2*hourperiod) - range/2)], [btAmp1, pw(jj).pkAmp1], 'b-', 'LineWidth', 0.25);
  plot([(1/(2*hourperiod) + range/2), (1/(2*hourperiod) + range/2)], [btAmp1, pw(jj).pkAmp1], 'b-', 'LineWidth', 0.25);
  

%yaxis on log scale
     set(gca,'yscale', 'log');


end

