%function [trial, day] = KatieDayDessembler(in, channel,  ReFs)
%% usage
%[trial, day] = KatieDayTrialDessembler(kg(#), channel, triallength, ReFs)
% 
% clear trial
% clear day
clearvars -except kg
in = kg(54);
channel = 1;
ReFs = 10;



% ReFs = 10;
%% Take spline estimate of raw data

%ReFs = 10;  % Sample rate for splines
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld


[xx, obwyy, zyy, sumfftyy, lighttimes] = k_detrendspliner(in,channel, ReFs);

% lighttimes = abs(luztimes);
% %add back the light time we subtracted 
% lighttimes(end +1) = lighttimes(end) + ld;

%Make a time base that starts and ends on lighttimes 
    %necessary to define length of data

    timcont = [in.e(1).s.timcont] / (60*60);
    timcont = timcont(timcont >= lighttimes(1) & timcont <= lighttimes(end));
%     



    
%% Divide sample into days to compare against trial day means

%define length of sample
lengthofsampleHOURS = lighttimes(end) - lighttimes(1); 
howmanydaysinsample = floor(lengthofsampleHOURS / (ld*2));
howmanysamplesinaday = ld * 2 * ReFs;

tim = 1/ReFs:1/ReFs:howmanysamplesinaday/ReFs;
%spline data

for k = 1:howmanydaysinsample
    

    %         % Get the index of the start time of the day
                dayidx = find(xx >= xx(1) + (k-1) * (ld*2) & xx < xx(1) + k*(ld*2)); % k-1 so that we start at zero

                if length(dayidx) >= howmanysamplesinaday
                day(k).SobwAmp = obwyy(dayidx);
                day(k).SzAmp = zyy(dayidx);
                day(k).Ssumfftyy = sumfftyy(dayidx);
                day(k).tim = tim;
                day(k).xx = xx(dayidx);
                end
 end
    
    
 %% plot to check

%plot all days of sample on top of eachother 
figure(28); clf; hold on; 
    
    subplot(211); hold on; title('All days');
        meanday(k,:) = zeros(1, length(day(k).tim));
        
             for k = 1:length(day)
                    plot(day(k).tim, day(k).SobwAmp, 'LineWidth', 2);
                    meanday(k,:) = meanday(k,:) + day(k).SobwAmp;
             end
            
        mmday= mean(meanday);
        plot(day(1).tim, mmday, 'k-', 'LineWidth', 2);
        plot([ld ld], ylim, 'k-', 'LineWidth', 1);

    subplot(212); hold on; title('Chronologically')

        for j = 1:length(day)
            plot(day(j).xx, day(j).SobwAmp, 'LineWidth', 2);
        end

       
%assuming we start with dark...        
        for kk = 1:length(lighttimes)

            if mod(kk,2) == 1 %if kk is odd plot with a black line
            plot([lighttimes(kk), lighttimes(kk)], ylim, 'k-');    
            else %if kk is even plot with a yellow line
            plot([lighttimes(kk), lighttimes(kk)], ylim, 'r-');    
            end
            
        end
        


 %plot 1st 3 days   
 figure(29); clf; hold on; 
    
    daysforphase = 3;
    days = 1:1:daysforphase;


    subplot(211); hold on; title('First 3 days');
       
    
         for k = 1:length(days)
                plot(day(k).tim, day(k).SobwAmp, 'LineWidth', 2);
               
         end
            
       
        plot([ld ld], ylim, 'k-', 'LineWidth', 1);

    subplot(212); hold on; title('Over time')


        for j = 1:length(days)
            plot(day(j).xx, day(j).SobwAmp, 'LineWidth', 2);
        end

       
%assuming we start with dark...        
        for kk = 1:1:(daysforphase *2)

            if mod(kk,2) == 1 %if kk is odd plot with a black line
            plot([lighttimes(kk), lighttimes(kk)], ylim, 'k-');    
            else %if kk is even plot with a yellow line
            plot([lighttimes(kk), lighttimes(kk)], ylim, 'r-');    
            end
            
        end

