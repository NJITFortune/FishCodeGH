
function [exp, fish, td] = k_tempdaymeans(in)
% 
%   clearvars -except xxkg xxkg2 hkg hkg2 hot cold
%   in = hot(1).h;

 td = in(1).tday(1).td;

%% entire fucking for loop just to find the shortest day
 for j = length(in):-1:1 %number of fish in experiment trial

       %calculate mean for plotting
       for l = length(in(j).tday):-1:1
        longs(l) = length(in(j).tday(l).obw);
        end
      
       shorty(j) = min(longs);
 end
 shortest = min(shorty);
 
%%

 %all days
 %average day by fish
 
%figure(99);clf; hold on; 
 for j = length(in):-1:1 % experiments of x hour length
  
       

         for k = length(in(j).tday):-1:1 %days within each trial
        
              %fill temporary vector with data from each day 
                mtday(k,:) = in(j).tday(k).obw(1:shortest);
                ftday(k,:) = in(j).tday(k).freq(1:shortest);%-mean(in(j).tday(k).freq(1:shortest));
                
                fish(j).amprange(k,:) = in(j).tday(k).amprange;
                amprange(k,:) = in(j).tday(k).amprange;
               
         end

      %average across days
      avgrange(j,:) = mean(amprange);
 
      %necessary so that the mean of a single day isn't one value  
      if length(in(j).tday) > 1  
      %average across days   
       tdaymean(j,:) = mean(mtday);
       ftdaymean(j,:) = mean(ftday);
      else
       tdaymean(j,:) = mtday;
        ftdaymean(j,:) = ftday;
      end

      zeroedftdaymean(j,:) = ftdaymean(j)-mean(ftdaymean(j));

 end
           
 %average across fish
   numrow = size(tdaymean);
    if numrow(1) == 1
         exp.meanoftempexperimentmeans = movmean(tdaymean, 5);
         exp.meanoftempfreqmeans = movmean(zeroedftdaymean, 5);
    else
    %averages for each x hour set of experiments
    expmean = mean(tdaymean);
    exp.meanoftempexperimentmeans = movmean(expmean, 5);

    freqmean = mean(zeroedftdaymean);
    exp.meanoftempfreqmeans = movmean(freqmean, 5);
    end
    %testmean = movmean(expmean, 5);
    %average max and min
    exp.expavgrange = mean(avgrange);
    
        %expmean = smoothdata(meanofexperimentmeans, 'SamplePoints',in(1).trial(1).tim);
    
    
    
    exp.tempdaytim = in(j).tday(1).tim(1:shortest)/3600;
   
    
   
   

    
    

