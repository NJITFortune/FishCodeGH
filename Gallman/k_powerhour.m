%function k_powerhour(in)


% not functioning today
clearvars -except l24kg k hkg
in = l24kg(66);

%% prep - define variables
ReFs = 20;
channel = 1;
Fs = 1/ReFs;


[regtim, regfreq, regtemp, regobwpeaks] = k_datatrimmean(in, channel, ReFs);
lighttimes = k_lighttimes(in, 3);


% trim data to lighttimes
    timidx = regtim >= lighttimes(1) & regtim <= lighttimes(end);
    regtim = regtim(timidx);
     obw = regobwpeaks(timidx);
   
    freq = regfreq(timidx);
    temp = regtemp(timidx);

    N = length(obw);

%     %periodogram(obw, rectwin(N),N, Fs)
% 
%     [pxx,f] = pwelch(obw,hamming(N),[],N,Fs);
% 
%    
%  figure(6);clf; hold on;
% 
%     plot(f,pxx);

   