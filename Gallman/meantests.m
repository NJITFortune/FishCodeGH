
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
%Take top of dataset
    %find peaks
    [~,LOCS] = findpeaks(obw);
    %find peaks of the peaks
    [obwpeaks,cLOCS] = findpeaks(obw(LOCS));
    peaktim = timcont(LOCS(cLOCS));
    peakfreq = oldfreq(LOCS(cLOCS));
    peaktemp = oldtemp(LOCS(cLOCS));

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

  %trimmed 
  fcn = @(x) trimmean(x,33);
  trimmean33 = matlab.tall.movingWindow(fcn, window, obw');


%plot to check
figure(76); clf; hold on;
    plot(timcont, obw, '.', 'MarkerSize', 8, 'DisplayName', 'obw');
%     plot(timcont, tmean, 'LineWidth',1, 'DisplayName', 'Mean');
%     plot(timcont, gmean, 'LineWidth',1, 'DisplayName', 'Geometic mean');
%     plot(timcont, harmean, 'LineWidth',1, 'DisplayName', 'Harmonic mean');
    plot(timcont, trimmean33, 'LineWidth',1, 'DisplayName', 'Trimmed mean 33%');
    plot(peaktim, obwpeaks, 'LineWidth',1, 'DisplayName', 'Peaks of peaks');
    plot([lighttimes' lighttimes'], ylim, 'k-','HandleVisibility','off');
    xlim([85 135]);
    legend('AutoUpdate','off');

%% trimmed mean vs non mean measures

 %% which trim percetage to use
  %trimmed 
%   fcn = @(x) trimmean(x,33);
%   trimmean33 = matlab.tall.movingWindow(fcn, window, obw');
% 
%   fcn = @(x) trimmean(x,10);
%   trimmean10 = matlab.tall.movingWindow(fcn, window, obw');
% 
%   %trimmed 
%   fcn = @(x) trimmean(x,40);
%   trimmean40 = matlab.tall.movingWindow(fcn, window, obw');
% 
%   %plot to check
% figure(77); clf; hold on;
%     plot(timcont, obw, '.', 'MarkerSize', 8, 'DisplayName', 'obw');
%    % plot(timcont, tmean, 'LineWidth',1, 'DisplayName', 'Mean');
%    plot(timcont, trimmean40, 'LineWidth',1, 'DisplayName', 'Trimmed mean 40%');
%     plot(timcont, trimmean33, 'LineWidth',1, 'DisplayName', 'Trimmed mean 33%');
%     plot(timcont, trimmean10, 'LineWidth',1, 'DisplayName', 'Trimmed mean 10%');
%     %plot(peaktim, obwpeaks, 'LineWidth',1, 'DisplayName', 'Peaks of peaks');
%     plot([lighttimes' lighttimes'], ylim, 'k-','HandleVisibility','off');
%     xlim([85 135]);
%     legend('AutoUpdate','off');

%% probability plot

%probplot(obw)

