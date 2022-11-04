clearvars -except xxkg k hkg
out = xxkg(k);
channel = 1;

luz = [out.info.luz];
binwidth = 1;

       
       figure(2); clf; hold on; %title('band pass filter');
        %xlim([13 116]);
       % ylim([0 60]);
        xlabel('Hours');
        ylabel('Triggers per hour');

%             for k = 2:length(luz)
%             
%                 if luz(k-1) < 0
%                   
%                   d = histogram([out.e(1).s.timcont]/(60*60), 'BinWidth', binwidth,'BinLimits',[abs(luz(k-1)),abs(luz(k))]);
%                  
%                   d.Normalization = 'countdensity';
%                   d.FaceColor = [0.9 0.9 0.9];
%                 else
%                     
%                    l = histogram([out.e(1).s.timcont]/(60*60),'BinWidth', binwidth, 'BinLimits',[abs(luz(k-1)),abs(luz(k))]);
%                   
%                    l.Normalization = 'countdensity';
%                    l.FaceColor = [255/255 232/255 124/255];
%                     l.FaceColor = [0.9290 0.6940 0.1250];
%                   l.FaceColor = 'y';
%                 end
%             end

     % figure(3);clf;hold on;

    [N, edges] = histcounts([out.e(channel).s.timcont]/(60*60), 'BinWidth', binwidth);
        edges = edges(2:end) - (edges(2)-edges(1))/2;

       % plot(edges, N,'k-', 'LineWidth',2);
% 
% 
%         highWn = 0.005/(binwidth/2); % Original but perhaps too strong for 4 and 5 hour days
%          [bb,aa] = butter(5, highWn, 'high');
% 
        lowWn = 0.075/(binwidth/2);
        [dd,cc] = butter(5, lowWn, 'low');
        filtN = filtfilt(dd,cc, double(N));
    %     filtN = filtfilt(bb,aa, filtN); %high pass
%       
  %      plot(edges, filtN-mean(filtN), 'LineWidth',2)  
         [peaks, locs] = findpeaks(filtN, edges); %xlim([13 116]); ylim([0 60]);
    
    
%findpeaks(filtN, edges);


 %raw data 
  tto{channel} = out.idx(channel).obwidx; 
                timcont = [out.e(channel).s(tto{channel}).timcont]; %time in seconds
                obw =  [out.e(channel).s(tto{channel}).obwAmp]; %divide by max to normalize
                oldfreq = [out.e(channel).s(tto{channel}).fftFreq];
                oldtemp = [out.e(channel).s(tto{channel}).temp];
            
             %trimmed mean
             window = 5;
              fcn = @(x) trimmean(x,33);
              obwtrim = matlab.tall.movingWindow(fcn, window, obw');
              freqtrim = matlab.tall.movingWindow(fcn, window, oldfreq');
              temptrim = matlab.tall.movingWindow(fcn, window, oldtemp');

        lighttimes = k_lighttimes(out, 3);
            %Regularize
                %regularize data to ReFs interval
                [regtim, ~, ~, regobwpeaks] = k_regularmetamucil(timcont, obwtrim', timcont, obw, freqtrim', temptrim', 20, lighttimes);

        lowWn = 0.025/(20/2);
                [dd,cc] = butter(5, lowWn, 'low');
                regobwpeaks= filtfilt(dd,cc, double(regobwpeaks));
            %  regobwpeaks = filtfilt(bb,aa, regobwpeaks); %high pass
        
  ax(1) = subplot(211); hold on; 
              plot(timcont/3600, obw, '.', 'Color', [0.3010 0.7450 0.9330], 'MarkerSize', 8);
           %   plot(regtim/3600, regobwpeaks, 'k-', 'LineWidth',2);
        
        newtim = regtim/3600;
        
        [~, newtimidx, ~] = intersect(newtim,locs);
        
        
        
           %   plot(newtim(newtimidx), regobwpeaks(newtimidx), '.', 'MarkerSize', 20);

  ax(2) = subplot(212);  hold on;
            xlabel('Hours');
        ylabel('Triggers per hour');

            for j = 2:length(luz)
            
                if luz(j-1) < 0
                  
                  d = histogram([out.e(channel).s.timcont]/(60*60), 'BinWidth', binwidth,'BinLimits',[abs(luz(j-1)),abs(luz(j))]);
                 
                  d.Normalization = 'countdensity';
                  d.FaceColor = [0.9 0.9 0.9];
                  d.EdgeColor = [0.9 0.9 0.9];
               
                else
                    
                   l = histogram([out.e(channel).s.timcont]/(60*60),'BinWidth', binwidth, 'BinLimits',[abs(luz(j-1)),abs(luz(j))]);
                  
                   l.Normalization = 'countdensity';
                   l.FaceColor = [255/255 239/255 0/255];
                   l.EdgeColor = [255/255 239/255 0/255];
                  %  l.FaceColor = [0.9290 0.6940 0.1250];
                  %l.FaceColor = 'y';
                end
            end

         %   plot(locs, peaks,'r.', 'MarkerSize', 20)

linkaxes(ax, 'x');