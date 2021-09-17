function [out, trial] = KatieDessembler1(in, orgidx)     
% Usage: out = KatieDessembler(in(orgidx), orgidx)
% Example: out = KatieDessembler(in(orgidx), orgidx)
% And out is something...

% define sample range
    perd = 48; % default length is 48 hours
    perd = perd - rem(perd, in.info.ld);  % If not integer divisible, take fewer samples to not go over     
    
    perdsex = perd * 60 * 60; % perd in seconds, for convenience since timcont is in seconds

    % How many trials available?
    lengthofsampleHOURS = (in.e(1).s(end).timcont/(60*60)) - (in.e(1).s(1).timcont/(60*60));    
    % How many integer trials in dataset
    numoperiods = floor(lengthofsampleHOURS / perd); % of periods

% Construct splines and get lightimes

ReFs = 10;  % Sample rate for splines

[xx(1,:), obwyy(1,:), zyy(1,:), sumfftyy(1,:), lighttimes] = makeSplines(in, 1, ReFs);
[xx(2,:), obwyy(2,:), zyy(2,:), sumfftyy(2,:), ~] = makeSplines(in, 2, ReFs);

% Make a time base that starts and ends on lighttimes     

    timcont = [in.e(1).s.timcont] / (60*60);
    timcont = timcont(timcont >= lighttimes(1) & timcont < lighttimes(end));
    
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld



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
    
    
%% Make trials from the spline data

for jj = 1:numoperiods
    
    for j = 1:2
        
            timidx = find(xx(j,:) > xx(j,1) + ((jj-1) * perd) & ...
               xx(j,:) < xx(j,1) + (jj * perd));
           
             % Data   
             out(jj).e(j).SobwAmp = obwyy(j,timidx);
             out(jj).e(j).SzAmp = zyy(j,timidx);
             out(jj).e(j).SsumfftAmp = sumfftyy(j,timidx);
             
             % Time  
             out(jj).e(j).Stimcont = xx(j,timidx) - xx(j,timidx(1));          
           
    end
    
end

figure(3); clf;  

    maxlen = 0;

    for k= 1:length(out) 
        xax(1) = subplot(211); hold on;
        plot(out(k).e(1).Stimcont, out(k).e(1).SobwAmp, '.'); 
        xax(2) = subplot(212); hold on;
        plot(out(k).e(2).Stimcont, out(k).e(2).SobwAmp, '.'); 
        
        maxlen = max([maxlen out(k).e(1).Stimcont(end)]);        
    end

    linkaxes(xax, 'x'); xlim([0 maxlen]);

%% Make days from spline trials 

for jj = length(out):-1:1 % For each trial
    
    howmanydaysintrial = floor(perd / (ld*2));
    howmanysamplesinaday = ld * 2 * ReFs;
    
    for k = 0:howmanydaysintrial-1 % Each day in a trial

        for j = 1:2 % Electrodes
        
        dayidx = find(out(jj).e(j).Stimcont > howmanydaysintrial*k*ld*2, 1);            
        trial(jj).day(k+1).e(j).SobwAmp = out(jj).e(j).SobwAmp(dayidx:dayidx+howmanysamplesinaday-1);
        
        end
        
    end

    trial(jj).tim = ReFs:ReFs:howmanysamplesinaday*howmanysamplesinaday;
    
end
