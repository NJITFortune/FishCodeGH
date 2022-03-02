
clearvars -except kg

in = kg(105);
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
[xx, sumfftyy, temperaturetimes] = k_tempspliner(in,channel, ReFs, p);

    timcont = [in.e(channel).s.timcont] / (60*60);
    %timcont = timcont(timcont >= temperaturetimes(1) & timcont <= temperaturetimes(end));

    %obwraw = [in.e(channel).s(timcont >= temperaturetimes(1) & timcont <= temperaturetimes(end)).obwAmp];
    tempraw = [in.e(channel).s.temp];
    %tempraw = k_voltstodegC(in, channel);
    temptims = [in.info.temptims];
    freq = [in.e(channel).s.fftFreq];
    light = abs(in.info.luz);

%% plot to check
figure(3); clf; hold on;
    plot(timcont, tempraw, 'r-');
    plot([temptims temptims], ylim, 'k-', 'LineWidth', 0.5);
    plot([light' light'], ylim, 'b-');



figure(34); clf; hold on; 

    plot(xx, (sumfftyy/2)-mean(sumfftyy/2), '-', 'LineWidth', 3);
    plot(timcont, (freq/200)-mean(freq/200), 'c-', 'LineWidth', 2);
    plot(timcont, tempraw-mean(tempraw), 'r-', 'LineWidth', 1);
    plot([temptims temptims], ylim, 'k-', 'LineWidth', 2);
   % xlim([20,120]);

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


   % xa(1) = subplot(211); hold on;
           % plot(xx, obwyy, '-', 'LineWidth', 3);
            

%make average amp by temp day variable
% preavg(kk, :) = zeros(1, length(pday(kk).obw));

    %xa(2) = subplot(212); hold on; 
    

        for kk = 1:length(pday)


            plot(pday(kk).entiretim, pday(kk).sumfft, 'LineWidth', 2);

            %preavg(kk, :) = preavg(kk, :) + pday(kk).obw;

        end
        %plot(timcont, tempraw-1.5, 'r-', 'LineWidth', 1);
        plot(timcont, (freq/200)-mean(freq/200), 'm-');
        plot([temptims temptims], ylim, 'k-', 'LineWidth', 0.5);
        plot([light' light'], ylim, 'b-');
        
%linkaxes(xa, 'x');



figure(778); clf; hold on;


        plot(pday(1).tim, pday(1).summfft);
        pmean = pday(1).sumfft;
        ptim = pday(1).sumfft;

        for p = 2:length(pday)

            plot(pday(p).tim, pday(p).sumfft, 'LineWidth', 2);
            pmean = pmean(1:min([length(pmean), length(pday(p).summfft)]));
            pmean = pmean + pday(p).summfft(1:length(pmean));
           
        end
% 
        pmean = pmean / length(pday);
        ptim = ptim(1:length(pmean));

        plot(ptim, pmean, 'k', 'LineWidth', 3)
%calculate temp ld equivalent
    td = floor(temperaturetimes(3)-temperaturetimes(2));
        plot([td, td], ylim, 'k-', 'LineWidth', 2);
        
 %% ERIC HELP PLEASE
 
%  Error using  + 
% Matrix dimensions must agree.
% 
% Error in tempday (line 92)
%             pmean(p,:) = pmean(p, :) + pday(p).obw;
%         
        