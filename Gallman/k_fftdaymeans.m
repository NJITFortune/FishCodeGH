function [hourtim, meanoftrialmeans, amprange, ld, pulsetype] = k_fftdaymeans(in)
%% usage
%processes output from KatieDayTrialDessembler.m of kg by hourexp
%k_daydessembledplotter.m without the plotting
%for use with plotting mean summary of entire kg

% clearvars -except dark kg kg2 colorsforplots
% in = dark(1).h;

% for k = 1:length(dark)
%      [dark(k).hourtim, dark(k).meanoftrialmeans, dark(k).ld] = k_fftdaymeans(dark(k).h);
% end

%in.trial and %in.day

ld = in(1).trial(1).ld;

 %all days
 %average day by trial
 
clear mday;
%figure(99);clf; hold on; 
 for j = 1:length(in)
  
    for jj=1:length(in(j).trial) 

   
        %in(j).trial(jj).Sentiretimcont

        %create temporary vector to calculate mean by trial
        mday(jj,:) = zeros(1,length(in(j).trial(jj).tim));

        for k = 1:length(in(j).trial(jj).day)

                %fill temporary vector with data from each day 
                mday(jj,:) = mday(jj,:) + in(j).trial(jj).day(k).SsumfftAmp;
                
                %plot(in(j).trial(jj).day(k).SsumfftAmp);
               
        end

         % To get average across days, divide by number of days
            
            mday(jj,:) = mday(jj,:) / length(in(j).trial(jj).day);
            trialampmax(jj,:) =  max([in(j).trial(jj).trialmax]);
            trialampmin(jj,:) = min([in(j).trial(jj).trialmin]);
    end
    amprange(j,:) = [min(trialampmin), max(trialampmax)];
    
 end  

    
   
    % Mean of means
    meanoftrialmeans = mean(mday); % Takes the mean of the means for a day from each trial 
    
    hourtim = in(1).trial(1).tim;
   
   

    
    

