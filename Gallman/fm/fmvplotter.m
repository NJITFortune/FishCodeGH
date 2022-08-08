function fmvplotter(in)

salmon = [255/255, 140/255, 105/255];
%Blue sky
BlueSky = [98/255, 122/255, 157/255];

%Blue flower
Flowerblue = [133/255, 128/255, 177/255];


%in = fm(k)
figure(47); clf; title('Average Velocity'); hold on; xlim([0,85]); %ylim([0,2.5]);

    plot([in.timfo.timcont]-[in.timfo.timcont(1)], (medfilt1([in.ss.velmean], 7)), '.-', 'MarkerSize', 16, 'LineWidth', .2, 'Color', BlueSky);
   % plot([in2.timfo.timcont]-[in2.timfo.timcont(1)], (medfilt1([in2.ss.velmean], 7)), '.', 'MarkerSize', 16, 'LineWidth', .2, 'Color', Flowerblue);
    plot([(in.timfo.lighttimes-in.timfo.timcont(1))', (in.timfo.lighttimes-in.timfo.timcont(1))'], ylim, 'k-');
    plot([in.timfo.lighttimes' in.timfo.lighttimes'], ylim, 'k-');


    xlabel('Time (hours)');
    ylabel('Average velocity (cm/s)');
    
figure(50); clf;  title('Standard Deviation'); hold on; xlim([0,85]); %ylim([0,4]);

    plot([in.timfo.timcont]-[in.timfo.timcont(1)], medfilt1([in.ss.velstd],7), '.-', 'LineWidth', 2, 'MarkerSize', 16, 'Color', salmon);
    plot([(in.timfo.lighttimes-in.timfo.timcont(1))', (in.timfo.lighttimes-in.timfo.timcont(1))'], ylim, 'k-');
    %plot([in.timfo.lighttimes' in.timfo.lighttimes'], ylim, 'k-');   

    xlabel('Time (hours)');
    ylabel('Standard deviations');

figure(51); clf;  title('Tank Crossings'); hold on; xlim([0,85]); %ylim([0,18]);

    plot([in.timfo.timcont]-[in.timfo.timcont(1)], medfilt1([in.sx.midxings], 7), '.-', 'LineWidth', 2, 'MarkerSize', 16, 'Color', salmon); %ylim([0, 35]);
    plot([(in.timfo.lighttimes-in.timfo.timcont(1))', (in.timfo.lighttimes-in.timfo.timcont(1))'], ylim, 'k-');
    %plot([in.timfo.lighttimes' in.timfo.lighttimes'], ylim, 'k-');  

    xlabel('Time (hours)');
    ylabel('Tank crossings');

% figure(48); clf; hold on;
% 
%     plot([in.ss.timcont], [in.ss.velmean2], '.-');
%     plot([in.timfo.lighttimes' in.timfo.lighttimes'], ylim, 'k-');
