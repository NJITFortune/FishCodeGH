%function out = k_dataprepper(in, channel, ReFs)
%notfunction
clearvars -except rkg kg2 hkg hkg2 xxkg xxkg2     
% 
in = hkg(k);
channel = 1;
ReFs = 20;
light = 3;
p = 0.7;

%% prep

lighttimes = k_lighttimes(in, light);


   %% Prepare raw data variables

    %outlier removal
     tto = [in.idx(channel).obwidx]; 
          
    %raw data
        timcont = [in.e(channel).s(tto).timcont]; %time in seconds
        obw = [in.e(channel).s(tto).obwAmp]/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
        oldfreq = timcont;
        
        %Make a time base that starts and ends on lighttimes 
            rawidx = timcont >= lighttimes(1) & timcont <= lighttimes(end);
            timmy = timcont(rawidx);
            obwAmp = obw(rawidx);
            
   %peaks of peaks
        %find peaks
        [~,LOCS] = findpeaks(obw);
        %find peaks of the peaks
        [obwpeaks,cLOCS] = findpeaks(obw(LOCS));
        peaktim = timcont(LOCS(cLOCS));       