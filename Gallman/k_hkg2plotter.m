function k_hkg2plotter(out)
% plot the data for fun
% Usage: k_initialplotter(kg(#));
%close all;


%remove outlier indices       
tto = out.idx.obwidx; % tto is indices for obwAmp

  
 
%% Continuous data plot

figure(4); clf; hold on;
    %set(gcf, 'Position', [200 100 2*560 2*420]);

totplot = 5;
plotorder = 1;
colnum = 1;


ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('obwAmp'); %ylim([0,5]);

       plot([out.s(tto).timcont]/(60*60), [out.s(tto).obwAmp], '.', 'Color', [0.3010 0.7450 0.9330], 'MarkerSize', 5);

            % Add feedingtimes, if we have them... 
               if isfield(out.info, 'feedingtimes')
                if ~isempty([out.info.feedingtimes])
                   ax(plotorder) = subplot(totplot, colnum, plotorder); plot([out.info.feedingtimes' out.info.feedingtimes']', ylim, 'm-', 'LineWidth', 2, 'MarkerSize', 10);                
                end
               end  

       plotorder = plotorder + 1;


ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('frequency');   
    
     
        plot([out.s(tto).timcont]/(60*60), [out.s(tto).freq], '.k', 'Markersize', 8);

        plotorder = plotorder + 1;

ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('temp');
    
    plot([out.s(tto).timcont]/(60*60), [out.s(tto).temp], '-r', 'Markersize', 8);

        % Add temptimes, if we have them... 
           if isfield(out.info, 'temptims')
            if ~isempty([out.info.temptims])
               ax(plotorder) = subplot(totplot, colnum, plotorder);
               for j = 1:length([out.info.temptims])
                    plot([out.info.temptims(j), out.info.temptims(j)], ylim, 'b-');
               end         
            end
           end  


    plotorder = plotorder + 1;

ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('light');  
    plot([out.s.timcont]/(60*60), [out.s.light], '.', 'Markersize', 8);
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


    



                    


