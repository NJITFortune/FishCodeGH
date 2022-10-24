%function out = k_derivesum(in, channel, ReFs)
%% prep 
clearvars -except kg kg2 hkg hkg2 xxkg xxkg2 k

in = hkg(2);
channel = 1;
%kg(12) starts with light

%binsize in minutes
binsize = 20;
transbinnum = 8;



[regtim, regfreq, regtemp, regobwpeaks] = k_datatrimmean(in, channel, ReFs)