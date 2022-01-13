%function later
%% prep 
clearvars -except kg kg2

in = kg(2);
channel = 1;

%% define data by light transitions

%create light transistion vector lighttimes
lighttimeslong = abs(in.info.luz);
ld = in.info.ld;

%trim lighttimes to poweridx
    if isempty(in.info.poweridx) %if there are no values in poweridx []
        lighttimeslesslong = lighttimeslong;
    else %take data from within power idx range

            lighttimesidx = lighttimeslong > in.info.poweridx(1) & lighttimeslong < in.info.poweridx(2);
            lighttimeslesslong = lighttimeslong(lighttimesidx);
        
    end

  
    %only take times for light vectors that have data
    for j = 1:length(lighttimeslesslong)-1
            
            %is there data between j and j+1?    
            %if ~isempty(find([in.e(1).s(ttsf{1} ).timcont]/(60*60) >= lighttimeslesslong(j) & [in.e(1).s(ttsf{1}).timcont]/(60*60) < (lighttimeslesslong(j+1)),1))  
                
                   lighttrim(j) = lighttimeslesslong(j);
                 
            %end 
    end
    
    
    
    lighttimes = lighttimeslesslong;
    %for when we use the computer to find light transistions
    for k = 1:length(lighttimes)
        lighttimes(k) = floor(lighttimes(k));
    end


%trim time and amplitude vectors to light transitions
    
        timcont = [in.e(channel).s.timcont]/3600;
        lidx = find(timcont >=lighttimes(1) & timcont <= lighttimes(end));

        timcont = timcont(lidx);
        fftAmp = [in.e(channel).s(lidx).sumfftAmp];


%plot to check
    figure(5); clf; hold on;
        plot(timcont, fftAmp, '.');
        plot([lighttimes' lighttimes'], ylim, 'k-', 'LineWidth', 0.5);

%% Divide into bins

%length of experiment
totaltimhours = lighttimes(end)-lighttimes(1);
%bins
binsize = 10; %minutes
totalnumbins = totaltimhours/(binsize/60);
binz = 1:1:totalnumbins;

bintimhour = (lighttimes(1)*60 + (binsize (binz-1));

%data is currently in hours - need 10minute bins
    %convert timcont to minutes?
    timcontmin = timcont * 60;
  

    for j = 1:totalnumbins

        bintim(j,:) = timcontmin(j) + binsize;

    end







