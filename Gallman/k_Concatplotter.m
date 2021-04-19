function k_Concatplotter(out)
% plot the data for fun
% Usage: k_initialplotter(kg(#));
close all;
%% Preparations

threshy = 1; % number of days to shorten gap

%oulier removal
% All the data (set because we may want to plot before running KatieRemover and/or KatieLabeler)
    tto{1} = 1:length([out.e(1).s.timcont]); % tto is indices for obwAmp
    tto{2} = tto{1};

    ttz{1} = tto{1}; % ttz is indices for zAmp
    ttz{2} = tto{1};

    ttsf{1} = tto{1}; % ttsf is indices for sumfftAmp
    ttsf{2} = tto{1};
    
% If we have removed outliers via KatieRemover, get the indices...    
    if ~isempty(out.idx)
        tto{1} = out.idx(1).obwidx; 
        tto{2} = out.idx(2).obwidx; % tto is indices for obwAmp
        
        ttz{1} = out.idx(1).zidx; 
        ttz{2} = out.idx(2).zidx; % ttz is indices for zAmp
        
        ttsf{1} = out.idx(1).sumfftidx; 
        ttsf{2} = out.idx(2).sumfftidx; % ttsf is indices for sumfftAmp
    end

%% Omit gaps of a certain length 

    sf1timcont = gapinator([out.e(1).s.timcont], ttsf{1}, threshy);
    sf2timcont = gapinator([out.e(2).s.timcont], ttsf{2}, threshy);
    
    z1timcont = gapinator([out.e(1).s.timcont], ttz{1}, threshy);
    z2timcont = gapinator([out.e(2).s.timcont], ttz{2}, threshy);

    o1timcont = gapinator([out.e(1).s.timcont], tto{1}, threshy);
    o2timcont = gapinator([out.e(2).s.timcont], tto{2}, threshy);
    
    timcont1 = gapinatornoidx([out.e(1).s.timcont], threshy);
    timcont2 = gapinatornoidx([out.e(2).s.timcont], threshy);

%% Continuous data plot

figure(1); clf; 
    set(gcf, 'Position', [200 100 2*560 2*420]);

ax(1) = subplot(511); hold on; title('sumfftAmp');
    yyaxis right; plot(sf1timcont, [out.e(2).s(ttsf{2}).sumfftAmp], '.');
    yyaxis left; plot(sf2timcont, [out.e(1).s(ttsf{1}).sumfftAmp], '.');
    datetick('x', 'dd');

ax(2) = subplot(512); hold on; title('zAmp');
    yyaxis right; plot(z1timcont, [out.e(2).s(ttz{2}).zAmp], '.');
    yyaxis left; plot(z2timcont, [out.e(1).s(ttz{1}).zAmp], '.');
    datetick('x', 'HH');

ax(3) = subplot(513); hold on; title('obwAmp');
    yyaxis right; plot(o2timcont(tto{2}), [out.e(2).s(tto{2}).obwAmp], '.');
    yyaxis left; plot(o1timcont(tto{1}), [out.e(1).s(tto{1}).obwAmp], '.');
    datetick('x', 'HH:MM');

ax(4) = subplot(514); hold on; title('frequency (black) and temperature (red)');   
        yyaxis right; plot(timcont2, [out.e(2).s.fftFreq], '.k', 'Markersize', 8);
        yyaxis right; plot(timcont1, [out.e(1).s.fftFreq], '.k', 'Markersize', 8);
        yyaxis left; plot(timcont2, [out.e(2).s.temp], '.r', 'Markersize', 8);
        yyaxis left; plot(timcont1, [out.e(1).s.temp], '.r', 'Markersize', 8);
        %datetick('x', 'HH');
    
ax(5) = subplot(515); hold on; title('light transitions');
    plot(timcont1, [out.e(1).s.light], '.', 'Markersize', 8);
    ylim([-1, 6]);
    xlabel('Continuous');
    %datetick('x', 'HH');
        
% Add feedingtimes, if we have them...    
     if ~isempty(out.info)
        subplot(511); plot([out.info.feedingtimes' out.info.feedingtimes']', [0 max([out.e(1).s.sumfftAmp])], 'm-', 'LineWidth', 2, 'MarkerSize', 10);
        subplot(512); plot([out.info.feedingtimes' out.info.feedingtimes']', [0 max([out.e(1).s.zAmp])], 'm-', 'LineWidth', 2, 'MarkerSize', 10);
        % subplot(515); plot([abs(out.info.luz)' abs(out.info.luz)'], [0 6], 'm-', 'LineWidth', 2, 'MarkerSize', 10);
                    drawnow;
        
     end
     
%         darkidx = find(out.info.luz < 0); lightidx = find(out.info.luz > 0);
%         for j=1:length(darkidx); plot([abs(out.info.luz(darkidx(j))) abs(out.info.luz(darkidx(j)))], [0 5], 'k-'); end
%         for j=1:length(lightidx); plot([abs(out.info.luz(lightidx(j))) abs(out.info.luz(lightidx(j)))], [0 5], 'c-'); end
%         
        
linkaxes(ax, 'x'); 


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

% %% Light/Dark Plot 
% 
% if ~isempty(out.info)
% 
% figure(3); clf; title('Light to dark');hold on;
%     set(gcf, 'Position', [400 100 2*560 2*420]);
% figure(4); clf; title('Dark to light'); hold on;
%     set(gcf, 'Position', [500 100 2*560 2*420]);
% 
%     lighttimes = abs(out.info.luz);
% 
%      for j=1:length(lighttimes)-2
% 
%         if out.info.luz(j) > 0  % Light side
% 
%                 if ~isempty(find([out.e(1).s(tto{1}).timcont]/(60*60) > lighttimes(j) & [out.e(1).s(tto{1}).timcont]/(60*60) <= lighttimes(j+2), 1))            
%                     figure(3); 
%                     subplot(211); hold on; title('OBW');   % Light to dark plot  OBW     
%                     ott = find([out.e(1).s(tto{1}).timcont]/(60*60) > lighttimes(j) & [out.e(1).s(tto{1}).timcont]/(60*60) <= lighttimes(j+2));
%                     plot(([out.e(1).s(tto{1}(ott)).timcont]/(60*60)) - lighttimes(j), [out.e(1).s(tto{1}(ott)).obwAmp] - mean([out.e(1).s(tto{1}(ott)).obwAmp]), 'o', 'MarkerSize', 2);
%                     upperlim = max([out.e(1).s(tto{1}(ott)).obwAmp] - mean([out.e(1).s(tto{1}(ott)).obwAmp]));
%                     plot([[out.info.ld] [out.info.ld]], [-upperlim upperlim], 'k-', 'Linewidth', 2);  
%                     subplot(212); hold on; title('zAmp');     % Light to dark plot zAmp     
%                     ztt = find([out.e(1).s(ttz{1}).timcont]/(60*60) > lighttimes(j) & [out.e(1).s(ttz{1}).timcont]/(60*60) <= lighttimes(j+2));
%                     plot(([out.e(1).s(ttz{1}(ztt)).timcont]/(60*60)) - lighttimes(j), [out.e(1).s(ttz{1}(ztt)).zAmp] - mean([out.e(1).s(ttz{1}(ztt)).zAmp]), 'o', 'MarkerSize', 2); 
%                     upperlim = max([out.e(1).s(ttz{1}(ztt)).zAmp] - mean([out.e(1).s(ttz{1}(ztt)).zAmp]));
%                     plot([[out.info.ld] [out.info.ld]], [-upperlim upperlim], 'k-', 'Linewidth', 2); 
%                     drawnow;
%                 end
%         
%         else % Dark side
%             
%             if ~isempty(find([out.e(2).s(tto{2}).timcont]/(60*60) > lighttimes(j) & [out.e(2).s(tto{2}).timcont]/(60*60) <= lighttimes(j+2), 1))            
%                     figure(4); 
%                     subplot(211); hold on; title('OBW');     % Dark to light plot  OBW      
%                     ott = find([out.e(2).s(tto{2}).timcont]/(60*60) > lighttimes(j) & [out.e(2).s(tto{2}).timcont]/(60*60) <= lighttimes(j+2));
%                     plot(([out.e(2).s(tto{2}(ott)).timcont]/(60*60)) - lighttimes(j), [out.e(2).s(tto{2}(ott)).obwAmp] - mean([out.e(2).s(tto{2}(ott)).obwAmp]), 'o', 'MarkerSize', 2); 
%                     upperlim = max([out.e(2).s(tto{2}(ott)).obwAmp] - mean([out.e(2).s(tto{2}(ott)).obwAmp]));
%                     plot([[out.info.ld] [out.info.ld]], [-upperlim upperlim], 'k-', 'Linewidth', 2);  
%                     subplot(212); hold on;  title('zAmp');     % Dark to light plot  zAmp      
%                     ztt = find([out.e(2).s(ttz{2}).timcont]/(60*60) > lighttimes(j) & [out.e(2).s(ttz{2}).timcont]/(60*60) <= lighttimes(j+2));
%                     plot(([out.e(2).s(ttz{2}(ztt)).timcont]/(60*60)) - lighttimes(j), [out.e(2).s(ttz{2}(ztt)).zAmp] - mean([out.e(2).s(ttz{2}(ztt)).zAmp]), 'o', 'MarkerSize', 2); 
%                     upperlim = max([out.e(2).s(ttz{2}(ztt)).zAmp] - mean([out.e(2).s(ttz{2}(ztt)).zAmp]));
%                     plot([[out.info.ld] [out.info.ld]], [-upperlim upperlim], 'k-', 'Linewidth', 2); 
%                     drawnow;
%             end
%             
%         end         
%          
%      end
% end
%      
%% Embedded function for removing time gaps of longer than threshy days (usually 1 day)
    function newtims = gapinator(originaltims, idx, threshy)
        
    newtims = originaltims;
    gapolas = caldays(caldiff(originaltims(idx), 'days'));
    largegapIDX = find(gapolas > threshy);

        for jjj = 1:length(largegapIDX) % for each long gap
            for kkk = largegapIDX(jjj)+1:length(idx)
                tmp = newtims(idx(kkk)) - caldays(gapolas(largegapIDX(jjj)));
                newtims(idx(kkk)) = tmp(1);
            end
        end
    
    end

    function newtimsnoidx = gapinatornoidx(originaltims, threshy)
        
    newtimsnoidx = originaltims;
    gapolas = caldays(caldiff(originaltims, 'days'));
    largegapIDX = find(gapolas > threshy);

        for jjj = 1:length(largegapIDX) % for each long gap
            for kkk = largegapIDX(jjj)+1:length(originaltims)
                tmp = newtimsnoidx((kkk)) - caldays(gapolas(largegapIDX(jjj)));
                newtimsnoidx((kkk)) = tmp(1);
            end
        end
    
    end

end
            
