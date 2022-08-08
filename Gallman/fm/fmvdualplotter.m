function fmvdualplotter(in)
%% colors
%Pinks
salmon = [255/255, 140/255, 105/255];
Modred = [193/255, 90/255, 99/255];
%Blues
BlueSky = [98/255, 122/255, 157/255];
Flowerblue = [133/255, 128/255, 177/255];

%% plots
%in = fm(k)
figure(448); clf; title('Average velocity'); hold on; %xlim([0,85]);% ylim([0,10]);

    tmplightimes = in.timfo.lighttimes-in.timfo.timcont(1)';

   fill([tmplightimes(1) tmplightimes(1) tmplightimes(2) tmplightimes(2)], [0 18 18 0], [0.9 0.9 0.9])
   fill([tmplightimes(3) tmplightimes(3) tmplightimes(4) tmplightimes(4)], [0 18 18 0], [0.9 0.9 0.9])
   fill([tmplightimes(5) tmplightimes(5) tmplightimes(6) tmplightimes(6)], [0 18 18 0], [0.9 0.9 0.9])
%   fill([tmplightimes(7) tmplightimes(7) tmplightimes(8) tmplightimes(8)], [0 18 18 0], [0.9 0.9 0.9])

   %fill([0 0, 90 90], [0 18 18 0], [0.9 0.9 0.9]);
   length([in.timfo.timcont])
   length([in.ss.onevel])

    p1 = plot([in.timfo.timcont]-[in.timfo.timcont(1)], (medfilt1([in.ss.onevel], 7)), '.-', 'MarkerSize', 16, 'LineWidth', .2, 'Color', salmon);
    p2 =  plot([in.timfo.timcont]-[in.timfo.timcont(1)], (medfilt1([in.ss.twovel], 7)), '.-', 'MarkerSize', 16, 'LineWidth', .2, 'Color', Modred);
%   plot([(in.timfo.lighttimes-in.timfo.timcont(1))' (in.timfo.lighttimes-in.timfo.timcont(1))'], ylim, 'k-');
    
   legend([p1 p2], 'Fish one', 'Fish two');

    xlabel('Time (hours)');
    ylabel('Velocity (cm/s)');
    
    %%
figure(450); clf;  title('Standard Deviation'); hold on; xlim([0,85]); %ylim([0,10]);

   fill([tmplightimes(1) tmplightimes(1) tmplightimes(2) tmplightimes(2)], [0 18 18 0], [0.9 0.9 0.9])
   fill([tmplightimes(3) tmplightimes(3) tmplightimes(4) tmplightimes(4)], [0 18 18 0], [0.9 0.9 0.9])
   fill([tmplightimes(5) tmplightimes(5) tmplightimes(6) tmplightimes(6)], [0 18 18 0], [0.9 0.9 0.9])
   fill([tmplightimes(7) tmplightimes(7) tmplightimes(8) tmplightimes(8)], [0 18 18 0], [0.9 0.9 0.9])

    p1 = plot([in.timfo.timcont]-[in.timfo.timcont(1)], (medfilt1([in.ss.onestd], 7)), '.-', 'MarkerSize', 16, 'LineWidth', .2, 'Color', salmon);
    p2 =  plot([in.timfo.timcont]-[in.timfo.timcont(1)], (medfilt1([in.ss.twostd], 7)), '.-', 'MarkerSize', 16, 'LineWidth', .2, 'Color', Modred);
   plot([(in.timfo.lighttimes-in.timfo.timcont(1))' (in.timfo.lighttimes-in.timfo.timcont(1))'], ylim, 'k-');
    
   legend([p1 p2], 'Fish one', 'Fish two');

    xlabel('Time (hours)');
    ylabel('Standard deviations');

figure(451); clf;  title('Tank Crossings'); hold on; xlim([0,85]); %ylim([0,1]);

   fill([tmplightimes(1) tmplightimes(1) tmplightimes(2) tmplightimes(2)], [0 18 18 0], [0.9 0.9 0.9])
   fill([tmplightimes(3) tmplightimes(3) tmplightimes(4) tmplightimes(4)], [0 18 18 0], [0.9 0.9 0.9])
   fill([tmplightimes(5) tmplightimes(5) tmplightimes(6) tmplightimes(6)], [0 18 18 0], [0.9 0.9 0.9])
   fill([tmplightimes(7) tmplightimes(7) tmplightimes(8) tmplightimes(8)], [0 18 18 0], [0.9 0.9 0.9])


    p1 = plot([in.timfo.timcont]-[in.timfo.timcont(1)], (medfilt1([in.ss.onemidxings], 7)), '.-', 'MarkerSize', 16, 'LineWidth', .2, 'Color', salmon);
    p2 =  plot([in.timfo.timcont]-[in.timfo.timcont(1)], (medfilt1([in.ss.twomidxings], 7)), '.-', 'MarkerSize', 16, 'LineWidth', .2, 'Color', Modred);
   plot([(in.timfo.lighttimes-in.timfo.timcont(1))' (in.timfo.lighttimes-in.timfo.timcont(1))'], ylim, 'k-');
    
   legend([p1 p2], 'Fish one', 'Fish two');

    xlabel('Time (hours)');
    ylabel('Tank crossings');

