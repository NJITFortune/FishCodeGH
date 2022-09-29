%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4
clearvars -except hkg k
% 
in = hkg(k);
channel = 1;
ReFs = 10;
light = 3;


%% crop data to lighttimes
%prep variables
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld
%create positive vector of lighttimes
lighttimeslong = abs(in.info.luz);
poweridx = [in.info.poweridx];

%if we start with dark...
if in.info.luz(1) < 0

    
    %fit light vector to power idx
        %poweridx = good data
    if isempty(poweridx) %if there are no values in poweridx []
        if light < 4
        lighttimes = lighttimeslong;
        else
        lighttimes = lighttimeslong(2:end);
        end
    else %take data from within power idx range

        if light < 4 %we start with dark
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
        if light < 4
        lighttimes = lighttimeslong;
        else
        lighttimes = lighttimeslong(2:end);
        end
    else %take data from within power idx range

        if light < 4 %we start with dark
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
    lighttimes = floor(lighttimes*3600);


%% Prepare raw data variables

    %outlier removal
     tto = [in.idx(channel).obwidx]; 
          
    %raw data
        timcont = [in.e(channel).s(tto).timcont]; %time in seconds
        obw = [in.e(channel).s(tto).obwAmp]/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
        oldfreq = timcont;
        
        %Make a time base that starts and ends on lighttimes 
            rawidx = timcont >= lighttimes(1) & timcont <= lighttimes(end);
            timmy = timcont(rawidx);
            obwAmp = obw(rawidx);
          

%spline
%[splinexx, obwyy] =  k_obwabovespliner(timcont, obw, ReFs, lighttimes);

%obwyyminusmean = obwyy-mean(obwyy);


    %Take top of dataset
        %find peaks
        [~,LOCS] = findpeaks(obw);
        %find peaks of the peaks
        [obwpeaks,cLOCS] = findpeaks(obw(LOCS));
        peaktim = timcont(LOCS(cLOCS));
      
    %Regularize
        %spline 
         xx = lighttimes(1):ReFs:lighttimes(end);
         
        spliney = csaps(subffttim, subfft, p);
        %resample new x values based on light/dark
        subfftyy = fnval(xx, spliney);

        %metamucil
            %regularize data to ReFs interval
            [regtim, ~, regobwpeaks] = k_regularmetamucil(peaktim, obwpeaks, timcont, obw, oldfreq, ReFs, lighttimes);
    
             regobwpeaksminusmean = regobwpeaks - mean(regobwpeaks);

% 
%     %filter data
%         %cut off frequency
%          highWn = 0.005/(ReFs/2); % Original but perhaps too strong for 4 and 5 hour days
%         %highWn = 0.001/(ReFs/2);
% 
%         %low pass removes spikey-ness
%         lowWn = 0.025/(ReFs/2);
%         [dd,cc] = butter(5, lowWn, 'low');
%         datadata = filtfilt(dd,cc, double(regobwpeaks));
% 
%         
%         %high pass removes feeding trend for high frequency experiments
%        
%         [bb,aa] = butter(5, highWn, 'high');
%       %  datadata = filtfilt(bb,aa, double(regobwpeaks)); %double vs single matrix?
%         datadata = filtfilt(bb,aa, datadata); %double vs single matrix?
% 
% 
% %         %low pass removes spikey-ness
% %         lowWn = 0.01/(ReFs/2);
% %         [dd,cc] = butter(5, lowWn, 'low');
% %         datadata = filtfilt(dd,cc, double(regobwpeaks));
% % 
%          regobwpeaksminusmean = datadata - mean(datadata);

      

    %trim everything to lighttimes
    timidx = regtim >= lighttimes(1) & regtim <= lighttimes(end);
    regxx = regtim(timidx);
    regobw = regobwpeaks(timidx);  
    regobwminusmean = regobwpeaksminusmean(timidx);

