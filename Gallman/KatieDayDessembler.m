function day = KatieDayDessembler(in, channel, triallength, ReFs)
%% Take spline estimate of raw data

%ReFs = 10;  % Sample rate for splines
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld


[xx, obwyy, zyy, sumfftyy, lighttimes] = k_detrendspliner(in,channel, ReFs);

% lighttimes = abs(luztimes);
% %add back the light time we subtracted 
% lighttimes(end +1) = lighttimes(end) + ld;

%Make a time base that starts and ends on lighttimes 
    %necessary to define length of data

    timcont = [in.e(1).s.timcont] / (60*60);
    timcont = timcont(timcont >= lighttimes(1) & timcont <= lighttimes(end));
%     

%% Define trial period

% define sample range
perd = triallength;
    %perd = 48; % default length is 48 hours
    %perd = perd - rem(perd, in.info.ld);  % If not integer divisible, take fewer samples to not go over     
    % How many trials available?
    lengthofsampleHOURS = lighttimes(end) - lighttimes(1); 
    %lengthofsampleHOURS = timcont(end) - timcont(1); 
    % How many integer trials in dataset
    %numotrials = floor(lengthofsampleHOURS / perd); % of trials
    
    % Divide by daylength to get the number of days in the trial
        howmanydaysintrial = floor(perd / (ld*2));
        % This is the number of sample in a day
        howmanysamplesinaday = ld * 2 * ReFs;

% %testing timidx
% timz = 1:1:numotrials+1;
% %generate new  light vector
%     triallength(timz) = lighttimes(1) + (perd*(timz-1)); 


%% Divide data into days

%raw data
    for kk = 1:howmanysamplesinaday
        
       
                j = channel;
    %         % Get the index of the start time of the day
                dayidx = find(timcont > (kk-1) * (ld*2), 1) -1; % k-1 so that we start at zero
                
                timidx = find(timcont >= lighttimes(1) + (kk-1) * (ld*2) & timcont < lighttimes(1) + (kk) * (ld*2));

                day(kk).obwAmp = [in.e(j).s(timidx).obwAmp];
                day(kk).zAmp = [in.e(j).s(timidx).zAmp];
                day(kk).sumfft = [in.e(j).s(timidx).sumfftAmp];
                day(kk).timcont = timcont(timidx);
    end

%spline data
    for k = 1:howmanysamplesinaday

    %         % Get the index of the start time of the day
                dayidx = find(xx > xx(1) + (k-1) * (ld*2) & xx < xx(1) + kk*(ld*2)); % k-1 so that we start at zero

                day(k).SobwAmp = obwyy(dayidx);
                day(k).SzAmp = zyy(dayidx);
                day(k).Ssumfftyy = sumfftyy(dayidx);
                day(k).tim = xx(dayidx);
    end
    
    length(day(end).SobwAmp)
    length(day(end).tim)
    % Make a time sequence for the datums (easier than extracting from
            % xx...)
          %  day.tim = 1/ReFs:1/ReFs:howmanysamplesinaday/ReFs;



 %% plot to check

 %all days
    %spline
 figure(27); clf; hold on; title('Day average spline');
    


    for k = 1:length(day)
        mday(k,:) = zeros(1, length(day(k).tim));
        plot(day(k).tim, day(k).SobwAmp);
        mday(k,:) = mday(k,:) + day(k).SobwAmp;
    end
    
        mday(k,:) = mday(k,:) / length(day);
        plot(day(k).tim, mday(k,:), 'k-', 'LineWidth', 3);
 
        
 figure(28); clf; hold on; title('Day average raw');
    


    for k = 1:length(day)
        mday(k,:) = zeros(1, length(day(1).tim));
        plot(day(k).timcont, day(k).obwAmp);
        mday(k,:) = mday(k,:) + day(k).obwAmp;
    end
    
        mday(k,:) = mday(k,:) / length(day);
        plot(day(k).timcont, mday(k,:), 'k-', 'LineWidth', 3);
    
    
  