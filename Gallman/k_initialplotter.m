function k_initialplotter(out)
% plot the data for fun
% Usage: k_initialplotter(kg(#));
%% Plot the data for fun

% All the data
    tto{1} = 1:length([out.e(1).s.timcont]);
    tto{2} = tto{1};
    ttz{1} = tto{1};
    ttz{2} = tto{1};
    %ttpf{1} = tto{1};
    %ttpf{2} = tto{1};
    ttsf{1} = tto{1};
    ttsf{2} = tto{1};
    
% BUT.. if we have removed outliers, use these...    
    if isfield(out, 'idx')
        tto{1} = out.idx(1).obwidx; tto{2} = out.idx(2).obwidx;
        ttz{1} = out.idx(1).zidx; ttz{2} = out.idx(2).zidx;
        %ttpf{1} = out.idx(1).peakfftidx; ttpf{2} = out.idx(2).peakfftidx;
        ttsf{1} = out.idx(1).sumfftidx; ttsf{2} = out.idx(2).sumfftidx;
    end

% Continuous data plot
figure(1); clf; 
    set(gcf, 'Position', [200 100 2*560 2*420]);

ax(1) = subplot(511); hold on; title('sumfftAmp');
    yyaxis right; plot([out.e(2).s(ttsf{2}).timcont]/(60*60), [out.e(2).s(ttsf{2}).sumfftAmp], '.');
    yyaxis left; plot([out.e(1).s(ttsf{1}).timcont]/(60*60), [out.e(1).s(ttsf{1}).sumfftAmp], '.');
   % plot([out.timcont]/(60*60), [out.Ch3sumAmp], '.');

ax(2) = subplot(512); hold on; title('zAmp');
    yyaxis right; plot([out.e(2).s(ttz{2}).timcont]/(60*60), [out.e(2).s(ttz{2}).zAmp], '.');
    yyaxis left; plot([out.e(1).s(ttz{1}).timcont]/(60*60), [out.e(1).s(ttz{1}).zAmp], '.');
   % plot([out.info.feedingtimes' out.info.feedingtimes'], [0 max([out.e(1).s.sumfftAmp])], 'm-', 'LineWidth', 2, 'MarkerSize', 10);

ax(3) = subplot(513); hold on; title('obwAmp');
    yyaxis right; plot([out.e(2).s(tto{2}).timcont]/(60*60), [out.e(2).s(tto{2}).obwAmp], '.');
    yyaxis left; plot([out.e(1).s(tto{1}).timcont]/(60*60), [out.e(1).s(tto{1}).obwAmp], '.');
   % plot([out.info.feedingtimes' out.info.feedingtimes'], [0 max([out.e(1).s.sumfftAmp])], 'm-', 'LineWidth', 2, 'MarkerSize', 10);

ax(4) = subplot(514); hold on; title('frequency (black) and temperature (red)');   
        yyaxis right; plot([out.e(2).s.timcont]/(60*60), [out.e(2).s.fftFreq], '.k', 'Markersize', 8);
        yyaxis right; plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.fftFreq], '.k', 'Markersize', 8);
        yyaxis left; plot([out.e(2).s.timcont]/(60*60), [out.e(2).s.temp], '.r', 'Markersize', 8);
        yyaxis left; plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.temp], '.r', 'Markersize', 8);
    
ax(5) = subplot(515); hold on; title('light transitions');
    plot([out.e(2).s.timcont]/(60*60), [out.e(1).s.light], '.', 'Markersize', 8);
    ylim([-1, 6]);
    xlabel('Continuous');
    
    
     if isfield(out, 'info')
        subplot(511); plot([out.info.feedingtimes' out.info.feedingtimes'], [0 max([out.e(1).s.sumfftAmp])], 'm-', 'LineWidth', 2, 'MarkerSize', 10);
        subplot(512); plot([out.info.feedingtimes' out.info.feedingtimes'], [0 max([out.e(1).s.zAmp])], 'm-', 'LineWidth', 2, 'MarkerSize', 10);
        subplot(513); plot([out.info.feedingtimes' out.info.feedingtimes'], [0 max([out.e(1).s.obwAmp])], 'm-', 'LineWidth', 2, 'MarkerSize', 10);
     end
     
%         darkidx = find(out.info.luz < 0); lightidx = find(out.info.luz > 0);
%         for j=1:length(darkidx); plot([abs(out.info.luz(darkidx(j))) abs(out.info.luz(darkidx(j)))], [0 5], 'k-'); end
%         for j=1:length(lightidx); plot([abs(out.info.luz(lightidx(j))) abs(out.info.luz(lightidx(j)))], [0 5], 'c-'); end
%         
        
