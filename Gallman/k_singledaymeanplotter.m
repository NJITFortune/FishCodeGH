
function k_singledaymeanplotter(day)

%% plot to check


%average over single day    
%figure(56); clf; hold on; 
a = [min([day.Sobwyy])-min([day.Sobwyy])/4, max([day.Sobwyy])+max([day.Sobwyy])/4];
 
    %create fill box 
    if light < 4 %we start with dark
        fill([0 0 ld ld], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
    else %we start with light
        fill([ld ld ld*2 ld*2], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
    end
    
    %mean two ways to prove math
  %  mday = zeros(1, length(day(1).tim));        
     for j = 1:length(day)
            plot(day(j).tim/3600, day(j).Sobwyy);
            meanday(j,:) = day(j).Sobwyy;
         %   mday = mday + day(j).Sobwyy;
            
     end
        
            mmday= mean(meanday);
           % othermday = mday/(length(day));
            plot(day(1).tim/3600, mmday, 'k-', 'LineWidth', 3);
          %  plot(day(1).tim/3600, othermday, 'b-', 'LineWidth', 3);
            plot([day(1).ld day(1).ld], ylim, 'k-', 'LineWidth', 3);
            
            



