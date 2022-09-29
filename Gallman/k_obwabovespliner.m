function [xx, subfftyy, lighttimes] =  k_obwabovespliner(in, channel, ReFs, light)
%% Usage
%in = kg(k);
%ReFs = 20;
%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4
%% Prep
%tightness of spline fit
p = 0.99;

%outliers
tto{channel} = in.idx(channel).obwidx;

%% trim luz to data - Generate lighttimes

lighttimeslong = abs(in.info.luz);
ld = in.info.ld;

    %fit light vector to power idx
        %poweridx = good data
    if isempty(in.info.poweridx) %if there are no values in poweridx []
        lighttimeslesslong = lighttimeslong;
    else %take data from within power idx range

        if light < 4 %we start with dark
            lighttimesidx = lighttimeslong > in.info.poweridx(1) & lighttimeslong < in.info.poweridx(2);
            lighttimeslesslong = lighttimeslong(lighttimesidx);
        else %we start with light
            %poweridx normally starts with dark, so we need to add ld to start with light
            poweridx1 = in.info.poweridx(1) + ld;
            lighttimesidx = lighttimeslong > poweridx1(1) & lighttimeslong < in.info.poweridx(2);
            lighttimeslesslong = lighttimeslong(lighttimesidx);
        end
    end

  
%only take times for light vectors that have data
for j = 1:length(lighttimeslesslong)-1
        
        %is there data between j and j+1?    
        %if ~isempty(find([in.e(1).s(ttsf{1} ).timcont]/(60*60) >= lighttimeslesslong(j) & [in.e(1).s(ttsf{1}).timcont]/(60*60) < (lighttimeslesslong(j+1)),1))  
            
               lighttrim(j) = lighttimeslesslong(j);
             
        %end 
end


% take all cells with values and make a new vector
lighttimes = lighttrim(lighttrim > 0);
%luztimes = luztimes(1,lighttrim > 0);
%add back the light time we subtracted 
%ld = lighttimes(end) - lighttimes(end-1);
%lighttimes(end +1) = lighttimes(end) + ld;
%lighttimes
for k = 1:length(lighttimes)
    lighttimes(k) = floor(lighttimes(k));
end


%% cspline entire data set
    
    xx = lighttimes(1):1/ReFs:lighttimes(end);
      
      %estimate new yvalues for every x value
      
            %obw
            spliney1 = csaps([in.e(channel).s(tto{channel}).timcont]/(60*60), [in.e(channel).s(tto{channel}).obwAmp]/max([in.e(channel).s(tto{channel}).obwAmp]), p);
            
            %estimate without resample
            obwAmp = fnval([in.e(1).s(tto{1}).timcont]/(60*60), spliney1);
%             %detrend ydata
%             dtobwyy = detrend(obwyy,6,'SamplePoints', xx);
            %raw data variables
                obwtimOG = [in.e(1).s(tto{1}).timcont]/(60*60);
                obwAmpOG = [in.e(1).s(tto{1}).obwAmp]/max([in.e(1).s(tto{1}).obwAmp]);


% figure(57); clf; title('testing original spline'); hold on;
%     plot(sumffttimOG, sumfftAmpOG, '.');
%     plot(xx, sumfftyy, '-');
%% subset raw data            
        
%take raw data above the spline

   fftidx = find(obwAmpOG > obwAmp);
   subfft = obwAmpOG(fftidx);
   subffttim = obwtimOG(fftidx);
     
%estimate new spline 

  %estimate new yvalues for every x value

        %obw
        spliney = csaps(subffttim, subfft, p);
        %resample new x values based on light/dark
        subfftyy = fnval(xx, spliney);
       
%detrend ydata
%    dtsubfftyy = detrend(subfftyy,0,'SamplePoints', xx); %changed from polynomial detrend to mean subtraction 
%    normsubfftyytrend = 1./(subfftyy - dtsubfftyy);
%    tnormsubfftyy = subfftyy .* normsubfftyytrend;



