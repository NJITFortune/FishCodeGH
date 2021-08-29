function k_initialplotter(out)
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

%% Continuous data plot

figure(1); clf; 
    set(gcf, 'Position', [200 100 2*560 2*420]);

ax(1) = subplot(511); hold on; title('sumfftAmp - magenta = added worms to tank');
    yyaxis right; plot([out.e(2).s(ttsf{2}).timcont]/(60*60), [out.e(2).s(ttsf{2}).sumfftAmp], '.');
    yyaxis left; plot([out.e(1).s(ttsf{1}).timcont]/(60*60), [out.e(1).s(ttsf{1}).sumfftAmp], '.');

ax(2) = subplot(512); hold on; title('zAmp - green = social');
    yyaxis right; plot([out.e(2).s(ttz{2}).timcont]/(60*60), [out.e(2).s(ttz{2}).zAmp], '.');
    yyaxis left; plot([out.e(1).s(ttz{1}).timcont]/(60*60), [out.e(1).s(ttz{1}).zAmp], '.');

xa(1) = subplot(513); hold on; title('obwAmp');
    yyaxis right; plot([out.e(2).s(tto{2}).timcont]/(60*60*24), [out.e(2).s(tto{2}).obwAmp], '.');
    yyaxis left; plot([out.e(1).s(tto{1}).timcont]/(60*60*24), [out.e(1).s(tto{1}).obwAmp], '.');

ax(3) = subplot(514); hold on; title('frequency (black) and temperature (red)');   
        yyaxis right; plot([out.e(2).s.timcont]/(60*60), [out.e(2).s.fftFreq], '.k', 'Markersize', 8);
        yyaxis right; plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.fftFreq], '.k', 'Markersize', 8);
        yyaxis left; plot([out.e(2).s.timcont]/(60*60), [out.e(2).s.temp], '-r', 'Markersize', 8);
        yyaxis left; plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.temp], '-r', 'Markersize', 8);
    
ax(4) = subplot(515); hold on; title('light transitions');
    plot([out.e(2).s.timcont]/(60*60), [out.e(1).s.light], '.', 'Markersize', 8);
    ylim([-1, 6]);
    xlabel('Continuous');
        