%% Define day length

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
        

        %SPLINE
        %not sure if this is necessary but doing it separately just in case
           

             % Get the index of the start time of the day
                sdayidx = find(splinexx >= splinexx(1) + (j-1) * daylengthSECONDS & splinexx < splinexx(1) + j* daylengthSECONDS); % k-1 so that we start at zero

                if length(sdayidx) >= howmanysamplesinaday-1 %important so that we know when to stop

                    %amplitude data
                    sday(j).obwyy = obwyy(sdayidx);
                    %amplitude data with mean subtraction
                    sday(j).obwyyminusmean = obwyyminusmean(sdayidx);
                    %new time base from 0 the length of day by ReFS
                    sday(j).tim = tim;
                    %old time base divided by day for plotting chronologically
                    sday(j).entiretimcont = splinexx(sdayidx);
                    %not sure why we need how long the day is in hours...
                    sday(j).ld = in.info.ld;
                    %max amp of each day
                    sday(j).amprange = max(obwyy(sdayidx));
                    
                end

        %METAMUCIL
        %not sure if this is necessary but doing it separately just in case
           

             % Get the index of the start time of the day
                ddayidx = find(regxx >= regxx(1) + (j-1) * daylengthSECONDS & regxx < regxx(1) + j* daylengthSECONDS); % k-1 so that we start at zero

                if length(ddayidx) >= howmanysamplesinaday-1 %important so that we know when to stop

                    %amplitude data
                    day(j).regobw = regobw(ddayidx);
                    %amplitude data with mean subtraction
                    day(j).regobwminusmean = regobwminusmean(ddayidx);
                    %new time base from 0 the length of day by ReFS
                    day(j).tim = tim;
                    %old time base divided by day for plotting chronologically
                    day(j).entiretimcont = regxx(ddayidx);
                    %not sure why we need how long the day is in hours...
                    day(j).ld = in.info.ld;
                    %max amp of each day
                    day(j).amprange = max(regobw(ddayidx));
                    
                end
      
end

 
 %% plot to check
%time vectors currently in seconds, divide by 3600 to get hours
 
%days over experiment time
figure(55); clf; hold on;


    ax(1) = subplot(211); title('spline estimate'); hold on;
        
        for j = 1:length(sday)
            plot(sday(j).entiretimcont/3600, sday(j).obwyy, 'LineWidth', 1.5);
        end %only to establish ylim for box plotting
    
         %fill boxes
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


        plot(timmy/3600, obwAmp, '.'); %this time for real on top of boxes
        %plot spline by day - coerce to single color?
        for j = 1:length(sday)
            plot(sday(j).entiretimcont/3600, sday(j).obwyy, 'LineWidth', 1.5);
        end

     

    ax(2) = subplot(212); title('metamucil estimate'); hold on;
        
          for j = 1:length(day)
               plot(day(j).entiretimcont/3600, day(j).regobw, 'LineWidth', 1.5);
          end %only to establish ylim for box plotting
    
         %fill boxes
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


    plot(timmy/3600, obwAmp, '.'); %this time for real on top of boxes
    %plot spline by day - coerce to single color?
    for j = 1:length(day)
        plot(day(j).entiretimcont/3600, day(j).regobw, 'LineWidth', 1.5);
    end

linkaxes(ax, 'x');

%average over single day    
figure(56); clf; hold on; 

    %a = [-0.2 0.2];
    %create fill box 
    if light < 4 %we start with dark
        fill([0 0 ld ld], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9], 'HandleVisibility','off');
    else %we start with light
        fill([ld ld ld*2 ld*2], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9], 'HandleVisibility','off');
    end
    
    %mean two ways to prove math
    
     for j = 1:length(day)
          
            smeanday(j,:) = sday(j).obwyyminusmean;
            meanday(j,:) = day(j).regobwminusmean;
            
     end
        
            mmday= mean(meanday);
            smday = mean(smeanday);
            plot(day(1).tim/3600, mmday, 'k-', 'LineWidth', 3, 'DisplayName', 'metamucil');
            plot(day(1).tim/3600, smday, 'b-', 'LineWidth', 3, 'DisplayName', 'spline');
            legend('AutoUpdate','off');

            plot([ld ld], ylim, 'k-', 'LineWidth', 3);
            
            



