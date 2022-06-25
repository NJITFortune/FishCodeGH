function maxAmp  = KatiepreAssembler(userfilespec)
% This function reads the original data collection files
% It filters the data and saves it into a single structure
% Performs these analyses: OBW, zAMP
% Relies on k_zAmp, k_FindMaxWindow, k_fft
%
% Usage: kg(#).e = KatieAssembler(userfilespec, Fs, numstart)
%



%% SET UP 
% Get the list of files to be analyzed  
        iFiles = dir(userfilespec);
        load(iFiles(1).name, 'tim');
            Fs = 1 / (tim(2) - tim(1));
            clear tim
               
% Set up filters
        % High pass filter cutoff frequency
            highp = 200; %200
            [b,a] = butter(5, highp/(Fs/2), 'high'); % Filter to eliminate 60Hz contamination
        % Low pass filter cutoff frequency
            lowp = 1200;    %2000
            [f,e] = butter(5, lowp/(Fs/2), 'low'); % Filter to eliminate high frequency contamination
                    
% How much of the sample that we will use (each sample is 1 second)  
% This is important because the fish moves
        SampleWindw = 0.250; % 250 ms window
             
        
%% CYCLE THROUGH EVERY FILE IN DIRECTORY

    ff = waitbar(0, 'Cycling through files.');

for k = 791%1:length(iFiles) %1417:2600 %1836 %1579

     waitbar(k/length(iFiles), ff, 'Assembling', 'modal');
        
        
    
       % LOAD THE DATA FILE
        load(iFiles(k).name, 'data', 'tim');
        
       % Filter data  
          
            data(:,1) = filtfilt(b,a, data(:,1)); % High pass filter
            data(:,1) = filtfilt(f,e, data(:,1)); % Low pass filter   
            
            data(:,2) = filtfilt(b,a, data(:,2)); % High pass filter
            data(:,2) = filtfilt(f,e, data(:,2)); % Low pass filter   

    
            
       % PICK YOUR WINDOW - THIS IS A CRITICAL STEP THAT MAY NEED REVISION

        for j = 1:2 % Perform analyses on the two channels
        
            [startim, ~] = k_FindMaxWindow(data(:,j), tim, SampleWindw);
            data4analysis = data(tim > startim & tim < startim+SampleWindw, j);            
            
            % ANALYSES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
%             % OBW
%             [~,~,~,out(j).s(k).obwAmp] = obw(data4analysis, Fs, [botFreqOBW topFreqOBW]);
%             % zAmp
%             out(j).s(k).zAmp = k_zAmp(data4analysis);
            % FFT Machine
            maxAmp(j).amp(k) = max(abs(data4analysis - mean(data4analysis))); 

            %for the times we have too many outliers for max calculation
            if length(k) < 2
                maxAmp(j).idk = k;
            end
        end
        
end

        pause(1); close(ff);

        
        

 
 
 
 
    
        
        
        
        
        
         
    