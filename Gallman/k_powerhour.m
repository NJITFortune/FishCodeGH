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


%less strong low pass filter?
           lowWn = 0.1/(ReFs/2); %OG 0.9
           [dd,cc] = butter(5, lowWn, 'low');

           datadata = filtfilt(dd,cc, double(obw)); %low pass

    N = length(obw);
    periodogram(datadata, rectwin(N),N, Fs)