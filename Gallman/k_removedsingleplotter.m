function k_removedsingleplotter(out)
% plot the data for fun
% Usage: k_initialplotter(kg(#));
%close all;
%% Preparations

         tto{1} = out.idx(1).obwidx; tto{2} = out.idx(2).obwidx; % tto is indices for obwAmp
%         ttz{1} = out.idx(1).zidx; ttz{2} = out.idx(2).zidx; % ttz is indices for zAmp
       % ttsf{1} = out.idx(1).sumfftidx; ttsf{2} = out.idx(2).sumfftidx; % ttsf is indices for sumfftAmp
 
%% Continuous data plot

figure(3); clf; hold on;
    %set(gcf, 'Position', [200 100 2*560 2*420]);



ax(1) = subplot(411); hold on; title('ch1 obwAmp'); %ylim([0,5]);
   plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.obwAmp], 'k.');
   plot([out.e(1).s(tto{1}).timcont]/(60*60), [out.e(1).s(tto{1}).obwAmp],'.', 'Color', [0.3010 0.7450 0.9330]);

ax(2) = subplot(412); hold on; title('ch2 obwAmp'); %ylim([0,5]);
   plot([out.e(2).s.timcont]/(60*60), [out.e(2).s.obwAmp], 'k.');
   plot([out.e(2).s(tto{2}).timcont]/(60*60), [out.e(2).s(tto{2}).obwAmp],'.');


ax(3) = subplot(413); hold on; title('fish frequency');   
    plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.fftFreq], '.k', 'Markersize', 8);
    plot([out.e(1).s(tto{1}).timcont]/(60*60), [out.e(1).s(tto{1}).fftFreq], '.', 'Markersize', 8);

    plot([out.e(2).s.timcont]/(60*60), [out.e(2).s.fftFreq], '.k', 'Markersize', 8);
    plot([out.e(2).s(tto{2}).timcont]/(60*60), [out.e(2).s(tto{2}).fftFreq], '.', 'Markersize', 8);

ax(4) = subplot(414); hold on; title('light transitions');  
    plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.light], '.', 'Markersize', 8);
    ylim([-1, 6]);
    xlabel('Continuous');
        
linkaxes(ax, 'x');