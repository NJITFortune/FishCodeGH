
clearvars -except kg

in = kg(51);
channel = 1;
p = 0.5;
ReFs = 10;  %resample once every minute (Usually 60)

%% Take spline estimate of entire data set

ld = in.info.ld; % Whatever - ld is shorter than in.info.ld

%detrendspliner uses csaps to estimate cubic spline of data 
    %subtracts trend from data
    %uses new time base defined by ReFs
[xx, obwyy, zyy, sumfftyy, temperaturetimes] = k_tempspliner(in,channel, ReFs, p);

%Make a time base of raw data that starts and ends on lighttimes 
    %necessary to define length of data and plot against spline estimate
    timcont = [in.e(channel).s.timcont] / (60*60);
    timcont = timcont(timcont >= temperaturetimes(1) & timcont <= temperaturetimes(end));

    obwraw = [in.e(channel).s(timcont >= temperaturetimes(1) & timcont <= temperaturetimes(end)).obwAmp];
    tempraw = [in.e(channel).s(timcont >= temperaturetimes(1) & timcont <= temperaturetimes(end)).temp];
    temptims = [in.info.temptims];
    freq = [in.e(channel).s(timcont >= temperaturetimes(1) & timcont <= temperaturetimes(end)).fftFreq];

%% plot tp check

figure(34); clf; hold on; 

    plot(xx, (obwyy/2)-mean(obwyy/2), '-', 'LineWidth', 3);
    plot(timcont, (freq/200)-mean(freq/200), 'c-', 'LineWidth', 2);
    plot(timcont, tempraw-mean(tempraw), 'r-', 'LineWidth', 1);
    plot([temptims temptims], ylim, 'k-', 'LineWidth', 2);
   % xlim([20,120]);

%% divide into tempdays

%this is going to suck because the temp doesn't change super consistently

for k = 2:2:length(temptims)-2
    %define index overwhich to divide data
    tidx = find(xx >= temptims(k-1) & xx < temptims(k+1));   

    pday(k).obw(:) = obwyy(tidx);
    pday(k).zAmp(:) = zyy(tidx);
    pday(k). sumfft(:) = sumfftyy(tidx);

    pday(k).entiretim(:) = xx(tidx);
    
    pday(k).tim(:) = xx(tidx)-xx(tidx(1));
    
end


figure(777); clf; hold on;


   % xa(1) = subplot(211); hold on;
           % plot(xx, obwyy, '-', 'LineWidth', 3);
            

%make average amp by temp day variable
% preavg(kk, :) = zeros(1, length(pday(kk).obw));

    %xa(2) = subplot(212); hold on; 
    

        for kk = 1:length(pday)


            plot(pday(kk).entiretim, pday(kk).obw, 'LineWidth', 2);

            %preavg(kk, :) = preavg(kk, :) + pday(kk).obw;

        end
        plot([temptims temptims], ylim, 'k-', 'LineWidth', 2);
        
%linkaxes(xa, 'x');



figure(778); clf; hold on;

pmean = zeros(1, length(pday(1).obw));

        for p = 1:length(pday)

            plot(pday(p).entiretim, pday(p).obw, 'LineWidth', 2);
            pmean = pmean + pday(p).obw;
            %preavg(kk, :) = preavg(kk, :) + pday(kk).obw;

        end

%     pavg = preavg/ length(pday);
%     plot(pday(1).daytim, pavg, 'k-');
%     