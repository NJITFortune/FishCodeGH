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


%figure
figure(31); clf; hold on;
    set(gcf, 'renderer', 'painters');
    
     ax(1) = subplot(311); hold on;   xlim([0, timcont(end)-timcont(1)]);
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
        ylabel('Mean square amplitude');
        xlabel('Time (hours)');

    ax(2) = subplot(312); hold on; xlim([0, timcont(end)-timcont(1)]); ylim([400 600]);
              plot(timcont-timcont(1), freq, 'k.');
    
    ax(3) = subplot(313); hold on; xlim([0, timcont(end)-timcont(1)]);
        binwidth = 0.5;
        %ylim([0 100]);
        ylabel('Tube triggers per half hour');
        xlabel('Time (hours)')
    
                for j = 2:length(lighttimes)
                
                    if mod(j,2) == 0 %if j is odd
                      
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


    linkaxes(ax, 'x');
            
    
    
    
        