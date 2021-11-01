
clearvars -except kg
%close(figure(222));

%tests for spline fitting subtraction
%plot like the detrending?

in = kg(61);
channel = 1;
ReFs = 10;
p = 0.9;


ld = in.info.ld;

%% Take spline estimate of raw data

[xx, obwyy, obwAmp, obwtimOG, obwAmpOG, lighttimes] =  k_testobwspliner(in, channel, ReFs, p);

% Plot spline vs raw data

figure(222); clf; title('spline estimate vs raw data'); hold on;
    
    axs(1) = subplot(211); title('entire data set'); hold on;

        plot(obwtimOG, obwAmpOG, '.', 'MarkerSize', 3);
        plot(xx, obwyy, 'LineWidth', 3);

        for j = 1:length(lighttimes)
        plot([lighttimes(j) lighttimes(j)], ylim, 'k-', 'LineWidth', 1);
        end

%% spline estimate of raw data above original spline

% %subset raw data
   obwidx = find(obwAmpOG > obwAmp);
   subobw = obwAmpOG(obwidx);
   subobwtim = obwtimOG(obwidx);
   
%estimate new spline 
p = 0.5;

  %estimate new yvalues for every x value

        %obw
        spliney = csaps(subobwtim, subobw, p);
        %resample new x values based on light/dark
        subobwyy = fnval(xx, spliney);
       
            
%plot to check

    axs(2) = subplot(212); title('data subset'); hold on;
    
        plot(subobwtim, subobw, '.', 'MarkerSize', 3);
        plot(xx, subobwyy, 'LineWidth', 3);

        for j = 1:length(lighttimes)
        plot([lighttimes(j) lighttimes(j)], ylim, 'k-', 'LineWidth', 1);
        end
   
linkaxes(axs, 'x');

%% more plots

figure(223); clf; hold on; 

    xs(1) = subplot(211); title('raw data'); hold on;

        plot(obwtimOG, obwAmpOG, '.', 'MarkerSize', 3);
        plot(subobwtim, subobw, '.', 'MarkerSize', 3);
        

        for j = 1:length(lighttimes)
        plot([lighttimes(j) lighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
        end
     legend('full data set', 'data subset');
   
    xs(2) = subplot(212); title('spline estimate'); hold on;

        plot(xx, obwyy, 'LineWidth', 3);
        plot(xx, subobwyy, 'LineWidth', 3);
        
        
        for j = 1:length(lighttimes)
        plot([lighttimes(j) lighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
        end
        
    legend('full data set', 'data subset');
   
linkaxes(xs, 'x');

% %% does it change the mean estimate?
% 
% %divide data into trials to calculate day means by trial
% 
%   fulltrial = k_trialdaydivider(obwtimOG, obwAmpOG, xx, obwyy, ld, lighttimes, ReFs);
%   subtrial = k_trialdaydivider(subobwtim, subobw, xx, subobwyy, ld, lighttimes, ReFs);
%   
% %plot
% %FULL TRIAL
% %average day by trial
%  figure(227); clf; title('Day average by fulltrial'); hold on; 
%     for jj=1:length(fulltrial) 
% 
%         %create temporary vector to calculate mean by trial
%         mday(jj,:) = zeros(1,length(fulltrial(jj).daytim));
% 
% 
%         for k=1:length(fulltrial(jj).daytim)
% 
%                 %fill temporary vector with data from each day 
%                 mday(jj,:) = mday(jj,:) + fulltrial(jj).SAmpday(k);
%                 subplot(211); hold on; title('Days');
%                 plot(fulltrial(jj).daytim, fulltrial(jj).SAmpday(k));
%                 plot([ld ld], ylim, 'k-', 'LineWidth', 1);
% 
%         end
% 
%          % To get average across days, divide by number of days
%             mday(jj,:) = mday(jj,:) / length(fulltrial(jj).daytim);
%             subplot(212); hold on; title('Day average by trial');
%             plot(fulltrial(jj).daytim, mday(jj,:), '-', 'Linewidth', 1);
%             plot([ld ld], ylim, 'k-', 'LineWidth', 1);
% 
%     end
%     
%     % Mean of means
%  
%     subplot(212); hold on;
%      meanofmeans = mean(mday); % Takes the mean of the means for a day from each trial 
%     plot(fulltrial(jj).daytim, meanofmeans, 'k-', 'LineWidth', 3);
%    
% %SUB TRIAL
% %average day by trial
%  figure(228); clf; title('Day average by subtrial'); hold on; 
%     for jj=1:length(subtrial) 
% 
%         %create temporary vector to calculate mean by trial
%         submday(jj,:) = zeros(1,length(subtrial(jj).daytim));
% 
% 
%         for k=1:length(subtrial(jj).daytim)
% 
%                 %fill temporary vector with data from each day 
%                 submday(jj,:) = submday(jj,:) + subtrial(jj).SAmpday(k);
%                 subplot(211); hold on; title('Days');
%                 plot(subtrial(jj).daytim, subtrial(jj).SAmpday(k));
%                 plot([ld ld], ylim, 'k-', 'LineWidth', 1);
% 
%         end
% 
%          % To get average across days, divide by number of days
%             submday(jj,:) = submday(jj,:) / length(subtrial(jj).daytim);
%             subplot(212); hold on; title('Day average by trial');
%             plot(subtrial(jj).daytim, submday(jj,:), '-', 'Linewidth', 1);
%             plot([ld ld], ylim, 'k-', 'LineWidth', 1);
% 
%     end
%     
%     % Mean of means
%  
%     subplot(212); hold on;
%      submeanofmeans = mean(submday); % Takes the mean of the means for a day from each trial 
%     plot(subtrial(jj).daytim, submeanofmeans, 'k-', 'LineWidth', 3);
%     
%     
%  figure(229); clf; title('Day Averages by estimate')
%   
%   plot(subtrial(jj).daytim, meanofmeans, 'k-', 'LineWidth', 3);
%   plot(subtrial(jj).daytim, submeanofmeans, 'k-', 'LineWidth', 3);
%   legend('full data spline', 'subdata spline');
%   
%%

trial = k_trialdaydivider(obwtimOG, obwAmpOG, xx, obwyy, ld, lighttimes, ReFs);
figure(227); clf; title('Day average by fulltrial'); hold on; 

drawnow

    for jj=1:length(trial) 

        %create temporary vector to calculate mean by trial
        mday(jj,:) = zeros(1,length(trial(jj).daytim));

        for k=1:length(trial(jj).day)

                %fill temporary vector with data from each day 
                mday(jj,:) = mday(jj,:) + trial(jj).day(k).SAmpday;
                subplot(211); hold on; title('Days');
                plot(trial(jj).daytim, trial(jj).day(k).SAmpday);
                plot([ld ld], ylim, 'k-', 'LineWidth', 1);

        end

         % To get average across days, divide by number of days
            mday(jj,:) = mday(jj,:) / length(trial(jj).day);
            subplot(212); hold on; title('Day average by trial');
            plot(trial(jj).daytim, mday(jj,:), '-', 'Linewidth', 1);
            plot([ld ld], ylim, 'k-', 'LineWidth', 1);

    end
    
    % Mean of means
 
    subplot(212); hold on;
     meanofmeans = mean(mday); % Takes the mean of the means for a day from each trial 
    plot(trial(jj).daytim, meanofmeans, 'k-', 'LineWidth', 3);
   