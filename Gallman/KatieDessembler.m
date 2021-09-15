function out = KatieDessembler(in)     
        
%% Setup

    perd = 48; % default length is 48 hours
    if rem(perd, kg.info.ld) ~= 0
        
    end


    lengthofsample = (in(1).s(end).timcont/(60*60)) - ([in(1).s(1).timcont]/(60*60));
    
    numoperiods = 1 + ceil(lengthofsample / 48); % of periods
    timz = 1:1:numoperiods;
    %generate new 12 hour light vector
    twoday(timz) = [in(1).s(1).timcont]/(60*60) + (48*(timz-1)); 




%% divide into trials of 48 hours


    
    
        for jj = 1:length(numoperiods)-1
    
for j = 1:2
             %divide into trial of 48 hours
             trialwindowidx = [in(j).s.timcont]/(60*60) >= twoday(jj) & [in(j).s.timcont]/(60*60) < twoday(jj+1);

             %amplitude data
             out(jj).e(j).obwAmp = [in(j).s(trialwindowidx).obwAmp];
             out(jj).e(j).zAmp = [in(j).s(trialwindowidx).zAmp];
             out(jj).e(j).sumfftAmp = [in(j).s(trialwindowidx).sumfftAmp];
             out(jj).e(j).fftFreq = [in(j).s(trialwindowidx).fftFreq];
             
             %variables
             out(jj).e(j).s(:).timcont = [in(j).s(trialwindowidx).timcont];
             out(jj).e(j).s(:).light = [in(j).s(trialwindowidx).light];
             out(jj).e(j).s(:).temp = [in(j).s(trialwindowidx).temp];
             
             
        end

end     


        

 
 
 
 
    
        
        
        
        
        
         
    