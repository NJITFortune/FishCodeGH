%function [out, trial] = KatieDessembler1(in, orgidx)     
% Usage: [out, trial] = KatieDessembler(in(orgidx), orgidx)
% Example: [out, trial] = KatieDessembler(kg(1), 1)
% Out is raw data, trial is spline data
%% Take spline estimate of raw data

clearvars -except kg

in = kg(32);

ld = in.info.ld; % Whatever - ld is shorter than in.info.ld
ReFs = 10;  % Sample rate for splines

for j = 1:2
[xx(j, :), obwyy(j, :), zyy(j, :), sumfftyy(j, :), lighttimes] = k_spliner(in,j, ReFs);
end

%lighttimes = abs(luztimes(1,:));
lighttimes
%add back the light time we subtracted 
%lighttimes(end +1) = lighttimes(end) + ld;

% Make a time base that starts and ends on lighttimes 
    %necessary to compare spline with raw data

    timcont = [in.e(1).s.timcont] / (60*60);
    timcont = timcont(timcont >= lighttimes(1) & timcont < lighttimes(end));
    

%% Define trial period

% define sample range
    perd = 48; % default length is 48 hours
    %perd = perd - rem(perd, in.info.ld);  % If not integer divisible, take fewer samples to not go over     
    % How many trials available?
    lengthofsampleHOURS = timcont(end) - timcont(1);    
    % How many integer trials in dataset
    numotrials = floor(lengthofsampleHOURS / perd); % of trials


%% Cycle to chop raw data into trials  

for jj = 1:numotrials
    
            % indices for our sample window of perd hours
            timidx = find(timcont > timcont(1) + ((jj-1)*perd) & ...
               timcont < timcont(1) + (jj*perd));
            
            for j = 1:2
            
             % Data   
             out(jj).e(j).obwAmp = [in.e(j).s(timidx).obwAmp];
             out(jj).e(j).zAmp = [in.e(j).s(timidx).zAmp];
             out(jj).e(j).sumfftAmp = [in.e(j).s(timidx).sumfftAmp];
             out(jj).e(j).fftFreq = [in.e(j).s(timidx).fftFreq];
             
             % Time and treatment 
             out(jj).e(j).timcont = [in.e(j).s(timidx).timcont] - in.e(j).s(timidx(1)).timcont + 1;
             out(jj).e(j).light = [in.e(j).s(timidx).light];
             out(jj).e(j).temp = [in.e(j).s(timidx).temp];
             
             out(jj).ld = in.info.ld; 
             %out(jj).kg = orgidx; % idx for kg
             
            end

end     
        
%% Plot raw trial data

figure(2); clf;  

    maxlen = 0;

    for k= 1:length(out) 
        ax(1) = subplot(211); hold on;
        plot(out(k).e(1).timcont/3600, out(k).e(1).obwAmp, '.'); 
        ax(2) = subplot(212); hold on;
        plot(out(k).e(2).timcont/3600, out(k).e(2).obwAmp, '.'); 
        
        maxlen = max([maxlen out(k).e(1).timcont(end)/3600]);        
    end

    linkaxes(ax, 'x'); xlim([0 maxlen]);
    subplot(211); title('Raw data for each trial');

%% Make days so we can plot raw data by days 

% This is not necessary.  
    
    
%% Make trials from the spline data

for jj = 1:numotrials
    
    for j = 1:2
             
            % Get the index for the start of the current period (xx is time)
            timidx = find(xx(j,:) > xx(j,1) + ((jj-1) * perd), 1);
            % Get the rest of the indices for the trial  
            timidx = timidx:timidx + (perd*ReFs)-1;
            
            if length(obwyy(j,:)) >= timidx(end)
             % Data   
             out(jj).e(j).SobwAmp = obwyy(j,timidx);
             out(jj).e(j).SzAmp = zyy(j,timidx);
             out(jj).e(j).SsumfftAmp = sumfftyy(j,timidx);
             
             % Time  
             out(jj).e(j).Stimcont = xx(j,timidx) - xx(j,timidx(1)); % Time starting at zero          
            end
    end
    
end

figure(3); clf; 

    maxlen = 0;

    for k= 1:length(out) 
        xax(1) = subplot(211); hold on;
        plot(out(k).e(1).Stimcont, out(k).e(1).SobwAmp, '.'); 
        xax(2) = subplot(212); hold on;
        plot(out(k).e(2).Stimcont, out(k).e(2).SobwAmp, '.'); 
        
        maxlen = max([maxlen out(k).e(1).Stimcont(end)]);        
    end

    linkaxes(xax, 'x'); xlim([0 maxlen]);
    subplot(211); title('Splines for each trial');

%% Make days from spline trials 

