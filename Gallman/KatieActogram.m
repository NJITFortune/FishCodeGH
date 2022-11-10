%function [day] = KatieRegObwDay(in, channel, ReFs, light)%multisingleRegobwDay

%function [day] = KatieRegobwDayDessembler(in, channel,  ReFs, light)
%% usage
%[day] = KatieRegobwDayDessembler(kg(#), channel, ReFs)
%
%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4


% % % % % %for when i'm too lazy to function
  clearvars -except kg kg2 rkg k hkg2 hkg xxkg xxkg2 dark darkmulti light lightmulti l24kg
% % % % % 
in = l24kg(k);
ReFs = 20;
lightstart = 3; %start with dark
channel = 1;
ld = 12;

%light = 4; %start with light
% fish = 5; %lo freq



%% crop data to lighttimes
%prep variables
%ld = in.info.ld; % Whatever - ld is shorter than in.info.ld
%create positive vector of lighttimes
lighttimeslong = abs(in.info.luz);
poweridx = [in.info.poweridx];

%if we start with dark...
if in.info.luz(1) < 0

    
    %fit light vector to power idx
        %poweridx = good data
    if isempty(poweridx) %if there are no values in poweridx []
        if lightstart < 4
        lighttimes = lighttimeslong;
        else
        lighttimes = lighttimeslong(2:end);
        end
    else %take data from within power idx range

        if lightstart < 4 %we start with dark
            lighttimesidx = lighttimeslong > poweridx(1) & lighttimeslong < poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        else %we start with light
            %poweridx normally starts with dark, so we need to add ld to start with light
            poweridx1 = poweridx(1) + ld;
            lighttimesidx = lighttimeslong > poweridx1 & lighttimeslong < poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        end
    end

else %we start with light
    lighttimeslong = lighttimeslong(2:end);
    if isempty(poweridx) %if there are no values in poweridx []
        if lightstart < 4
        lighttimes = lighttimeslong;
        else
        lighttimes = lighttimeslong(2:end);
        end
    else %take data from within power idx range

        if lightstart < 4 %we start with dark
            lighttimesidx = lighttimeslong > poweridx(1) & lighttimeslong < poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        else %we start with light
            %poweridx normally starts with dark, so we need to add ld to start with light
            poweridx1 = poweridx(1) + ld;
            lighttimesidx = lighttimeslong > poweridx1 & lighttimeslong < poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        end
    end
end

%make lighttimes an integer
    %convert to seconds because xx is in seconds
    lighttimes = lighttimes*3600;



%% process data
%prepare data variables

%outlier removal
 tto = [in.idx(channel).obwidx]; 
      
%raw data
    timcont = [in.e(channel).s(tto).timcont]; %time in seconds
    obw = [in.e(channel).s(tto).obwAmp];%/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
    oldfreq = [in.e(channel).s(tto).fftFreq];
  %  oldtemp = [in.e(channel).s(tto).temp];
    oldlight = [in.e(channel).s(tto).light];


    
 %trimmed mean
 window = 5;
  fcn = @(x) trimmean(x,33);
  obwtrim = matlab.tall.movingWindow(fcn, window, obw');
  freqtrim = matlab.tall.movingWindow(fcn, window, oldfreq');
  lighttrim = matlab.tall.movingWindow(fcn, window, oldlight');

    
    
%Regularize
    %regularize data to ReFs interval
    [regtim, regfreq, regtemp, regobwpeaks] = k_regularmetamucil(timcont, obwtrim', timcont, obw, freqtrim', lighttrim', ReFs, lighttimes);

%  %peaks of peaks
%         %find peaks
%         [~,LOCS] = findpeaks(obw);
%         %find peaks of the peaks
%         [obwpeaks,cLOCS] = findpeaks(obw(LOCS));
%         peaktim = timcont(LOCS(cLOCS));       
%         peakfreq = oldfreq(LOCS(cLOCS));       
%         peaktemp = oldtemp(LOCS(cLOCS));  
% 
% 
% 
%  [regtim, regfreq, regtemp, regobwpeaks] = k_regularmetamucil(peaktim, obwpeaks, timcont, obw, peakfreq, peaktemp, ReFs, lighttimes);

        %filter data
        if ld < 11

        %high pass removes feeding trend for high frequency experiments
        %cut off frequency
        highWn = 0.005/(ReFs/2); % Original but perhaps too strong for 4 and 5 hour days
         [bb,aa] = butter(5, highWn, 'high');

         %less strong low pass filter - otherwise fake prediction 
               lowWn = 0.9/(ReFs/2); %OG 0.9
               [dd,cc] = butter(5, lowWn, 'low');

        datadata = filtfilt(dd,cc, double(regobwpeaks)); %low pass
        datadata = filtfilt(bb,aa, datadata); %high pass

        else
        %stronger low pass filter for lower frequency experiments 
        lowWn = 0.1/(ReFs/2);
        [dd,cc] = butter(5, lowWn, 'low');
        datadata = filtfilt(dd,cc, double(regobwpeaks));
        end
            

    %trim everything to lighttimes
    timidx = regtim >= lighttimes(1) & regtim <= lighttimes(end);
    xx = regtim(timidx);
  %  obwyy = regobwpeaks(timidx);
    obwyy = datadata(timidx); 
   % obwyy = obwyy-mean(obwyy);
    freq = regfreq(timidx);
    light = regtemp(timidx);
    

    rawidx = timcont >= lighttimes(1) & timcont <= lighttimes(end);
    timmy = timcont(rawidx);
    obwAmp = obw(rawidx);
    rawfreq = oldfreq(rawidx);
    %rawtemp = oldtemp(rawidx);


   
%% Define day length

 %day
    daylengthSECONDS = (ld*2) * 3600;  
    lengthofsampleHOURS = (lighttimes(end) - lighttimes(1)) / 3600; 
    % This is the number of data samples in a day
    howmanysamplesinaday = floor(daylengthSECONDS / ReFs);
    %how many days in total experiment
    howmanydaysinsample = (floor(lengthofsampleHOURS / (ld*2)));


%% Divide sample into days 
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
                    day(j).light = light(ddayidx);
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

%                 rawddayidx = find(timcont >= xx(1) + (k-1) * daylengthSECONDS & timcont < xx(1) + k* daylengthSECONDS); % k-1 so that we start at zero
%                 %if length(rawddayidx) >= howmanysamplesinaday %important so that we know when to stop
%                     day(k).timcont = timcont(rawddayidx)-timcont(rawddayidx(1));
%                     day(k).rawamp = sumfft(rawddayidx);
%                 %end
 end
%  
 %% plot to check
%time vectors currently in seconds, divide by 3600 to get hours

figure(789); clf; hold on;
    for j = 1:length(day)
        ax(j) = subplot(length(day), 1, j); hold on;

           lidx = find(day(j).light > 4);
           plot(day(j).tim(lidx)/3600, day(j).Sobwyy(lidx),'-', 'Color', [0.9290 0.6940 0.1250]);

           didx = find(day(j).light < 0);
           plot(day(j).tim(didx)/3600, day(j).Sobwyy(didx), 'k');

    end

linkaxes(ax, 'x');

            
            
                


    

    













