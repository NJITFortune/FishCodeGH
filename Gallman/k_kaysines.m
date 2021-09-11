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
                    
                   avgresp(jj/2, :) = dtobwyy(otx);

      end
      
      out.tim = obwxx(otx) - obwxx(otx(1));
      out.mavgresp = mean(avgresp);
     
      
else %channel = 2
    
        
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
              out.mavgresp = mean(avgresp);
             
end

%% impose fake 12:12 cycle 
%check for underlying 24 hour rhythm

% Generate 12 hour light vector

%create new light vector
    %total duration
    fulllighttime = lighttimes(end)-lighttimes(1);
    %number of 12 hour transistion over duration
    cycnum = ceil(fulllighttime/12)+1;
    %time index - basically the same as j = 1:length(cycnum);
    timz = 1:1:cycnum;
    %generate new 12 hour light vector
    twelvelight(timz) = lighttimes(1) + (12*(timz-1)); 
    
%% separate into 24 hour days
    

  
if channel == 1
  
   
   ot1 = find(obwxx >= twelvelight(1) & obwxx < twelvelight(3));
   
    for j = 2:2:length(twelvelight)-2

              if length((obwxx >= twelvelight(j-1) & obwxx < twelvelight(j+1))) >= length(ot1)
                   
                  otx = find(obwxx >= twelvelight(j-1) & obwxx < twelvelight(j+1)); 
                   
                   twavgresp1(j/2, :) = dtobwyy(otx);
              end

    end

              out.twelvetim = obwxx(otx) - obwxx(otx(1));
              out.twelvemavgresp = mean(twavgresp);



   
        
 
       
else    %channel 2 
    
    ot1 = find(obwxx >= twelvelight(1) & obwxx < twelvelight(3));
 
     for j = 2:2:length(twelvelight)-2

               if length((obwxx >= twelvelight(j-1) & obwxx < twelvelight(j+1))) >= length(ot1)
                  
                   otx = find(obwxx >= twelvelight(j-1) & obwxx < twelvelight(j+1)); 

                   twavgresp2(j/2, :) = dtobwyy(otx);
                   
               end
     end
 
              out.twelvetim = obwxx(otx) - obwxx(otx(1));
              out.twelvemavgresp = mean(twavgresp);
end
