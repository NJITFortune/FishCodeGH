function out = k_kaysines(in, channel)

%in = kg(k)
%out = kay(k).e.


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

 
if channel == 1
    
      obwxx = lighttimes(1):1/ReFs:lighttimes(end);
      
      %estimate new yvalues for every x value
      %obw only for now
      
            spliney = csaps([in.e(1).s(tto{1}).timcont]/(60*60), [in.e(1).s(tto{1}).obwAmp], p);
            %resample new x values based on light/dark
            obwyy = fnval(obwxx, spliney);
            %detrend ydata
            dtobwyy = detrend(obwyy,6,'SamplePoints', obwxx);
      
      
%separate into days
%always starts with dark?
      for jj = 2:2:length(lighttimes)-1


                   otx = find(obwxx >= lighttimes(jj-1) & obwxx < lighttimes(jj+1)); 
                    
                   out(jj).dtobwyy(:) = dtobwyy(otx);
                   
                   out(jj).tim(:) = obwxx(otx) - obwxx(otx(1));
                  
                   out(jj).avgresp(jj/2, :) = dtobwyy(otx);

      end
      
else
    
        
        obwxx = lighttimes(1):1/ReFs:lighttimes(end);

              %estimate new yvalues for every x value
              %obw only for now

                    spliney = csaps([in.e(2).s(tto{2}).timcont]/(60*60), [in.e(2).s(tto{2}).obwAmp], p);
                    %resample new x values based on light/dark
                    obwyy = fnval(obwxx, spliney);
                    %detrend ydata
                    dtobwyy = detrend(obwyy,6,'SamplePoints', obwxx);


        %separate into days
        %always starts with dark?
              for jj = 2:2:length(lighttimes)-1


                           otx = find(obwxx >= lighttimes(jj-1) & obwxx < lighttimes(jj+1)); 

                           
                           
                           avgresp(jj/2, :) = dtobwyy(otx);

              end

              out.tim = obwxx(otx) - obwxx(otx(1));
              


end


   
