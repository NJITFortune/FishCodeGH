%function [trial] = KatieMultifftDayTrialDessembler(in, fishfreq, ReFs, light)
%% usage
%[trial, day] = KatieDayTrialDessembler(kg(#), channel, triallength, ReFs)

%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4

%fishfreq is a label for whether we want to take data from the high
%frequency fish or the low frequency fish
    %high freq = 1
    %low freq = 2

clearvars -except kg kg2

in = kg2(1);
ReFs = 10;
light = 3;
fishfreq = 1;


%% prep

% define length of trial 
if in.info.ld > 10 
    triallength = in.info.ld * 2;
else
    triallength = in.info.ld * 4;
end

%triallength

ld = in.info.ld; % Whatever - ld is shorter than in.info.ld

%% Take spline estimate of raw data

%entire data set
%[xx, obwyy, ~, ~, lighttimes] = k_detrendspliner(in,channel, ReFs);

%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4

figure(87); clf; hold on;

    if fishfreq < 2 %we are looking at data from the high frequency fish

        %get data
        [hixx, ~, HiAmp, HiTim, ~, ~, Hiyy, Hiuntyy,~, ~, Hilighttimes, ~] =  k_multifftsubspliner(in, ReFs, light);


        %Make a time base that starts and ends on lighttimes 
        %necessary to define length of raw data
        Hitimcont = HiTim(HiTim >= Hilighttimes(1) & HiTim <= Hilighttimes(end));
        HiAmp = HiAmp(HiTim >= Hilighttimes(1) & HiTim <= Hilighttimes(end));

        %plot spline fit without detrending to view accuracy
        plot(Hitimcont, HiAmp, '.', 'MarkerSize', 3);
        plot(hixx, Hiuntyy, '-', 'LineWidth', 2);
        for j = 1:length(Hilighttimes)
            plot([Hilighttimes(j), Hilighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
        end

    
    else %we are looking at data from the low frequency fish
    
        [~, loxx, ~, ~, LoAmp, LoTim, ~, ~, Loyy, Lountyy, ~, Lolighttimes] =  k_multifftsubspliner(in, ReFs, light);
    
        Lotimcont = LoTim(LoTim >= Lolighttimes(1) & LoTim <= Lolighttimes(end));
        LoAmp = LoAmp(LoTim >= Lolighttimes(1) & LoTim <= Lolighttimes(end));

        plot(Lotimcont, LoAmp, '.', 'MarkerSize', 3);
        plot(loxx, Lountyy,'-', 'LineWidth', 2);
        clear j;
        for j = 1:length(Lolighttimes)
            plot([Lolighttimes(j), Lolighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
        end

    end

 
%% Divide data into trials

if fishfreq < 2 %high frequency fish

 %define trial period   
 HilengthofsampleHOURS = Hilighttimes(end) - Hilighttimes(1); % How many trials available?
 Hinumotrials = floor(HilengthofsampleHOURS / triallength); %# of trials
    
    for jj = 1:Hinumotrials
        %raw data
                % indices for our sample window of perd hours
                Hitimidx = find(Hitimcont >= Hilighttimes(1) + ((jj-1)*triallength) & ...
                Hitimcont < Hilighttimes(1) + (jj*triallength));
             
                 % Data   
                 hout(jj).HifftAmp = HiAmp(Hitimidx);
                 
                 
                 % Time and treatment 
                 hout(jj).Hitimcont = Hitimcont(Hitimidx) - Hitimcont(Hitimidx(1)); %+1
                 hout(jj).Hientiretimcont = Hitimcont(Hitimidx);
                 
                 hout(jj).ld = in.info.ld;  

        %spline data
                % Get the index for the start of the current period (xx is time)
                HiStimidx = find(hixx > hixx(1) + ((jj-1) * triallength), 1);
                % Get the rest of the indices for the trial  
                HiStimidx = HiStimidx:HiStimidx + (triallength*ReFs)-1;
                
                if length(Hiyy) >= HiStimidx(end)
                 % Data   
                 hout(jj).HiSAmp = Hiyy(HiStimidx);
                 
                 % Time  
                 hout(jj).HiStimcont = hixx(HiStimidx) - hixx(HiStimidx(1)); % Time starting at zero  
                 hout(jj).HiSentiretimcont = hixx(HiStimidx);
                end
    
    
    end   

else 
    %low frequency fish

    %define trial period 
    LolengthofsampleHOURS = Lolighttimes(end) - Lolighttimes(1); % How many trials available
    % How many integer trials in dataset 
    Lonumotrials = floor(LolengthofsampleHOURS / triallength); % of trial

    clear jj;
    for jj = 1:Lonumotrials
        
        %raw data
                % indices for our sample window of perd hours
                Lotimidx = find(Lotimcont >= Lolighttimes(1) + ((jj-1)*triallength) & ...
                Lotimcont < Lolighttimes(1) + (jj*triallength));
             
                
                 % Data   
                 lout(jj).LofftAmp = LoAmp(Lotimidx);
                 
                 
                 % Time and treatment 
                 lout(jj).Lotimcont = Lotimcont(Lotimidx) - Lotimcont(Lotimidx(1)); %+1
                 lout(jj).Loentiretimcont = Lotimcont(Lotimidx);
                 
                 lout(jj).ld = in.info.ld;  

      
        %spline data
                % Get the index for the start of the current period (xx is time)
                LoStimidx = find(loxx > loxx(1) + ((jj-1) * triallength), 1);
                % Get the rest of the indices for the trial  
                LoStimidx = LoStimidx:LoStimidx + (triallength*ReFs)-1;
                
                if length(Loyy) >= LoStimidx(end)
                 % Data   
                 lout(jj).LoSAmp = Loyy(LoStimidx);
                 
                 % Time  
                 lout(jj).LoStimcont = loxx(LoStimidx) - loxx(LoStimidx(1)); % Time starting at zero  
                 lout(jj).LoSentiretimcont = loxx(LoStimidx);
                end
    
    end   
end

%% divide trials into days


if fishfreq < 2 %high frequency fish
    %high frequency fish
    clear jj;
        for jj = length(hout):-1:1 % For each trial
            
            ld = hout(jj).ld;
    
            % Divide by daylength to get the number of days in the trial
            howmanydaysintrial = floor(triallength / (ld*2));
            % This is the number of sample in a day
            howmanysamplesinaday = ld * 2 * ReFs;
    
            for k = 1:howmanydaysintrial % Each day in a trial
    
    
                % Get the index of the start time of the trial
                hidayidx = find(hout(jj).HiStimcont > (k-1) * (ld*2), 1) -1; % k-1 so that we start at zero
    
                % Get the datums
                %trial(jj).day(k).SobwAmp = out(jj).SobwAmp(dayidx:dayidx+howmanysamplesinaday-1);
    %             trial(jj).day(k).SzAmp = out(jj).SzAmp(dayidx:dayidx+howmanysamplesinaday-1);
                trial(jj).day(k).HiSAmp = hout(jj).HiSAmp(hidayidx:hidayidx+howmanysamplesinaday-1);
    %             
                   trial(jj).ld = in.info.ld; 
    
               
    
            end
                % Make a time sequence for the datums (easier than extracting from
                % xx...)
                trial(jj).tim = 1/ReFs:1/ReFs:howmanysamplesinaday/ReFs;
    
        end
        
else    
    %low frequency fish
    clear jj;
        for jj = length(lout):-1:1 % For each trial
            
            ld = lout(jj).ld;
    
            % Divide by daylength to get the number of days in the trial
            howmanydaysintrial = floor(triallength / (ld*2));
            % This is the number of sample in a day
            howmanysamplesinaday = ld * 2 * ReFs;
    
            for k = 1:howmanydaysintrial % Each day in a trial
    
    
                % Get the index of the start time of the trial
                lodayidx = find(hout(jj).HiStimcont > (k-1) * (ld*2), 1) -1; % k-1 so that we start at zero
    
                % Get the datums
                %trial(jj).day(k).SobwAmp = out(jj).SobwAmp(dayidx:dayidx+howmanysamplesinaday-1);
    %             trial(jj).day(k).SzAmp = out(jj).SzAmp(dayidx:dayidx+howmanysamplesinaday-1);
                trial(jj).day(k).LoSAmp = lout(jj).LoSAmp(lodayidx:lodayidx+howmanysamplesinaday-1);
    %             
                   trial(jj).ld = in.info.ld; 
    
               
    
            end
                % Make a time sequence for the datums (easier than extracting from
                % xx...)
                trial(jj).tim = 1/ReFs:1/ReFs:howmanysamplesinaday/ReFs;
    
        end

end    
    
 %% plot to check

 %trials across tims
 figure(26); clf; title('trials across time');  hold on;

 if fishfreq < 2 %high frequency fish
 
    clear jj;
    for jj = 1:length(hout)
        
        plot(hout(jj).Hientiretimcont, hout(jj).HifftAmp, '.', 'MarkerSize', 3);
        plot(hout(jj).HiSentiretimcont, hout(jj).HiSAmp, '-', 'LineWidth', 3);
        
    end
     clear j;
    for j = 1:length(Hilighttimes)
        
        plot([Hilighttimes(j), Hilighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
    end
 
 else %low frequecy fish 
    clear jj;
    for jj = 1:length(lout)
        
        plot(lout(jj).Loentiretimcont, lout(jj).LofftAmp, '.', 'MarkerSize', 3);
        plot(lout(jj).LoSentiretimcont, lout(jj).LoSAmp, '-', 'LineWidth', 3);
        
    end
     clear j;
    for j = 1:length(Lolighttimes)
        
        plot([Lolighttimes(j), Lolighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
    end

 end

 clear himday;

 if fishfreq < 2 %high frequency fish
 %all days
 %average day by trial
 %high frequency fish
 figure(27); clf;title('Day average by trial High frequency fish'); hold on; 
 clear jj;
    for jj=1:length(trial) 

        %create temporary vector to calculate mean by trial
        himday(jj,:) = zeros(1, length(trial(jj).tim));

        clear k;
        for k = 1:length(trial(jj).day)

                %fill temporary vector with data from each day 
                himday(jj,:) = himday(jj,:) + trial(jj).day(k).HiSAmp;
                subplot(211); hold on; title('Days');
                plot(trial(jj).tim, trial(jj).day(k).HiSAmp);
                plot([ld ld], ylim, 'k-', 'LineWidth', 1);

        end

         % To get average across days, divide by number of days
            himday(jj,:) = himday(jj,:) / length(trial(jj).day);
            subplot(212); hold on; title('Day average by trial hi frequency fish');
            plot(trial(jj).tim, himday(jj,:), '-', 'Linewidth', 1);
            plot([ld ld], ylim, 'k-', 'LineWidth', 1);

    end
    
    % Mean of means
 
    subplot(212); hold on;
     himeanofmeans = mean(himday); % Takes the mean of the means for a day from each trial 
    plot(trial(jj).tim, himeanofmeans, 'k-', 'LineWidth', 3);
 
 else

%low frequency fish
 figure(28); clf; title('Day average by trial Low frequency fish'); hold on; 
 clear jj;
    for jj=1:length(trial) 

        %create temporary vector to calculate mean by trial
        lomday(jj,:) = zeros(1, length(trial(jj).tim));

        clear k;
        for k = 1:length(lotrial(jj).day)

                %fill temporary vector with data from each day 
                lomday(jj,:) = lomday(jj,:) + trial(jj).day(k).LoSAmp;
                subplot(211); hold on; title('Days');
                plot(trial(jj).tim, trial(jj).day(k).LoSAmp);
                plot([ld ld], ylim, 'k-', 'LineWidth', 1);

        end

         % To get average across days, divide by number of days
            lomday(jj,:) = lomday(jj,:) / length(trial(jj).day);
            subplot(212); hold on; title('Day average by trial hi frequency fish');
            plot(trial(jj).tim, lomday(jj,:), '-', 'Linewidth', 1);
            plot([ld ld], ylim, 'k-', 'LineWidth', 1);

    end
    
    % Mean of means
 
    subplot(212); hold on;
     lomeanofmeans = mean(lomday); % Takes the mean of the means for a day from each trial 
    plot(trial(jj).tim, lomeanofmeans, 'k-', 'LineWidth', 3);
 end   
    
% figure(29); clf; title('trial day means for both fish'); hold on; 
% 
%     plot(hitrial(jj).tim, himeanofmeans);
%     plot(lotrial(jj).tim, lomeanofmeans);
%     plot([ld ld], ylim, 'k-', 'LineWidth', 1);
%     legend('high frequency fish', 'low frequency fish');
%      legend('boxoff')
% 
% 
