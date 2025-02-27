function k_unseparationplotchecker(out)

%% preparations
%indicies for fish/tube data
 
    hitube{1} = find([out.e1hiamp] ./ [out.e2hiamp] > 2.5);
    hitube{2} = find([out.e2hiamp] ./ [out.e1hiamp] > 2.5);
    
    lotube{1} = find([out.e1loamp] ./ [out.e2loamp] > 2.5);
    lotube{2} = find([out.e2loamp] ./ [out.e1loamp] > 2.5);
    
%colors
teal = [0.2 0.8 0.8];
blue = [0 0.4470 0.7410];

orange = [0.8500 0.3250 0.0980];
yellow = [0.9290 0.6940 0.1250];

% %outlier removal indicies
% 
% % All the data (set because we may want to plot before running KatieRemover and/or KatieLabeler)
%     tto{1} = 1:length([out.e(2).s.timcont]); % tto is indices for obwAmp
%     tto{2} = tto{1};
% 
%     ttz{1} = tto{1}; % ttz is indices for zAmp
%     ttz{2} = tto{1};
% 
%     ttsf{1} = tto{1}; % ttsf is indices for sumfftAmp
%     ttsf{2} = tto{1};
%     
% % If we have removed outliers via KatieRemover, get the indices...    
%     if ~isempty(out.idx)
%         tto{1} = out.idx(1).obwidx; tto{2} = out.idx(2).obwidx; % tto is indices for obwAmp
%         ttz{1} = out.idx(1).zidx; ttz{2} = out.idx(2).zidx; % ttz is indices for zAmp
%         ttsf{1} = out.idx(1).sumfftidx; ttsf{2} = out.idx(2).sumfftidx; % ttsf is indices for sumfftAmp
%     end
            
%% plots

figure(5); clf; title('Can we put both tubes together?')

    
    ax(1) = subplot(511); hold on; title('High frequency fish');
        plot([out(hitube{1}).timcont]/3600, [out(hitube{1}).e1hiamp], '.', 'Color', teal);
        plot([out(hitube{2}).timcont]/3600, [out(hitube{2}).e2hiamp], '.', 'Color', blue);
        
    
    ax(2) = subplot(512); hold on; title('Low frequency fish');
        plot([out(lotube{1}).timcont]/3600, [out(lotube{1}).e1loamp], '.','Color', orange);
        plot([out(lotube{2}).timcont]/3600, [out(lotube{2}).e2loamp], '.', 'Color', yellow);
    
        
    ax(3) = subplot(513); hold on; title('Frequency');
        plot([out.HiTim], [out.HIfreq], '.','Color', teal); 
        plot([out.LoTim], [out.LOfreq], '.','Color', orange); 
        
    
    ax(4) = subplot(514); hold on; title('Temperature');
            plot([out.timcont]/3600, [out.temp], 'r.');
    
    ax(5) = subplot(515); hold on;
        plot([out.timcont]/3600, [out.light]);
        ylim([-1, 6]);
        
linkaxes(ax, 'x');

figure(6); clf; title('By fish')

        axs(1) = subplot(511); hold on; title('High frequency fish');
            plot([out.HiTim], [out.HiAmp], '.', 'Color', teal);
            


        axs(2) = subplot(512); hold on; title('Low frequency fish');
            plot([out.LoTim], [out.LoAmp], '.','Color', orange);
       

        axs(3) = subplot(513); hold on; title('Frequency');
            plot([out.HiTim], [out.HIfreq], '.','Color', teal); 
            plot([out.LoTim], [out.LOfreq], '.','Color', orange); 


        axs(4) = subplot(514); hold on; title('Temperature');
                plot([out.timcont]/3600, [out.temp], 'r.');

        axs(5) = subplot(515); hold on;
            plot([out.timcont]/3600, [out.light]);
            ylim([-1, 6]);

linkaxes(axs, 'x');


