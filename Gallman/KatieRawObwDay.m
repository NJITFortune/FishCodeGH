%function [darkhalfamp, darkhalftim, lighthalfamp, lighthalftim] = KatieRawObwDay(in, channel, light)
% %% prep 

% % 
 clearvars -except kg kg2 hkg hkg2 xxkg xxkg2 k
% 
in = hkg(k);
channel = 3;
light = 3;
ReFs = 20;

% %kg(12) starts with light
% 
% %binsize in minutes
% binsize = 20;
% transbinnum = 8;

%% data

ld = in.info.ld;

lighttimes = k_lighttimes(in, 3);
lighttimes = lighttimes/3600;


 if channel < 3 %single fish data has two channel

    %outlier removal
     tto = [in.idx(channel).obwidx]; 
          
    %raw data
        timcont = [in.e(channel).s(tto).timcont]/3600; %time in hours
        obw = [in.e(channel).s(tto).obwAmp]/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
        oldfreq = [in.e(channel).s(tto).fftFreq];
        oldtemp = [in.e(channel).s(tto).temp];

  else %multifish data only has one channel
    %outlier removal
     tto = [in.idx.obwidx]; 
          
    %raw data
        timcont = [in.s(tto).timcont]/3600; %time in hours
        obw = [in.s(tto).obwAmp]/max([in.s(tto).obwAmp]); %divide by max to normalize
        oldfreq = [in.s(tto).freq];
        oldtemp = [in.s(tto).temp];

  end
            
%% dark to light transitions

%length of experiment
totaltimhours = lighttimes(end)-lighttimes(1);
%divide into days
%index      
daysz = 1:1:floor(totaltimhours/(ld*2));

%dark transistions
darkdays = lighttimes(1) + ((2*ld) * (daysz-1));

%light transitions
lightdays = lighttimes(2) + ((2*ld) * (daysz-1));


%% dark summary by day for stats

if light == 3

  %divide raw data into days that start with dark
    for jj = 2:length(darkdays)
  
        darkidx = find(timcont >= darkdays(jj-1) & timcont < darkdays(jj));
            dday(jj-1).tim(:) = timcont(darkidx)-timcont(darkidx(1));
            dday(jj-1).amp(:) = obw(darkidx);
            dday(jj-1).entiretimcont = timcont(darkidx);
    
    end
    
    
    ddayamp = dday(1).amp;
    ddaytim = dday(1).tim;
    
    for j = 2:length(dday)
        ddayamp = [ddayamp, dday(j).amp];
        ddaytim = [ddaytim, dday(j).tim];
    end
    
    [ddaytim, sortidx] = sort(ddaytim);
    ddayamp = ddayamp(sortidx);
    ddayamp = ddayamp-mean(ddayamp);
    
    darkhalfidx = find(ddaytim < ld);
    darkhalfamp = ddayamp(darkhalfidx);
    darkhalftim = ddaytim(darkhalfidx);
    
    lighthalfidx = find(ddaytim >= ld);
    lighthalfamp = ddayamp(lighthalfidx);
    lighthalftim = ddaytim(lighthalfidx);


