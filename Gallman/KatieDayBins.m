%function [trial] = KatiefftDayTrialDessembler(in, channel,  ReFs, light)
%% usage
%[trial, day] = KatieDayTrialDessembler(kg(#), channel, triallength, ReFs)
%
%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4


%for when i'm too lazy to function
clearvars -except kg kg2

in = kg(1);
channel = 1;
ReFs = 20;
light = 3;

%% prep

% define length of trial
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld


%outliers
    % Prepare the data with outliers

            ttsf{channel} = 1:length([in.e(channel).s.timcont]); % ttsf is indices for sumfftAmp
            
    % Prepare the data without outliers

            % If we have removed outliers via KatieRemover, get the indices...    
            if ~isempty(in.idx) 
                ttsf{channel} = in.idx(channel).sumfftidx; % ttsf is indices for sumfftAmp
            end

%regularize data across time in ReFs second intervals

    timcont = [in.e(channel).s(ttsf{channel}).timcont];
    sumfft = [in.e(channel).s(ttsf{channel}).sumfftAmp];

    [xx, sumfftyy] = metamucil(timcont, sumfft, ReFs);


%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4
%% trim luz to data - Generate lighttimes

lighttimeslong = abs(in.info.luz);
ld = in.info.ld;

    %fit light vector to power idx
        %poweridx = good data
    if isempty(in.info.poweridx) %if there are no values in poweridx []
        lighttimes = lighttimeslong;
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

%make lighttimes an integer
    %convert to seconds because xx is in seconds
    lighttimes = floor(lighttimes*3600);

%% define data by lighttimes

%Make a time base that starts and ends on lighttimes 
    %necessary to define length of data
    %resampled data
    idx = find(xx >= lighttimes(1) & xx <= lighttimes(end));
    xx = xx(idx);
    sumfftyy = sumfftyy(idx);
    %raw data
    idx = find(timcont >= lighttimes(1) & timcont <= lighttimes(end));
    timcont = timcont(idx);
    sumfft = sumfft(idx);
    

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

                    day(k).Ssumfftyy = sumfftyy(ddayidx);
                    day(k).tim = tim;

                end

                rawddayidx = find(timcont >= xx(1) + (k-1) * daylengthSECONDS & timcont < xx(1) + k* daylengthSECONDS); % k-1 so that we start at zero
                %if length(rawddayidx) >= howmanysamplesinaday %important so that we know when to stop
                    rawday(k).timcont = timcont(rawddayidx)-timcont(rawddayidx(1));
                    rawday(k).rawamp = sumfft(rawddayidx);
                %end
 end
 
 %% plot to check

%plot averages for days 
figure(28); clf; hold on; 


     for k = 1:length(day)
            plot(day(k).tim/3600, day(k).Ssumfftyy); %all days
            %plot(day(k).timcont/3600, day(k).rawamp, '.')
            meanday(k,:) = day(k).Ssumfftyy;
     end
        
            mmday= mean(meanday);
            plot(day(1).tim/3600, mmday, 'k-', 'LineWidth', 3);
            plot([ld ld], ylim, 'k-', 'LineWidth', 3);
 
% spliney = csaps([trial(1).tim], meanofmeans, .99);
% sumfftyy = fnval([trial(1).tim], spliney);
%compare day mean calculations            
figure(31); clf; hold on;
    plot(day(1).tim/3600, mmday);
     plot(day(1).tim/3600, movmean(mmday,5), 'r', 'LineWidth', 3);
     plot(day(1).tim/3600,smoothdata(mmday, 'SamplePoints',day(1).tim), 'LineWidth', 3);
%     plot(day(1).tim, movmean(mmday,10), 'c', 'LineWidth', 5);
%     plot(day(1).tim, movmean(mmday,20), 'm', 'LineWidth', 5);
   
   % plot(abovetim/3600, aboveamp,'k-', 'LineWidth', 1);
  %  plot(timnoreps/3600, ampnoreps, '.');
   % plot(newtim/3600, movmean(newamp, 5), 'c-');
    %plot(trial(1).tim, sumfftyy, 'k-', 'LineWidth', 3);
    plot([ld ld], ylim, 'k-', 'LineWidth', 3);
    legend('day mean', 'trial mean');
     legend('boxoff')
% 

% 
