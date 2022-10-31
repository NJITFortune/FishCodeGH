clearvars -except xxkg
out = xxkg(45);

luz = [out.info.luz];
binwidth = 1;

       
       figure(2); clf; hold on; title('band pass filter');
        xlim([13 152]);
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
%                     l.FaceColor = [0.9290 0.6940 0.1250];
%                 %   l.FaceColor = 'y';
%                 end
%             end

     % figure(3);clf;hold on;

    [N, edges] = histcounts([out.e(1).s.timcont]/(60*60), 'BinWidth', binwidth);
        edges = edges(2:end) - (edges(2)-edges(1))/2;

        plot(edges, N,'k-', 'LineWidth',2);


        highWn = 0.005/(binwidth/2); % Original but perhaps too strong for 4 and 5 hour days
         [bb,aa] = butter(5, highWn, 'high');

        lowWn = 0.05/(binwidth/2);
        [dd,cc] = butter(5, lowWn, 'low');
        filtN = filtfilt(dd,cc, double(N));
        filtN = filtfilt(bb,aa, filtN); %high pass
      
        plot(edges, filtN, 'LineWidth',2)  
%         findpeaks(filtN, edges);