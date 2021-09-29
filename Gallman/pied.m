
%load('/Volumes/Datums/kg/pk.mat');

figure(314); clf; hold on;

  cmap = colormap(jet);

    for j = 1:10%10

      
        ld(j,:) = pk(j).ld;
        crosshour = (2*pi) / (2 * pk(j).ld);
        plot(pk(j).timforpi .* crosshour, pk(j).meanoftrialmeans .* crosshour, 'Color', colormap(jet));
        legend(num2str(ld)); 
        legend('AutoUpdate', 'off');
        
       
    end
 plot([pi pi], ylim, 'k-');