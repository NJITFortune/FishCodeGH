function out = KatieDessembler1(in, orgidx)     
% Usage: out = KatieDessembler(in(orgidx), orgidx)
% Example: out = KatieDessembler(in(orgidx), orgidx)
% And out is something...

%define sample range
    perd = 48; % default length is 48 hours
    perd = perd - rem(perd, in.info.ld);  % If not integer divisible, take fewer samples to not go over     
    
    perdsex = perd * 60 * 60; % perd in seconds, for convenience since timcont is in seconds

    % How many trials available?
    lengthofsampleHOURS = (in.e(1).s(end).timcont/(60*60)) - (in.e(1).s(1).timcont/(60*60));    
    % How many integer trials in dataset
    numoperiods = floor(lengthofsampleHOURS / perd); % of periods

% Construct splines and get lightimes

[xx1, obwyy1, zyy1, sumfftyy1, lighttimes] = makeSplines(in, 1);
[xx2, obwyy2, zyy2, sumfftyy2, ~] = makeSplines(in, 2);

% Make a time base that starts and ends on lighttimes     

    timcont = [in.e(1).s.timcont] / (60*60);
    timcont = timcont(timcont >= lighttimes(1) & timcont < lighttimes(end));
    

%% Cycle to chop raw data into trials  

for jj = 1:numoperiods
    
            % indices for our sample window of perd hours
            timidx = find(timcont > timcont(1) + ((jj-1)*perd) & ...
               timcont < timcont(1) + (jj*perd));
            
            for j = 1:2
            
             % Data   
             out(jj).e(j).obwAmp = [in.e(j).s(timidx).obwAmp];
             out(jj).e(j).zAmp = [in.e(j).s(timidx).zAmp];
             out(jj).e(j).sumfftAmp = [in.e(j).s(timidx).sumfftAmp];
             out(jj).e(j).fftFreq = [in.e(j).s(timidx).fftFreq];
             
             % Time and treatment 
             out(jj).e(j).timcont = [in.e(j).s(timidx).timcont] - in.e(j).s(timidx(1)).timcont + 1;
             out(jj).e(j).light = [in.e(j).s(timidx).light];
             out(jj).e(j).temp = [in.e(j).s(timidx).temp];
             
             out(jj).ld = in.info.ld; 
             out(jj).kg = orgidx; % idx for kg
             
            end

end     
        
%% Plot raw trial data

figure(2); clf;  

    maxlen = 0;

    for k= 1:length(out) 
        ax(1) = subplot(211); hold on;
        plot(out(k).e(1).timcont/3600, out(k).e(1).obwAmp, '.'); 
        ax(2) = subplot(212); hold on;
        plot(out(k).e(2).timcont/3600, out(k).e(2).obwAmp, '.'); 
        
        maxlen = max([maxlen out(k).e(1).timcont(end)/3600]);        
    end

    linkaxes(ax, 'x'); xlim([0 maxlen]);

%% Make days so we can plot raw data by days 

% This is not necessary.  
    
    

for jj = 1:numoperiods
    
    startperdidx = find(xx1 >= xx1(1)
    
    
end

