function k_phaseplotter(out)
% plot the data for fun
% Usage: k_phaseplotter(kg(#));
close all;
%% Preparations

% All the data (set because we may want to plot before running KatieRemover and/or KatieLabeler)
    tto{1} = 1:length([out.e(1).s.timcont]); % tto is indices for obwAmp
    tto{2} = tto{1};

    ttz{1} = tto{1}; % ttz is indices for zAmp
    ttz{2} = tto{1};

    ttsf{1} = tto{1}; % ttsf is indices for sumfftAmp
    ttsf{2} = tto{1};
    
% If we have removed outliers via KatieRemover, get the indices...    
    if ~isempty(out.idx)
        tto{1} = out.idx(1).obwidx; tto{2} = out.idx(2).obwidx; % tto is indices for obwAmp
        ttz{1} = out.idx(1).zidx; ttz{2} = out.idx(2).zidx; % ttz is indices for zAmp
        ttsf{1} = out.idx(1).sumfftidx; ttsf{2} = out.idx(2).sumfftidx; % ttsf is indices for sumfftAmp
    end

% get variables to plot trigger frequency/tim
[timcont, lighttimes, halfday] = KatieTriggers(out); 

%get spline estimate
[xx, tnormsubobwyy, ~] =  k_obwsubspliner(out, 1, 10);

%% Continuous data plot

figure(11); clf; hold on; 
    set(gcf, 'Position', [200 100 2*560 2*420]);


ax(1) = subplot(411); hold on; title('raw obwAmp');
    %plot([out.e(2).s(tto{2}).timcont]/(60*60), [out.e(2).s(tto{2}).obwAmp], '.');
    plot([out.e(1).s(tto{1}).timcont]/(60*60), [out.e(1).s(tto{1}).obwAmp], '.');
   
ax(2) = subplot(412); hold on; title('spline obwAmp');
    plot(xx, tnormsubobwyy, 'LineWidth', 3);


ax(3) = subplot(413); hold on; title('triggers per lightchange');
    
    for k = 1:length(halfday)

         if mod(k,2) == 0
         histogram(halfday(k).entiretimcont, lighttimes, 'FaceColor', 'k'); 
            
         else
         histogram(halfday(k).entiretimcont, lighttimes, 'FaceColor', 'y'); 
           
         end
    end
    

ax(4) = subplot(414); hold on; title('total triggers');

     histogram(timcont, 1000); 
      for kk = 1:length(lighttimes)

            if mod(kk,2) == 1 %if kk is odd plot with a black line
            plot([lighttimes(kk), lighttimes(kk)], ylim, 'k-', 'LineWidth', 3);    
            else %if kk is even plot with a yellow line
            plot([lighttimes(kk), lighttimes(kk)], ylim, 'm-', 'LineWidth', 3);    
            end
            
      end





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
if isfield(out.info, 'luz')
    if  ~isempty(out.info.luz)
        
        %luz by transition type
            %separate by transition type
            lighton = out.info.luz(out.info.luz > 0);
            darkon = out.info.luz(out.info.luz < 0);
            
            %plot
            ax(1) = subplot(411); hold on;
            plot([lighton' lighton']', [0 max([out.e(1).s.obwAmp])], 'm-', 'LineWidth', 1.5, 'MarkerSize', 10);
            plot([abs(darkon)' abs(darkon)']', [0 max([out.e(1).s.obwAmp])], 'k-', 'LineWidth', 1.5, 'MarkerSize', 10);

                       
            ax(2) = subplot(412); hold on;
            plot([lighton' lighton']', ylim, 'm-', 'LineWidth', 1.5, 'MarkerSize', 10);
            plot([abs(darkon)' abs(darkon)']', ylim, 'k-', 'LineWidth', 1.5, 'MarkerSize', 10);

            
    end    
end
linkaxes(ax, 'x'); 


                    


