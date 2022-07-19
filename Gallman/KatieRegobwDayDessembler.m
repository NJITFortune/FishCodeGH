%function [day] = KatieRegobwDayDessembler(in, channel,  ReFs, light)
%% usage
%[day] = KatieRegobwDayDessembler(kg(#), channel, ReFs)
%
%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4


% % %for when i'm too lazy to function
 clearvars -except kg kg2 rkg
% % 
in = rkg(1);
channel = 1;
ReFs = 20;
light = 3;

%% prep

% redefine length of light cycle
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld

%outliers
    % Prepare the data with outliers
            tto{channel} = 1:length([in.e(channel).s.timcont]); % ttsf is indices for sumfftAmp
          %  ttsf{channel} = 1:length([in.e(channel).s.timcont]); % ttsf is indices for sumfftAmp
    % Prepare the data without outliers
            % If we have removed outliers via KatieRemover, get the indices...    
            if ~isempty(in.idx) 
                tto{channel} = in.idx(channel).obwidx; % ttsf is indices for obwAmp
               % ttsf{channel} = in.idx(channel).sumfftidx; % ttsf is indices for sumfftAmp
            end

%% crop data to lighttimes 

%create positive vector of lighttimes
lighttimeslong = abs(in.info.luz);

%if we start with dark...
if in.info.luz(1) < 0

    %fit light vector to power idx
        %poweridx = good data
    if isempty(in.info.poweridx) %if there are no values in poweridx []
        if light < 4
        lighttimes = lighttimeslong;
        else
        lighttimes = lighttimeslong(2:end);
        end
    else %take data from within power idx range

        if light < 4 %we start with dark
            lighttimesidx = lighttimeslong > in.info.poweridx(1) & lighttimeslong < in.info.poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        else %we start with light
            %poweridx normally starts with dark, so we need to add ld to start with light
            poweridx1 = in.info.poweridx(1) + ld;
            lighttimesidx = lighttimeslong > poweridx1(1) & lighttimeslong < in.info.poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        end
    end

else %we start with light
    lighttimeslong = lighttimeslong(2:end);
    if isempty(in.info.poweridx) %if there are no values in poweridx []
        if light < 4
        lighttimes = lighttimeslong;
        else
        lighttimes = lighttimeslong(2:end);
        end
    else %take data from within power idx range

        if light < 4 %we start with dark
            lighttimesidx = lighttimeslong > in.info.poweridx(1) & lighttimeslong < in.info.poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        else %we start with light
            %poweridx normally starts with dark, so we need to add ld to start with light
            poweridx1 = in.info.poweridx(1) + ld;
            lighttimesidx = lighttimeslong > poweridx1(1) & lighttimeslong < in.info.poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        end
    end
end
%make lighttimes an integer
    %convert to seconds because xx is in seconds
    lighttimes = floor(lighttimes*3600);

%trim data to lighttimes
    %raw data
    timcont = [in.e(channel).s(tto{channel}).timcont];
    obw = [in.e(channel).s(tto{channel}).obwAmp];

%     timcont = [in.e(channel).s(ttsf{channel}).timcont];
%     obw = [in.e(channel).s(ttsf{channel}).sumfftAmp];


%% take top of data set 

    %find peaks
    [PKS,LOCS] = findpeaks(obw);
    %find peaks of the peaks
    [obwpeaks,cLOCS] = findpeaks(obw(LOCS));
    peaktim = timcont(LOCS(cLOCS));

    
    %regularize data to ReFs interval
    [regtim, regobwminusmean, regobwpeaks] = k_regularmetamucil(peaktim, obwpeaks, ReFs);
    %[regtim, regobw] = metamucil(timcont, obw, ReFs);
   

     %xx = lighttimes(1):ReFs:lighttimes(end);
    timidx = regtim >= lighttimes(1) & regtim <= lighttimes(end);
    xx = regtim(timidx);
    obwyy = regobwminusmean(timidx);  
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

for k = 1:howmanydaysinsample
    
              %resampled data  
    %         % Get the index of the start time of the day
                ddayidx = find(xx >= xx(1) + (k-1) * daylengthSECONDS & xx < xx(1) + k* daylengthSECONDS); % k-1 so that we start at zero

                if length(ddayidx) >= howmanysamplesinaday %important so that we know when to stop

                    %amplitude data
                    day(k).Sobwyy = obwyy(ddayidx);
                    %new time base from 0 the length of day by ReFS
                    day(k).tim = tim;
                    %old time base divided by day for plotting chronologically
                    day(k).entiretimcont = xx(ddayidx);
                    %not sure why we need how long the day is in hours...
                    day(k).ld = in.info.ld;
                    %max amp of each day
                    day(k).amprange = max(obwyy(ddayidx));
                    
                end

%                 rawddayidx = find(timcont >= xx(1) + (k-1) * daylengthSECONDS & timcont < xx(1) + k* daylengthSECONDS); % k-1 so that we start at zero
%                 %if length(rawddayidx) >= howmanysamplesinaday %important so that we know when to stop
%                     day(k).timcont = timcont(rawddayidx)-timcont(rawddayidx(1));
%                     day(k).rawamp = sumfft(rawddayidx);
%                 %end
 end
 
 %% plot to check

%days over experiment time
figure(55); clf; hold on;
    for k = 1:length(day)
        plot(day(k).entiretimcont/3600, day(k).Sobwyy);
    end

   % plot([lighttimes'/3600 lighttimes'/3600], ylim, 'k-');
   
    a = ylim; %all of above is just to get the max for the plot lines...
    
    for j = 1:length(lighttimes)-1
        if mod(j,2) == 1
        fill([lighttimes(j)/3600 lighttimes(j)/3600 lighttimes(j+1)/3600 lighttimes(j+1)/3600], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
        end
    end

    for k = 1:length(day)
        plot(day(k).entiretimcont/3600, day(k).Sobwyy, 'LineWidth', 1);
    end

%average over single day    
figure(56); clf; hold on; 

 mday = zeros(1, length(day(1).tim));

     for k = 1:length(day)
            plot(day(k).tim/3600, day(k).Sobwyy);
            meanday(k,:) = day(k).Sobwyy;
            mday = mday + day(k).Sobwyy;
            
     end
        
            mmday= mean(meanday);
            othermday = mday/(length(day));
            plot(day(1).tim/3600, mmday, 'k-', 'LineWidth', 3);
            plot(day(1).tim/3600, othermday, 'b-', 'LineWidth', 3);
            plot([ld ld], ylim, 'k-', 'LineWidth', 3);
            a = ylim;
            if light < 3
            fill([0 0 ld ld], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
            end



