%function [trial] = KatiefftDayTrialDessembler(in, channel,  ReFs, light)
%% usage
%[trial, day] = KatieDayTrialDessembler(kg(#), channel, triallength, ReFs)

%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4
clearvars -except kg kg2
% 
in = kg(1);
channel = 1;
ReFs = 60;
light = 3;

%% prep
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld

% define length of trial 
if in.info.ld > 15 
    triallength = in.info.ld * 2;
else
    triallength = in.info.ld * 4;
end

%triallength


%% Take spline estimate of raw data
%outliers
    % Prepare the data with outliers

%             tto{1} = 1:length([in.e(1).s.timcont]); % tto is indices for obwAmp
%             tto{2} = tto{1};
% 
%             ttz{1} = tto{1}; % ttz is indices for zAmp
%             ttz{2} = tto{1};

            ttsf{1} = 1:length([in.e(1).s.timcont]); % ttsf is indices for sumfftAmp
            ttsf{2} = 1:length([in.e(2).s.timcont]);
    % Prepare the data without outliers

            % If we have removed outliers via KatieRemover, get the indices...    
            if ~isempty(in.idx) 
%                 tto{1} = in.idx(1).obwidx; tto{2} = in.idx(2).obwidx; % tto is indices for obwAmp
%                 ttz{1} = in.idx(1).zidx; ttz{2} = in.idx(2).zidx; % ttz is indices for zAmp
                ttsf{1} = in.idx(1).sumfftidx; ttsf{2} = in.idx(2).sumfftidx; % ttsf is indices for sumfftAmp
            end

clear lighttrim;
clear lighttimeslesslong;
clear lighttimesidx;
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
for k = 1:length(lighttimes)
    lighttimes(k) = floor(lighttimes(k))*3600;
end
%% define data by lighttimes

%Make a time base that starts and ends on lighttimes 
    %necessary to define length of data
    xx = [in.ch(channel).xx];
    idx = find(xx >= lighttimes(1) & xx <= lighttimes(end));
    xx = xx(idx);

    sumfftyy = [in.ch(channel).sumfftAmpyy];
    sumfftyy = sumfftyy(idx);

   

%% Define trial period

    % How many trials available?
    lengthofsampleHOURS = lighttimes(end) - lighttimes(1); 
    %lengthofsampleHOURS = timcont(end) - timcont(1); 
    % How many integer trials in dataset
    numotrials = floor(lengthofsampleHOURS / triallength); % of trials


%% Divide data into trials


%KatieRegular data

for jj = 1:numotrials
    
    
             
            % Get the index for the start of the current period (xx is time)
            Stimidx = find(xx >= xx(1) + ((jj-1) * triallength), 1);
            % Get the rest of the indices for the trial  
            Stimidx = Stimidx:Stimidx + (triallength*ReFs)-1;
            
            if length(sumfftyy) >= Stimidx(end)
             % Data   
             %out(jj).SobwAmp = fftyy(Stimidx);
%              out(jj).SzAmp = zyy(Stimidx);
             out(jj).SsumfftAmp = sumfftyy(Stimidx);
             
             % Time  
             out(jj).Stimcont = xx(Stimidx) - xx(Stimidx(1)); % Time starting at zero  
             out(jj).Sentiretimcont = xx(Stimidx);
            end
    
    
end
%above copied from KatieTrialTrendDessembler

%% divide trials into days


    for jj = length(out):-1:1 % For each trial
        

        % Divide by daylength to get the number of days in the trial
        howmanydaysintrial = floor(triallength / (ld*2));
        % This is the number of sample in a day
        howmanysamplesinaday = ld * 2 * ReFs;

        for k = 1:howmanydaysintrial % Each day in a trial


            % Get the index of the start time of the trial
            dayidx = find(out(jj).Stimcont > (k-1) * (ld*2), 1) -1; % k-1 so that we start at zero

            % Get the datums
            %trial(jj).day(k).SobwAmp = out(jj).SobwAmp(dayidx:dayidx+howmanysamplesinaday-1);
%             trial(jj).day(k).SzAmp = out(jj).SzAmp(dayidx:dayidx+howmanysamplesinaday-1);
            trial(jj).day(k).SsumfftAmp = out(jj).SsumfftAmp(dayidx:dayidx+howmanysamplesinaday-1);
%             
               trial(jj).ld = ld; 

           

        end
            % Make a time sequence for the datums (easier than extracting from
            % xx...)
            trial(jj).tim = 1/ReFs:1/ReFs:howmanysamplesinaday/ReFs;

    end
    
%% Divide sample into days to compare against trial day means

howmanydaysinsample = floor(lengthofsampleHOURS / (ld*2));

tim = 1/ReFs:1/ReFs:howmanysamplesinaday/ReFs;
%spline data

for k = 1:howmanydaysinsample
    

    %         % Get the index of the start time of the day
                dayidx = find(xx >= xx(1) + (k-1) * (ld*2) & xx < xx(1) + k*(ld*2)); % k-1 so that we start at zero

                if length(dayidx) >= howmanysamplesinaday
%                 day(k).SobwAmp = obwyy(dayidx);
%                 day(k).SzAmp = zyy(dayidx);
                day(k).Ssumfftyy = sumfftyy(dayidx);
                day(k).tim = tim;
                end
 end
 
 %% plot to check

 %trials across tims
 figure(26); clf; title('trials across time');  hold on;
 
    for jj = 1:length(out)
        
        plot(out(jj).Sentiretimcont, out(jj).SsumfftAmp, '-', 'LineWidth', 3);
        
    end
    
    for j = 1:length(lighttimes)
        
        plot([lighttimes(j), lighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
    end
    
 
 clear mday;
 
 %all days
 %average day by trial
 figure(27); clf; hold on; title('Day average by trial');
    for jj=1:length(trial) 

        %create temporary vector to calculate mean by trial
        mday(jj,:) = zeros(1, length(trial(jj).tim));


        for k=1:length(trial(jj).day)

                %fill temporary vector with data from each day 
                mday(jj,:) = mday(jj,:) + trial(jj).day(k).SsumfftAmp;
                subplot(211); hold on; title('Days');
                plot(trial(jj).tim, trial(jj).day(k).SsumfftAmp);
                plot([ld ld], ylim, 'k-', 'LineWidth', 1);

        end

         % To get average across days, divide by number of days
            mday(jj,:) = mday(jj,:) / length(trial(jj).day);
            subplot(212); hold on; title('Day average by trial');
            plot(trial(jj).tim, mday(jj,:), '-', 'Linewidth', 1);
            plot([ld ld], ylim, 'k-', 'LineWidth', 1);

    end
    
    % Mean of means
 
    subplot(212); hold on;
     meanofmeans = mean(mday); % Takes the mean of the means for a day from each trial 
    plot(trial(jj).tim, meanofmeans, 'k-', 'LineWidth', 3);
    

   
    
figure(28); clf; hold on; 

clear meanday;

 for k = 1:length(day)
        plot(day(k).tim, day(k).Ssumfftyy);
        meanday(k,:) = day(k).Ssumfftyy;
 end
    
        mmday= mean(meanday);
        plot(day(1).tim, mmday, 'k-', 'LineWidth', 3);
        plot([ld ld], ylim, 'k-', 'LineWidth', 1);
        
figure(29); clf; hold on;
    plot(day(1).tim, mmday);
    plot(trial(jj).tim, meanofmeans);
    plot([ld ld], ylim, 'k-', 'LineWidth', 1);
    legend('day mean', 'trial mean');
     legend('boxoff')
% 
% 
