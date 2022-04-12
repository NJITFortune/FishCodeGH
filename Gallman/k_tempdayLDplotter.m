function k_tempdayLDplotter(in, channel, p, start)

% clearvars -except kg
% 
% in = kg(103); %[108 109-ch2 103 104 105 50 51 52 53]
% channel = 1;
% p = 0.5;
ReFs = 10;  %resample once every minute (Usually 60)

%start is either up or down (which way does the first temp halfday start?) 
%up = 1;
%down = -1

%% Take spline estimate of entire data set
%easier variables
% temptims = [in.info.temptims];
% ld = in.info.ld; % Whatever - ld is shorter than in.info.ld

%detrendspliner uses csaps to estimate cubic spline of data 
    %subtracts trend from data
    %uses new time base defined by ReFs
[xx, sumfftyy, temperaturetimes] = k_tempsplinerstart(in,channel, ReFs, p, start);

    timcont = [in.e(channel).s.timcont] / (60*60);
    %timcont = timcont(timcont >= temperaturetimes(1) & timcont <= temperaturetimes(end));

    %obwraw = [in.e(channel).s(timcont >= temperaturetimes(1) & timcont <= temperaturetimes(end)).obwAmp];
    tempraw = [in.e(channel).s.temp];
    %tempraw = k_voltstodegC(in, channel);
    temptims = [in.info.temptims];
    freq = [in.e(channel).s.fftFreq];
    light = abs(in.info.luz);

%% plot to check
% figure(3); clf; hold on;
%     plot(timcont, tempraw, 'r-');
%     plot([temptims temptims], ylim, 'k-', 'LineWidth', 0.5);
%     plot([light' light'], ylim, 'b-');
% 
% 
% 
% figure(34); clf; hold on; 
% 
%     plot(xx, (sumfftyy/2)-mean(sumfftyy/2), '-', 'LineWidth', 3);
%     plot(timcont, (freq/200)-mean(freq/200), 'c-', 'LineWidth', 2);
%     plot(timcont, tempraw-mean(tempraw), 'r-', 'LineWidth', 1);
%     plot([temptims temptims], ylim, 'k-', 'LineWidth', 2);
%    % xlim([20,120]);

%% divide into tempdays

%this is going to suck because the temp doesn't change super consistently

for k = 2:2:length(temperaturetimes)-1
    %define index overwhich to divide data
    tidx = find(xx >= temperaturetimes(k-1) & xx < temperaturetimes(k+1));   

%     pday(k/2).obw(:) = obwyy(tidx);
%     pday(k/2).zAmp(:) = zyy(tidx);
    pday(k/2).sumfft(:) = sumfftyy(tidx);

    pday(k/2).entiretim(:) = xx(tidx);
    
    pday(k/2).tim(:) = xx(tidx)-xx(tidx(1));
    
    
end


figure(777); clf; hold on;



        for kk = 1:length(pday)

            plot(pday(kk).entiretim, pday(kk).sumfft, 'LineWidth', 2);

            %plot(pday(kk).entiretim, (pday(kk).sumfft/2) - mean(pday(kk).sumfft/2), 'LineWidth', 2);

            %preavg(kk, :) = preavg(kk, :) + pday(kk).obw;

        end

        plot(timcont, tempraw-mean(tempraw), 'r-', 'LineWidth', 1);
        %plot(timcont, (freq/200)-mean(freq/200), 'm-');
        plot([temptims temptims], ylim, 'k-', 'LineWidth', 0.5);
        plot([light' light'], ylim, 'b-');



figure(778); clf; hold on;


        plot(pday(1).tim, pday(1).sumfft - mean(pday(1).sumfft));
        pmean = pday(1).sumfft - mean(pday(1).sumfft);
        ptim = pday(1).tim;

        for p = 2:length(pday)

            plot(pday(p).tim, pday(p).sumfft - mean(pday(p).sumfft), 'LineWidth', 2);
            pmean = pmean(1:min([length(pmean), length(pday(p).sumfft)]));
            pmean = pmean + (pday(p).sumfft(1:length(pmean)) - mean(pday(p).sumfft(1:length(pmean))));
           
        end
% 
        pmean = pmean / length(pday);
        ptim = ptim(1:length(pmean));

        plot(ptim, pmean, 'k', 'LineWidth', 5)
%calculate temp ld equivalent
    td = floor(temperaturetimes(3)-temperaturetimes(2));
        plot([td, td], ylim, 'k-', 'LineWidth', 2);
        
