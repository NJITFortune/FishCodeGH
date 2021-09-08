function kay = k_kaysines(in)

%in = kg(k).e(j);
%out = kg(k).e.
figure(101); clf; hold on;

in = kg(27);
p = 0.7;
ReFs = 10;  %resample once every minute (Usually 60)
% Usage: k_initialplotter(kg(#));

%% Prep
ld = [in.info.ld];


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
    if isempty(in.info.poweridx) %if there are no values in poweridx []
        lighttimeslesslong = lighttimeslong;
    else
        lighttimesidx = lighttimeslong > in.info.poweridx(1) & lighttimeslong < in.info.poweridx(2);
        lighttimeslesslong = lighttimeslong(lighttimesidx);
    end

    
%only take times for light vector that have data
for j = 1:length(lighttimeslesslong)-1
        
        %is there data between j and j+1?    
        if ~isempty(find([in.e(1).s(tto{1}).timcont]/(60*60) >= lighttimeslesslong(j) & [in.e(1).s(tto{1}).timcont]/(60*60) < (lighttimeslesslong(j+1)),1))  
            ott = [in.e(1).s(tto{1}).timcont]/(60*60) >= lighttimeslesslong(j) & [in.e(1).s(tto{1}).timcont]/(60*60) < lighttimeslesslong(j+1); 
            lighttim = [in.e(1).s(tto{1}(ott)).timcont]/(60*60);
            length(lighttim);
            
            if all(lighttim(1) >= lighttimeslesslong(j) & lighttim(1) < lighttimeslesslong(j) + ld/2)        
               lighttrim(j) = lighttimeslesslong(j);
              
            end
         
        end 
end


%take all cells with values and make a new vector
lighttimes = lighttrim(lighttrim > 0);


%% cspline entire data set

 for j = 2:-1:1
      %light = [in.e(1).s(tto{1}).light];
      %only need single x vector for each amplitude since we resample over
      %the same interval
      
      %resample time evenly across days
      kay(j).dayxx = lighttimes(1):1/ReFs:lighttimes(end);
      
      %estimate new yvalues for every x value
      %obw only for now
      
            spliney = csaps([in.e(j).s(tto{j}(pidx)).timcont]/(60*60), [in.e(j).s(tto{j}(pidx)).obwAmp], p);
            %resample new x values based on light/dark
            obwyy = fnval(kay(j).dayxx, spliney);
            %detrend ydata
            dtobwyy = detrend(obwyy,6,'SamplePoints',kay(j).obwxx);
      
      
%separate into days
%always starts with dark?
      for jj = 2:2:length(lighttimes)-1


                   otx = find(kay(j).obwxx >= lighttimes(jj-1) & kay(j).obwxx < lighttimes(jj+1)); 
                    
                   kay(j).sinobw(jj) = dtobwyy(otx);
                  
                   kay(j).avgresp(jj/2, :) = dtobwyy(otx);

      end
      
            
 end           







   
