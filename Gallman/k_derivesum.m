%function out = k_derivesum(in, channel, ReFs)
%% prep 
clearvars -except kg kg2 hkg hkg2 xxkg xxkg2 k

in = hkg(2);
channel = 1;
%kg(12) starts with light

%binsize in minutes
binsize = 20;
transbinnum = 8;


[regtim, regfreq, regtemp, regobwpeaks] = k_datatrimmean(in, channel, ReFs);


%% dark to light transitions

%divide into days
%index      
daysz = 1:1:floor(totaltimhours/(ld*2));

%dark transistions
darkdays = lighttimes(1) + ((2*ld) * (daysz-1));

%light transitions
lightdays = lighttimes(2) + ((2*ld) * (daysz-1));

%how many bins around the transistion 
%transbinnum = 8;
transtim = transbinnum*binsize/60;