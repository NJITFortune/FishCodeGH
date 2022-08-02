%function [hourtim, meanofexperimentmeans, hourampmax, ld] = k_fftdaymovabovemeans(in)
%% usage
%processes output from KatieDayTrialDessembler.m of kg by hourexp
%k_daydessembledplotter.m without the plotting
%for use with plotting mean summary of entire kg

%   clearvars -except dark kg kg2 colorsforplots light
%   in = light(10).h;

% for k = 1:length(dark)
%      [dark(k).hourtim, dark(k).meanoftrialmeans, dark(k).ld] = k_fftdaymeans(dark(k).h);
% end

%in.trial and %in.day

in = dark(5).h;

ld = in(1).day(1).ld;

 %all days
 %average day by trial
 

%figure(99);clf; hold on; 
 for j = 1:length(in) % experiments of x hour length
  
 j   
     
        mday = zeros(1, length(in(j).day(1).tim));

        for k = 1:length(in(j).day) %days within each trial
        
              %fill temporary vector with data from each day 
                mday(k,:) = in(j).day(k).Sobwyy;
                amprange(k,:) = in(j).day(k).amprange;
              
                %plot(in(j).trial(jj).day(k).SsumfftAmp)

               
        end
    
      if length(in(j).day) > 1  
      %average across days   
       daymean(j,:) = mean(mday);
      else
       daymean(j,:) = mday;
      end

      %max amp range
      expampmax(j,:) = max(amprange);
            
            
            
 end
           
 
    
    %averages for each x hour set of experiments
    expmean = mean(daymean);
    meanofexperimentmeans = movmean(expmean, 5);
    
        %expmean = smoothdata(meanofexperimentmeans, 'SamplePoints',in(1).trial(1).tim);
    
    %amprange for hour;
    hourampmax = max(expampmax); 
   
    % Mean of means
    %meanofmeans = mean(mday); % Takes the mean of the means for a day from each trial 
    
    
    
    hourtim = in(j).day(1).tim/3600;
    
   
   

    
    

