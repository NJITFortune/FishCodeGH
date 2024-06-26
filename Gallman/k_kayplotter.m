function k_kayplotter(in, ld)

%in = kay
%% trial light cycle
figure(1); clf; hold on; title('trial hour day');
%set(figure(1),'Units','normalized','Position',[0 0 .5 .5]); 
    
 %plot data
      axs(1) = subplot(211); hold on; 
        for j = 1:length(in)
            plot(in(j).tim, in(j).mavgresp / max(abs(in(j).mavgresp - mean(in(j).mavgresp))));
            forcalcmean(j,:) = in(j).mavgresp / max(abs(in(j).mavgresp - mean(in(j).mavgresp)));
        end
            plot(in(1).tim, mean(forcalcmean), 'k', 'LineWidth', 3);
            plot([ld ld], ylim, 'k-','Linewidth', 2);
            xlim([0, in(1).tim(end)]);
       
        %prep for fig   
            %calculate mean and sd of kay, 
            tt = [in(1).tim];
            tt = [tt, tt(end:-1:1)];
            kavgresp = mean(forcalcmean);
            kstd = std(forcalcmean);   
        
      axs(2) = subplot(212); hold on; 
        fill(tt, [kavgresp+kstd, kavgresp(end:-1:1)-kstd(end:-1:1)], 'c');
        plot(in(1).tim, kavgresp, 'k', 'LineWidth', 3);
        plot([ld ld], ylim, 'k-', 'Linewidth', 2); 
        xlim([0, in(1).tim(end)]);

 linkaxes(axs, 'x'); 
        
%% imposed 12 hour cycle
figure(12); clf; hold on; title('24hour day');
%set(figure(1),'Units','normalized','Position',[0 0 .5 .5]); 
    
    
    
 %plot data
      ax(1) = subplot(211); hold on; 
        for j = 1:length(in)
            plot(in(j).twelvetim, in(j).twelvemavgresp / max(abs(in(j).twelvemavgresp- mean(in(j).twelvemavgresp))));
            twforcalcmean(j,:) = in(j).twelvemavgresp / max(abs(in(j).twelvemavgresp - mean(in(j).twelvemavgresp)));
        end
            plot(in(1).twelvetim, mean(twforcalcmean), 'k', 'LineWidth', 3);
            plot([12 12], ylim, 'k-','Linewidth', 2);
            xlim([0, in(1).twelvetim(end)]);
       
        %prep for fig   
            %calculate mean and sd of kay
            tt = [in(1).twelvetim];
            tt = [tt, tt(end:-1:1)];
            kavgresp = mean(twforcalcmean);
            kstd = std(twforcalcmean);   
        
      ax(2) = subplot(212); hold on; 
        fill(tt, [kavgresp+kstd, kavgresp(end:-1:1)-kstd(end:-1:1)], 'c');
        plot(in(1).twelvetim, kavgresp, 'k', 'LineWidth', 3);
        plot([12 12], ylim, 'k-', 'Linewidth', 2); 
        xlim([0, in(1).twelvetim(end)]);
        
 linkaxes(ax, 'x');