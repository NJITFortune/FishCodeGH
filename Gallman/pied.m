
%load('/Volumes/Datums/kg/pk.mat');

figure(314); clf; hold on;



    for j = 1:10

          ld(j,:) = pk(j).ld;
        crosshour = (2*pi) / (2 * pk(j).ld);
        plot(pk(j).timforpi .* crosshour, pk(j).meanoftrialmeans .* crosshour);
        plot([pi pi], ylim, 'k-'); hold on;
        legend(num2str(ld'));

    end
