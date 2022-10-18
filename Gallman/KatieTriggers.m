
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

%% Prepare data

%define lighttimes in seconds
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld
lighttimes = k_lighttimes(in, 3); 

%outlier removal
 tto = [in.idx(channel).obwidx]; 
      
%raw data
    timcont = [in.e(channel).s(tto).timcont]; %time in seconds
    obw = [in.e(channel).s(tto).obwAmp]/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
    oldfreq = [in.e(channel).s(tto).fftFreq];
    oldtemp = [in.e(channel).s(tto).temp];
%% bins over time
%figure(34); clf; hold on;
 h = histogram(timcont/3600);   

% %% Divide sample into days to compare against trial day means
% 
% for k = 2:length(lighttimes)
%     
% 
%              % Get the index of the start time of the day
%                 dayidx = find(timcont > lighttimes(k-1) & timcont <= lighttimes(k));
%              
%                 %data
%                    
%                     day(k-1).SobwAmp = obw(dayidx);
%                   
%                     day(k-1).timcont = timcont(dayidx) - timcont(dayidx(1));
%                     day(k-1).entiretimcont = timcont(dayidx);
%                    
%                 %end
%  end
% 
%     
%  %% plot to check
% 
% %plot all days of sample on top of eachother 
% figure(28); clf; hold on; 
%     
%     subplot(211); hold on; title('All days');
%         
%         
%              for k = 1:length(day)
%                  if mod(k,2) == 1 %if kk is odd
%                     plot(day(k).timcont/3600, day(k).SobwAmp, '*');
%                  else 
%                     plot(day(k).timcont/3600 + ld, day(k).SobwAmp, '*');
%                  end
%                     
%              end
%             
%         
%         plot([ld ld], ylim, 'k-', 'LineWidth', 1);
% 
%     subplot(212); hold on; title('Chronologically')
% 
%         for channel = 1:length(day)
%             plot(day(channel).entiretimcont/3600, day(channel).SobwAmp, '*');
%         end
% 
%        
% %assuming we start with dark...        
%         for kk = 1:length(lighttimes)
% 
%             if mod(kk,2) == 1 %if kk is odd plot with a black line
%             plot([lighttimes(kk)/3600, lighttimes(kk)/3600], ylim, 'k-', 'LineWidth', 2);    
%             else %if kk is even plot with a yellow line
%             plot([lighttimes(kk)/3600, lighttimes(kk)/3600], ylim, 'y-', 'LineWidth', 2);    
%             end
%             
%         end
%      
%  %% how many triggers per half day?
% 
%  figure(32);clf; hold on;
% 
%  for k = 1:length(day)
%     ax(1) = subplot(211); hold on; title('triggers per lightchange');
%      
%      if mod(k,2) == 0
%      histogram(day(k).entiretimcont/3600, lighttimes, 'FaceColor', 'k'); 
%         
%      else
%      histogram(day(k).entiretimcont/3600, lighttimes, 'FaceColor', 'y'); 
%        
%      end
%  end
%      
% 
%      ax(2) = subplot(212); hold on; title('total triggers');
%      histogram(timcont, 100); 
%       for kk = 1:length(lighttimes)
% 
%             if mod(kk,2) == 1 %if kk is odd plot with a black line
%             plot([lighttimes(kk)/3600, lighttimes(kk)/3600], ylim, 'k-', 'LineWidth', 3);    
%             else %if kk is even plot with a yellow line
%             plot([lighttimes(kk)/3600, lighttimes(kk)/3600], ylim, 'y-', 'LineWidth', 3);    
%             end
%             
%       end
% 
%  linkaxes(ax, 'x');
%     
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
%  