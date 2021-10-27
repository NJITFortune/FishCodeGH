
clearvars -except kg

in = kg(52);
channel = 1;
p = 0.5;
ReFs = 10;  %resample once every minute (Usually 60)

%% Take spline estimate of entire data set

ld = in.info.ld; % Whatever - ld is shorter than in.info.ld

%detrendspliner uses csaps to estimate cubic spline of data 
    %subtracts trend from data
    %uses new time base defined by ReFs
[xx, obwyy, zyy, sumfftyy, lighttimes] = k_tempspliner(in,channel, ReFs);

%Make a time base of raw data that starts and ends on lighttimes 
    %necessary to define length of data and plot against spline estimate
    timcont = [in.e(channel).s.timcont] / (60*60);
    timcont = timcont(timcont >= lighttimes(1) & timcont <= lighttimes(end));

    obwraw = [in.e(channel).s(timcont >= lighttimes(1) & timcont <= lighttimes(end)).obwAmp];
    tempraw = [in.e(channel).s(timcont >= lighttimes(1) & timcont <= lighttimes(end)).temp];
    temptims = [in.info.temptims];
%% plot tp check

figure(34); clf; hold on; 

    plot(xx, (obwyy/2)-mean(obwyy/2), '-', 'LineWidth', 3);
   % plot(timcont, obwraw, '.', 'MarkerSize', 3);
plot(timcont, tempraw-mean(tempraw), 'r-', 'LineWidth', 1);
plot([temptims temptims], ylim, 'k-', 'LineWidth', 2);
xlim([20,120]);