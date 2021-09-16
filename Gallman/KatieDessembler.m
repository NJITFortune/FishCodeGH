function out = KatieDessembler(in, orgidx)     
% Usage: out = KatieDessembler(in(orgidx), orgidx)
% Example: out = KatieDessembler(in(orgidx), orgidx)
% And out is something...

%% Setup

%define spline parameters
p = 0.7;
ReFs = 10;  %resample once every minute (Usually 60)

%outliers
    % Prepare the data with outliers

            tto{1} = 1:length([in.e(1).s.timcont]); % tto is indices for obwAmp
            tto{2} = tto{1};

            ttz{1} = tto{1}; % ttz is indices for zAmp
            ttz{2} = tto{1};

            ttsf{1} = tto{1}; % ttsf is indices for sumfftAmp
            ttsf{2} = tto{1};
    % Prepare the data without outliers

            % If we have removed outliers via KatieRemover, get the indices...    
            if ~isempty(in.idx) 
                tto{1} = in.idx(1).obwidx; tto{2} = in.idx(2).obwidx; % tto is indices for obwAmp
                ttz{1} = in.idx(1).zidx; ttz{2} = in.idx(2).zidx; % ttz is indices for zAmp
                ttsf{1} = in.idx(1).sumfftidx; ttsf{2} = in.idx(2).sumfftidx; % ttsf is indices for sumfftAmp
            end
         

    
%% only take times for light vector that have data
ld = in.info.ld;
lighttimeslong = abs(in.info.luz);
%fit light vector to power idx
    if isempty(in.info.poweridx) %if there are no values in poweridx []
        lighttimeslesslong = lighttimeslong;
    else
        lighttimesidx = lighttimeslong > in.info.poweridx(1) & lighttimeslong < in.info.poweridx(2);
        lighttimeslesslong = lighttimeslong(lighttimesidx);
    end
    
for j = 1:length(lighttimeslesslong)-1
        
        %is there data between j and j+1?    
        if ~isempty(find([in.e(1).s(tto{1}).timcont]/(60*60) >= lighttimeslesslong(j) & [in.e(1).s(tto{1}).timcont]/(60*60) < (lighttimeslesslong(j+1)),1))  
            ott = [in.e(1).s(tto{1}).timcont]/(60*60) >= lighttimeslesslong(j) & [in.e(1).s(tto{1}).timcont]/(60*60) < lighttimeslesslong(j+1); 
            lighttim = [in.e(1).s(tto{1}(ott)).timcont]/(60*60);
            
            if all(lighttim(1) >= lighttimeslesslong(j) & lighttim(1) < lighttimeslesslong(j) + ld/2)        
               lighttrim(j) = lighttimeslesslong(j);
              
            end
         
        end 
end


%take all cells with values and make a new vector
lighttimes = lighttrim(lighttrim > 0);   

%% Make spline data    

   xx = lighttimes(1):1/ReFs:lighttimes(end);
      
     % estimate new y values for every x value
     for j = 1:2
      
            %obw
            spliney = csaps([in.e(j).s(tto{j}).timcont]/(60*60), [in.e(j).s(tto{j}).obwAmp], p);
            %resample new x values based on light/dark
            yy = fnval(xx, spliney);
            %detrend ydata
            k(j).dtobwyy = detrend(yy,6,'SamplePoints', xx);
            k(j).dtobwyy = yy;
            
            %zAmp
            spliney = csaps([in.e(j).s(ttz{j}).timcont]/(60*60), [in.e(j).s(ttz{j}).zAmp], p);
            %resample new x values based on light/dark
            yy = fnval(xx, spliney);
            %detrend ydata
            k(j).dtzyy = detrend(yy,6,'SamplePoints', xx);
            
            %fftAmp
            spliney = csaps([in.e(j).s(ttsf{j}).timcont]/(60*60), [in.e(j).s(ttsf{j}).sumfftAmp], p);
            %resample new x values based on light/dark
            yy = fnval(xx, spliney);
            %detrend ydata
            k(j).dtsfftyy = detrend(yy,6,'SamplePoints', xx);
            
     end
    
%% Divide into trials 

%define sample range
    perd = 48; % default length is 48 hours
    perd = perd - rem(perd, ld);       
    
    %perdsex = perd * 60 * 60; % perd in seconds, for convenience since timcont is in seconds

    % How many samples available?
    xx(end)
    xx(1)
    lengthofsampleHOURS = (xx(end) - xx(1));    
    % How many integer periods
    numoperiods = floor(lengthofsampleHOURS / perd); % of periods
    
        for jj = 1:numoperiods
    
            % indices for our sample window of perd hours
            timidx = find(xx > xx(1) + ((jj-1)*perd) & ...
                xx < xx(1) + (jj*perd));
            
            for j = 1:2
            
             % Data   
             out(jj).e(j).obwAmp = k(j).dtobwyy(timidx);
             out(jj).e(j).zAmp = k(j).dtzyy(timidx);
             out(jj).e(j).sumfftAmp =  k(j).dtsfftyy(timidx);
             out(jj).e(j).fftFreq = [in.e(j).s(timidx).fftFreq];
             
             % Time and treatment 
             out(jj).e(j).timcont = xx(timidx) - xx(timidx(1)) + 1;
             out(jj).e(j).light = [in.e(j).s(timidx).light];
             out(jj).e(j).temp = [in.e(j).s(timidx).temp];
             
             out(jj).ld = in.info.ld; 
             out(jj).kg = orgidx; % idx for kg
             
            end

        end     
        
%% generate within-trial averages? 

      %Arent we treating this independently? Take the average across all
      %trial of ld?

%% Plot trial data

figure(1); clf;  

    maxlen = 0;

    for k= 1:length(out) 
        ax(1) = subplot(211); hold on;
        plot(out(k).e(1).timcont, out(k).e(1).obwAmp); 
        ax(2) = subplot(212); hold on;
        plot(out(k).e(2).timcont, out(k).e(2).obwAmp); 
        
        maxlen = max([maxlen out(k).e(1).timcont(end)]);
        
    end

    linkaxes(ax, 'x'); xlim([0 maxlen]);
 
 
 
    
        
        
        
        
        
         
    