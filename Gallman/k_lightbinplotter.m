function k_lightbinplotter(out)
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

totplot = 2;
plotorder = 1;
colnum = 1;
binwidth = 1;

ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('ch1 obwAmp'); %ylim([0,5]);

       plot([out.e(1).s(tto{1}).timcont]/(60*60), [out.e(1).s(tto{1}).obwAmp], '.', 'Color', [0.3010 0.7450 0.9330], 'MarkerSize', 5);

        %luz by transition type
                        %separate by transition type
                        lighton = out.info.luz(out.info.luz > 0);
                        darkon = out.info.luz(out.info.luz < 0);
                        
                        %plot
                        if ~isempty(lighton)
                        plot([lighton' lighton']', ylim, 'y-', 'LineWidth', 2);
                        end
                        if ~isempty(darkon)
                        plot([abs(darkon)' abs(darkon)']', ylim, 'k-', 'LineWidth', 2);
                        end
            % Add feedingtimes, if we have them... 
               if isfield(out.info, 'feedingtimes')
                if ~isempty([out.info.feedingtimes])
                   ax(plotorder) = subplot(totplot, colnum, plotorder); plot([out.info.feedingtimes' out.info.feedingtimes']', ylim, 'm-', 'LineWidth', 2, 'MarkerSize', 10);                
                end
               end  

       plotorder = plotorder + 1;
 
luz = [out.info.luz];
if length(luz) > 1
ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('tube triggers'); %ylim([0,5]);
       % plot([out.e(2).s(tto{2}).timcont]/(60*60), [out.e(2).s(tto{2}).obwAmp], '.', 'Color', [0.4660 0.6740 0.1880], 'MarkerSize', 5);

        %luz = floor([out.info.luz]);
        luz = [out.info.luz];
            for k = 2:length(luz)
            
                if luz(k-1) < 0
                  
                  d = histogram([out.e(1).s(tto{1}).timcont]/(60*60), 'BinWidth', binwidth,'BinLimits',[abs(luz(k-1)),abs(luz(k))]);
                  d.Normalization = 'countdensity';
                  d.FaceColor = [0.9 0.9 0.9];
                else
                    
                   l = histogram([out.e(1).s(tto{1}).timcont]/(60*60),'BinWidth', binwidth, 'BinLimits',[abs(luz(k-1)),abs(luz(k))]);
                   l.Normalization = 'countdensity';
                   l.FaceColor = 'y';
                end
            end

        plotorder = plotorder + 1;
end
% ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('frequency');   
%     
%         plot([out.e(2).s(tto{2}).timcont]/(60*60), [out.e(2).s(tto{2}).fftFreq], '.k', 'Markersize', 8);
%         plot([out.e(1).s(tto{1}).timcont]/(60*60), [out.e(1).s(tto{1}).fftFreq], '.k', 'Markersize', 8);
% 
%         plotorder = plotorder + 1;
% 
% ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('temp');
%     
%     plot([out.e(2).s(tto{2}).timcont]/(60*60), [out.e(2).s(tto{2}).temp], '-r', 'Markersize', 8);
%     plot([out.e(1).s(tto{1}).timcont]/(60*60), [out.e(1).s(tto{1}).temp], '-r', 'Markersize', 8);
% 
%         % Add temptimes, if we have them... 
%            if isfield(out.info, 'temptims')
%             if ~isempty([out.info.temptims])
%                ax(plotorder) = subplot(totplot, colnum, plotorder);
%                for j = 1:length([out.info.temptims])
%                     plot([out.info.temptims(j), out.info.temptims(j)], ylim, 'b-');
%                end         
%             end
%            end  
% 
% %     ch2tempC = real(k_voltstodegC(out, 2));
% %     ch1tempC = real(k_voltstodegC(out, 1));
% %     
% %     plot([out.e(2).s.timcont]/(60*60), ch2tempC, '-r', 'Markersize', 8);
% %     plot([out.e(1).s.timcont]/(60*60), ch1tempC, '-r', 'Markersize', 8);
% 
%     plotorder = plotorder + 1;
% 
% ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('light');  
%     plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.light], '.', 'Markersize', 8);
%     ylim([-1, 6]);
%     xlabel('Continuous');
% 
%         % Add light transitions times to check luz if we have programmed it
%             if isfield(out.info, 'luz')
%                 if  ~isempty(out.info.luz)
%                     
%                     %luz by transition type
%                         %separate by transition type
%                         lighton = out.info.luz(out.info.luz > 0);
%                         darkon = out.info.luz(out.info.luz < 0);
%                         
%                         %plot
%                         plot([lighton' lighton']', [0 6], 'y-', 'LineWidth', 2);
%                         plot([abs(darkon)' abs(darkon)']', [0 6], 'k-', 'LineWidth', 2);
%                 end    
%             end
% 

linkaxes(ax, 'x'); 
  
