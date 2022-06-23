function [day] = KatieRegfftDayDessembler(in, channel,  ReFs, light)
%% usage
%[trial, day] = KatieDayTrialDessembler(kg(#), channel, triallength, ReFs)
%
%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4


% % %for when i'm too lazy to function
%  clearvars -except kg kg2 rgk
% % % 
% in = kg(12);
% channel = 1;
% ReFs = 20;
% light = 3;

%% prep

% define length of trial
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld


%outliers
    % Prepare the data with outliers

          %  tto{channel} = 1:length([in.e(channel).s.timcont]); % ttsf is indices for sumfftAmp
            ttsf{channel} = 1:length([in.e(channel).s.timcont]); % ttsf is indices for sumfftAmp
    % Prepare the data without outliers

            % If we have removed outliers via KatieRemover, get the indices...    
            if ~isempty(in.idx) 
               % tto{channel} = in.idx(channel).obwidx; % ttsf is indices for obwAmp
                ttsf{channel} = in.idx(channel).sumfftidx; % ttsf is indices for sumfftAmp
            end

%% crop data to lighttimes 

    ld = in.info.ld;
lighttimeslong = abs(in.info.luz);
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

else 
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


    %raw data
%     timcont = [in.e(channel).s(tto{channel}).timcont];
%     obw = [in.e(channel).s(tto{channel}).obwAmp];

    timcont = [in.e(channel).s(ttsf{channel}).timcont];
    obw = [in.e(channel).s(ttsf{channel}).sumfftAmp];


    %xx = lighttimes(1):ReFs:lighttimes(end);
    timidx = timcont >= lighttimes(1) & timcont <= lighttimes(end);
    timcont = timcont(timidx);
    obw = obw(timidx);  
%% take top of data set 

    %find peaks
    [PKS,LOCS] = findpeaks(obw);
    %find peaks of the peaks
    [obwpeaks,cLOCS] = findpeaks(obw(LOCS));
    peaktim = timcont(LOCS(cLOCS));


    %data above spline
    %[subffttim, subfft, ~, lighttimes] =  k_fftabovespline(in, timcont, sumfft, ReFs, light); %squiggle is the spline for plotting

    %regularize data to ReFs interval
    [xx, regobwminusmean, regobwpeaks] = k_regularmetamucil(peaktim, obwpeaks, ReFs);
    %[regtim, regobw] = metamucil(timcont, obw, ReFs);
    
    %take the top of the data set
    

     
    %convert amp to dB
   % dBamp = 20*log10(regsumfft/max(regsumfft));

    %raw data
%     idx = find(timcont >= lighttimes(1) & timcont <= lighttimes(end));
%     timcont = timcont(idx);
%     sumfft = sumfft(idx);
    

%% Define trials and days

 %day
    daylengthSECONDS = (ld*2) * 3600;  
    lengthofsampleHOURS = (lighttimes(end) - lighttimes(1)) / 3600; 
    % This is the number of sample in a day
    howmanysamplesinaday = floor(daylengthSECONDS / ReFs);
    %how many days total
    howmanydaysinsample = (floor(lengthofsampleHOURS / (ld*2)));


%% Divide sample into days 
%tim = 1/ReFs:1/ReFs:howmanysamplesinaday/ReFs;
tim = ReFs:ReFs:(ld*2)*3600;
%spline data

for k = 1:howmanydaysinsample
    
              %resampled data  
    %         % Get the index of the start time of the day
                ddayidx = find(xx >= xx(1) + (k-1) * daylengthSECONDS & xx < xx(1) + k* daylengthSECONDS); % k-1 so that we start at zero

                if length(ddayidx) >= howmanysamplesinaday %important so that we know when to stop

                  %  day(k).Ssumfftyy = regobwpeaks(ddayidx);
                    day(k).Ssumfftyy = regobwminusmean(ddayidx);
%                    day(k).nonormregsumfft = nonormregsumfft(ddayidx);
                    %day(k).Ssumfftyy = dBamp(ddayidx);
                    day(k).tim = tim;
                    day(k).ld = in.info.ld;
                   % day(k).amprange = max(regsumfft(ddayidx))-min(regsumfft(ddayidx));
                    day(k).amprange = max(regobwminusmean(ddayidx));
                end

%                 rawddayidx = find(timcont >= xx(1) + (k-1) * daylengthSECONDS & timcont < xx(1) + k* daylengthSECONDS); % k-1 so that we start at zero
%                 %if length(rawddayidx) >= howmanysamplesinaday %important so that we know when to stop
%                     day(k).timcont = timcont(rawddayidx)-timcont(rawddayidx(1));
%                     day(k).rawamp = sumfft(rawddayidx);
%                 %end
 end
 
 %% plot to check

%plot averages for days without trial division 
% figure(56); clf; hold on; 
% 
%  mday = zeros(1, length(day(1).tim));
% 
%      for k = 1:length(day)
%             plot(day(k).tim/3600, day(k).Ssumfftyy);
%             meanday(k,:) = day(k).Ssumfftyy;
%             mday = mday + day(k).Ssumfftyy;
%             
%      end
%         
%             mmday= mean(meanday);
%             othermday = mday/(length(day));
%             plot(day(1).tim/3600, mmday, 'k-', 'LineWidth', 3);
%             plot(day(1).tim/3600, othermday, 'b-', 'LineWidth', 3);
%             plot([ld ld], ylim, 'k-', 'LineWidth', 3);

     



