clearvars -except xxkg
out = xxkg(24);

luz = [out.info.luz];
binwidth = 1;

       
       figure(2); clf; hold on;
            for k = 2:length(luz)
            
                if luz(k-1) < 0
                  
                  d = histogram([out.e(1).s.timcont]/(60*60), 'BinWidth', binwidth,'BinLimits',[abs(luz(k-1)),abs(luz(k))]);
                  [N(k-1,:), edges(k-1,:), bin(k-1,:)] = histcounts([out.e(1).s.timcont]/(60*60), 'BinWidth', binwidth,'BinLimits',[abs(luz(k-1)),abs(luz(k))]);
                  d.Normalization = 'countdensity';
                  d.FaceColor = [0.9 0.9 0.9];
                else
                    
                   l = histogram([out.e(1).s.timcont]/(60*60),'BinWidth', binwidth, 'BinLimits',[abs(luz(k-1)),abs(luz(k))]);
                  [N(k-1,:), edges(k-1,:), bin(k-1,:)] = histcounts([out.e(1).s.timcont]/(60*60), 'BinWidth', binwidth,'BinLimits',[abs(luz(k-1)),abs(luz(k))]);
                   l.Normalization = 'countdensity';
                   l.FaceColor = 'y';
                end
            end

      figure(3);

        plot(edges, N);