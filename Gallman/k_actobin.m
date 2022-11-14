%function k_actobin(in, channel)

%not functioning
clearvars -except l24kg k hkg

in = l24kg(k);
channel = 1;

lighttimes = k_lighttimes(in, 3);
lighttimes = lighttimes/3600;

timcont = [in.e(channel).s.timcont]/3600;
luz = [in.info.luz];
%obw = [in.e(channel).s.obw];

plotlengthHOURS = 4; %hours
howmanyplots = floor((timcont(end) - lighttimes(1))/4);
binwidth = 0.5;

    for j = 1:howmanyplots
    
              %resampled data  
    %         % Get the index of the start time of the day
                ddayidx = find(timcont >= lighttimes(1) + (j-1) * plotlengthHOURS & timcont < lighttimes(1) + j* plotlengthHOURS); % k-1 so that we start at zero
               
              %  if timcont(ddayidx)-timcont(ddayidx(1)) >= 4 %important so that we know when to stop

                    act(j).timcont = timcont(ddayidx)-timcont(ddayidx(1));
                    %act(j).obw = obw(ddayidx);
                    
              %  end

    end




    figure(4897); clf; title('four hour bins'); hold on;
    set(gca,'Xticklabel',[], 'Yticklabel', []);

        for j = 1:length(act)

         ax(j) = subplot(length(act), 1, j); hold on;

                  d = histogram(act(j).timcont, 'BinWidth', binwidth);
                  d.Normalization = 'countdensity';
                 % d.FaceColor = [0.9 0.9 0.9];
                
        end

      %  xlabel('time (hours)');
        linkaxes(ax, 'x');
        
                
        
        