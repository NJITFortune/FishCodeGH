%% cspline by light epoch
%if luz is +/- , take data from luz - in initial plotter

% klight = in.info.luz(in.info.luz > 0);
% kdark = in.info.luz(in.info.luz < 0);


%separate data into light epochs
%lighttimes = abs(in.info.luz);

%preallocate
% fobwdayy = [length(lighttimes)-1, in.info.ld*ReFs];
% fobwdayx = [length(lighttimes)-1, in.info.ld*ReFs];
% fobwdayxx = [length(lighttimes)-1, in.info.ld*ReFs];


%iterate through for each light epoch
% for j = 1:length(lighttimes)-1
%        
%         %is there data between j and j+1?    
%         if ~isempty(find([in.e(1).s(tto{1}).timcont]/(60*60) >= lighttimes(j) & [in.e(1).s(tto{1}).timcont]/(60*60) < lighttimes(j+1),1))           
%             %time index for light epoch - timcont between j and j+1 in hours
%             ott = find([in.e(1).s(tto{1}).timcont]/(60*60) >= lighttimes(j) & [in.e(1).s(tto{1}).timcont]/(60*60) < lighttimes(j+1)); 
%         
%             %is there enough data to do analysis?
%             if length(ott) > 10
%                 %amplitude and time data in light epoch 
%                 obwday = [in.e(1).s(tto{1}(ott)).obwAmp];
%                 obwtim = [in.e(1).s(tto{1}(ott)).timcont]/(60*60);
%                 
%                 %calculate cubic spline for data
%                 spliney = csaps(obwtim, obwday, p);
%                 
%                 %resample once every minute
%                     %has to be lighttimes(j) because we don't always have data right at first lighttime
%                 obwdayx = lighttimes(j):1/ReFs:lighttimes(j+1)-1/ReFs;
%                 length(obwdayx)
%                     
%               
%                 %estimate cubic spline along resampled time     
%                 obwdayy = fnval(spliney,obwdayx); 
%                 length(obwdayy)
%                 %time from zero to ld for plotting
%                     %can't use for spline estimate - gives lots of zeros
%                 obwdayxx = obwdayx-lighttimes(j);
%                
%                 
%                 %plot to check
%                 figure(101); 
%                 %plot(obwdayxx, obwdayy, 'o', 'MarkerSize', 2);
% %                 plot(obwtim, obwday, '.', 'Markersize', 8); 
%                 plot(obwdayx, obwdayy, 'o', 'MarkerSize', 5);
% %                 plot(obwdayx, fnval(obwdayx, spliney), 'o', 'MarkerSize', 2);
% 
% 
%                 %save output as variables
%                 %%help this part doesn't work
%                 day(j).obwdayy = obwdayy;
%                 day(j).obwdayxx = obwdayxx;
%                 day(j).obwdayx = obwdayx;
%                   
%               
%             end
%        
%         end 
%                  
% end

% percentchange(j, :) = abs(mean(obwdayy(j,:)) - mean(obwdayy(j+1,:)))./mean(obwdayy(j+1,:))
             
    
%separate light from dark     
    