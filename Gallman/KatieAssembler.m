function out  = KatieAssembler(userfilespec, Fs)
% This function reads the original data collection files
% It filters the data and saves it into a single structure
% Performs these analyses: OBW, zAMP


%% SET UP 
% Get the list of files to be analyzed  
        iFiles = dir(userfilespec);
               
% Set up filters
        % High pass filter cutoff frequency
            highp = 200;
            [b,a] = butter(5, highp/(Fs/2), 'high'); % Filter to eliminate 60Hz contamination
        % Low pass filter cutoff frequency
            lowp = 2000;    
            [f,e] = butter(5, lowp/(Fs/2), 'low'); % Filter to eliminate high frequency contamination
                    
% How much of the sample that we will use (each sample is 1 second)  
% This is important because the fish moves
        SampleWindw = 0.250; % 250 ms window
        
% Fish limit frequencies for OBW calculation (unlikely to be changed)
        topFreqOBW = 800;
        botFreqOBW = 300;
        
%% CYCLE THROUGH EVERY FILE IN DIRECTORY
        
for k = length(iFiles):-1:1
        
       % LOAD THE DATA FILE
        load(iFiles(k).name, 'data', 'tim');
        out(k).Fs = 1 / (tim(2)-tim(1)); % Extract the sample rate
        
       % Filter data  
          
            data(:,1) = filtfilt(b,a, data(:,1)); % High pass filter
            data(:,1) = filtfilt(f,e, data(:,1)); % Low pass filter   
            
            data(:,2) = filtfilt(b,a, data(:,2)); % High pass filter
            data(:,2) = filtfilt(f,e, data(:,2)); % Low pass filter   

        % PICK YOUR WINDOW - THIS IS A CRITICAL STEP THAT MAY NEED REVISION

        for j = 1:2 % For the two channels
        
            % [~, idx] = max(abs(data(:,j))); % FIND THE MAXIMUM
            [startim, startidx] = k_FindMaxWindow(data(:,j), tim, out(k).Fs, SampleWindw);
            
            maxtim(j) = tim(idx);
            %place the peak amplitude in the middle of the new sample time window
            startim(j) = max([0, maxtim(j)-(SampleWindw/2)]); 
                %if the peak is near the end of the sample, need to just take the last windw 
                if startim(j)+(SampleWindw/2) > tim(end)
                   startim(j) = tim(end) - SampleWindw;
                end
            %create subsample time index by defining sample duration
            %sampidx = find(tim > startim(j) & tim < startim(j)+windw); 
            
            % Take data from the time window defined by startim for each
            % channel
            tmpdat = data(tim > startim(j) & tim < startim(j)+SampleWindw, dataChans(j));            
            
            
            [~,~,~,out(k).obwAmp(j)] = obw(data(sampidx,dataChans(1)), Fs, [botFreqOBW topFreqOBW]);
        
        out(k).Ch1obwAmp = kg_obw
        
        end
end
    