linkaxes(ax, 'x');

%% 24 hour plot 
% tim24 based off of computer midnight

figure(2); clf; 
    set(gcf, 'Position', [300 100 2*560 2*420]);

xa(1) = subplot(511); hold on; title('sumfftAmp');
    plot([out.e(2).s(ttsf{2}).tim24]/(60*60), [out.e(2).s(ttsf{2}).sumfftAmp], '.');
    plot([out.e(1).s(ttsf{1}).tim24]/(60*60), [out.e(1).s(ttsf{1}).sumfftAmp], '.');

xa(2) = subplot(512); hold on; title('zAmp');
    plot([out.e(2).s(ttz{2}).tim24]/(60*60), [out.e(2).s(ttz{2}).zAmp], '.');
    plot([out.e(1).s(ttz{1}).tim24]/(60*60), [out.e(1).s(ttz{1}).zAmp], '.');
   
xa(3) = subplot(513); hold on; title('obwAmp');
    plot([out.e(2).s(tto{2}).tim24]/(60*60), [out.e(2).s(tto{2}).obwAmp], '.');
    plot([out.e(1).s(tto{1}).tim24]/(60*60), [out.e(1).s(tto{1}).obwAmp], '.');
    
xa(4) = subplot(514); hold on; title('frequency (black) and temperature (red)'); 
    yyaxis right; plot([out.e(2).s.tim24]/(60*60), -[out.e(2).s.temp], '.');
    yyaxis left; ylim([200 800]);
        plot([out.e(2).s.tim24]/(60*60), [out.e(2).s.fftFreq], '.', 'Markersize', 8);      
    
xa(5) = subplot(515); hold on; title('light transitions');
    plot([out.e(2).s.tim24]/(60*60), [out.e(1).s.light], '.', 'Markersize', 8);
    xlabel('24 Hour');
    ylim([-1, 6]);

linkaxes(xa, 'x'); xlim([0 24]); 

        subplot(5,1,1); 
            plot([5 5], [0, max([out.e(1).s.sumfftAmp])], 'y', 'LineWidth', 4); 
            plot([17 17], [0, max([out.e(1).s.sumfftAmp])], 'k', 'LineWidth', 4);
        subplot(5,1,2); 
            plot([5 5], [0, max([out.e(1).s.zAmp])], 'y', 'LineWidth', 4); 
            plot([17 17], [0, max([out.e(1).s.zAmp])], 'k', 'LineWidth', 4);
        subplot(5,1,3); 
            plot([5 5], [0, max([out.e(1).s.obwAmp])], 'y', 'LineWidth', 4); 
            plot([17 17], [0, max([out.e(1).s.obwAmp])], 'k', 'LineWidth', 4);


%% Light/Dark Plot 

figure(3); clf; 
    set(gcf, 'Position', [400 100 2*560 2*420]);
figure(4); clf; 
    set(gcf, 'Position', [500 100 2*560 2*420]);

    lighttimes = abs(out.info.luz);

     for j=1:length(lighttimes)-2

        if out.info.luz(j) > 0  % Light side

                if ~isempty(find([out.e(2).s(tto{2}).timcont]/(60*60) > lighttimes(j) & [out.e(2).s(tto{2}).timcont]/(60*60) <= lighttimes(j+2), 1))            
                    figure(3); subplot(211);     % Light to dark plot  OBW     
                    ott = find([out.e(2).s(tto{2}).timcont]/(60*60) > lighttimes(j) & [out.e(2).s(tto{2}).timcont]/(60*60) <= lighttimes(j+2));
                    plot(([out.e(2).s(tto{2}(ott)).timcont]/(60*60)) - lighttimes(j), [out.e(2).s(tto{2}(ott)).obwAmp], 5, 'o-', 'MarkerSize', 2); 
                end
        
        else % Dark side
            
            if ~isempty(find([out.e(2).s(tto{2}).timcont] > lighttimes(j) & [out.e(2).s(tto{2}).timcont] <= lighttimes(j+2), 1))            
                    figure(4); subplot(211);      % Dark to light plot  OBW      
                    ott = find([out.e(2).s(tto{2}).timcont]/(60*60) > lighttimes(j) & [out.e(2).s(tto{2}).timcont]/(60*60) <= lighttimes(j+2));
                    plot(([out.e(2).s(tto{2}(ott)).timcont]/(60*60)) - lighttimes(j), [out.e(2).s(tto{2}(ott)).obwAmp], 5, 'o-', 'MarkerSize', 2); 
            end
            
        end         
         
     end
            
