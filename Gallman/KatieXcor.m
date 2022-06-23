%function [day] = KatieRegfftDayDessembler(in, channel,  ReFs, light)
%% usage
%[trial, day] = KatieDayTrialDessembler(kg(#), channel, triallength, ReFs)
%
%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4


% % %for when i'm too lazy to function
clearvars -except kg kg2
% % % 
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

%% regularize data across time in ReFs second intervals

    %raw data
    timcont = [in.e(channel).s(ttsf{channel}).timcont];
    sumfft = [in.e(channel).s(ttsf{channel}).sumfftAmp];

    %data above spline
    [subffttim, subfft, ~, lighttimes] =  k_fftabovespline(in, timcont, sumfft, ReFs, light); %squiggle is the spline for plotting

    %regularize data to ReFs interval
    [xx, regsumfft] = k_regularmetamucil(subffttim, subfft, ReFs);

    %create new luz vector trimmed to lighttimes
    %dark transistions are negative 
    for j = 1:length(lighttimes)
        if light < 4 %if we start with a dark transition
            if mod(j, 2) == 1 %if j is odd
                newluz(j) = -lighttimes(j);
            else
                newluz(j) = lighttimes(j);
            end
        else %if we start with a light transition
            if mod(j, 2) == 0 %iff j is even
                newluz(j) = -lighttimes(j);
            else
                newluz(j) = lighttimes(j);
            end
    
        end
    end

%% create square pulse for lighttimes
tim = ReFs:ReFs:(ld)*3600;
%day
    lightlengthSECONDS = ld * 3600;  
    lengthofsampleHOURS = (lighttimes(end) - lighttimes(1)) / 3600; 
    % This is the number of sample in a day
    howmanysamplesinalighttime = floor(lightlengthSECONDS / ReFs);

    %initialize light vector of zeros length of amp data
    luzsquare = zeros(1, length(regsumfft));
    for k = 1:length(lighttimes)
        
                  %resampled data  
        %         % Get the index of the start time of the day
                    lightidx = find(xx > lighttimes(1) + (k-1) * lightlengthSECONDS & xx <= lighttimes(1) + k* lightlengthSECONDS); % k-1 so that we start at zero
    
                   %fill vector with ones with the lights were on to make square wave 
                   if newluz(k) > 0
                       luzsquare(lightidx) = 1;
                   else
                       luzsquare(lightidx) = 0;
                   end
    
    
    end

%plot to check coding
figure(86); clf; hold on;
    plot(xx, regsumfft);
    plot(xx, luzsquare);

%% xcorr
figure(34);clf; hold on;
    [c,lags] = xcorr(regsumfft,luzsquare);
    
    plot(lags/3600,c)
    plot([0, 0], ylim)