%  %KatieRegObwDay
%     %trimmed mean
%      window = 5;
%       fcn = @(x) trimmean(x,33);
%       obwtrim = matlab.tall.movingWindow(fcn, window, obw');
%       freqtrim = matlab.tall.movingWindow(fcn, window, oldfreq');
%       temptrim = matlab.tall.movingWindow(fcn, window, oldtemp');
% 
%     %convert time vectors back to seconds for resample
%     timcont = timcont*3600;
%     lighttimes = lighttimes*3600;
%     
%     %Regularize
%         %regularize data to ReFs interval
%         [regtim, regfreq, regtemp, regobwpeaks] = k_regularmetamucil(timcont, obwtrim', timcont, obw, freqtrim', temptrim', ReFs, lighttimes);
% 
%          %filter data
%         if ld < 11
% 
%         %high pass removes feeding trend for high frequency experiments
%         %cut off frequency
%          highWn = 0.005/(ReFs/2); % Original but perhaps too strong for 4 and 5 hour days
%          [bb,aa] = butter(5, highWn, 'high');
% 
%          %less strong low pass filter - otherwise fake prediction 
%                lowWn = 0.9/(ReFs/2);
%                [dd,cc] = butter(5, lowWn, 'low');
% 
%         datadata = filtfilt(dd,cc, double(regobwpeaks)); %low pass
%         datadata = filtfilt(bb,aa, datadata); %high pass
% 
%         else
%         %stronger low pass filter for lower frequency experiments 
%         lowWn = 0.1/(ReFs/2);
%         [dd,cc] = butter(5, lowWn, 'low');
%         datadata = filtfilt(dd,cc, double(regobwpeaks));
%         end
%    
%         %trim everything to lighttimes
%         timidx = regtim >= lighttimes(1) & regtim <= lighttimes(end);
%         xx = regtim(timidx);
%       %  obwyy = regobwpeaks(timidx);
%         obwyy = datadata(timidx); 
%         obwyy = obwyy-mean(obwyy);
%         freq = regfreq(timidx);
%         temp = regtemp(timidx);
% 
%     %define day length
%         daylengthSECONDS = (ld*2) * 3600;  
%         lengthofsampleHOURS = (lighttimes(end) - lighttimes(1)) / 3600; 
%         % This is the number of data samples in a day
%         howmanysamplesinaday = floor(daylengthSECONDS / ReFs);
%         %how many days in total experiment
%         howmanydaysinsample = (floor(lengthofsampleHOURS / (ld*2)));
% 
% 
%     % Divide sample into days 
%         % needs to be in seconds
%         tim = ReFs:ReFs:(ld*2)*3600;
%     
%     for j = 1:howmanydaysinsample
%         
%                   %resampled data  
%         %         % Get the index of the start time of the day
%                     ddayidx = find(xx >= xx(1) + (j-1) * daylengthSECONDS & xx < xx(1) + j* daylengthSECONDS); % k-1 so that we start at zero
%     
%                     if length(ddayidx) >= howmanysamplesinaday %important so that we know when to stop
%     
%                         %amplitude data
%                         day(j).Sobwyy = obwyy(ddayidx);
%                         %frequency data
%                         day(j).freq = freq(ddayidx);
%                         %temperature data
%                         day(j).temp = temp(ddayidx);
%                         %new time base from 0 the length of day by ReFS
%                         day(j).tim = tim;
%                         %old time base divided by day for plotting chronologically
%                         day(j).entiretimcont = xx(ddayidx);
%                         %not sure why we need how long the day is in hours...
%                         day(j).ld = in.info.ld;
%                         %max amp of each day
%                         day(j).amprange = max(obwyy(ddayidx));
%                         
%                     end
%     
%      end


end
%% light summary by day for stats

if light == 4

    %divide raw data into days that start with dark
    for jj = 2:length(lightdays)
    
        lightidx = find(timcont >= lightdays(jj-1) & timcont < lightdays(jj));
            lday(jj-1).tim(:) = timcont(lightidx)-timcont(lightidx(1));
            lday(jj-1).amp(:) = obw(lightidx);
            lday(jj-1).entiretimcont = timcont(lightidx);
    
    end
    
    
    ldayamp = lday(1).amp;
    ldaytim = lday(1).tim;
    
    for j = 2:length(lday)
        ldayamp = [ldayamp, lday(j).amp];
        ldaytim = [ldaytim, lday(j).tim];
    end
    
    [ldaytim, sortidx] = sort(ldaytim);
    ldayamp = ldayamp(sortidx);
    
    darkhalfidx = find(ldaytim >= ld);
    darkhalfamp = ldayamp(darkhalfidx);
    darkhalftim = ldaytim(darkhalfidx);
    
    lighthalfidx = find(ldaytim<ld);
    lighthalfamp = ldayamp(lighthalfidx);
    lighthalftim = ldaytim(lighthalfidx);

end

%% plot to check

% 
% 
% figure(45); clf; hold on;
% 
%     plot(darkhalftim, darkhalfamp-mean(darkhalfamp), '.', 'Color', [0.7, 0.7, 0.7]);
%     plot(lighthalftim, lighthalfamp-mean(lighthalfamp), 'm.');
%     plot([ld ld], ylim, 'k-', 'LineWidth', 2);

    

%     for j = 1:length(day)
%         meanday(j,:) = day(j).Sobwyy;      
%     end
%         mmday= mean(meanday);
%         plot(day(1).tim/3600, mmday, 'k-', 'LineWidth', 3);
            



% figure(68);clf; hold on;
% 
%     for j = 1:length(dday)
%         plot(dday(j).entiretimcont, dday(j).amp, '.');
%     end
%     
%     plot([darkdays' darkdays'], ylim, 'k-');




