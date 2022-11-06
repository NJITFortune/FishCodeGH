function k_prettyampmultihkg2plotter(in)

% %not functioning
% clearvars -except hkg k xxkg hkg2 xxkg2 dark dark multi
% k = 48; %gold!
% in = hkg2(k);
% channel = 1;


%data
    %outlier removal
     tto = [in.idx.obwidx]; 
          
    %raw data
        timcont = [in.s(tto).timcont]/3600; %time in hours
        obw = [in.s(tto).obwAmp]/max([in.s(tto).obwAmp]); %divide by max to normalize
%         freq = [in.s(tto).freq];
%         temp = [in.s(tto).temp];

        %lighttimes = k_lighttimes(in, 3);
       % lighttimes = lighttimes/3600; %hours

       lighttimes = abs([in.info.luz]);

%         lidx = find(timcont >= lighttimes(1) & timcont <= lighttimes(end));
%         timcont = timcont(lidx);
%         obw = obw(lidx);
%         freq = freq(lidx);
%         temp = temp(lidx);



figure(31); clf; hold on;
    set(gcf, 'renderer', 'painters');
    
     ax(1) = subplot(211); hold on;   %xlim([0, 70]);
        %get y axis bounds for boxes
        plot(timcont-timcont(1), obw, '.');
        a = ylim;

        %plot boxes
    
%         for j = 2:length(lighttimes)
%             if mod(j-1,2) == 1 %if j is odd
%             fill([lighttimes(j-1)-timcont(1) lighttimes(j-1)-timcont(1) lighttimes(j)-timcont(1) lighttimes(j)-timcont(1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
%             end
%         end
    
        plot(timcont-timcont(1), obw, '.','Color', [0.3010 0.7450 0.9330], 'MarkerSize', 8);

        ylabel('Mean square amplitude');
       % xlabel('Time (hours)')


     xlim([0 timcont(end)]);
    ax(2) = subplot(212); hold on; %xlim([0, 70]);
        binwidth = 0.5;
        %ylim([0 100]);
        ylabel('Tube triggers per half hour');
        xlabel('Time (hours)')
    


    
                for j = 2:length(lighttimes)
                
                    if mod(j,2) == 0 %if j is odd
                    %if mod(j,2) == 1 %if j is even
                      
                      d = histogram(timcont-timcont(1), 'BinWidth', binwidth,'BinLimits',[lighttimes(j-1)-timcont(1),lighttimes(j)-timcont(1)]);
                      d.Normalization = 'countdensity';
                      d.FaceColor = [0.9 0.9 0.9];
                      d.EdgeColor = [0.9 0.9 0.9];
                    else
                        
                       l = histogram(timcont-timcont(1),'BinWidth', binwidth, 'BinLimits',[lighttimes(j-1)-timcont(1),lighttimes(j)-timcont(1)]);
                       l.Normalization = 'countdensity';
                         l.FaceColor = [255/255 239/255 0/255];
                         l.EdgeColor = [255/255 239/255 0/255];
                    end
                end

          xlim([0 timcont(end)]);
    linkaxes(ax, 'x');
            
    
    
    
        