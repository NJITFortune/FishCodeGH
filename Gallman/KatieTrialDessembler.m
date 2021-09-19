function out = KatieTrialDessembler(in, channel)  

% Out is raw data, trial is spline data
%% Take spline estimate of raw data

ReFs = 10;  % Sample rate for splines

[xx, obwyy, zyy, sumfftyy, lighttimes] = makeSplines(in,channel, ReFs);


% Make a time base that starts and ends on lighttimes 
    %necessary to compare spline with raw data

    timcont = [in.e(1).s.timcont] / (60*60);
    timcont = timcont(timcont >= lighttimes(1) & timcont < lighttimes(end));
    
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld
%% Define trial period

% define sample range
    perd = 48; % default length is 48 hours
    %perd = perd - rem(perd, in.info.ld);  % If not integer divisible, take fewer samples to not go over     
    % How many trials available?
    lengthofsampleHOURS = timcont(end) - timcont(1);    
    % How many integer trials in dataset
    numotrials = floor(lengthofsampleHOURS / perd); % of trials

%% Divide data into trials

%raw data

for jj = 1:numotrials
    
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
             %out(jj).kg = orgidx; % idx for kg
             
            end

end   


%spline data

for jj = 1:numotrials
    
    for j = 1:2
             
            % Get the index for the start of the current period (xx is time)
            timidx = find(xx(j,:) > xx(j,1) + ((jj-1) * perd), 1);
            % Get the rest of the indices for the trial  
            timidx = timidx:timidx + (perd*ReFs)-1;
            
            if length(obwyy(j,:)) >= timidx(end)
             % Data   
             out(jj).e(j).SobwAmp = obwyy(j,timidx);
             out(jj).e(j).SzAmp = zyy(j,timidx);
             out(jj).e(j).SsumfftAmp = sumfftyy(j,timidx);
             
             % Time  
             out(jj).e(j).Stimcont = xx(j,timidx) - xx(j,timidx(1)); % Time starting at zero          
            end
    end
    
end

%% Plot to check



