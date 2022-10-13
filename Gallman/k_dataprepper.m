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

  if channel < 3 %single fish data has two channel

    %outlier removal
     tto = [in.idx(channel).obwidx]; 
          
    %raw data
        timcont = [in.e(channel).s(tto).timcont]; %time in seconds
        obw = [in.e(channel).s(tto).obwAmp]/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
        oldfreq = [in.e(channel).s(tto).fftFreq];
        oldtemp = [in.e(channel).s(tto).temp];

  else %multifish data only has one channel
    %outlier removal
     tto = [in.idx.obwidx]; 
          
    %raw data
        timcont = [in.s(tto).timcont]; %time in seconds
        obw = [in.s(tto).obwAmp]/max([in.s(tto).obwAmp]); %divide by max to normalize
        oldfreq = [in.s(tto).freq];
        oldtemp = [in.s(tto).temp];

  end
            
   %peaks of peaks
        %find peaks
        [~,LOCS] = findpeaks(obw);
        %find peaks of the peaks
        [obwpeaks,cLOCS] = findpeaks(obw(LOCS));
        peaktim = timcont(LOCS(cLOCS));       
        peakfreq = oldfreq(LOCS(cLOCS));       
        peaktemp = oldtemp(LOCS(cLOCS));  

        