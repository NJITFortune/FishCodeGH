
function [xx, tnormsubobwyy, lighttimes] =  k_obwsubspliner(in, channel, ReFs)
%% Usage
%out = [new ReFs time, resampled obw, resampled zAmp, resampled sumfft, lightchange in hours] 
%in = (kg(#), channel, 10
%% Prep
%just lazy
ld = [in.info.ld];
%tightness of spline fit
p = 0.9;

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
         
        
%% trim luz to data - Generate lighttimes
lighttimeslong = abs(in.info.luz);

    %fit light vector to power idx
        %poweridx = good data
    if isempty(in.info.poweridx) %if there are no values in poweridx []
        lighttimeslesslong = lighttimeslong;
    else %take data from within power idx range
        lighttimesidx = lighttimeslong > in.info.poweridx(1) & lighttimeslong < in.info.poweridx(2);
        lighttimeslesslong = lighttimeslong(lighttimesidx);
    end

    
%only take times for light vectors that have data
for j = 1:length(lighttimeslesslong)-1
        
        %is there data between j and j+1?    
        if ~isempty(find([in.e(1).s(tto{1}).timcont]/(60*60) >= lighttimeslesslong(j) & [in.e(1).s(tto{1}).timcont]/(60*60) < (lighttimeslesslong(j+1)),1))  
            
               lighttrim(j) = lighttimeslesslong(j);
             
        end 
end


% take all cells with values and make a new vector
lighttimes = lighttrim(lighttrim > 0);
%luztimes = luztimes(1,lighttrim > 0);
%add back the light time we subtracted 
lighttimes(end +1) = lighttimes(end) + ld;


%% cspline entire data set

 
if channel == 1
    
    xx = lighttimes(1):1/ReFs:lighttimes(end);
      
      %estimate new yvalues for every x value
      
            %obw
            spliney = csaps([in.e(1).s(tto{1}).timcont]/(60*60), [in.e(1).s(tto{1}).obwAmp], p);
            %resample new x values based on light/dark
            obwyy = fnval(xx, spliney);
            %estimate without resample
            obwAmp = fnval([in.e(1).s(tto{1}).timcont]/(60*60), spliney);
            %detrend ydata
            dtobwyy = detrend(obwyy,6,'SamplePoints', xx);
            %raw data variables
                obwtimOG = [in.e(1).s(tto{1}).timcont]/(60*60);
                obwAmpOG = [in.e(1).s(tto{1}).obwAmp];
      
            %zAmp
            spliney = csaps([in.e(1).s(ttz{1}).timcont]/(60*60), [in.e(1).s(ttz{1}).zAmp], p);
            %resample new x values based on light/dark
            zyy = fnval(xx, spliney);
            %detrend ydata
            dtzyy = detrend(zyy,6,'SamplePoints', xx);
                ztimOG = [in.e(1).s(ttz{1}).timcont]/(60*60);
                zAmpOG = [in.e(1).s(ttz{1}).zAmp]; 
            
            %sumfft
            spliney = csaps([in.e(1).s(ttsf{1}).timcont]/(60*60), [in.e(1).s(ttsf{1}).sumfftAmp], p);
            %resample new x values based on light/dark
            sumfftyy = fnval(xx, spliney);
            %detrend ydata
            dtsumfftyy = detrend(sumfftyy,6,'SamplePoints', xx);
                sumffttimOG = [in.e(1).s(ttsf{1}).timcont]/(60*60);
                sumfftAmpOG = [in.e(1).s(ttsf{1}).sumfftAmp]; 
     
      
else %channel = 2
    
        
    xx = lighttimes(1):1/ReFs:lighttimes(end);

      %estimate new yvalues for every x value
             
            %obw
            spliney = csaps([in.e(2).s(tto{2}).timcont]/(60*60), [in.e(2).s(tto{2}).obwAmp], p);
            %resample new x values based on light/dark
            obwyy = fnval(xx, spliney);
            obwAmp = fnval([in.e(2).s(tto{2}).timcont]/(60*60), spliney);
            %detrend ydata
            dtobwyy = detrend(obwyy,6,'SamplePoints', xx);
                obwtimOG = [in.e(2).s(tto{2}).timcont]/(60*60);
                obwAmpOG = [in.e(2).s(tto{2}).obwAmp];
                    
            %zAmp
            spliney = csaps([in.e(2).s(ttz{2}).timcont]/(60*60), [in.e(2).s(ttz{2}).zAmp], p);
            %resample new x values based on light/dark
            zyy = fnval(xx, spliney);
            %detrend ydata
            dtzyy = detrend(zyy,6,'SamplePoints', xx);
                ztimOG = [in.e(2).s(ttz{2}).timcont]/(60*60);
                zAmpOG = [in.e(2).s(ttz{2}).zAmp]; 
            
            %sumfft
            spliney = csaps([in.e(2).s(ttsf{2}).timcont]/(60*60), [in.e(2).s(ttsf{2}).sumfftAmp], p);
            %resample new x values based on light/dark
            sumfftyy = fnval(xx, spliney);
            %detrend ydata
            dtsumfftyy = detrend(sumfftyy,6,'SamplePoints', xx);
                sumffttimOG = [in.e(2).s(ttsf{2}).timcont]/(60*60);
                sumfftAmpOG = [in.e(2).s(ttsf{2}).sumfftAmp]; 
             
end
%% subset raw data            
        
%take raw data above the spline
   obwidx = find(obwAmpOG > obwAmp);
   subobw = obwAmpOG(obwidx);
   subobwtim = obwtimOG(obwidx);
   
   
   
%estimate new spline 
p = 0.5;

  %estimate new yvalues for every x value

        %obw
        spliney = csaps(subobwtim, subobw, p);
        %resample new x values based on light/dark
        subobwyy = fnval(xx, spliney);
       
%detrend ydata
   dtsubobwyy = detrend(subobwyy,6,'SamplePoints', xx);
   normsubobwyytrend = 1./(subobwyy - dtsubobwyy);
   tnormsubobwyy = subobwyy .* normsubobwyytrend;



