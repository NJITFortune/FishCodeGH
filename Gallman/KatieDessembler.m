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


        
        
%% divide into trials of 48 hours

for j = 1:2 % Perform analyses on the two channels     
    
    numotrials = ([in(j).s.timcont]/(60*60))/48 + 1;
    
    
    for jj = 1:length(numotrials)-1

             %divide into trial of 48 hours
             trialwindowidx = [in(j).s.timcont] >= numotrials(jj) & [in(j).s.timcont] < numotrials(jj+1);

             trial(jj).in(j).s.readydata = [in(j).s(trialwindowidx).normdata4analysis];
             
             for k = 1:length([trial(jj).in(j).s.readydata])
                 
             end

    end

end       
        

 
 
 
 
    
        
        
        
        
        
         
    