for jj = length(out):-1:1 % For each trial
    
    % Divide by daylength to get the number of days in the trial
    howmanydaysintrial = floor(perd / (ld*2));
    % This is the number of sample in a day
    howmanysamplesinaday = ld * 2 * ReFs;
    
    for k = 1:howmanydaysintrial % Each day in a trial

        for j = 1:2 % Electrodes
        
        % Get the index of the start time of the trial
        dayidx = find(out(jj).e(j).Stimcont > (k-1) * (ld*2), 1) -1; % k-1 so that we start at zero
        
        % Get the datums
        trial(jj).day(k).e(j).SobwAmp = out(jj).e(j).SobwAmp(dayidx:dayidx+howmanysamplesinaday-1);
        trial(jj).day(k).e(j).SzAmp = out(jj).e(j).SzAmp(dayidx:dayidx+howmanysamplesinaday-1);
        trial(jj).day(k).e(j).SsumfftAmp = out(jj).e(j).SsumfftAmp(dayidx:dayidx+howmanysamplesinaday-1);
        
        end
        
    end
        % Make a time sequence for the datums (easier than extracting from
        % xx...)
        trial(jj).tim = 1/ReFs:1/ReFs:howmanysamplesinaday/ReFs;
    
end

% Plot all days
figure(27); clf; 
for j=1:length(trial) 
    
    mday1(j,:) = zeros(1,length(trial(j).tim));
    mday2(j,:) = zeros(1,length(trial(j).tim));
    
    for k=1:length(trial(j).day)
        
        subplot(211); hold on;
            tmpnormdata = trial(j).day(k).e(1).SobwAmp - min(trial(j).day(k).e(1).SobwAmp); % set floor to zero
            tmpnormdata = tmpnormdata / max(tmpnormdata); % set max to 1
            mday1(j,:) = mday1(j,:) + tmpnormdata;
            
            plot(trial(j).tim, tmpnormdata);
            
            
        subplot(212); hold on;
            tmpnormdata = trial(j).day(k).e(2).SobwAmp - min(trial(j).day(k).e(2).SobwAmp); % set floor to zero
            tmpnormdata = tmpnormdata / max(tmpnormdata); % set max to 1
            mday2(j,:) = mday2(j,:) + tmpnormdata;
            
            plot(trial(j).tim, tmpnormdata); 
    end
    
     % To get average across days, divide by number of days
        mday1(j,:) = mday1(j,:) / length(trial(j).day);
        subplot(211); hold on;
        plot(trial(j).tim, mday1(j,:), 'k-', 'Linewidth', 1);
        
        mday2(j,:) = mday2(j,:) / length(trial(j).day);
        subplot(212); hold on;
        plot(trial(j).tim, mday2(j,:), 'k-', 'Linewidth', 1);
    
    
end
subplot(211); title('Every day cycle');


% Plot means of trials
figure(28); clf; 

for j=1:length(trial) 
    
    subplot(211); hold on; title('channel 1');
        mtrial1(j,:) = zeros(1,length(trial(j).tim));
        for k=1:length(trial(j).day)
            % Normalize 0 to 1
            tmpnormdata = trial(j).day(k).e(1).SobwAmp - min(trial(j).day(k).e(1).SobwAmp); % set floor to zero
            tmpnormdata = tmpnormdata / max(tmpnormdata); % set max to 1
            
            % add current day to previous day(s)
            mtrial1(j,:) = mtrial1(j,:) + tmpnormdata;
        end
        % To get average across days, divide by number of days
        mtrial1(j,:) = mtrial1(j,:) / length(trial(j).day);
        plot(trial(j).tim, mtrial1(j,:));
        
    subplot(212); hold on; title('channel 2');
        mtrial2(j,:) = zeros(1,length(trial(j).tim));
        for k=1:length(trial(j).day)
            % Normalize 0 to 1
            tmpnormdata = trial(j).day(k).e(2).SobwAmp - min(trial(j).day(k).e(2).SobwAmp); % set floor to zero
            tmpnormdata = tmpnormdata / max(tmpnormdata); % set max to 1
            
            % add current day to previous day(s)
            mtrial2(j,:) = mtrial2(j,:) + tmpnormdata;
        end
        % To get average across days, divide by number of days
        mtrial2(j,:) = mtrial2(j,:) / length(trial(j).day);
        plot(trial(j).tim, mtrial2(j,:));
end

% Mean of means
 subplot(211); hold on; 
    meanofmeans1 = mean(mtrial1); % Takes the mean of the means for a day from each trial 
    plot(trial(j).tim, meanofmeans1, 'k', 'LineWidth', 3);
 subplot(212); hold on;
     meanofmeans2 = mean(mtrial2); % Takes the mean of the means for a day from each trial 
    plot(trial(j).tim, meanofmeans2, 'k', 'LineWidth', 3);
    
    
figure(27); hold on;
subplot(211); hold on; 
    meanofmeans1 = mean(mtrial1); % Takes the mean of the means for a day from each trial 
    plot(trial(j).tim, meanofmeans1, 'k', 'LineWidth', 3);
 subplot(212); hold on;
     meanofmeans2 = mean(mtrial2); % Takes the mean of the means for a day from each trial 
    plot(trial(j).tim, meanofmeans2, 'k', 'LineWidth', 3);




