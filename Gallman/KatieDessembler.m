function out  = KatieDessembler(in)
% This function reads the original data collection files
% It filters the data and saves it into a single structure
% Performs these analyses: OBW, zAMP
% Relies on k_zAmp, k_FindMaxWindow, k_fft
%
% Usage: kg(#).e = KatieAssembler(userfilespec, Fs, numstart)
%

% This should not change, but if for some reason...

        
% Fish limit frequencies for OBW calculation (unlikely to be changed)
        topFreqOBW = 800;
        botFreqOBW = 300;


        
        
%% CYCLE THROUGH EVERY FILE IN DIRECTORY

    ff = waitbar(0, 'Cycling through files.');

    
    
for k = 1:length([in.s.timcont])
       
     waitbar(k/[in.s.timcont], ff, 'Assembling', 'modal');

    

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
    
            
        % There are 86400 seconds in a day.
        out(j).s(k).timcont = (hour*60*60) + (minute*60) + second + (daycount*86400) ;
        out(j).s(k).tim24 = (hour*60*60) + (minute*60) + second;
        
        end
        
end

        pause(1); close(ff);
        

 
 
 
 
    
        
        
        
        
        
         
    