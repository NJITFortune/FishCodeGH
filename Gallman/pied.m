
%load('/Volumes/Datums/kg/pk.mat');

figure(314); clf; hold on;
%set(0,'DefaultAxesColorOrder', lines(10));


    for j = 1:10%10

      
        ld(j,:) = pk(j).ld;
        crosshour = (2*pi) / (2 * pk(j).ld);
        plot(pk(j).timforpi .* crosshour, pk(j).meanoftrialmeans .* crosshour);
        legend(num2str(ld)); 
        legend('AutoUpdate', 'off');
        
       
    end
 plot([pi pi], ylim, 'k-');