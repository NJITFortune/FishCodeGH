function [trial] = KatiefftDayTrialDessembler(in, channel,  ReFs, light)
%% usage
%[trial, day] = KatieDayTrialDessembler(kg(#), channel, triallength, ReFs)

%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4
clearvars -except kg kg2
% 
in = kg(127);
    %113,114,115
channel = 2;
ReFs = 60;
light = 3;

%% prep

% define length of trial
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld

%define length of trial by daylength
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
    halfdayinseconds = (ld/2)*3600;
 %   xx = (lighttimes(1)-ld/2):1/ReFs:(lighttimes(end)-ld/2);

%% define data by lighttimes

%Make a time base that starts and ends on lighttimes 
    %necessary to define length of data

    idx = find(xx >= lighttimes(1)-halfdayinseconds & xx <= lighttimes(end)-halfdayinseconds);
    xx = xx(idx);
    sumfftyy = sumfftyy(idx);


%% Define trials and days

 %trial
   triallengthSECS = triallength * 3600;
    % How many trials in sample?
    lengthofsampleHOURS = (xx(end) - xx(1)) / 3600; 
    % How many integer trials in dataset
    numotrials = floor(lengthofsampleHOURS / triallength); % of trials
    % How many samples in a trial
    samplesinatrial = floor(triallengthSECS/ReFs);
    

 %day
    daylengthSECONDS = (ld) * 3600;
    % Divide by daylength to get the number of days in the trial
        howmanydaysintrial = floor(triallength / (ld));
        % This is the number of sample in a day
        howmanysamplesinaday = floor(daylengthSECONDS / ReFs);
        %how many days total
        howmanydaysinsample = (floor(lengthofsampleHOURS / (ld)));


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



%% divide trials into days


    for jj = length(out):-1:1 % For each trial
        
        for k = 1:howmanydaysintrial % Each day in a trial


            % Get the index of the start time of the trial
            dayidx = find(out(jj).Stimcont > (k-1) * (ld*3600), 1) -1; % k-1 so that we start at zero

            % Get the datums
            trial(jj).day(k).SsumfftAmp = out(jj).SsumfftAmp(dayidx:dayidx+howmanysamplesinaday-1);
%             
               trial(jj).ld = ld; 

          
        end
            % Make a time sequence for the datums (easier than extracting from
            % xx...)
%            trial(jj).tim = 1/ReFs:1/ReFs:howmanysamplesinaday/ReFs;
            trial(jj).tim = 1/ReFs:1/ReFs:(ld);
            
    end
    length(trial(end).tim)
    length(trial(end).day(end).SsumfftAmp)

%% Divide sample into days to compare against trial day means

%tim = 1/ReFs:1/ReFs:howmanysamplesinaday/ReFs;
tim = 1/ReFs:1/ReFs:(ld);
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

darkpulse = ld/2;
lightreturn = darkpulse + 1;

 %trials across tims
 figure(26); clf; title('trials across time');  hold on;
 
    for jj = 1:length(out)
        
        plot(out(jj).Sentiretimcont/3600, out(jj).SsumfftAmp, '-', 'LineWidth', 3);
        
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


        for k = 1:length(trial(jj).day)

                %fill temporary vector with data from each day 
                mday(jj,:) = mday(jj,:) + trial(jj).day(k).SsumfftAmp;

                subplot(211); hold on; title('Days');
                    plot(trial(jj).tim, trial(jj).day(k).SsumfftAmp);
                    plot([darkpulse, darkpulse], ylim, 'k-', 'LineWidth', 1);
                    plot([lightreturn, lightreturn], ylim, 'm-', 'LineWidth', 1);
           

        end

         % To get average across days, divide by number of days
            mday(jj,:) = mday(jj,:) / length(trial(jj).day);
            subplot(212); hold on; title('Day average by trial');
            plot(trial(jj).tim, mday(jj,:), '-', 'Linewidth', 1);
            %lightlines
            plot([darkpulse, darkpulse], ylim, 'k-', 'LineWidth', 1);
            plot([lightreturn, lightreturn], ylim, 'm-', 'LineWidth', 1);
          
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
        %lightlines
         plot([darkpulse, darkpulse], ylim, 'k-', 'LineWidth', 1);
         plot([lightreturn, lightreturn], ylim, 'm-', 'LineWidth', 1);
        

        
figure(29); clf; hold on;
    plot(day(1).tim, mmday);
    plot(trial(jj).tim, meanofmeans);
    %lightlines
    plot([darkpulse, darkpulse], ylim, 'k-', 'LineWidth', 1);
    plot([lightreturn, lightreturn], ylim, 'm-', 'LineWidth', 1);
  
    legend('day mean', 'trial mean');
    legend('boxoff')
%% 
figure(30); clf; hold on; 

clear meanday;

 for k = 1:length(day)

        plot(day(k).tim, day(k).Ssumfftyy - day(k).Ssumfftyy(ceil(length(day(k).Ssumfftyy))/2));
        meanday(k,:) = day(k).Ssumfftyy;
 end
    
        mmday= mean(meanday);
        plot(day(1).tim, mmday, 'k-', 'LineWidth', 3);
        %lightlines
         plot([darkpulse, darkpulse], ylim, 'k-', 'LineWidth', 1);
         plot([lightreturn, lightreturn], ylim, 'm-', 'LineWidth', 1);
         plot(xlim, [0, 0], 'k-', 'LineWidth', 1);
        
