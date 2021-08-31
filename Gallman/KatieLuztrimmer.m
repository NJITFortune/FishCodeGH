
function out = KatieLuztrimmer(in)
%usage kg(k).info.luz = KatieLuztrimmer(kg(k))
%% outliers
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
%% trim luz to data
lighttimeslong = abs(in.info.luz);

for j = 1:length(lighttimeslong)-1
        
        %is there data between j and j+1?    
        if ~isempty(find([in.e(1).s(tto{1}).timcont]/(60*60) >= lighttimeslong(j) & [in.e(1).s(tto{1}).timcont]/(60*60) < (lighttimeslong(j+1)),1))  
            ott = find([in.e(1).s(tto{1}).timcont]/(60*60) >= lighttimeslong(j) & [in.e(1).s(tto{1}).timcont]/(60*60) < lighttimeslong(j+1)); 
           lighttim = [in.e(1).s(tto{1}(ott)).timcont]/(60*60);
           ld = [in.info.ld];
            
            if all(lighttim(1) >= lighttimeslong(j) & lighttim(1) < lighttimeslong(j) + ld/2)        
               lighttrim(j) = lighttimeslong(j);
               trimluz(j) = in.info.luz(j);  
            end
            
             
        end 
end

nonzeroluz = find(trimluz);
out = in.info.luz(nonzeroluz);

end
