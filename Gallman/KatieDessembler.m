function trial  = KatieDessembler(in, Fs)
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


        
        
%% divide into trials of 48 hours

for j = 1:2 % Perform analyses on the two channels     
    
    numotrials = ([in(j).s.timcont]/(60*60))/48 + 1;
    
    
    for jj = 1:length(numotrials)-1

             %divide into trial of 48 hours
             trialwindowidx = [in(j).s.timcont]/(60*60) >= numotrials(jj) & [in(j).s.timcont]/(60*60) < numotrials(jj+1);

             trial(jj).in(j).s.readydata = [in(j).s(trialwindowidx).normdata4analysis];
             trial(jj).in(j).s.timcont = [in(j).s(trialwindowidx).timcont];
             trial(jj).in(j).s.light = [in(j).s(trialwindowidx).light];
             trial(jj).in(j).s.temp = [in(j).s(trialwindowidx).temp];
             
             
             for k = 1:length([trial(jj).in(j).s.readydata])
                % OBW
                [~,~,~,trial(jj).in(j).s(k).obwAmp] = obw([trial(jj).in(j).s(k).readydata], Fs, [botFreqOBW topFreqOBW]);
                % zAmp
                trial(jj).in(j).s(k).zAmp = k_zAmp([trial(jj).in(j).s(k).readydata]);
                % FFT Machine
                [ trial(jj).in(j).s(k).fftFreq,  trial(jj).in(j).s(k).peakfftAmp,  trial(jj).in(j).s(k).sumfftAmp] = k_fft([trial(jj).in(j).s(k).readydata], Fs); 
             end

    end

end       
        

 
 
 
 
    
        
        
        
        
        
         
    