% Add feedingtimes, if we have them... 

     if ~isempty(out.info.feedingtimes)
        subplot(511); plot([out.info.feedingtimes' out.info.feedingtimes']', [0 max([out.e(1).s.sumfftAmp])], 'm-', 'LineWidth', 2, 'MarkerSize', 10);
        % subplot(515); plot([abs(out.info.luz)' abs(out.info.luz)'], [0 6], 'm-', 'LineWidth', 2, 'MarkerSize', 10);
                    drawnow;
     end
     
% Add social times, if we have them...    
    if ~isempty(out.info.socialtimes)   
    subplot(512); plot([abs(out.info.socialtimes)' abs(out.info.socialtimes)']', [0 max([out.e(1).s.zAmp])], 'g-', 'LineWidth', 2, 'MarkerSize', 10);
    end  
        
    
% Add light transitions times to check luz
    if  ~isempty(out.info.luz)
        out.info.luz
        %just luz
            %subplot(515); plot([abs(out.info.luz)' abs(out.info.luz)']', [0 6], 'g-', 'LineWidth', 2, 'MarkerSize', 10);
        %luz by transition type
            %separate by transition type
            lighton = out.info.luz(out.info.luz > 0);
            darkon = out.info.luz(out.info.luz < 0);
            
            %plot
            subplot(515); hold on;
            plot([lighton' lighton']', [0 6], 'y-', 'LineWidth', 2, 'MarkerSize', 10);
            plot([abs(darkon)' abs(darkon)']', [0 6], 'k-', 'LineWidth', 2, 'MarkerSize', 10);
           
    end    

linkaxes(ax, 'x'); 
xa.XLim = ax(1).XLim/24;

                    drawnow;


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

                    drawnow;

%% Light/Dark Plot 

if ~isempty(out.info)

figure(3); clf; title('Light to dark');hold on;
    set(gcf, 'Position', [400 100 2*560 2*420]);
figure(4); clf; title('Dark to light'); hold on;
    set(gcf, 'Position', [500 100 2*560 2*420]);

    lighttimes = abs(out.info.luz);

     for j=1:length(lighttimes)-2

        if out.info.luz(j) > 0  % Light side

                if ~isempty(find([out.e(1).s(tto{1}).timcont]/(60*60) > lighttimes(j) & [out.e(1).s(tto{1}).timcont]/(60*60) <= lighttimes(j+2), 1))            
                    figure(3); 
                    subplot(211); hold on; title('OBW');   % Light to dark plot  OBW     
                    ott = find([out.e(1).s(tto{1}).timcont]/(60*60) > lighttimes(j) & [out.e(1).s(tto{1}).timcont]/(60*60) <= lighttimes(j+2));
                    plot(([out.e(1).s(tto{1}(ott)).timcont]/(60*60)) - lighttimes(j), [out.e(1).s(tto{1}(ott)).obwAmp] - mean([out.e(1).s(tto{1}(ott)).obwAmp]), 'o', 'MarkerSize', 2);
                    upperlim = max([out.e(1).s(tto{1}(ott)).obwAmp] - mean([out.e(1).s(tto{1}(ott)).obwAmp]));
                    plot([[out.info.ld] [out.info.ld]], [-upperlim upperlim], 'k-', 'Linewidth', 2);  
                    
                    subplot(212); hold on; title('zAmp');     % Light to dark plot zAmp     
                    ztt = find([out.e(1).s(ttz{1}).timcont]/(60*60) > lighttimes(j) & [out.e(1).s(ttz{1}).timcont]/(60*60) <= lighttimes(j+2));
                    plot(([out.e(1).s(ttz{1}(ztt)).timcont]/(60*60)) - lighttimes(j), [out.e(1).s(ttz{1}(ztt)).zAmp] - mean([out.e(1).s(ttz{1}(ztt)).zAmp]), 'o', 'MarkerSize', 2); 
                    upperlim = max([out.e(1).s(ttz{1}(ztt)).zAmp] - mean([out.e(1).s(ttz{1}(ztt)).zAmp]));
                    plot([[out.info.ld] [out.info.ld]], [-upperlim upperlim], 'k-', 'Linewidth', 2); 
                    drawnow;
                end
        
        else % Dark side
            
            if ~isempty(find([out.e(2).s(tto{2}).timcont]/(60*60) > lighttimes(j) & [out.e(2).s(tto{2}).timcont]/(60*60) <= lighttimes(j+2), 1))            
                    figure(4); 
                    subplot(211); hold on; title('OBW');     % Dark to light plot  OBW      
                    ott = find([out.e(2).s(tto{2}).timcont]/(60*60) > lighttimes(j) & [out.e(2).s(tto{2}).timcont]/(60*60) <= lighttimes(j+2));
                    plot(([out.e(2).s(tto{2}(ott)).timcont]/(60*60)) - lighttimes(j), [out.e(2).s(tto{2}(ott)).obwAmp] - mean([out.e(2).s(tto{2}(ott)).obwAmp]), 'o', 'MarkerSize', 2); 
                    %line at hour
                    upperlim = max([out.e(2).s(tto{2}(ott)).obwAmp] - mean([out.e(2).s(tto{2}(ott)).obwAmp]));
                    plot([[out.info.ld] [out.info.ld]], [-upperlim upperlim], 'k-', 'Linewidth', 2);  
                    
                    
                    subplot(212); hold on;  title('zAmp');     % Dark to light plot  zAmp      
                    ztt = find([out.e(2).s(ttz{2}).timcont]/(60*60) > lighttimes(j) & [out.e(2).s(ttz{2}).timcont]/(60*60) <= lighttimes(j+2));
                    plot(([out.e(2).s(ttz{2}(ztt)).timcont]/(60*60)) - lighttimes(j), [out.e(2).s(ttz{2}(ztt)).zAmp] - mean([out.e(2).s(ttz{2}(ztt)).zAmp]), 'o', 'MarkerSize', 2); 
                   
                    upperlim = max([out.e(2).s(ttz{2}(ztt)).zAmp] - mean([out.e(2).s(ttz{2}(ztt)).zAmp]));
                    plot([[out.info.ld] [out.info.ld]], [-upperlim upperlim], 'k-', 'Linewidth', 2); 
                    drawnow;
            end
            
        end         
         
     end
     
end
            
