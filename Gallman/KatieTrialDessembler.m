%function out = KatieTrialDessembler(in, channel)  
clearvars -except kg

in = kg(8);
channel = 1;
% Out is raw data, trial is spline data
%% Take spline estimate of raw data

ReFs = 10;  % Sample rate for splines
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld


[xx, obwyy, zyy, sumfftyy, lighttimes] = k_spliner(in,channel, ReFs);

% lighttimes = abs(luztimes);
% %add back the light time we subtracted 
% lighttimes(end +1) = lighttimes(end) + ld;

% Make a time base that starts and ends on lighttimes 
    %necessary to compare spline with raw data

    timcont = [in.e(1).s.timcont] / (60*60);
    timcont = timcont(timcont >= lighttimes(1) & timcont <= lighttimes(end));
    timcont(1)

%% Define trial period

% define sample range
    perd = 48; % default length is 48 hours
    %perd = perd - rem(perd, in.info.ld);  % If not integer divisible, take fewer samples to not go over     
    % How many trials available?
    lengthofsampleHOURS = timcont(end) - timcont(1);    
    % How many integer trials in dataset
    numotrials = floor(lengthofsampleHOURS / perd); % of trials

%testing timidx
timz = 1:1:numotrials+1;
%generate new  light vector
    triallength(timz) = lighttimes(1) + (perd*(timz-1)); 


%% Divide data into trials

%raw data

for jj = 1:numotrials
    
            % indices for our sample window of perd hours
            timidx = find(timcont >= timcont(1) + ((jj-1)*perd) & ...
               timcont < timcont(1) + (jj*perd));

%             % Get the index for the start of the current period (xx is time)
%             timidx = find(timcont > timcont(1) + ((jj-1) * perd), 1);
%             % Get the rest of the indices for the trial  
%             timidx = timidx:timidx + (perd*ReFs)-1;
            
            j = channel;
            
           
             % Data   
             out(jj).obwAmp = [in.e(j).s(timidx).obwAmp];
             out(jj).zAmp = [in.e(j).s(timidx).zAmp];
             out(jj).sumfftAmp = [in.e(j).s(timidx).sumfftAmp];
             out(jj).fftFreq = [in.e(j).s(timidx).fftFreq];
             
             % Time and treatment 
             out(jj).timcont = [in.e(j).s(timidx).timcont] - in.e(j).s(timidx(1)).timcont; %+1
             out(jj).entiretimcont = [in.e(j).s(timidx).timcont];
             out(jj).light = [in.e(j).s(timidx).light];
             out(jj).temp = [in.e(j).s(timidx).temp];
             
             out(jj).ld = in.info.ld; 
             %out(jj).kg = orgidx; % idx for kg
             
           

end   


%spline data

for jj = 1:numotrials
    
    
             
            % Get the index for the start of the current period (xx is time)
            Stimidx = find(xx > xx(1) + ((jj-1) * perd), 1);
            % Get the rest of the indices for the trial  
            Stimidx = Stimidx:Stimidx + (perd*ReFs)-1;
            
            if length(obwyy) >= Stimidx(end)
             % Data   
             out(jj).SobwAmp = obwyy(Stimidx);
             out(jj).SzAmp = zyy(Stimidx);
             out(jj).SsumfftAmp = sumfftyy(Stimidx);
             
             % Time  
             out(jj).Stimcont = xx(Stimidx) - xx(Stimidx(1)); % Time starting at zero  
             out(jj).Sentiretimcont = xx(Stimidx);
            end
    
    
end

%% Plot to check
%raw data

figure(48); clf; title('spline vs raw data');hold on; 

 
   % maxlen = 0;

    for k = 1:length(out) 
      
        plot(out(k).entiretimcont/3600 , out(k).obwAmp, '.'); 
        plot(out(k).Sentiretimcont, out(k).SobwAmp, 'k-', 'LineWidth', 3); 
        
       % maxlen = max([maxlen out(k).entiretimcont/3600]);        
    end

     %xlim([0 maxlen]);
     
figure(49); clf;  


 
   maxlen = 0;

    for k = 1:length(out) 
       
      subplot(211); hold on; title('spline vs raw data');
         plot(out(k).timcont/3600, out(k).obwAmp, '.'); 
        
      subplot(212); hold on; title('spline vs trial data');
        plot(out(k).Stimcont, out(k).SobwAmp, '.', 'MarkerSize', 3); 
        
        maxlen = max([maxlen out(k).timcont(end)/3600]);        
    end

     xlim([0 maxlen]);
   


% figure(49); clf; 
% 
%      for k = 1:length(out) 
%          
%         subplot(211); hold on; title('spline vs light');
%         
%          subplot(212); hold on; title('spline vs trial light');
%     

