function trial  = KatieDessembler(in)

           
        
        
%% divide into trials of 48 hours

for j = 1:2 % Perform analyses on the two channels     
    
    numoperiods = ([in(j).s.timcont]/(60*60))/48 + 1;
    
    
    for jj = 1:length(numoperiods)-1

             %divide into trial of 48 hours
             trialwindowidx = [in(j).s.timcont]/(60*60) >= numoperiods(jj) & [in(j).s.timcont]/(60*60) < numoperiods(jj+1);

             %amplitude data
             trial(jj).e(j).s.obwAmp = [in(j).s(trialwindowidx).obwAmp];
             trial(jj).e(j).s.zAmp = [in(j).s(trialwindowidx).zAmp];
             trial(jj).e(j).s.sumfftAmp = [in(j).s(trialwindowidx).sumfftAmp];
             trial(jj).e(j).s.fftFreq = [in(j).s(trialwindowidx).fftFreq];
             
             %variables
             trial(jj).e(j).s.timcont = [in(j).s(trialwindowidx).timcont];
             trial(jj).e(j).s.light = [in(j).s(trialwindowidx).light];
             trial(jj).e(j).s.temp = [in(j).s(trialwindowidx).temp];
             
             
    end

end       
        

 
 
 
 
    
        
        
        
        
        
         
    