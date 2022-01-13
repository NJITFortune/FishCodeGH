
clearvars -except kg

in = kg(50);
channel = 1;
p = 0.5;
ReFs = 10;  %resample once every minute (Usually 60)

%% testing why the temp doesn't seem to line up...
  temptims = [in.info.temptims];

figure(2); clf; hold on;
    plot([in.e(channel).s.timcont]/3600, [in.e(channel).s.temp], 'r-');
    plot([temptims temptims], ylim, 'k-', 'LineWidth', 2);

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


figure(3); clf; hold on;
    plot(timcont, tempraw, 'r-');
    plot([temptims temptims], ylim, 'k-', 'LineWidth', 2);


%% plot tp check

figure(34); clf; hold on; 

    plot(xx, (obwyy/2)-mean(obwyy/2), '-', 'LineWidth', 3);
    plot(timcont, (freq/200)-mean(freq/200), 'c-', 'LineWidth', 2);
    plot(timcont, tempraw-mean(tempraw), 'r-', 'LineWidth', 1);
    plot([temptims temptims], ylim, 'k-', 'LineWidth', 2);
   % xlim([20,120]);

%% divide into tempdays

%this is going to suck because the temp doesn't change super consistently

for k = 2:2:length(temptims)-1
    %define index overwhich to divide data
    tidx = find(xx >= temptims(k-1) & xx < temptims(k+1));   

    pday(k/2).obw(:) = obwyy(tidx);
    pday(k/2).zAmp(:) = zyy(tidx);
    pday(k/2). sumfft(:) = sumfftyy(tidx);

    pday(k/2).entiretim(:) = xx(tidx);
    
    pday(k/2).tim(:) = xx(tidx)-xx(tidx(1));
    
    
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
        plot(timcont, tempraw-1.5, 'r-', 'LineWidth', 1);
        plot([temptims temptims], ylim, 'k-', 'LineWidth', 0.5);
        
%linkaxes(xa, 'x');



figure(778); clf; hold on;


pmean = zeros(1, length(pday(1).obw));
ptim = zeros(1, length(pday(1).obw));


        for p = 1:length(pday)

            plot(pday(p).tim, pday(p).obw, 'LineWidth', 2);

                if length(pmean) > length(pday(p).obw)
                    pmean(1:length(pday(p).obw)) = pmean(1:length(pday(p).obw)) + pday(p).obw;
                end
                if length(pmean) < length(pday(p).obw)
                    pmean = pmean + pday(p).obw(1:length(pmean));
                    pmean(end+1:length(pday(p).obw)) = pday(p).obw(length(pmean)+1:end);
                end
                if length(pmean) == length(pday(p).obw)
                        pmean = pmean + pday(p).obw;
                end

                if length(pday(p).tim) > length(ptim)
                    ptim = pday(p).tim;
                end
           
        end
% 
        pmean = pmean / length(pday);
        plot(ptim, pmean, 'k', 'LineWidth', 3)

        
 %% ERIC HELP PLEASE
 
%  Error using  + 
% Matrix dimensions must agree.
% 
% Error in tempday (line 92)
%             pmean(p,:) = pmean(p, :) + pday(p).obw;
%         
        