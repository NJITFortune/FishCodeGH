
clearvars -except xxkg hkg hkg2 xxkg2

k = 43;
channel = 1;
in = xxkg(k);

%outlier removal
 tto = [in.idx(channel).obwidx]; 
      
%raw data
    timcont = [in.e(channel).s(tto).timcont]/3600; %time in seconds
   
    obw = [in.e(channel).s(tto).obwAmp]/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
    oldfreq = [in.e(channel).s(tto).fftFreq];
    oldtemp = [in.e(channel).s(tto).temp];
    

    lighttimes = k_lighttimes(in, 3);
    lighttimes = lighttimes/3600;
%trim data to lighttimes
    lidx = find(timcont >= lighttimes(1) & timcont <= lighttimes(end));
    timcont = timcont(lidx);
    obw = obw(lidx);

%% peaks of peaks for comparison


%% mean alternative tests using filters?

%movmean vs tall moving window
window = 5;
  %movmean
    movobw = movmean(obw, window);
%tall moving window
  %mean
  fcn = @(x) mean(x,1,'omitnan');
  tmean = matlab.tall.movingWindow(fcn, window, obw');

  %geomean
  fcn = @(x) geomean(x,1,'omitnan');
  gmean = matlab.tall.movingWindow(fcn, window, obw');

  %harmonic
  fcn = @(x) harmmean(x,1,'omitnan');
  harmean = matlab.tall.movingWindow(fcn, window, obw');


%plot to check
figure(76); clf; hold on;
    plot(timcont, obw, '.', 'MarkerSize', 8, 'DisplayName', 'obw');
    plot(timcont, tmean, 'LineWidth',1, 'DisplayName', 'Mean');
    plot(timcont, gmean, 'LineWidth',1, 'DisplayName', 'Geometic mean');
    plot(timcont, harmean, 'LineWidth',1, 'DisplayName', 'Harmonic mean');
    plot([lighttimes' lighttimes'], ylim, 'k-','HandleVisibility','off');
    xlim([85 135]);
    legend('AutoUpdate','off');




