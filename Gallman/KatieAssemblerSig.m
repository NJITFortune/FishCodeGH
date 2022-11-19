function out  = KatieAssemblerSig(userfilespec, numstart, sigfreq)
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
tempstate = 5;

daycount = 0; %necessary to create time vector

%for normalization against max Amp
% preAmp  = KatiepreAssembler(userfilespec);
% 
%     maxamp(1) = max(preAmp(1).amp);
%     maxamp(2) = max(preAmp(2).amp);
% 
%    if isfield(preAmp, 'idx') 
%        out.maxampidx = maxAmp(1).idk;
%    end


%% SET UP 
% Get the list of files to be analyzed  
        iFiles = dir(userfilespec);

% Get sample frequency
        load(iFiles(1).name, 'tim');
        Fs = 1 / (tim(2) - tim(1));
        clear tim
               
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
        botFreqOBW = 200;

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
          
            filtdata(:,1) = filtfilt(b,a, data(:,1)); % High pass filter
            filtdata(:,1) = filtfilt(f,e, filtdata(:,1)); % Low pass filter   
            
            filtdata(:,2) = filtfilt(b,a, data(:,2)); % High pass filter
            filtdata(:,2) = filtfilt(f,e, filtdata(:,2)); % Low pass filter   

        % Add time stamps (in seconds) relative to computer midnight (COMES FROM THE FILENAME)
 
                hour = str2double(iFiles(k).name(numstart:numstart+1));        %numstart based on time stamp text location
                minute = str2double(iFiles(k).name(numstart+3:numstart+4));
                second = str2double(iFiles(k).name(numstart+6:numstart+7));
                
            if k > 1 && ((hour*60*60) + (minute*60) + second) < out(2).s(k-1).tim24
                   daycount = daycount + 1;
            end
            
       % PICK YOUR WINDOW - THIS IS A CRITICAL STEP THAT MAY NEED REVISION

        for j = 1:2 % Perform analyses on the two channels
        
            % FIND THE MAXIMUM
            % find the 250ms window where the amplitude is greatest 
            [out(j).s(k).startim, ~] = k_FindMaxWindow(filtdata(:,j), tim, SampleWindw);
            data4analysis = filtdata(tim > out(j).s(k).startim & tim < out(j).s(k).startim+SampleWindw, j);   
            %normalization step - subtract mean and divide by maximum
            data4analysis = (data4analysis - mean(data4analysis));

            %shift data so that it always starts and ends on the same phase
                    %find the first zero crossing
                    z = zeros(1,length(data4analysis)); %create vector length of data
                    z(data4analysis > 0) = 1; %fill with 1s for all filtered data greater than 0
                    z = diff(z); %subtract the X(2) - X(1) to find the positive zero crossings
                    posZs = find(z == 1); 
                    newidx = find(tim >= tim(posZs(1)) & tim <= tim(posZs(end)));

           data4analysis = data4analysis(newidx);
           
            % ANALYSES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %exclude noisy data
            fft = fftmachine(data(:,j), Fs);
             sig = find(fft.fftfreq > 200 & fft.fftfreq < 800);
             noise = find(fft.fftfreq < 100);

         %if Noise > Signal
            if max(fft.fftdata(sig))/max(fft.fftdata(noise)) < 1 
                %obw 
                out(j).s(k).bw = -0.1; out(j).s(k).flo = -0.1; out(j).s(k).fhi = -0.1;
                out(j).s(k).obwAmp = -0.1;
                %zAmp
                out(j).s(k).zAmp = -0.1;
                %fftmachine
                out(j).s(k).fftFreq = -0.1; out(j).s(k).inputsig = -0.1;
                out(j).s(k).peakfftAmp = -0.1; out(j).s(k).sumfftAmp = -0.1;
                
            else
            
            % OBW
            [~,~,~,out(j).s(k).obwAmp] = obw(data4analysis, Fs, [botFreqOBW topFreqOBW]);
            % zAmp
            out(j).s(k).zAmp = k_zAmp(data4analysis);
            % FFT Machine
            [out(j).s(k).fftFreq, out(j).s(k).peakfftAmp, out(j).s(k).sumfftAmp, out(j).s(k).inputsig] = k_fftplussig(data4analysis, Fs, sigfreq); 
            end
      
            out(j).s(k).light = mean(data(:,lightchan));
            out(j).s(k).temp = mean(data(:,tempchan));
            out(j).s(k).tempsate = mean(data(:,tempstate));
    
            
        % There are 86400 seconds in a day.
        out(j).s(k).timcont = (hour*60*60) + (minute*60) + second + (daycount*86400) ;
        out(j).s(k).tim24 = (hour*60*60) + (minute*60) + second;
       
        
        end
        
end

        pause(1); close(ff);
        

 
 
 
 
    
        
        
        
        
        
         
    