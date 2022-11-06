function k_tempLDfigplotter(in, channel)
%channel = 1,2 singlefish
%channel = 3 multifish

%% data prep
ReFs = 20;
temptims = sort([in.info.temptims]);

if channel < 3 %single fish
    %outlier removal
     tto = [in.idx(channel).obwidx]; 
      
    %raw data
    timcont = [in.e(channel).s(tto).timcont]; %time in seconds
    obw = [in.e(channel).s(tto).obwAmp];%/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
    oldfreq = [in.e(channel).s(tto).fftFreq];
    oldtemp = [in.e(channel).s(tto).temp];


else %multifish

    %outlier removal
     tto = [in.idx.obwidx]; 
      
    %raw data
    timcont = [in.s(tto).timcont]; %time in seconds
    obw = [in.s(tto).obwAmp];%/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
    oldfreq = [in.s(tto).freq];
    oldtemp = [in.s(tto).temp];

end

lighttimes = k_lighttimes(in, light);

  %trimmed mean
 window = 5;
  fcn = @(x) trimmean(x,33);
  obwtrim = matlab.tall.movingWindow(fcn, window, obw');
  freqtrim = matlab.tall.movingWindow(fcn, window, oldfreq');
  temptrim = matlab.tall.movingWindow(fcn, window, oldtemp');

  %regularize data to ReFs interval
    [regtim, regfreq, regtemp, regobwpeaks] = k_regularmetamucil(timcont, obwtrim', timcont, obw, freqtrim', temptrim', ReFs, lighttimes);
 
    %filter
    
     highWn = 0.005/(ReFs/2); % Original but perhaps too strong for 4 and 5 hour days
         [bb,aa] = butter(5, highWn, 'high');

    lowWn = 0.1/(ReFs/2);
        [dd,cc] = butter(5, lowWn, 'low');
       

        datadata = filtfilt(dd,cc, double(regobwpeaks)); %low pass
        datadata = filtfilt(bb,aa, datadata); %high pass


  %trim everything to lighttimes
    timidx = regtim >= lighttimes(1) & regtim <= lighttimes(end);
    xx = regtim(timidx);
   % obwyy = regobwpeaks(timidx);
    obwyy = datadata(timidx); 
  
    freq = regfreq(timidx);
    temp = regtemp(timidx);


    rawidx = timcont >= lighttimes(1) & timcont <= lighttimes(end);
    timmy = timcont(rawidx);
    obwAmp = obw(rawidx);
    rawfreq = oldfreq(rawidx);
    rawtemp = oldtemp(rawidx);


     temptims = temptims(temptims >= lighttimes(1)/3600 & temptims <= lighttimes(end)/3600);
      
        %do we start with warming or cooling?
        tempidx = find(timcont/3600 >= temptims(1) & timcont/3600 < temptims(2));
    
            if mean(temp(tempidx)) > mean(temp)
                tiz = temptims(1);
                
            else
                tiz = -temptims(1);
            end



%% divide into days
 %define day length
    daylengthSECONDS = (ld*2) * 3600;  
    lengthofsampleHOURS = (lighttimes(end) - lighttimes(1)) / 3600; 
    % This is the number of data samples in a day
    howmanysamplesinaday = floor(daylengthSECONDS / ReFs);
    %how many days in total experiment
    howmanydaysinsample = (floor(lengthofsampleHOURS / (ld*2)));


%% Divide sample into days based on light
% needs to be in seconds
tim = ReFs:ReFs:(ld*2)*3600;

for j = 1:howmanydaysinsample
    
              %resampled data  
    %         % Get the index of the start time of the day
                ddayidx = find(xx >= xx(1) + (j-1) * daylengthSECONDS & xx < xx(1) + j* daylengthSECONDS); % k-1 so that we start at zero

                if length(ddayidx) >= howmanysamplesinaday %important so that we know when to stop

                    %amplitude data
                    day(j).Sobwyy = obwyy(ddayidx);
                    %frequency data
                    day(j).freq = freq(ddayidx);
                    %temperature data
                    day(j).temp = temp(ddayidx);
                    %new time base from 0 the length of day by ReFS
                    day(j).tim = tim;
                    %old time base divided by day for plotting chronologically
                    day(j).entiretimcont = xx(ddayidx);
                    %not sure why we need how long the day is in hours...
                    day(j).ld = in.info.ld;
                    %max amp of each day
                    day(j).amprange = max(obwyy(ddayidx));
                    day(j).ampmin = min(obwyy(ddayidx));
                    
                end

 end

%% plot based on daylight - for cycles

% %fill colors for plotting
hot = [255/255, 204/255, 204/255];
cold = [204/255, 238/255, 255/255];

figure(55); clf; hold on;

    xa(1) = subplot(211); hold on;
    
            %  plot(timmy/3600, obwAmp, '.');
            plot(timmy/3600, obwAmp-mean(obwAmp), '.');
            for j = 1:length(day)
                plot(day(j).entiretimcont/3600, day(j).Sobwyy);
            end
            
            
            % plot([lighttimes'/3600 lighttimes'/3600], ylim, 'k-');
            
            a = ylim; %all of above is just to get the max for the plot lines...
            if light < 4 %the first lighttime is dark
                for j = 1:length(lighttimes)-1
                    if mod(j,2) == 1 %if j is odd
                        fill([lighttimes(j)/3600 lighttimes(j)/3600 lighttimes(j+1)/3600 lighttimes(j+1)/3600], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
                    end
                end
            else %the second lighttime is dark
                for j = 1:length(lighttimes)-1
                    if mod(j,2) == 0 %if j is even
                        fill([lighttimes(j)/3600 lighttimes(j)/3600 lighttimes(j+1)/3600 lighttimes(j+1)/3600], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
                    end
                end
            end
            
            for j = 1:length(day)
                plot(day(j).entiretimcont/3600, day(j).Sobwyy, 'LineWidth', 1.5);
            end
            
            plot(timmy/3600, obwAmp-mean(obwAmp), '.');
            plot(xx/3600, obwyy);


    xa(2) = subplot(212); hold on;



            %  plot(timmy/3600, obwAmp, '.');
            plot(timmy/3600, rawfreq, '.');
            for j = 1:length(day)
                plot(day(j).entiretimcont/3600, day(j).freq);
            end
            
            
            % plot([lighttimes'/3600 lighttimes'/3600], ylim, 'k-');
            
            freqlim = ylim; %all of above is just to get the max for the plot lines...
            if  tiz > 0 %we start with warming
                for j = 1:length(temptims)-1
                    if mod(j,2) == 1 %if j is odd
                fill([temptims(j)/3600 temptims(j)/3600 temptims(j+1)/3600 temptims(j+1)/3600], [freqlim(1) freqlim(2) freqlim(2) freqlim(1)], hot);
                    else
                fill([temptims(j)/3600 temptims(j)/3600 temptims(j+1)/3600 temptims(j+1)/3600], [freqlim(1) freqlim(2) freqlim(2) freqlim(1)], cold);
                    end
                end
            else
                for j = 1:length(temptims)-1
                    if mod(j,2) == 1 %if j is odd
                fill([temptims(j)/3600 temptims(j)/3600 temptims(j+1)/3600 temptims(j+1)/3600], [freqlim(1) freqlim(2) freqlim(2) freqlim(1)], cold);
                    else
                fill([temptims(j)/3600 temptims(j)/3600 temptims(j+1)/3600 temptims(j+1)/3600], [freqlim(1) freqlim(2) freqlim(2) freqlim(1)], hot);
                    end
                end
            end


             plot(timmy/3600, rawfreq, '.');

            for j = 1:length(day)
                plot(day(j).entiretimcont/3600, day(j).freq, 'LineWidth', 1.5);
            end
            
          
linkaxes(xa, 'x');           














