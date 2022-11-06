function k_initialplotter(out)
% plot the data for fun
% Usage: k_initialplotter(kg(#));
%close all;
%% Preparations

% All the data (set because we may want to plot before running KatieRemover and/or KatieLabeler)
    tto{1} = 1:length([out.e(1).s.timcont]); % tto is indices for obwAmp
    tto{2} = tto{1};
% 
%     ttz{1} = tto{1}; % ttz is indices for zAmp
%     ttz{2} = tto{1};
% 
%     ttsf{1} = 1:length([out.e(1).s.timcont]); % ttsf is indices for sumfftAmp
%     ttsf{2} = 1:length([out.e(2).s.timcont]);
%     
% If we have removed outliers via KatieRemover, get the indices...  
 if isfield(out, 'idx')
    if ~isempty(out.idx)
         tto{1} = out.idx(1).obwidx; tto{2} = out.idx(2).obwidx; % tto is indices for obwAmp
%         ttz{1} = out.idx(1).zidx; ttz{2} = out.idx(2).zidx; % ttz is indices for zAmp
   %     ttsf{1} = out.idx(1).sumfftidx; ttsf{2} = out.idx(2).sumfftidx; % ttsf is indices for sumfftAmp
    end
 end
%% Continuous data plot

figure(4); clf; hold on;
    %set(gcf, 'Position', [200 100 2*560 2*420]);

totplot = 5;
plotorder = 1;
colnum = 1;


ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('ch1 obwAmp'); %ylim([0,5]);

       plot([out.e(1).s(tto{1}).timcont]/(60*60), [out.e(1).s(tto{1}).obwAmp], '.', 'Color', [0.3010 0.7450 0.9330], 'MarkerSize', 5);

            % Add feedingtimes, if we have them... 
               if isfield(out.info, 'feedingtimes')
                if ~isempty([out.info.feedingtimes])
                   ax(plotorder) = subplot(totplot, colnum, plotorder); plot([out.info.feedingtimes' out.info.feedingtimes']', ylim, 'm-', 'LineWidth', 2, 'MarkerSize', 10);                
                end
               end  

       plotorder = plotorder + 1;

ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('ch2 obwAmp'); %ylim([0,5]);
        plot([out.e(2).s(tto{2}).timcont]/(60*60), [out.e(2).s(tto{2}).obwAmp], '.', 'Color', [0.4660 0.6740 0.1880], 'MarkerSize', 5);

            % Add feedingtimes, if we have them... 
               if isfield(out.info, 'feedingtimes')
                if ~isempty([out.info.feedingtimes])
                   ax(plotorder) = subplot(totplot, colnum, plotorder); plot([out.info.feedingtimes' out.info.feedingtimes']', ylim, 'm-', 'LineWidth', 2, 'MarkerSize', 10);                
                end
               end 

        plotorder = plotorder + 1;

ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('frequency');   
    
        plot([out.e(2).s(tto{2}).timcont]/(60*60), [out.e(2).s(tto{2}).fftFreq], '.k', 'Markersize', 8);
        plot([out.e(1).s(tto{1}).timcont]/(60*60), [out.e(1).s(tto{1}).fftFreq], '.k', 'Markersize', 8);

        plotorder = plotorder + 1;

ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('temp');

%  binwidth = .5;
%  timcont = [out.e(1).s(tto{1}).timcont]/(60*60);
%         luz = [out.info.luz];
%             for k = 2:length(luz)
%             
%                 if luz(k-1) < 0
%                   
%                   d = histogram(timcont, 'BinWidth', binwidth,'BinLimits',[abs(luz(k-1))-timcont(1),abs(luz(k))-timcont(1)]);
%                   d.Normalization = 'countdensity';
%                   d.FaceColor = [0.9 0.9 0.9];
%                 else
%                     
%                    l = histogram(timcont,'BinWidth', binwidth, 'BinLimits',[abs(luz(k-1))-timcont(1),abs(luz(k))-timcont(1)]);
%                    l.Normalization = 'countdensity';
%                    l.FaceColor = 'y';
%                 end
%             end
    
    plot([out.e(2).s(tto{2}).timcont]/(60*60), [out.e(2).s(tto{2}).temp], '-r', 'Markersize', 8);
    plot([out.e(1).s(tto{1}).timcont]/(60*60), [out.e(1).s(tto{1}).temp], '-r', 'Markersize', 8);

        % Add temptimes, if we have them... 
           if isfield(out.info, 'temptims')
            if ~isempty([out.info.temptims])
               ax(plotorder) = subplot(totplot, colnum, plotorder);
               for j = 1:length([out.info.temptims])
                    plot([out.info.temptims(j), out.info.temptims(j)], ylim, 'b-');
               end         
            end
           end  

%     ch2tempC = real(k_voltstodegC(out, 2));
%     ch1tempC = real(k_voltstodegC(out, 1));
%     
%     plot([out.e(2).s.timcont]/(60*60), ch2tempC, '-r', 'Markersize', 8);
%     plot([out.e(1).s.timcont]/(60*60), ch1tempC, '-r', 'Markersize', 8);

    plotorder = plotorder + 1;

ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('light');  
    plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.light], '.', 'Markersize', 8);
    ylim([-1, 6]);
    xlabel('Continuous');

        % Add light transitions times to check luz if we have programmed it
            if isfield(out.info, 'luz')
                if  ~isempty(out.info.luz)
                    
                    %luz by transition type
                        %separate by transition type
                        lighton = out.info.luz(out.info.luz > 0);
                        darkon = out.info.luz(out.info.luz < 0);
                        
                        %plot
                        ax(plotorder) = subplot(totplot, colnum, plotorder); hold on;
                        plot([lighton' lighton']', [0 6], 'y-', 'LineWidth', 2);
                        plot([abs(darkon)' abs(darkon)']', [0 6], 'k-', 'LineWidth', 2);
                end    
            end


linkaxes(ax, 'x'); 
  

% % Add input signal times, if we have them...
%     if isfield(out.e(2).s, 'inputsig')
%         if ~isempty([out.e(2).s.inputsig])
% 
%             %signal off vs on
%             threshold = 2;
%             onidx = find([out.e(2).s.inputsig] > threshold);
%             onsig = (ones(1, length(onidx)))*4;
%           %  offidx = find([out.e(2).s.inputsig] < threshold);
%            % offsig = (ones(1, length(offidx)));
%             
%             ax(4) = subplot(414); 
%             plot([out.e(2).s.timcont]/3600, [out.e(2).s.inputsig], 'r.', 'Markersize', 8);
%             %plot([out.e(2).s(onidx).timcont]/3600, onsig, 'r.', 'Markersize', 8);
%            % plot([out.e(2).s(offidx).timcont]/3600, offsig, 'r.', 'Markersize', 8);
%         end
%     end


    



                    


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
