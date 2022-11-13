%function k_prettypeakplotter(in, channel)

%not functioning
clearvars -except l24kg k

in = l24kg(k);
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
        freq = freq(lidx);
        temp = temp(lidx);

    %amplitude
             %trimmed mean
             window = 5;
              fcn = @(x) trimmean(x,33);
              obwtrim = matlab.tall.movingWindow(fcn, window, obw');
              freqtrim = matlab.tall.movingWindow(fcn, window, freq');
              temptrim = matlab.tall.movingWindow(fcn, window, temp');
        %Regularize
                %regularize data to ReFs interval
                [regtim, regfreq, ~, regobwpeaks] = k_regularmetamucil(timcont *3600, obwtrim', timcont*3600, obw, freqtrim', temptrim', 20, lighttimes*3600);

        lowWn = 0.03/(20/2);%.025
                [dd,cc] = butter(5, lowWn, 'low');
                regobwpeaks= filtfilt(dd,cc, double(regobwpeaks));

                [amppeaks, amplocs] = findpeaks(regobwpeaks, regtim);




    %triggers
      binwidth = 0.5;
        [N, edges] = histcounts(timcont, 'BinWidth', binwidth);
        edges = edges(2:end) - (edges(2)-edges(1))/2;

        lowWn = 0.075/(binwidth/2);
        [dd,cc] = butter(5, lowWn, 'low');
        filtN = filtfilt(dd,cc, double(N));
 
         [peaks, locs] = findpeaks(filtN, edges);


         [~, histpeakidx, ~] = intersect(regtim/3600, locs);



%figure
figure(31); clf; hold on;
    set(gcf, 'renderer', 'painters');
    
     ax(1) = subplot(211); hold on;   xlim([0, timcont(end)-timcont(1)]);
      plot(regtim/3600 - timcont(1), regobwpeaks, 'k-', 'LineWidth', 2);
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
        plot(regtim/3600 - timcont(1), regobwpeaks, 'k-', 'LineWidth', 2);
        plot(amplocs/3600-timcont(1), amppeaks, 'r.', 'MarkerSize', 20);
        ylabel('Mean square amplitude');

%               ylabel('Frequency (Hz)');
    
    ax(2) = subplot(212); hold on; xlim([0, timcont(end)-timcont(1)]);



         highWn = 0.005/(ReFs/2); % Original but perhaps too strong for 4 and 5 hour days
         [bb,aa] = butter(5, highWn, 'high');

         %less strong low pass filter - otherwise fake prediction 
               lowWn = 0.9/(ReFs/2); %OG 0.9
               [dd,cc] = butter(5, lowWn, 'low');

        
        datadata = filtfilt(bb,aa, regobwpeaks); %high pass

         [hiamppeaks, hiamplocs] = findpeaks(regobwpeaks, regtim);







 plot(regtim/3600 - timcont(1), datadata, 'k-', 'LineWidth', 2);

%         
%         darkdy = gradient(regobwpeaks)./gradient(regtim);
%        
%         plot(regtim/3600 - timcont(1), darkdy,'k-', 'LineWidth', 2);
         a = ylim;
         for j = 1:length(lighttimes)-1
            if mod(j,2) == 1 %if j is odd
            fill([lighttimes(j)-timcont(1) lighttimes(j)-timcont(1) lighttimes(j+1)-timcont(1) lighttimes(j+1)-timcont(1)], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
            end
         end
%          plot(regtim/3600 - timcont(1), darkdy,'k-', 'LineWidth', 2);
% 
%          ylabel('Rate of change');

%         plot(regtim/3600 - timcont(1), regobwpeaks, 'k-', 'LineWidth', 2);
%         plot(regtim(histpeakidx)/3600 - timcont(1), regobwpeaks(histpeakidx), 'm.', 'MarkerSize', 20);
        %ylim([0 100]);



         plot(regtim/3600 - timcont(1), datadata, 'k-', 'LineWidth', 2);
         plot(hiamplocs/3600 -timcont(1), hiamppeaks, 'c.', 'MarkerSize', 20);
        ylabel('Tube triggers per half hour');
        xlabel('Time (hours)')
    
       %xlim([13 116]); ylim([0 60]);
%     
%                 for j = 2:length(lighttimes)
%                 
%                     if mod(j,2) == 0 %if j is odd
%                       
%                       d = histogram(timcont-timcont(1), 'BinWidth', binwidth,'BinLimits',[lighttimes(j-1)-timcont(1),lighttimes(j)-timcont(1)]);
%                       d.Normalization = 'countdensity';
%                       d.FaceColor = [0.9 0.9 0.9];
%                       d.EdgeColor = [0.9 0.9 0.9];
%                     else
%                         
%                        l = histogram(timcont-timcont(1),'BinWidth', binwidth, 'BinLimits',[lighttimes(j-1)-timcont(1),lighttimes(j)-timcont(1)]);
%                        l.Normalization = 'countdensity';
%                          l.FaceColor = [255/255 239/255 0/255];
%                          l.EdgeColor = [255/255 239/255 0/255];
%                     end
%                 end
% 
%               plot(edges-timcont(1), filtN,'k-', 'LineWidth',2);
%               plot(locs-timcont(1), peaks, 'm.', 'MarkerSize', 10);

    linkaxes(ax, 'x');
            
    
    
    
        