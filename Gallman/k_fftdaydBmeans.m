function [hourtim,  expmean,  ld, dBexprange, dBexpmean] = k_fftdaydBmeans(in)
%% usage
%processes output from KatieDayTrialDessembler.m of kg by hourexp
%k_daydessembledplotter.m without the plotting
%for use with plotting mean summary of entire kg

%   clearvars -except dark kg kg2 colorsforplots
%   in = dark(1).h;

% for k = 1:length(dark)
%      [dark(k).hourtim, dark(k).meanoftrialmeans, dark(k).ld] = k_fftdaymeans(dark(k).h);
% end

%in.trial and %in.day

ld = in(1).day(1).ld;

 %all days
 %average day by trial
 
%clear mday;
%figure(99);clf; hold on; 
 for j = 1:length(in) % experiments of x hour length
  
    clear meanday
    clear dayrange
    clear dBday
    clear mmday

    for k = 1:length(in(j).day)
%            
            meanday(k,:) = in(j).day(k).Ssumfftyy;
            dayrange(k,:) = max(in(j).day(k).Ssumfftyy)-min(in(j).day(k).Ssumfftyy);

     end
            
            maxdayrange(j, :) = max(dayrange);
            mmday(j, :) = mean(meanday);


    for k = 1:length(in(j).day)
%            
            dBday(k,:) = 20*log10(dayrange(k)/maxdayrange(j));
            
     end

            dBdayrange(j, :) = [min(dBday), max(dBday)];
            dBdaymean(j, :) = mean(dBday);
    
 end  
     
    %averages for each x hour set of experiments
    meanofexperimentmeans = mean(mmday);
    expmean = movmean(meanofexperimentmeans, 5);
    dBexpmean = mean(dBday);
    dBexprange = [min(dBdaymean), max(dBdaymean)];
     %expmean = smoothdata(meanofexperimentmeans, 'SamplePoints',in(1).trial(1).tim);
    
   
    % Mean of means
    %meanofmeans = mean(mday); % Takes the mean of the means for a day from each trial 
    
    
    
    hourtim = in(1).day(1).tim/3600;
    
   
   

    
    

