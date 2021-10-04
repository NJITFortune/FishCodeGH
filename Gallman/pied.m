
%load('/Volumes/Datums/kg/pk.mat');

close all; figure(314); clf; hold on;
set(0,'DefaultAxesColorOrder', prism(9));


    for j = 1:9

      
        ld(j,:) = ppk(j).ld;
        crosshour = (2*pi) / (2 * ppk(j).ld);
        plot((ppk(j).timforpi .* crosshour) - pi, (ppk(j).meanoftrialmeans) , 'LineWidth', 2);
        legend(num2str(ld)); 
        legend('AutoUpdate', 'off');
        
       
    end
 plot([0 0], ylim, 'k-');