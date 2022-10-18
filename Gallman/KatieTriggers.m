
%function [timcont, lighttimes, halfday] = KatieTriggers(in) 

%function [trial, day] = KatieDayDessembler(in, channel,  ReFs)
%% usage
%[trial, day] = KatieDayTrialDessembler(kg(#), channel, triallength, ReFs)
% 
% clear trial
% clear day
clearvars -except kg kg2 hkg hkg2 xxkg xxkg2
in = hkg(2);
channel = 1;
ReFs = 20;

%% Take spline estimate of raw data

%ReFs = 10;  % Sample rate for splines
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld


lighttimes = k_lighttimes(in, 3);

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
% lengthofsampleHOURS = lighttimes(end) - lighttimes(1); 
% howmanydaysinsample = floor(lengthofsampleHOURS / (ld));
% howmanysamplesinaday = ld * ReFs;

%tim = 1/ReFs:1/ReFs:howmanysamplesinaday/ReFs;
%spline data

for k = 2:length(lighttimes)-1
    

    %         % Get the index of the start time of the day
                %dayidx = find(timcont >= lighttimes(1) + ((k-1) * (ld)) & timcont < lighttimes(1) + k*ld); % k-1 so that we start at zero
                dayidx = find(timcont > lighttimes(k-1) & timcont <= lighttimes(k));
               % if length(dayidx) >= howmanysamplesinaday %makes sure we only have full days
                %data
                    for j = channel
                    halfday(k).SobwAmp = [in.e(j).s(dayidx).obwAmp];
%                     halfday(k).SzAmp = [in.e(j).s(dayidx).zAmp];
%                     halfday(k).Ssumfftyy = [in.e(j).s(dayidx).sumfftAmp];
%                  
                 
                     % Time and treatment 
                    halfday(k).timcont = timcont(dayidx) - timcont(dayidx(1));
                    halfday(k).entiretimcont = timcont(dayidx);
                    end 
                %end
 end
  clear k  
    
 %% plot to check

%plot all days of sample on top of eachother 
figure(28); clf; hold on; 
    
    subplot(211); hold on; title('All days');
        
        
             for k = 1:length(halfday)
                 if mod(k,2) == 1 %if kk is odd
                    plot(halfday(k).timcont, halfday(k).SobwAmp, '*');
                 else 
                    plot(halfday(k).timcont + ld, halfday(k).SobwAmp, '*');
                 end
                    
             end
            
        
        plot([ld ld], ylim, 'k-', 'LineWidth', 1);

    subplot(212); hold on; title('Chronologically')

        for j = 1:length(halfday)
            plot(halfday(j).entiretimcont, halfday(j).SobwAmp, '*');
        end

       
%assuming we start with dark...        
        for kk = 1:length(lighttimes)

            if mod(kk,2) == 1 %if kk is odd plot with a black line
            plot([lighttimes(kk), lighttimes(kk)], ylim, 'k-', 'LineWidth', 2);    
            else %if kk is even plot with a yellow line
            plot([lighttimes(kk), lighttimes(kk)], ylim, 'y-', 'LineWidth', 2);    
            end
            
        end
     
 %% how many triggers per half day?

 figure(32);clf; hold on;

 for k = 1:length(halfday)
    ax(1) = subplot(211); hold on; title('triggers per lightchange');
     
     if mod(k,2) == 0
     histogram(halfday(k).entiretimcont, lighttimes, 'FaceColor', 'k'); 
        
     else
     histogram(halfday(k).entiretimcont, lighttimes, 'FaceColor', 'y'); 
       
     end
 end
     

     ax(2) = subplot(212); hold on; title('total triggers');
     histogram(timcont, 100); 
      for kk = 1:length(lighttimes)

            if mod(kk,2) == 1 %if kk is odd plot with a black line
            plot([lighttimes(kk), lighttimes(kk)], ylim, 'k-', 'LineWidth', 3);    
            else %if kk is even plot with a yellow line
            plot([lighttimes(kk), lighttimes(kk)], ylim, 'y-', 'LineWidth', 3);    
            end
            
      end

 linkaxes(ax, 'x');
    


























 