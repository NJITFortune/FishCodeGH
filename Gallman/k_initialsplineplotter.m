function k_initialsplineplotter(out)
% plot the data for fun
% Usage: k_initialplotter(kg(#));
%close all;
%% Preparations

% All the data (set because we may want to plot before running KatieRemover and/or KatieLabeler)
%     tto{1} = 1:length([out.e(2).s.timcont]); % tto is indices for obwAmp
%     tto{2} = tto{1};
% 
%     ttz{1} = tto{1}; % ttz is indices for zAmp
%     ttz{2} = tto{1};

    ttsf{1} = 1:length([out.e(1).s.timcont]); % ttsf is indices for sumfftAmp
    ttsf{2} = 1:length([out.e(2).s.timcont]);
    
% If we have removed outliers via KatieRemover, get the indices...    
    if ~isempty(out.idx)
%         tto{1} = out.idx(1).obwidx; tto{2} = out.idx(2).obwidx; % tto is indices for obwAmp
%         ttz{1} = out.idx(1).zidx; ttz{2} = out.idx(2).zidx; % ttz is indices for zAmp
        ttsf{1} = out.idx(1).sumfftidx; ttsf{2} = out.idx(2).sumfftidx; % ttsf is indices for sumfftAmp
    end

ld = out.info.ld;
%% Continuous data plot

%colors
%channel 1
blueish = [103/255, 189/255, 170/255];
lavender = [133/255, 128/255, 177/255];
%channel 2
pinkish = [193/255, 90/255, 99/255];
orangeish = [224/255, 163/255, 46/255];


figure(2); clf; 
    set(gcf, 'Position', [200 100 2*560 2*420]);



    ax(1) = subplot(211); hold on; title('sumfftAmp spline channel 1');
        
        %raw spline estimate channel 1
        channel = 1;
        [xx1, sumfftyy1, lighttimes1] =  k_rawspliner(out, channel, 10, 0.5);
    
        %plot raw data again
        plot([out.e(1).s(ttsf{1}).timcont]/(60*60), [out.e(1).s(ttsf{1}).sumfftAmp], '.', 'MarkerSize', 10,'Color', blueish);
        %plot spline
        plot(xx1, sumfftyy1, 'LineWidth', 5, 'Color', lavender);
        %plot light times
        plot([lighttimes1' lighttimes1'], ylim, 'k-', 'LineWidth', 0.5);
    

    
    ax(2) = subplot(212); hold on; title('sumfftAmp spline channel 2');
        
        %raw spline estimate channel 1
        channel = 2;
        [xx2, sumfftyy2, lighttimes2] =  k_rawspliner(out, channel, 10, 0.5);
    
        %plot raw data again
        plot([out.e(2).s(ttsf{2}).timcont]/(60*60), [out.e(2).s(ttsf{2}).sumfftAmp], '.', 'MarkerSize', 10, 'Color', orangeish);
        %plot spline
        plot(xx2, sumfftyy2,  'LineWidth', 5, 'Color', pinkish);
        %plot light times
        plot([lighttimes2' lighttimes2'], ylim, 'k-', 'LineWidth', 0.5);

  


% Add light transitions times to check luz if we have programmed it
if isfield(out.info, 'luz')
    if  ~isempty(out.info.luz)
        
        %luz by transition type
            %separate by transition type
            lighton = out.info.luz(out.info.luz > 0);
            darkon = out.info.luz(out.info.luz < 0);
            
            %plot
            ax(1) = subplot(211); hold on;
                plot([lighton' lighton']', ylim, 'm-', 'LineWidth', 0.5);
            ax(2) = subplot(212); hold on;
                plot([lighton' lighton']', ylim, 'm-', 'LineWidth', 0.5);
            %plot([abs(darkon)' abs(darkon)']', [0 6], 'k-', 'LineWidth', 2, 'MarkerSize', 10);
    end    
end

%% day average

channel = 1;
[trial, day] = KatiefftDayTrialDessembler(out, channel,  10, 3);

figure(27); clf; hold on; title('Day average by trial');
    for jj=1:length(trial) 

        %create temporary vector to calculate mean by trial
        mday(jj,:) = zeros(1, length(trial(jj).tim));


        for k=1:length(trial(jj).day)

                %fill temporary vector with data from each day 
                mday(jj,:) = mday(jj,:) + trial(jj).day(k).SsumfftAmp;
                subplot(211); hold on; title('Days');
                plot(trial(jj).tim, trial(jj).day(k).SsumfftAmp);
                plot([ld ld], ylim, 'k-', 'LineWidth', 1);

        end

         % To get average across days, divide by number of days
            mday(jj,:) = mday(jj,:) / length(trial(jj).day);
            subplot(212); hold on; title('Day average by trial');
            plot(trial(jj).tim, mday(jj,:), '-', 'Linewidth', 1);
            plot([ld ld], ylim, 'k-', 'LineWidth', 1);

    end
    
    % Mean of means
 
    subplot(212); hold on;
     meanofmeans = mean(mday); % Takes the mean of the means for a day from each trial 
    plot(trial(jj).tim, meanofmeans, 'k-', 'LineWidth', 3);
    

   
    
figure(28); clf; hold on; 

clear meanday;

 for k = 1:length(day)
        plot(day(k).tim, day(k).Ssumfftyy);
        meanday(k,:) = day(k).Ssumfftyy;
 end
    
        mmday= mean(meanday);
        plot(day(1).tim, mmday, 'k-', 'LineWidth', 3);
        plot([ld ld], ylim, 'k-', 'LineWidth', 1);
        
figure(29); clf; hold on;
    plot(day(1).tim, mmday);
    plot(trial(jj).tim, meanofmeans);
    plot([ld ld], ylim, 'k-', 'LineWidth', 1);
    legend('day mean', 'trial mean');
     legend('boxoff')



        
% Add feedingtimes, if we have them... 
%    if isfield(out.info, 'feedingtimes')
%     if ~isempty([out.info.feedingtimes])
%        ax(1) = subplot(611); plot([out.info.feedingtimes' out.info.feedingtimes']', ylim, 'm-', 'LineWidth', 2, 'MarkerSize', 10);                
%     end
%    end  


% Add temptimes, if we have them... 
%    if isfield(out.info, 'temptims')
%     if ~isempty([out.info.temptims])
%        ax(5) = subplot(615); 
%        for j = 1:length([out.info.temptims])
%             plot([out.info.temptims(j), out.info.temptims(j)], ylim, 'b-');
%        end         
%     end
%    end  

% % Add social times, if we have them... 
%    if isfield(out.info.socialtimes)
%     if ~isempty(out.info.socialtimes)   
%         ax(2) = subplot(512); plot([abs(out.info.socialtimes)' abs(out.info.socialtimes)']', [0 max([out.e(1).s.zAmp])], 'g-', 'LineWidth', 2, 'MarkerSize', 10);
%     end  
%    end
    
% Add light transitions times to check luz if we have programmed it
% if isfield(out.info, 'luz')
%     if  ~isempty(out.info.luz)
%         
%         %luz by transition type
%             %separate by transition type
%             lighton = out.info.luz(out.info.luz > 0);
%             darkon = out.info.luz(out.info.luz < 0);
%             
%             %plot
%             ax(6) = subplot(616); hold on;
%             plot([lighton' lighton']', [0 6], 'y-', 'LineWidth', 2, 'MarkerSize', 10);
%             plot([abs(darkon)' abs(darkon)']', [0 6], 'k-', 'LineWidth', 2, 'MarkerSize', 10);
%     end    
% end
linkaxes(ax, 'x'); 


                    


%% 24 hour plot 
% tim24 based off of computer midnight

% figure(2); clf; 
%     set(gcf, 'Position', [300 100 2*560 2*420]);
% 
% xa(1) = subplot(511); hold on; title('sumfftAmp');
%     plot([out.e(2).s(ttsf{2}).tim24]/(60*60), [out.e(2).s(ttsf{2}).sumfftAmp], '.');
%     plot([out.e(1).s(ttsf{1}).tim24]/(60*60), [out.e(1).s(ttsf{1}).sumfftAmp], '.');
% 
% xa(2) = subplot(512); hold on; title('zAmp');
%     plot([out.e(2).s(ttz{2}).tim24]/(60*60), [out.e(2).s(ttz{2}).zAmp], '.');
%     plot([out.e(1).s(ttz{1}).tim24]/(60*60), [out.e(1).s(ttz{1}).zAmp], '.');
%    
% xa(3) = subplot(513); hold on; title('obwAmp');
%     plot([out.e(2).s(tto{2}).tim24]/(60*60), [out.e(2).s(tto{2}).obwAmp], '.');
%     plot([out.e(1).s(tto{1}).tim24]/(60*60), [out.e(1).s(tto{1}).obwAmp], '.');
%     
% xa(4) = subplot(514); hold on; title('frequency (black) and temperature (red)'); 
%     yyaxis right; plot([out.e(2).s.tim24]/(60*60), -[out.e(2).s.temp], '.');
%     yyaxis left; ylim([200 800]);
%         plot([out.e(2).s.tim24]/(60*60), [out.e(2).s.fftFreq], '.', 'Markersize', 8);      
%     
% xa(5) = subplot(515); hold on; title('light transitions');
%     plot([out.e(2).s.tim24]/(60*60), [out.e(1).s.light], '.', 'Markersize', 8);
%     xlabel('24 Hour');
%     ylim([-1, 6]);
% 
% linkaxes(xa, 'x'); xlim([0 24]); 
% 
%         subplot(5,1,1); 
%             plot([5 5], [0, max([out.e(1).s.sumfftAmp])], 'y', 'LineWidth', 4); 
%             plot([17 17], [0, max([out.e(1).s.sumfftAmp])], 'k', 'LineWidth', 4);
%         subplot(5,1,2); 
%             plot([5 5], [0, max([out.e(1).s.zAmp])], 'y', 'LineWidth', 4); 
%             plot([17 17], [0, max([out.e(1).s.zAmp])], 'k', 'LineWidth', 4);
%         subplot(5,1,3); 
%             plot([5 5], [0, max([out.e(1).s.obwAmp])], 'y', 'LineWidth', 4); 
%             plot([17 17], [0, max([out.e(1).s.obwAmp])], 'k', 'LineWidth', 4);
% 
%                     drawnow;

%% Light/Dark Plot 

%moved to k_lightdarkplotter

% if ~isempty(out.info)
% 
% figure(3); clf; title('Light to dark');hold on;
%     set(gcf, 'Position', [400 100 2*560 2*420]);
% figure(4); clf; title('Dark to light'); hold on;
%     set(gcf, 'Position', [500 100 2*560 2*420]);
% 
%     lighttimes = abs(out.info.luz);
% 
%      for j=1:length(lighttimes)-2
% 
%         if out.info.luz(j) > 0  % Light side
% 
%                 if ~isempty(find([out.e(1).s(tto{1}).timcont]/(60*60) > lighttimes(j) & [out.e(1).s(tto{1}).timcont]/(60*60) <= lighttimes(j+2), 1))            
%                     figure(3); 
%                     subplot(211); hold on; title('OBW');   % Light to dark plot  OBW     
%                     ott = find([out.e(1).s(tto{1}).timcont]/(60*60) > lighttimes(j) & [out.e(1).s(tto{1}).timcont]/(60*60) <= lighttimes(j+2));
%                     plot(([out.e(1).s(tto{1}(ott)).timcont]/(60*60)) - lighttimes(j), [out.e(1).s(tto{1}(ott)).obwAmp] - mean([out.e(1).s(tto{1}(ott)).obwAmp]), 'o', 'MarkerSize', 2);
%                     upperlim = max([out.e(1).s(tto{1}(ott)).obwAmp] - mean([out.e(1).s(tto{1}(ott)).obwAmp]));
%                     plot([[out.info.ld] [out.info.ld]], [-upperlim upperlim], 'k-', 'Linewidth', 2);  
%                     
%                     subplot(212); hold on; title('zAmp');     % Light to dark plot zAmp     
%                     ztt = find([out.e(1).s(ttz{1}).timcont]/(60*60) > lighttimes(j) & [out.e(1).s(ttz{1}).timcont]/(60*60) <= lighttimes(j+2));
%                     plot(([out.e(1).s(ttz{1}(ztt)).timcont]/(60*60)) - lighttimes(j), [out.e(1).s(ttz{1}(ztt)).zAmp] - mean([out.e(1).s(ttz{1}(ztt)).zAmp]), 'o', 'MarkerSize', 2); 
%                     upperlim = max([out.e(1).s(ttz{1}(ztt)).zAmp] - mean([out.e(1).s(ttz{1}(ztt)).zAmp]));
%                     plot([[out.info.ld] [out.info.ld]], [-upperlim upperlim], 'k-', 'Linewidth', 2); 
%                     drawnow;
%                 end
%         
%         else % Dark side
%             
%             if ~isempty(find([out.e(2).s(tto{2}).timcont]/(60*60) > lighttimes(j) & [out.e(2).s(tto{2}).timcont]/(60*60) <= lighttimes(j+2), 1))            
%                     figure(4); 
%                     subplot(211); hold on; title('OBW');     % Dark to light plot  OBW      
%                     ott = find([out.e(2).s(tto{2}).timcont]/(60*60) > lighttimes(j) & [out.e(2).s(tto{2}).timcont]/(60*60) <= lighttimes(j+2));
%                     plot(([out.e(2).s(tto{2}(ott)).timcont]/(60*60)) - lighttimes(j), [out.e(2).s(tto{2}(ott)).obwAmp] - mean([out.e(2).s(tto{2}(ott)).obwAmp]), 'o', 'MarkerSize', 2); 
%                     %line at hour
%                     upperlim = max([out.e(2).s(tto{2}(ott)).obwAmp] - mean([out.e(2).s(tto{2}(ott)).obwAmp]));
%                     plot([[out.info.ld] [out.info.ld]], [-upperlim upperlim], 'k-', 'Linewidth', 2);  
%                     
%                     
%                     subplot(212); hold on;  title('zAmp');     % Dark to light plot  zAmp      
%                     ztt = find([out.e(2).s(ttz{2}).timcont]/(60*60) > lighttimes(j) & [out.e(2).s(ttz{2}).timcont]/(60*60) <= lighttimes(j+2));
%                     plot(([out.e(2).s(ttz{2}(ztt)).timcont]/(60*60)) - lighttimes(j), [out.e(2).s(ttz{2}(ztt)).zAmp] - mean([out.e(2).s(ttz{2}(ztt)).zAmp]), 'o', 'MarkerSize', 2); 
%                    
%                     upperlim = max([out.e(2).s(ttz{2}(ztt)).zAmp] - mean([out.e(2).s(ttz{2}(ztt)).zAmp]));
%                     plot([[out.info.ld] [out.info.ld]], [-upperlim upperlim], 'k-', 'Linewidth', 2); 
%                     drawnow;
%             end
%             
%         end         
%          
%      end
%      
% end
%             
