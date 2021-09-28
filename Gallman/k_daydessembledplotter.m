function k_daydessembledplotter(in)
%% usage
%plots output from KatieDayTrialDessember for multiple kgs

%      for j = 1:length(kgidx)
%           [in(j).trial, in(j).day] = KatieDayTrialDessembler(kg(kgidx(j)), channel, 48, ReFs);
%      end

%in.trial and %in.day

ld = in(1).trial(1).ld;

 %all days
 %average day by trial
 figure(27); clf; hold on; title('Day average by trial');
 
 for j = 1:length(in)
    for jj=1:length(in(j).trial) 

        %create temporary vector to calculate mean by trial
        %t(j).mday(jj,:) = zeros(1,length(day14(j).trial(jj).tim));
        mday(jj,:) = zeros(1,length(in(j).trial(jj).tim));
       % t(j).mmday(jj,:) = zeros(1,length(day14(j).trial(jj).tim));

        for k=1:length(in(j).trial(jj).day)

                %fill temporary vector with data from each day 
                mday(jj,:) = mday(jj,:) + in(j).trial(jj).day(k).SobwAmp;
               
                
                %plot
                subplot(211); hold on; title('Days');
                plot(in(j).trial(jj).tim, in(j).trial(jj).day(k).SobwAmp);
                plot([ld ld], ylim, 'k-', 'LineWidth', 1);

        end

         % To get average across days, divide by number of days
            mday(jj,:) = mday(jj,:) / length(in(j).trial(jj).day);
           
            
            
            %plot
            subplot(212); hold on; title('Day average by trial');
            plot(in(j).trial(jj).tim, mday(jj,:), '-', 'Linewidth', 1);
            plot([ld ld], ylim, 'k-', 'LineWidth', 1);

    end

 end  
   
    % Mean of means
     meanoftrialmeans = mean(mday); % Takes the mean of the means for a day from each trial 
     
    subplot(212); hold on;
    plot(in(1).trial(1).tim, meanoftrialmeans, 'k-', 'LineWidth', 3);
   

    
    
figure(28); clf; hold on; 

for j = 1:length(in)

 for k = 1:length(in(j).day)
        plot(in(j).day(k).tim, in(j).day(k).SobwAmp);
        td(j).meanday(k,:) = in(j).day(k).SobwAmp;
 end
end
        mmday= mean(td(j).meanday);
        plot(in(1).day(1).tim, mmday, 'k-', 'LineWidth', 3);
        plot([ld ld], ylim, 'k-', 'LineWidth', 1);
        
figure(29); clf; hold on;
    plot(in(1).day(1).tim, mmday);
    plot(in(1).trial(1).tim, meanoftrialmeans);
    plot([ld ld], ylim, 'k-', 'LineWidth', 1);
    legend('day mean', 'trial mean');
     legend('boxoff')

