function k_meanmultidayplotter(in, kidx)
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

%in = dark(5).h;

ld = in(1).day(1).ld;
hourtim = in(1).day(1).tim/3600;
 %all days
 %average day by trial
 

figure(10);clf; title('daymean by fish'); hold on; 
 for j = 1:length(in) % experiments of x hour length
  
     leg(j,:) = kidx(j);
        mday = zeros(1, length(in(j).day(1).tim));

        for k = 1:length(in(j).day) %days within each trial
        
              %fill temporary vector with data from each day 
                mday(k,:) = in(j).day(k).Sobwyy;
%                 ampmax(k,:) = in(j).day(k).ampmax;
%                 ampmin(k,:) = in(j).day(k).ampmin;
%                 fish(j).amprange(k,:) = in(j).day(k).amprange;
%                 %plot(in(j).trial(jj).day(k).SsumfftAmp)
%                 amprange(k,:) = in(j).day(k).amprange;
               
        end
    
      if length(in(j).day) > 1  
      %average across days   
       daymean(j,:) = mean(mday);
%        avgmax(j,:) = mean(ampmax);
%        avgmin(j,:) = mean(ampmin);
%        avgrange(j,:) = mean(amprange);
      else
       daymean(j,:) = mday;
%        avgmax(j,:) = ampmax;
%        avgmin(j,:) = ampmin;
%        avgrange(j,:) = amprange;
      end

      plot(hourtim, daymean(j,:), 'DisplayName',num2str(leg(j))); hold on;
      %max amp range by exp
%       expampmax(j,:) = max(ampmax);
%       expampmin(j,:) = min(ampmin);
    
    
 end
           
   
    
    %averages for each x hour set of experiments
    expmean = mean(daymean);
    meanofexperimentmeans = movmean(expmean, 5);

    plot(hourtim, meanofexperimentmeans, 'k-', 'LineWidth', 3);
    plot([ld ld], [ylim], 'k-');hold off;
    legend

  

%     %average max and min
%     expavgmax = mean(avgmax);
%     expavgmin = mean(avgmin);
%     expavgrange = mean(avgrange);
%     
%         %expmean = smoothdata(meanofexperimentmeans, 'SamplePoints',in(1).trial(1).tim);
%     
%     %amprange for hour;
%     hourampmax = max(expampmax); 
   % hourampmin = min(expampmin); 
    % Mean of means
    %meanofmeans = mean(mday); % Takes the mean of the means for a day from each trial 
    

    
    

