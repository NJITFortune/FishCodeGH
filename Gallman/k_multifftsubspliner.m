
function [xx, Hitnormsubfftyy, Lotnormsubfftyy, lighttimes] =  k_multifftsubspliner(in, ReFs, light)
%% Usage
%out = [new ReFs time, resampled obw, resampled zAmp, resampled sumfft, lightchange in hours] 
%in = (kg(#), channel, 10
%% Prep
%just lazy
ld = [in.info.ld];
%tightness of spline fit
p = 0.9;

%outlier removal indicies
% All the data (set because we may want to plot before running KatieRemover and/or KatieLabeler)
    tthi = 1:length(out.fish.his); % tthi is indices for HiAmp
    ttlo = 1:length(out.fish.los); % ttlo is indices for LoAmp

 % figure(2); clf; plot(tthi); hold on; 

% If we have removed outliers via KatieRemover, get the indices... 
    if isfield(out, 'idx')
        if ~isempty(out.idx)
            tthi = [out.idx.Hiidx]; % tthi is indices for HiAmp
            ttlo = [out.idx.Loidx]; % ttlo is indices for LoAmp
        end
    end

         
%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4
%% trim luz to data - Generate lighttimes
lighttimeslong = abs(in.info.luz);

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
        %if ~isempty(find([in.e(1).s(tto{1}).timcont]/(60*60) >= lighttimeslesslong(j) & [in.e(1).s(tto{1}).timcont]/(60*60) < (lighttimeslesslong(j+1)),1))  
            
               lighttrim(j) = lighttimeslesslong(j);
             
       % end 
end


% take all cells with values and make a new vector
lighttimes = lighttrim(lighttrim > 0);
%luztimes = luztimes(1,lighttrim > 0);
%add back the light time we subtracted 
lighttimes(end +1) = lighttimes(end) + ld;


%% create easier vector names for raw data
   HiTim = [in.fish.his(tthi).HiTim];
   HiAmp = [in.fish.his(tthi).HiAmp];
   LoTim = [in.fish.los(ttlo).LoTim];
   LoAmp = [in.fish.los(ttlo).LoAmp];

%% cspline entire data set

%define resample time vector
xx = lighttimes(1):1/ReFs:lighttimes(end);
  
    %estimate new yvalues for every x value
       %high frequency fish
         spliney = csaps([in.fish.his(tthi).HiTim], [in.fish.his(tthi).HiAmp], p);
         
         %estimate without resample
         HifftAmp = fnval([in.fish.his(tthi).HiTim], spliney);    

         %resample new x values based on light/dark
         Hifftyy = fnval(xx, spliney);


       
       %low frequency fish
         spliney = csaps([in.fish.los(ttlo).LoTim], [in.fish.los(ttlo).LoAmp], p);
         
         %estimate without resample
         LofftAmp = fnval([in.fish.los(ttlo).LoTim], spliney);    

         %resample new x values based on light/dark
         Lofftyy = fnval(xx, spliney);
            

%% subset raw data       
%take raw data above the spline
   %high frequency fish
   Hifftidx = find(HiAmp > HifftAmp);
   Hisubfft = HiAmp(Hifftidx);
   Hisubffttim = HiTim(Hifftidx);
   
   %low frequency fish
   Lofftidx = find(LoAmp > LofftAmp);
   Losubfft = LoAmp(Lofftidx);
   Losubffttim = LoTim(Lofftidx);
   
   
%estimate new spline 
p = 0.5;

%estimate new yvalues for every xx value
    %high frequency fish
    spliney = csaps(Hisubffttim, Hisubfft, p);
    %resample new x values based on light/dark
    Hisubfftyy = fnval(xx, spliney);

    %low frequency fish
    spliney = csaps(Losubffttim, Losubfft, p);
    %resample new x values based on light/dark
    Losubfftyy = fnval(xx, spliney);

%% detrend ydata
  %subtract trend from data
    %high frequency fish
       Hidtsubfftyy = detrend(Hisubfftyy,6,'SamplePoints', xx);
       Hinormsubfftyytrend = 1./(Hisubfftyy - Hidtsubfftyy);
       Hitnormsubfftyy = Hisubfftyy .* Hinormsubfftyytrend;
    
    %lowfrequency fish
       Lodtsubfftyy = detrend(Losubfftyy,6,'SamplePoints', xx);
       Lonormsubfftyytrend = 1./(Losubfftyy - Lodtsubfftyy);
       Lotnormsubfftyy = Losubfftyy .* Lonormsubfftyytrend;



