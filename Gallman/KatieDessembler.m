function trial  = KatieDessembler(in, Fs)

           
        
        
%% divide into trials of 48 hours

for j = 1:2 % Perform analyses on the two channels     
    
    numotrials = ([in(j).s.timcont]/(60*60))/48 + 1;
    
    
    for jj = 1:length(numotrials)-1

             %divide into trial of 48 hours
             trialwindowidx = [in(j).s.timcont]/(60*60) >= numotrials(jj) & [in(j).s.timcont]/(60*60) < numotrials(jj+1);

             %amplitude data
             trial(jj).in(j).s(:).obwAmp = [in(j).s(trialwindowidx).obwAmp];
             trial(jj).in(j).s(:).zAmp = [in(j).s(trialwindowidx).zAmp];
             trial(jj).in(j).s(:).zAmp = [in(j).s(trialwindowidx).zAmp];
             
             %variables
             trial(jj).in(j).s.timcont = [in(j).s(trialwindowidx).timcont];
             trial(jj).in(j).s.light = [in(j).s(trialwindowidx).light];
             trial(jj).in(j).s.temp = [in(j).s(trialwindowidx).temp];
             
             
             
    end

end       
        

 
 
 
 
    
        
        
        
        
        
         
    