function out = KatieTrialDessembler(in, channel)  

% Out is raw data, trial is spline data
%% Take spline estimate of raw data

ReFs = 10;  % Sample rate for splines
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld

[xx, obwyy, zyy, sumfftyy, luztimes] = makeSplines(in,channel, ReFs);

lighttimes = abs(luztimes);
%add back the light time we subtracted 
lighttimes(end +1) = lighttimes(end) + ld;

% Make a time base that starts and ends on lighttimes 
    %necessary to compare spline with raw data

    timcont = [in.e(1).s.timcont] / (60*60);
    timcont = timcont(timcont >= lighttimes(1) & timcont < lighttimes(end));
    

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
            
            j = channel;
            
             % Data   
             out(jj).e(j).obwAmp = [in.e(j).s(timidx).obwAmp];
             out(jj).e(j).zAmp = [in.e(j).s(timidx).zAmp];
             out(jj).e(j).sumfftAmp = [in.e(j).s(timidx).sumfftAmp];
             out(jj).e(j).fftFreq = [in.e(j).s(timidx).fftFreq];
             
             % Time and treatment 
             out(jj).e(j).timcont = [in.e(j).s(timidx).timcont] - in.e(j).s(timidx(1)).timcont; %+1
             out(jj).e(j).entiretimcont = [in.e(j).s(timidx).timcont];
             out(jj).e(j).light = [in.e(j).s(timidx).light];
             out(jj).e(j).temp = [in.e(j).s(timidx).temp];
             
             out(jj).ld = in.info.ld; 
             %out(jj).kg = orgidx; % idx for kg
             
           

end   


%spline data

for jj = 1:numotrials
    
    j = channel;
             
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
             out(jj).e(j).Sentiretimcont = xx(j,timidx);
            end
    
    
end

%% Plot to check
%raw data

figure(48); clf;  

 
    maxlen = 0;

    for k = 1:length(out) 
      subplot(211); hold on; title('spline vs raw data');
        plot(out(k).e(channel).entiretimcont/3600, out(k).e(channel).obwAmp, '.'); 
        plot(out(k).e(channel).Sentiretimcont, out(k).e(channel).SobwAmp, '.', 'MarkerSize', 3); 
        
      subplot(212); hold on; title('spline vs trial data');
        plot(out(k).e(channel).timcont/3600, out(k).e(channel).obwAmp, '.'); 
        plot(out(k).e(channel).Stimcont, out(k).e(channel).SobwAmp, '.', 'MarkerSize', 3); 
        
        maxlen = max([maxlen out(k).e(channel).timcont(end)/3600]);        
    end

    linkaxes(ax, 'x'); xlim([0 maxlen]);
   

%convert light data into squares

figure(49); clf; 

     for k = 1:length(out) 
         
        subplot(211); hold on; title('spline vs light');
        
         subplot(212); hold on; title('spline vs trial light');
    

