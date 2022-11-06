function k_prettyampplotter(in, channel)

% %not functioning
% clearvars -except hkg k
% k = 12; %gold!
% in = hkg(k);
% channel = 1;


%data
    %outlier removal
     tto = [in.idx(channel).obwidx]; 
          
    %raw data
        timcont = [in.e(channel).s(tto).timcont]/3600; %time in hours
        obw = [in.e(channel).s(tto).obwAmp]/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
        freq = [in.e(channel).s(tto).fftFreq];
        temp = [in.e(channel).s(tto).temp];

        lighttimes = k_lighttimes(in, 3);
        lighttimes = lighttimes/3600; %hours

        lidx = find(timcont >= lighttimes(1) & timcont <= lighttimes(end));
        timcont = timcont(lidx);
        obw = obw(lidx);
        freq = freq(lidx);
        temp = temp(lidx);


             %trimmed mean
             window = 5;
              fcn = @(x) trimmean(x,33);
              obwtrim = matlab.tall.movingWindow(fcn, window, obw');
              freqtrim = matlab.tall.movingWindow(fcn, window, freq');
              temptrim = matlab.tall.movingWindow(fcn, window, temp');
        %Regularize
                %regularize data to ReFs interval
                [regtim, regfreq, ~, regobwpeaks] = k_regularmetamucil(timcont *3600, obwtrim', timcont, obw, freqtrim', temptrim', 20, lighttimes*3600);

        lowWn = 0.025/(20/2);
                [dd,cc] = butter(5, lowWn, 'low');
                regobwpeaks= filtfilt(dd,cc, double(regobwpeaks));

% 
% binwidth = 0.5;
% 
%  [N, edges] = histcounts(timcont, 'BinWidth', binwidth);
%         edges = edges(2:end) - (edges(2)-edges(1))/2;
% 
%         lowWn = 0.075/(binwidth/2);
%         [dd,cc] = butter(5, lowWn, 'low');
%         filtN = filtfilt(dd,cc, double(N));
%  
%          [peaks, locs] = findpeaks(filtN, edges); %xlim([13 116]); ylim([0 60]);
%figure
figure(31); clf; hold on;
    set(gcf, 'renderer', 'painters');
    
     ax(1) = subplot(211); hold on;   xlim([0, timcont(end)-timcont(1)]);
        %get y axis bounds for boxes
        plot(timcont-timcont(1), obw, '.');
        a = ylim;

        %plot boxes
    
        for j = 1:length(lighttimes)-1
            if mod(j,2) == 1 %if j is odd
            fill([lighttimes(j)-timcont(1) lighttimes(j)-timcont(1) lighttimes(j+1)-timcont(1) lighttimes(j+1)-timcont(1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
            end
        end
    
        plot(timcont-timcont(1), obw, '.','Color', [0.3010 0.7450 0.9330], 'MarkerSize', 8);
        plot(regtim/3600 - timcont(1), regobwpeaks, 'k-', 'LineWidth', 2);
        ylabel('Mean square amplitude');
       % xlabel('Time (hours)');

       %newtim = regtim/3600;
%        [~, newtimidx, ~] = intersect(newtim,locs);
        
        
        
            % plot(newtim(newtimidx)-timcont(1), regobwpeaks(newtimidx), 'r.', 'MarkerSize', 20);

%     ax(2) = subplot(312); hold on; xlim([0, timcont(end)-timcont(1)]); ylim([400 600]);
%              % plot(timcont-timcont(1), freq, '.', 'Color', [252/255, 108/255, 133/255]);
%                plot(regtim/3600 - timcont(1), regfreq, 'LineWidth', 2, 'Color', [252/255, 108/255, 133/255]);
%               ylabel('Frequency (Hz)');
    
    ax(2) = subplot(212); hold on; xlim([0, timcont(end)-timcont(1)]);


        
        darkdy = gradient(regobwpeaks)./gradient(regtim);
%         a = ylim;
%         plot(regtim/3600 - timcont(1), darkdy,'k-', 'LineWidth', 2)
%          for j = 1:length(lighttimes)-1
%             if mod(j,2) == 1 %if j is odd
%             fill([lighttimes(j)-timcont(1) lighttimes(j)-timcont(1) lighttimes(j+1)-timcont(1) lighttimes(j+1)-timcont(1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
%             end
%         end
         plot(regtim/3600 - timcont(1), darkdy,'k-', 'LineWidth', 2)

%         binwidth = 0.5;
%         %ylim([0 100]);
%         ylabel('Tube triggers per half hour');
%         xlabel('Time (hours)')
%     
% 
% %         [N, edges] = histcounts(timcont, 'BinWidth', binwidth);
% %         edges = edges(2:end) - (edges(2)-edges(1))/2;
% % 
% %         lowWn = 0.075/(binwidth/2);
% %         [dd,cc] = butter(5, lowWn, 'low');
% %         filtN = filtfilt(dd,cc, double(N));
% %  
% %          [peaks, locs] = findpeaks(filtN, edges); %xlim([13 116]); ylim([0 60]);
%     
%                 for j = 2:length(lighttimes)
%                 
%                     if mod(j,2) == 0 %if j is odd
%                       
%                       d = histogram(timcont-timcont(1), 'BinWidth', binwidth,'BinLimits',[lighttimes(j-1)-timcont(1),lighttimes(j)-timcont(1)]);
%                       d.Normalization = 'countdensity';
%                       d.FaceColor = [0.9 0.9 0.9];
%                       d.EdgeColor = [0.9 0.9 0.9];
%                     else
%                         
%                        l = histogram(timcont-timcont(1),'BinWidth', binwidth, 'BinLimits',[lighttimes(j-1)-timcont(1),lighttimes(j)-timcont(1)]);
%                        l.Normalization = 'countdensity';
%                          l.FaceColor = [255/255 239/255 0/255];
%                          l.EdgeColor = [255/255 239/255 0/255];
%                     end
%                 end
% 
%              % plot(edges-timcont(1), N,'k-', 'LineWidth',2);
    linkaxes(ax, 'x');
            
    
    
    
        