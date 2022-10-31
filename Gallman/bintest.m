clearvars -except xxkg
out = xxkg(24);

luz = [out.info.luz];
binwidth = 1;

       
%        figure(2); clf; hold on;
%             for k = 2:length(luz)
%             
%                 if luz(k-1) < 0
%                   
%                   d = histogram([out.e(1).s.timcont]/(60*60), 'BinWidth', binwidth,'BinLimits',[abs(luz(k-1)),abs(luz(k))]);
%                   for j = abs(luz(k-1)):binwidth:abs(luz(k))-1
%                   [N(j,:), edges(j,:)] = histcounts([out.e(1).s.timcont]/(60*60), 'BinWidth', binwidth,'BinLimits',[abs(luz(k-1)),abs(luz(k))]);
%                   end
%                   d.Normalization = 'countdensity';
%                   d.FaceColor = [0.9 0.9 0.9];
%                 else
%                     
%                    l = histogram([out.e(1).s.timcont]/(60*60),'BinWidth', binwidth, 'BinLimits',[abs(luz(k-1)),abs(luz(k))]);
%                   for j = abs(luz(k-1)):binwidth:abs(luz(k))
%                   [N(j,:), edges(j,:)] = histcounts([out.e(1).s.timcont]/(60*60), 'BinWidth', binwidth,'BinLimits',[abs(luz(k-1)),abs(luz(k))]);
%                   end
%                    l.Normalization = 'countdensity';
%                    l.FaceColor = 'y';
%                 end
%             end

      figure(3);clf;hold on;

    [N, edges] = histcounts([out.e(1).s.timcont]/(60*60), 'BinWidth', binwidth);
        edges = edges(2:end) - (edges(2)-edges(1))/2;

        plot(edges, N);


        highWn = 0.005/(binwidth/2); % Original but perhaps too strong for 4 and 5 hour days
         [bb,aa] = butter(5, highWn, 'high');

        lowWn = 0.1/(binwidth/2);
        [dd,cc] = butter(5, lowWn, 'low');
        filtN = filtfilt(dd,cc, double(N));
        filtN = filtfilt(bb,aa, filtN); %high pass
      
        plot(edges, filtN)  
        findpeaks(filtN, edges);