Fs = 10000;
len = 10;
tim = 1/Fs:1/Fs:len;

sig = rand(1, length(tim));
[b,a] = butter(3, 40/(Fs/2), 'low');
sig = sig - mean(sig); sig(1) = 0;
sig = filtfilt(b,a,sig); 

dsig = diff(sig); dsig(end+1) = dsig(end);

%%


figure(1);  clf;
            ax(1) = subplot(211); plot(tim, sig);
            ax(2) = subplot(212); plot(tim, dsig);
            linkaxes(ax,'x');

velthresh = 0.05;

z = zeros(1,length(tim));
z(sig > velthresh) = 1;
spikeeventidxs = find(diff(z) == 1);

%%
wind = 200;
for j = length(spikeeventidxs):-1:1

    if (spikeeventidxs(j)-wind > 0 && spikeeventidxs(j)+wind < length(tim))
        Vsamp(j,:) = sig(spikeeventidxs(j)-wind:spikeeventidxs(j)+wind);
        Asamp(j,:) = dsig(spikeeventidxs(j)-wind:spikeeventidxs(j)+wind);

        i = randi([wind+1, length(tim)-(wind+1)]);
        rVsamp(j,:) = sig(i-wind:i+wind);
        rAsamp(j,:) = dsig(i-wind:i+wind);


    end

end

figure(2); clf;
    xa(1) = subplot(221); plot(mean(Vsamp));     
    xa(2) = subplot(223); plot(mean(rVsamp)); 
    linkaxes(xa, 'xy');
    xxa(1) = subplot(222); plot(mean(Asamp));
    xxa(2) = subplot(224); plot(mean(rAsamp));
    linkaxes(xxa, 'xy');


length(spikeeventidxs)