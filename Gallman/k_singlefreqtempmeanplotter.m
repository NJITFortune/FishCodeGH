function k_singlefreqtempmeanplotter(day, j)

%% plot to check


%average over single day    
figure(j + 700); clf; hold on; 

 
    subplot(121); title('temperature'); hold on;
    %mean two ways to prove math
  %  mday = zeros(1, length(day(1).tim));        
     for j = 1:length(day)
         
            plot(day(j).tim/3600, k_temptocelcius(day(j).temp), 10000);
            tempday(j,:) = k_temptocelcius(day(j).temp);
         %   mday = mday + day(j).Sobwyy;
            
     end
        
            ttday= mean(tempday);
           % othermday = mday/(length(day));
            plot(day(1).tim/3600, ttday, 'r-', 'LineWidth', 3);
          %  plot(day(1).tim/3600, othermday, 'b-', 'LineWidth', 3);
%            plot([day(1).ld day(1).ld], ylim, 'k-', 'LineWidth', 3);


   subplot(122); title('frequency'); hold on;
    %mean two ways to prove math
  %  mday = zeros(1, length(day(1).tim));        
     for j = 1:length(day)
            plot(day(j).tim/3600, day(j).freq);
            freqday(j,:) = day(j).freq;
         %   mday = mday + day(j).Sobwyy;
            
     end
        
            ffday= mean(freqday);
           % othermday = mday/(length(day));
            plot(day(1).tim/3600, ffday, 'b-', 'LineWidth', 3);
          %  plot(day(1).tim/3600, othermday, 'b-', 'LineWidth', 3);
      %      plot([day(1).ld day(1).ld], ylim, 'k-', 'LineWidth', 3);
            
            



