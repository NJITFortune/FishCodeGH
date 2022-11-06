function [exp, fish, ld] = k_fftdaymovabovemeans(in)
%   clearvars -except hkg hkg2 dark light darkmulti lightmulti kg kg2
%   in = darkmulti(7).h;

ld = in(1).day(1).ld;

 %all days
 %average day by trial
 


%figure(99);clf; hold on; 
 for j = 1:length(in) % experiments of x hour length
  
%         mday = zeros(1, length(in(j).day(1).tim));
%         fday = zeros(1, length(in(j).day(1).tim));
%         tday = zeros(1, length(in(j).day(1).tim));
%      

        for k = 1:length(in(j).day) %days within each trial
        
              %fill temporary vector with data from each day 
                mday(k,:) = [in(j).day(k).Sobwyy];
%                 fish(j).amprange(k,:) = in(j).day(k).amprange;
%                 amprange(k,:) = in(j).day(k).amprange;
                
                fish(j).amprange(k,:) = in(j).day(k).amprange - in(j).day(k).ampmin;
                amprange(k,:) = in(j).day(k).amprange-in(j).day(k).ampmin;


                fday(k,:) = in(j).day(k).freq;
               % tday(k,:) = k_temptocelcius(in(j).day(k).temp);
                tday(k,:) = in(j).day(k).temp;
               
        end
    
     numdays = size(mday);
    if numdays(1) == 1
     
       daymean(j,:) = mday;
       freqday(j,:) = fday;
       tempday(j,:) = tday;
    else
         %average across days   
       daymean(j,:) = mean(mday);
       freqday(j,:) = mean(fday);
       tempday(j,:) = mean(tday);
    end
        avgrange(j,:) = mean(amprange);
    
 end
           
    numrow = size(daymean);
    if numrow(1) == 1
         exp.meanofexperimentmeans = movmean(daymean, 5);
     %   exp.meanofexperimentmeans = mean(daymean);
         exp.meanoftempmeans = tempday;
         exp.meanoffreqmeans = freqday;
    else
    %averages for each x hour set of experiments
   % expmean = mean(daymean);
    %exp.meanofexperimentmeans = movmean(expmean, 5);
    exp.meanofexperimentmeans = mean(daymean);
    exp.meanoffreqmeans = mean(freqday);
    exp.meanoftempmeans = mean(tempday);
    end
    %testmean = movmean(expmean, 5);
    %average max and min
    exp.expavgrange = mean(avgrange);
    
        %expmean = smoothdata(meanofexperimentmeans, 'SamplePoints',in(1).trial(1).tim);
    
    
    
    exp.hourtim = in(j).day(1).tim/3600;
    
   
   

    
    

