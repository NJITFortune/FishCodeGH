function [hourtim, meanoftrialmeans, ld] = k_daymeans(in)
%% usage
%processes output from KatieDayTrialDessembler.m of kg by hourexp
%k_daydessembledplotter.m without the plotting
%for use with plotting mean summary of entire kg

%      for j = 1:length(kgidx)
%           [in(j).trial, in(j).day] = KatieDayTrialDessembler(kg(kgidx(j)), channel, 48, ReFs);
%      end

%in.trial and %in.day

ld = in(1).trial(1).ld;

 %all days
 %average day by trial
 
clear mday;
 
 for j = 1:length(in)
    for jj=1:length(in(j).trial) 

        %create temporary vector to calculate mean by trial
        mday(jj,:) = zeros(1,length(in(j).trial(jj).tim));

        for k=1:length(in(j).trial(jj).day)

                %fill temporary vector with data from each day 
                mday(jj,:) = mday(jj,:) + in(j).trial(jj).day(k).SobwAmp;
               
        end

         % To get average across days, divide by number of days
            mday(jj,:) = mday(jj,:) / length(in(j).trial(jj).day);
          
    end

 end  
   
    % Mean of means
    meanoftrialmeans = mean(mday); % Takes the mean of the means for a day from each trial 
    
    hourtim = in(1).trial(1).tim;
   

    
    

