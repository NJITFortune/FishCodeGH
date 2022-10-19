
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

%% mean alternative tests using filters?

%movmean vs tall moving window
window = 5;
  %movmean
    movobw = movmean(obw, window);
  %tall moving window
  fcn = @(x) mean(x,1,'omitnan');
  tmean = matlab.tall.movingWindow(fcn, window, obw');


%plot to check
figure(76); clf; hold on;
    plot(timcont, obw, '.', 'MarkerSize', 8);
    plot(timcont, movobw);
    plot(timcont, tmean);
    plot([lighttimes' lighttimes'], ylim, 'k-');




