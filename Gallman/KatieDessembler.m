function out = KatieDessembler(in)

           
        
        
%% divide into trials of 48 hours

for j = 1:2
    
    numoperiods = (ceil([in(1).s(end).timcont]/(60*60)) / 48) + 1;
    timz = 1:1:numoperiods;
    %generate new 12 hour light vector
    twoday(timz) = [in(1).s(1).timcont]/(60*60) + (48*(timz-1)); 
    
        for jj = 1:length(numoperiods)-1
    

             %divide into trial of 48 hours
             trialwindowidx = [in(j).s.timcont]/(60*60) >= twoday(jj) & [in(j).s.timcont]/(60*60) < twoday(jj+1);

             %amplitude data
             out.e(j).s.obwAmp = [in(j).s(trialwindowidx).obwAmp];
             out(jj).e(j).s.zAmp = [in(j).s(trialwindowidx).zAmp];
             out(jj).e(j).s.sumfftAmp = [in(j).s(trialwindowidx).sumfftAmp];
             out(jj).e(j).s.fftFreq = [in(j).s(trialwindowidx).fftFreq];
             
             %variables
             out(jj).e(j).s(:).timcont = [in(j).s(trialwindowidx).timcont];
             out(jj).e(j).s(:).light = [in(j).s(trialwindowidx).light];
             out(jj).e(j).s(:).temp = [in(j).s(trialwindowidx).temp];
             
             
        end

end       
        

 
 
 
 
    
        
        
        
        
        
         
    