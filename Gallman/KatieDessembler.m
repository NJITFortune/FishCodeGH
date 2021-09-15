function out = KatieDessembler(in)     
% Usage: out = KatieDessembler(in)
% where in = kg(#)
% And out is something...

%% Setup

    perd = 48; % default length is 48 hours
    perd = perd - rem(perd, in.info.ld);       
    
    perdsex = perd * 60 * 60; % perd in seconds, for convenience since timcont is in seconds

    % How many samples available?
    lengthofsampleHOURS = (in.e(1).s(end).timcont/(60*60)) - (in.e(1).s(1).timcont/(60*60));    
    % How many integer periods
    numoperiods = floor(lengthofsampleHOURS / perd); % of periods
    
    timz = 1:1:numoperiods;
    %generate new 12 hour light vector
    twoday(timz) = [in.e(1).s(1).timcont]/(60*60) + (48*(timz-1)); 

%% divide into trials 
    
        for jj = 1:numoperiods
    
            % indices for our sample window of perd hours
            timidx = find([in.e(1).s.timcont] > in.e(1).s(1).timcont + ((jj-1)*perdsex) & ...
                [in.e(1).s.timcont] < in.e(1).s(1).timcont + (jj*perdsex));
            
            for j = 1:2
            
             % Data   
             out(jj).e(j).obwAmp = [in.e(j).s(timidx).obwAmp];
             out(jj).e(j).zAmp = [in.e(j).s(timidx).zAmp];
             out(jj).e(j).sumfftAmp = [in.e(j).s(timidx).sumfftAmp];
             out(jj).e(j).fftFreq = [in.e(j).s(timidx).fftFreq];
             
             % Time and treatment 
             out(jj).e(j).timcont = [in.e(j).s(timidx).timcont];
             out(jj).e(j).timstart = in.e(j).s(timidx(1)).timcont;
             out(jj).e(j).light = [in.e(j).s(timidx).light];
             out(jj).e(j).temp = [in.e(j).s(timidx).temp];
             
             
            end

        end     


        

 
 
 
 
    
        
        
        
        
        
         
    