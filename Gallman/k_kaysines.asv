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
            
            
%good data range - poweridx


    %Sample dataset by poweridx 
            %poweridx-window of good data to analyze [start end]  

            if isempty(in.info.poweridx) %if there are no values in poweridx []
               obtt = 1:length([in.e(1).s(tto{1}).timcont]/(60*60)); %use the entire data set to perform the analysis
            else %if there are values in poweridx [X1 X2]
                %perform the analysis between the poweridx values
                obtt = find([in.e(1).s(tto{1}).timcont]/(60*60) > in.info.poweridx(1) & [in.e(1).s(tto{1}).timcont]/(60*60) < in.info.poweridx(2));
            end
            
            %is the tto{1} necessary after we define obtt? - test.

        %create data variables of poweridx 
        obwdata1 = [in.e(1).s(tto{1}(obtt)).obwAmp]; 
        obwtim1 = [in.e(1).s(tto{1}(obtt)).timcont]/(60*60);
        
        
%% trim luz to data - Generate lighttimes
lighttimeslong = abs(in.info.luz);
lighttrim = zeros(1, length(lighttimeslong)-1);

for j = 1:length(lighttimeslong)-1
        
        %is there data between j and j+1?    
        if ~isempty(find([in.e(1).s(tto{1}(obtt)).timcont]/(60*60) >= lighttimeslong(j) & [in.e(1).s(tto{1}(obtt)).timcont]/(60*60) < (lighttimeslong(j+1)),1))  
            ott = [in.e(1).s(tto{1}(obtt)).timcont]/(60*60) >= lighttimeslong(j) & [in.e(1).s(tto{1}(obtt)).timcont]/(60*60) < lighttimeslong(j+1); 
           lighttim = [in.e(1).s(ott).timcont]/(60*60);
      
            %if there is more than half of the data in the luz epoch 
            if all(lighttim(1) >= lighttimeslong(j) & lighttim(1) < lighttimeslong(j) + ld/2) 
               %keep abs(luz) values for light vector 
               lighttrim(j) = lighttimeslong(j);
            end
            
        end 
end


%luz vector 
lighttimes = lighttrim(lighttrim > 0);


%% cspline entire data set

 for j = 2:-1:1
      %light = [in.e(1).s(tto{1}).light];
      
      %obw
      [kay(j).obwxx, obwyy] = k_splighty([in.e(j).s(tto{j}(obtt)).timcont]/(60*60) , [in.e(j).s(tto{j}(obtt)).obwAmp], lighttimes);
      dtobwyy = detrend(obwyy,6,'SamplePoints',kay(j).obwxx);
      
%       %zAmp
%       [kay(j).zAmpxx, kay(j).zAmpyy] = k_splighty([in.e(j).s(ttz{j}).timcont]/(60*60) , [in.e(j).s(ttz{j}).zAmp], lighttimes);
%       
%       %fftfreq
%       [kay(j).sumfftAmpxx, kay(j).sumfftAmpyy] = k_splighty([in.e(j).s(ttsf{j}).timcont]/(60*60) , [in.e(j).s(ttsf{j}).sumfftAmp], lighttimes);
%       
      
%separate into days
      for jj = 2:2:length(lighttimes)-1


                   otx = find(kay(j).obwxx >= lighttimes(jj-1) & kay(j).obwxx < lighttimes(jj+1)); 
                    
                   kay(j).sinobw(jj) = dtobwyy(otx);
                  
                   kay(j).avgresp(jj/2, :) = dtobwyy(otx);

      end
      
      
      
            
 end           







   
