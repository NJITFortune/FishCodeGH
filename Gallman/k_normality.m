function k_normality(out)
% plot the data for fun
% Usage: k_initialplotter(kg(#));
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
    



%% amplitude vs temperature

figure(1); clf; title('qqplot of amplitude measurements');
    set(gcf, 'Position', [200 100 2*560 2*420]);
    

ax(1) = subplot(511); hold on; title('sumfftAmp');
    
    qqplot([out.e(1).s(ttsf{1}).sumfftAmp])
    

ax(2) = subplot(512); hold on; title('zAmp');


    qqplot([out.e(1).s(ttz{1}).zAmp])
    

ax(3) = subplot(513); hold on; title('obwAmp');

    qqplot([out.e(1).s(tto{1}).obwAmp])

   
ax(4) = subplot(514); hold on; title('frequency');  

    qqplot([out.e(1).s.fftFreq]);

    
linkaxes(ax, 'x'); 
