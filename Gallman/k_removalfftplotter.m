function k_removalfftplotter(out)
% plot the data for fun
% Usage: k_initialplotter(kg(#));
close all;
%% Preparations

% Get the indices
  ttsf{1} = out.idx(1).sumfftidx; ttsf{2} = out.idx(2).sumfftidx; % ttsf is indices for sumfftAmp


%% Continuous data plot

figure(1); clf; 
    set(gcf, 'Position', [200 100 2*560 2*420]);

ax(1) = subplot(511); hold on; title('channel 1 fftAmp');
    plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.sumfftAmp], 'k.');
    plot([out.e(1).s(ttsf{1}).timcont]/(60*60), [out.e(1).s(ttsf{1}).sumfftAmp], 'r.');

ax(2) = subplot(512); hold on; title('channel 2 fftAmp');
     plot([out.e(2).s.timcont]/(60*60), [out.e(2).s.sumfftAmp], 'k.');
     plot([out.e(2).s(ttsf{2}).timcont]/(60*60), [out.e(2).s(ttsf{2}).sumfftAmp], 'b.');


ax(3) = subplot(513); hold on; title('frequency - ch1');   
   
    plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.fftFreq], '.k', 'Markersize', 8);
    plot([out.e(1).s(ttsf{1}).timcont]/(60*60), [out.e(1).s(ttsf{1}).fftFreq], '.m', 'Markersize', 8);
    
ax(4) = subplot(514); hold on; title('temperature');
   
    plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.temp], '-r', 'Markersize', 8);
    plot([out.e(1).s(ttsf{1}).timcont]/(60*60), [out.e(1).s(ttsf{1}).temp], '-r', 'Markersize', 8);

ax(5) = subplot(515); hold on; title('light transitions');  
    plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.light], '.', 'Markersize', 8);
    ylim([-1, 6]);
    xlabel('Continuous');
        
% Add feedingtimes, if we have them... 
   if isfield(out.info, 'feedingtimes')
    if ~isempty([out.info.feedingtimes])
       ax(1) = subplot(511); plot([out.info.feedingtimes' out.info.feedingtimes']', ylim, 'm-', 'LineWidth', 2, 'MarkerSize', 10);                
    end
   end  


% Add temptimes, if we have them... 
   if isfield(out.info, 'temptims')
    if ~isempty([out.info.temptims])
       ax(4) = subplot(514); 
       for j = 1:length([out.info.temptims])
            plot([out.info.temptims(j), out.info.temptims(j)], ylim, 'b-');
       end         
    end
   end  

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
            ax(5) = subplot(515); hold on;
            plot([lighton' lighton']', [0 6], 'y-', 'LineWidth', 2, 'MarkerSize', 10);
            plot([abs(darkon)' abs(darkon)']', [0 6], 'k-', 'LineWidth', 2, 'MarkerSize', 10);
    end    
end
linkaxes(ax, 'x'); 


                    


