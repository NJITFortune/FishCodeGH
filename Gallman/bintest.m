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

      figure(3);

    [N, edges] = histcounts([out.e(1).s.timcont]/(60*60), 'BinWidth', binwidth);
        edges = edges(2:end) - (edges(2)-edges(1))/2;

        plot(edges, N);

        %findpeaks(N, edges);
