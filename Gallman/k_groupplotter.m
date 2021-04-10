function k_groupplotter(out)
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
    
%% Linear Regression
x = [out.e(1).s(ttsf{1}).temp];
y = [out.e(1).s(ttsf{1}).sumfftAmp];
X = [ones(length(x),1) x];
b = X\y;
yCalc2 = X*b;
b1 = x/y;
yCalc1 = b1*x;
scatter(x,y)
hold on

plot(x,yCalc2,'--')
plot(x,yCalc1)


%% amplitude vs temperature

% figure(1); clf; 
%     set(gcf, 'Position', [200 100 2*560 2*420]);
% 
% ax(1) = subplot(511); hold on; title('sumfftAmp');
%     yyaxis right; plot([out.e(2).s(ttsf{2}).temp], [out.e(2).s(ttsf{2}).sumfftAmp], '.');
%     yyaxis left; plot([out.e(1).s(ttsf{1}).temp], [out.e(1).s(ttsf{1}).sumfftAmp], '.');
% 
% ax(2) = subplot(512); hold on; title('zAmp');
%     yyaxis right; plot([out.e(2).s(ttz{2}).temp], [out.e(2).s(ttz{2}).zAmp], '.');
%     yyaxis left; plot([out.e(1).s(ttz{1}).temp], [out.e(1).s(ttz{1}).zAmp], '.');
% 
% ax(3) = subplot(513); hold on; title('obwAmp');
%     yyaxis right; plot([out.e(2).s(tto{2}).temp], [out.e(2).s(tto{2}).obwAmp], '.');
%     yyaxis left; plot([out.e(1).s(tto{1}).temp], [out.e(1).s(tto{1}).obwAmp], '.');
% 
% ax(4) = subplot(514); hold on; title('frequency (black) and temperature (red)');   
%         yyaxis right; plot([out.e(2).s.temp], [out.e(2).s.fftFreq], '.k', 'Markersize', 8);
%         yyaxis left; plot([out.e(1).s.temp], [out.e(1).s.fftFreq], '.k', 'Markersize', 8);
%        
%     
% linkaxes(ax, 'x'); 


%% Continuous data plot

% figure(1); clf; 
%     set(gcf, 'Position', [200 100 2*560 2*420]);
% 
% ax(1) = subplot(511); hold on; title('sumfftAmp');
%     yyaxis right; plot([out.e(2).s(ttsf{2}).timcont]/(60*60), [out.e(2).s(ttsf{2}).sumfftAmp], '.');
%     yyaxis left; plot([out.e(1).s(ttsf{1}).timcont]/(60*60), [out.e(1).s(ttsf{1}).sumfftAmp], '.');
% 
% ax(2) = subplot(512); hold on; title('zAmp');
%     yyaxis right; plot([out.e(2).s(ttz{2}).timcont]/(60*60), [out.e(2).s(ttz{2}).zAmp], '.');
%     yyaxis left; plot([out.e(1).s(ttz{1}).timcont]/(60*60), [out.e(1).s(ttz{1}).zAmp], '.');
% 
% ax(1) = subplot(513); hold on; title('obwAmp');
%     yyaxis right; plot([out.e(2).s(tto{2}).timcont]/(60*60*24), [out.e(2).s(tto{2}).obwAmp], '.');
%     yyaxis left; plot([out.e(1).s(tto{1}).timcont]/(60*60*24), [out.e(1).s(tto{1}).obwAmp], '.');
% 
% ax(3) = subplot(514); hold on; title('frequency (black) and temperature (red)');   
%         yyaxis right; plot([out.e(2).s.timcont]/(60*60), [out.e(2).s.fftFreq], '.k', 'Markersize', 8);
%         yyaxis right; plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.fftFreq], '.k', 'Markersize', 8);
%         yyaxis left; plot([out.e(2).s.timcont]/(60*60), [out.e(2).s.temp], '.r', 'Markersize', 8);
%         yyaxis left; plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.temp], '.r', 'Markersize', 8);
%     
% ax(4) = subplot(515); hold on; title('light transitions');
%     plot([out.e(2).s.timcont]/(60*60), [out.e(1).s.light], '.', 'Markersize', 8);
%     ylim([-1, 6]);
%     xlabel('Continuous');
        
% Add feedingtimes, if we have them...    
%      if ~isempty(out.info)
%         subplot(511); plot([out.info.feedingtimes' out.info.feedingtimes']', [0 max([out.e(1).s.sumfftAmp])], 'm-', 'LineWidth', 2, 'MarkerSize', 10);
%         subplot(512); plot([out.info.feedingtimes' out.info.feedingtimes']', [0 max([out.e(1).s.zAmp])], 'm-', 'LineWidth', 2, 'MarkerSize', 10);
%         % subplot(515); plot([abs(out.info.luz)' abs(out.info.luz)'], [0 6], 'm-', 'LineWidth', 2, 'MarkerSize', 10);
%                     drawnow;
%         
%      end
%      
% linkaxes(ax, 'x'); 