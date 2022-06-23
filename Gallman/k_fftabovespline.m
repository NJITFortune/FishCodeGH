function [subffttim, subfft, sumfftyy, lighttimes] =  k_fftabovespline(in, timcont, sumfft, ReFs, light)
%% Usage
%out = [new ReFs time, resampled obw, resampled zAmp, resampled sumfft, lightchange in hours] 
%in = (kg(#), channel, 10
%% Prep
%just lazy
%ld = [in.info.ld];
%tightness of spline fit
pp = 0.99;


%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4
%% trim luz to data - Generate lighttimes
ld = in.info.ld;
lighttimeslong = abs(in.info.luz);
if in.info.luz(1) < 0

    %fit light vector to power idx
        %poweridx = good data
    if isempty(in.info.poweridx) %if there are no values in poweridx []
        if light < 4
        lighttimes = lighttimeslong;
        else
        lighttimes = lighttimeslong(2:end);
        end
    else %take data from within power idx range

        if light < 4 %we start with dark
            lighttimesidx = lighttimeslong > in.info.poweridx(1) & lighttimeslong < in.info.poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        else %we start with light
            %poweridx normally starts with dark, so we need to add ld to start with light
            poweridx1 = in.info.poweridx(1) + ld;
            lighttimesidx = lighttimeslong > poweridx1(1) & lighttimeslong < in.info.poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        end
    end

else 
    lighttimeslong = lighttimeslong(2:end);
    if isempty(in.info.poweridx) %if there are no values in poweridx []
        if light < 4
        lighttimes = lighttimeslong;
        else
        lighttimes = lighttimeslong(2:end);
        end
    else %take data from within power idx range

        if light < 4 %we start with dark
            lighttimesidx = lighttimeslong > in.info.poweridx(1) & lighttimeslong < in.info.poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        else %we start with light
            %poweridx normally starts with dark, so we need to add ld to start with light
            poweridx1 = in.info.poweridx(1) + ld;
            lighttimesidx = lighttimeslong > poweridx1(1) & lighttimeslong < in.info.poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        end
    end
end
%make lighttimes an integer
    %convert to seconds because xx is in seconds
    lighttimes = floor(lighttimes*3600);



%% cspline entire data set
    
    xx = lighttimes(1):ReFs:lighttimes(end);
    timidx = timcont >= lighttimes(1) & timcont <= lighttimes(end);
    timcont = timcont(timidx);
    sumfft = sumfft(timidx);  
            %sumfft
            spliney = csaps(timcont, sumfft, pp);
            %resample new x values based on light/dark
            sumfftyy = fnval(xx, spliney);
            %estimate without resample
            fftAmp = fnval(timcont, spliney);
            %detrend ydata
            %dtsumfftyy = detrend(sumfftyy,6,'SamplePoints', xx);

  
%% subset raw data            
        
%take raw data above the spline

   fftidx = find(sumfft > fftAmp);
   subfft = sumfft(fftidx);
   subffttim = timcont(fftidx);
   
   
   

% %estimate new spline 
% p = 0.99;
% 
%   %estimate new yvalues for every x value
% 
%         %obw
%         spliney = csaps(subffttim, subfft, p);
%         %resample new x values based on light/dark
%         subfftyy = fnval(xx, spliney);
%        
% %detrend ydata
%    dtsubfftyy = detrend(subfftyy,0,'SamplePoints', xx); %changed from polynomial detrend to mean subtraction 
%    normsubfftyytrend = 1./(subfftyy - dtsubfftyy);
%    tnormsubfftyy = subfftyy .* normsubfftyytrend;



