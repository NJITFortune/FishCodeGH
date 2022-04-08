%function [trial] = KatiefftDayTrialDessembler(in, channel,  ReFs, light)
%% usage
%[trial, day] = KatieDayTrialDessembler(kg(#), channel, triallength, ReFs)
%
%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4


%for when i'm too lazy to function
clearvars -except kg kg2

in = kg(5);
channel = 1;
ReFs = 60;
light = 3;

%% prep

% define length of trial
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld

 
if in.info.ld > 15 
    triallength = in.info.ld * 2;
else
    triallength = in.info.ld * 4;
end


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

    [xx, sumfftyy] = metamucil(timcont, sumfft);


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

        if light == 3 %we start with dark
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

    idx = find(xx >= lighttimes(1) & xx <= lighttimes(end));
    xx = xx(idx);
    sumfftyy = sumfftyy(idx);


%% Define trials and days

 %trial
   triallengthSECS = triallength * 3600;
    % How many trials in sample?
    lengthofsampleHOURS = (lighttimes(end) - lighttimes(1)) / 3600; 
    % How many integer trials in dataset
    numotrials = floor(lengthofsampleHOURS / triallength); % of trials
    % How many samples in a trial
    samplesinatrial = floor(triallengthSECS/ReFs);
    

 %day
    daylengthSECONDS = (ld*2) * 3600;
    % Divide by daylength to get the number of days in the trial
        howmanydaysintrial = floor(triallength / (ld*2));
        % This is the number of sample in a day
        howmanysamplesinaday = floor(daylengthSECONDS / ReFs);
        %how many days total
        howmanydaysinsample = (floor(lengthofsampleHOURS / (ld*2)));

%% Divide data into trials


%KatieRegular data

for jj = 1:numotrials
    
             
            % Get the index for the start of the current period (xx is time)
            Stimidx = find(xx > xx(1) + ((jj-1) * triallengthSECS), 1);
            % Get the rest of the indices for the trial  
            Stimidx = Stimidx:Stimidx + samplesinatrial;
            
            if length(sumfftyy) >= Stimidx(end)
             % Data   
             out(jj).SsumfftAmp = sumfftyy(Stimidx);
             
             % Time  
             out(jj).Stimcont = xx(Stimidx) - xx(Stimidx(1)); % Time starting at zero  
             out(jj).Sentiretimcont = xx(Stimidx);
            end
    
    
end
%above copied from KatieTrialTrendDessembler

%% divide trials into days


    for jj = length(out):-1:1 % For each trial
        
        for k = 1:howmanydaysintrial % Each day in a trial


            % Get the index of the start time of the trial
            dayidx = find(out(jj).Stimcont > (k-1) * (ld*2*3600), 1) -1; % k-1 so that we start at zero

            % Get the datums
            trial(jj).day(k).SsumfftAmp = out(jj).SsumfftAmp(dayidx:dayidx+howmanysamplesinaday-1);
%             
               trial(jj).ld = ld; 

           

        end
            % Make a time sequence for the datums (easier than extracting from
            % xx...)
%            trial(jj).tim = 1/ReFs:1/ReFs:howmanysamplesinaday/ReFs;
            trial(jj).tim = 1/ReFs:1/ReFs:(ld*2);

    end
    
%% Divide sample into days to compare against trial day means

%tim = 1/ReFs:1/ReFs:howmanysamplesinaday/ReFs;
tim = 1/ReFs:1/ReFs:(ld*2);
%spline data

for k = 1:howmanydaysinsample
    

    %         % Get the index of the start time of the day
                ddayidx = find(xx >= xx(1) + (k-1) * daylengthSECONDS & xx < xx(1) + k* daylengthSECONDS); % k-1 so that we start at zero

                if length(ddayidx) >= howmanysamplesinaday %important so that we know when to stop

                    day(k).Ssumfftyy = sumfftyy(ddayidx);
                    day(k).tim = tim;
                    
                end
 end
 
 %% plot to check

 %change back to hours because my brain doesnt think in seconds

 %trials across time - check division with lighttimes 
 figure(26); clf; title('trials across time');  hold on;
 
    for jj = 1:length(out)
        
        plot(out(jj).Sentiretimcont/3600, out(jj).SsumfftAmp, '.', 'LineWidth', 3);
        
    end
    
    for j = 1:length(lighttimes)
        
        plot([lighttimes(j)/3600, lighttimes(j)/3600], ylim, 'k-', 'LineWidth', 0.5);
    end
    

 
 %all days
 %average day by trial
 figure(27); clf; hold on; title('Day average by trial');
    for jj=1:length(trial) 

        %create temporary vector to calculate mean by trial
        mday(jj,:) = zeros(1, length(trial(jj).tim));


        for k=1:length(trial(jj).day)

                %fill temporary vector with data from each day 
                mday(jj,:) = mday(jj,:) + trial(jj).day(k).SsumfftAmp;

                %plot every day 
                subplot(211); hold on; title('Days');
                plot(trial(jj).tim, trial(jj).day(k).SsumfftAmp);
                plot([ld ld], ylim, 'k-', 'LineWidth', 1);

        end

         % To get average across days, divide by number of days
            mday(jj,:) = mday(jj,:) / length(trial(jj).day);

            %plot day average by trial
            subplot(212); hold on; title('Day average by trial');
            plot(trial(jj).tim, mday(jj,:), '-', 'Linewidth', 1);
            plot([ld ld], ylim, 'k-', 'LineWidth', 1);

    end
    
    % Mean of means
    meanofmeans = nanmean(mday); % Takes the mean of the means for a day from each trial 

    %plot average of days across trials
    subplot(212); hold on;
    plot(trial(jj).tim, meanofmeans, 'k-', 'LineWidth', 3);
    

   
%plot averages for days without trial division 
figure(28); clf; hold on; 


     for k = 1:length(day)
            plot(day(k).tim, day(k).Ssumfftyy);
            meanday(k,:) = day(k).Ssumfftyy;
     end
        
            mmday= nanmean(meanday);
            plot(day(1).tim, mmday, 'k-', 'LineWidth', 3);
            plot([ld ld], ylim, 'k-', 'LineWidth', 3);
 
%compare day mean calculations            
figure(29); clf; hold on;
    plot(day(1).tim, mmday);
    plot(trial(jj).tim, meanofmeans);
    plot([ld ld], ylim, 'k-', 'LineWidth', 3);
    legend('day mean', 'trial mean');
     legend('boxoff')
% 
% 
