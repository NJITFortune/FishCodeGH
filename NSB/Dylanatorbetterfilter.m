function [refsig, data] = Dylanatorbetterfilter(dat, refOrig, Fs)
% Usage [refsig, data] = Dylanator(dat, refOrig, Fs)

tim = 1/Fs:1/Fs:length(dat(4,:))/Fs;

[b,a] = butter(5, 5000 /(Fs/2), 'low');
[d,c] = butter(9, 10000/ (Fs/2), 'high');


xxS = [0, 0.02];

    refilt = filtfilt(b,a,refOrig - mean(refOrig)); % Low-pass filter

    figure(3); clf; % plot for no good reason
    for j=1:8

        tmpfilted = filtfilt(b,a,dat(j,:)); % Low-pass filter
        tmpfilted = filtfilt(d,c,tmpfilted); % High pass filter

        dat(j,:) = tmpfilted; clear tmpfilted;
        xxa(j) = subplot(8,1,j); plot(tim, dat(j,:)); 

    end
    linkaxes(xxa, 'x'); xlim(xxS);

figure(4); subplot(212); hold on; 
    plot(tim, refOrig); 
    plot(tim, refilt);
    xlim(xxS);
   

%% Get Ref zero crossings

zxs = zeros(1,length(refilt)); % a string of zeros
zxs(refilt > 0) = 1;
pnzxs = diff(zxs);

figure(5); clf;
    subplot(411); plot(refilt); hold on; plot(zeros(1,length(refilt)));
    subplot(412); plot(zeros(1,length(refilt))); 
    subplot(413); plot(zxs);
    subplot(414); plot(pnzxs);

%% Average cycles

    newFs = 25;
    fastphasetim = 1/newFs:1/newFs:2*pi;
    refsig = zeros(1, length(fastphasetim)); % New signal, all zeros
    
    resampdat = zeros(8, length(fastphasetim));
    
    strts = find(pnzxs == 1);

for j = 1:length(strts)-1

    chunk = refilt(strts(j):strts(j+1));
    timchunk = tim(strts(j):strts(j+1)) - tim(strts(j));
    phasetim = 2*pi*(timchunk / max(timchunk));
    ttmp = interp1(phasetim, chunk', fastphasetim, 'spline');
  
    refsig =  refsig + ttmp;
    
    for k = 1:8
        chunk = dat(k, strts(j):strts(j+1));
        resampdat(k,:) = interp1(phasetim, chunk', fastphasetim, 'spline');
    end

end

refsig = refsig / (length(strts)-1); % The average
for k = 1:8; resampdat(k,:) = resampdat(k,:) / (length(strts)-1); end

figure(27); plot(fastphasetim, refsig, 'c', 'LineWidth', 3);
figure(28); for j=1:8; ax(j) = subplot(4,2,j); plot(fastphasetim, resampdat(j,:)); end
linkaxes(ax, 'y');

data = resampdat;

