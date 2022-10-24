%function out = k_derivesum(in, channel, ReFs)
%% prep 
clearvars -except kg kg2 hkg hkg2 xxkg xxkg2 k

in = hkg(2);
channel = 1;
ReFs = 20;
%kg(12) starts with light

%binsize in minutes
binsize = 20;
transbinnum = 8;

lighttimes = k_lighttimes(in, 3);
lighttimes = lighttimes/3600;
%% dark to light transitions

%length of experiment
totaltimhours = lighttimes(end)-lighttimes(1);
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


%% dark summary by day for stats

%dark
for jj = 2:length(darkdays)

    darkidx = find(timcont >= darkdays(jj-1) & timcont < darkdays(jj));
        rawdday(jj-1).tim(:) = timcont(darkidx)-timcont(darkidx(1));
        rawdday(jj-1).amp(:) = obwAmp(darkidx);
        rawdday(jj-1).entiretimcont = timcont(darkidx);

end

[regtim, regfreq, regtemp, regobw] = k_datatrimmean(in, channel, ReFs);
regtim = regtim/3600;

for jj = 2:length(darkdays)

    darkidx = find(regtim >= darkdays(jj-1) & regtim < darkdays(jj));
        dday(jj-1).tim(:) = regtim(darkidx)-regtim(darkidx(1));
        dday(jj-1).amp(:) = regobw(darkidx);
        dday(jj-1).entiretimcont = regtim(darkidx);

end

%trim mean
for j = 1:length(dday)
    darkdayamp(j,:) = dday(j).amp;
end

avgdark = trimmean(darkdayamp, 33);
[darkxx, darkampyy] = metamucil([dday.tim]*3600, avgdark);

 darktimxx = darkxx/3600;
 darkdy= gradient(darkampyy)./gradient(darktimxx);
