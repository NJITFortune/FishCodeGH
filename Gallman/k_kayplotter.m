function k_kayplotter(in)

%in = kay

figure(1); clf; hold on; title('power at daylength in hours');
%set(figure(1),'Units','normalized','Position',[0 0 .5 .5]); 
    
    
    
 %plot data
      axs(1) = subplot(211); hold on; 
        for j = 1:length(kay)
            plot(kay(j).tim, kay(j).mavgresp);
            forcalcmean(j,:) = kay(j).mavgresp;
        end
            plot(kay(1).tim, mean(forcalcmean), 'k', 'LineWidth', 3);
            plot([k k], ylim, 'k-');
            xlim([0, kay(1).tim(end)]);
       
        %prep for fig   
            %calculate mean and sd of kay
            tt = [kay(1).tim];
            tt = [tt, tt(end:-1:1)];
            kavgresp = mean(forcalcmean);
            kstd = std(kavgresp);
            
        
        
      axs(2) = subplot(212); hold on; 
        fill(tt, [kavgresp+kstd, kavgresp(end:-1:1)-kstd(end:-1:1)], 'c');
        plot(kay(1).tim, kavgresp, 'k', 'LineWidth', 3);
        plot([k k], ylim, 'k-', 'Linewidth', 2); 
        xlim([0, kay(1).tim(end)]);
  