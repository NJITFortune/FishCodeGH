function out  = KatieConcatAssembler(userfilespec, Fs, numstart)
% This function reads the original data collection files
% It filters the data and saves it into a single structure
% Performs these analyses: OBW, zAMP
% Relies on k_zAmp, k_FindMaxWindow, k_fft
%
% Usage: kg(#).e = KatieAssembler(userfilespec, Fs, numstart)
%

% This should not change, but if for some reason...
tempchan = 3; % Either 4 or 3
lightchan = 4; % Either 5 or 4

%daycount = 0;


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

out(1).s(length(iFiles)).Fs = Fs;
out(1).s(length(iFiles)).name = [];
        
        
%% CYCLE THROUGH EVERY FILE IN DIRECTORY

    ff = waitbar(0, 'Cycling through files.');

for k = 1:length(iFiles)
       
     waitbar(k/length(iFiles), ff, 'Assembling', 'modal');

    
       % LOAD THE DATA FILE
        load(iFiles(k).name, 'data', 'tim');
        out(1).s(k).Fs = 1 / (tim(2)-tim(1)); % Extract the sample rate
        out(2).s(k).Fs = out(1).s(k).Fs;
        
       % Filter data  
          
            data(:,1) = filtfilt(b,a, data(:,1)); % High pass filter
            data(:,1) = filtfilt(f,e, data(:,1)); % Low pass filter   
            
            data(:,2) = filtfilt(b,a, data(:,2)); % High pass filter
            data(:,2) = filtfilt(f,e, data(:,2)); % Low pass filter   

        % Add time stamps (in seconds) relative to computer midnight (COMES FROM THE FILENAME)
                
                monstart = 12;
        
                month = str2double(iFiles(k).name(monstart:monstart+1));
                day = str2double(iFiles(k).name(monstart+3:monstart+4));
                year = str2double(iFiles(k).name(monstart+6:monstart+9));
                
                hour = str2double(iFiles(k).name(numstart:numstart+1));        %numstart based on time stamp text location
                minute = str2double(iFiles(k).name(numstart+3:numstart+4));
                second = str2double(iFiles(k).name(numstart+6:numstart+7));
                
                
           
            
       % PICK YOUR WINDOW - THIS IS A CRITICAL STEP THAT MAY NEED REVISION

        for j = 1:2 % Perform analyses on the two channels
        
            % [~, idx] = max(abs(data(:,j))); % FIND THE MAXIMUM
            [out(j).s(k).startim, ~] = k_FindMaxWindow(data(:,j), tim, SampleWindw);
            data4analysis = data(tim > out(j).s(k).startim & tim < out(j).s(k).startim+SampleWindw, j);            
            
            % ANALYSES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % OBW
            [~,~,~,out(j).s(k).obwAmp] = obw(data4analysis, Fs, [botFreqOBW topFreqOBW]);
            % zAmp
            out(j).s(k).zAmp = k_zAmp(data4analysis);
            % FFT Machine
            [out(j).s(k).fftFreq, out(j).s(k).peakfftAmp, out(j).s(k).sumfftAmp] = k_fft(data4analysis, Fs); 
        
      
            out(j).s(k).light = mean(data(:,lightchan));
            out(j).s(k).temp = mean(data(:,tempchan));
    
        %datetime    
        out(j).s(k).timcont = datetime(year, month, day, hour, minute, second);    
        %out(j).s(k).timcont = datenum(year, month, day, hour, minute, second);
        out(j).s(k).tim24 = (hour*60*60) + (minute*60) + second;
        
                
        end 
                        
end

        pause(1); close(ff); % ff is the waitbar
        

 
 
 
 
    
        
        
        
        
        
         
    