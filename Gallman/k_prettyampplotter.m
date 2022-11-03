%function k_prettyampplotter(in, channel)

%not functioning
clearvars -except hkg k
in = hkg(k);
channel = 1;


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


%figure
figure(31); clf; hold on;
    set(gcf, 'renderer', 'painters');
    
    %get y axis bounds for boxes
    plot(timcont, obw, '.');
    a = ylim;
    %plot boxes

    fill([0 0 lighttimes' lighttimes'], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);

    plot(timcont, obw, '.', 'MarkerSize', 10);



    