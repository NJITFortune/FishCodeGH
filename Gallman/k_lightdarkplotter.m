function k_lightdarkplotter(out)
% plot the data for fun
% Usage: k_lightdarkplotter(kg(#));
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
   
%% plot
    

figure(3); clf; title('Light to dark'); hold on;
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
            
