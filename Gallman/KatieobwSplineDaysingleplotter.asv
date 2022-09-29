%function [trial] = KatiefftDayTrialDessembler(in, channel,  ReFs, light)
%% usage
%[trial, day] = KatieDayTrialDessembler(kg(#), channel, triallength, ReFs)

%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4
clearvars -except hkg 
% 
in = hkg(2);
channel = 1;
ReFs = 10;
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

%entire data set
%[xx, obwyy, ~, ~, lighttimes] = k_detrendspliner(in,channel, ReFs);

[xx, sumfftyy, lighttimes] =  k_obwabovespliner(in, channel, ReFs, light);

%% Prepare raw data variables

%Make a time base that starts and ends on lighttimes 
    %necessary to define length of data
    timcont = [in.e(1).s.timcont] / (60*60);
    timcont = timcont(timcont >= lighttimes(1) & timcont <= lighttimes(end));


%% Define trial period

    % How many trials available?
    lengthofsampleHOURS = lighttimes(end) - lighttimes(1); 
    %lengthofsampleHOURS = timcont(end) - timcont(1); 
    % How many integer trials in dataset
    numotrials = floor(lengthofsampleHOURS / triallength); % of trials


%% Divide data into trials

%raw data

for jj = 1:numotrials
    
%             % indices for our sample window of perd hours
%             timidx = find(timcont >= timcont(1) + ((jj-1)*perd) & ...
%                timcont < timcont(1) + (jj*perd));

            j = channel;
           
                %timcont needs to have the same indicies as the rest of the
                %data
            % indices for our sample window of perd hours
            timidx = find(timcont >= lighttimes(1) + ((jj-1)*triallength) & ...
            timcont < lighttimes(1) + (jj*triallength));


%             % Get the index for the start of the current period (xx is time)
%             timidx = find(timcont > timcont(1) + ((jj-1) * perd), 1);
%             % Get the rest of the indices for the trial  
%             timidx = timidx:timidx + (perd*ReFs)-1;
            
         
            
           
             % Data   
             %out(jj).obwAmp = [in.e(j).s(timidx).obwAmp];
%              out(jj).zAmp = [in.e(j).s(timidx).zAmp];
             out(jj).sumfftAmp = [in.e(j).s(timidx).sumfftAmp];
%              out(jj).fftFreq = [in.e(j).s(timidx).fftFreq];
             
             % Time and treatment 
             out(jj).timcont = timcont(timidx) - timcont(timidx(1)); %+1
             out(jj).entiretimcont = timcont(timidx);
%              out(jj).light = [in.e(j).s(timidx).light];
%              out(jj).temp = [in.e(j).s(timidx).temp];
             
             out(jj).ld = in.info.ld; 
             %out(jj).kg = orgidx; % idx for kg
             
           

end   


%spline data

for jj = 1:numotrials
    
    
             
            % Get the index for the start of the current period (xx is time)
            Stimidx = find(xx > xx(1) + ((jj-1) * triallength), 1);
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
        
        ld = out(jj).ld;

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
               trial(jj).ld = in.info.ld; 

           

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
        
        plot(out(jj).entiretimcont, out(jj).sumfftAmp, '.', 'MarkerSize', 3);
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
