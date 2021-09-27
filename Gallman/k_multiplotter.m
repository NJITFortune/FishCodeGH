function k_multiplotter(out)
%% preparations
%indicies for fish/tube data







% All the data (set because we may want to plot before running KatieRemover and/or KatieLabeler)
    tto{1} = 1:length([out.e(2).s.timcont]); % tto is indices for obwAmp
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

figure(1); clf; 

    
    ax(1) = subplot(411); hold on; 
        yyaxis right; plot([out(], [out.intubeHi], '.');
        yyaxis left; plot([out.Lotimcont], [out.intubeLo], '.');

        legend('High frequency fish', 'Low frequency fish');
        
    ax(2) = subplot(412); hold on;
        yyaxis right; plot([out(Hisortidx).timcont], [out(Hisortidx).hifreq], '.'); 
        yyaxis left; plot([out(Losortidx).timcont], [out(Losortidx).lofreq], '.');
        
    
    ax(3) = subplot(413); hold on; 
            plot([out.timcont], [out.temp], '.');
    
    ax(4) = subplot(414); hold on;
        plot([out.timcont], [out.light]);
        ylim([-1, 6]);
        
linkaxes(ax, 'x');

