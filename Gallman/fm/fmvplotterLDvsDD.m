function fmvplotterLDvsDD(in1)%, in2)

salmon = [255/255, 140/255, 105/255];
%Blue sky
BlueSky = [98/255, 122/255, 157/255];

%Blue flower
Flowerblue = [133/255, 128/255, 177/255];

Bluishgreen = [103/255, 189/255, 170/255];

Modred = [193/255, 90/255, 99/255];



%in = fm(k)j
figure(48); clf; title('Average Velocity'); hold on; xlim([0,85]); %ylim([0,16]);

   tmplightimes = in1.timfo.lighttimes-in1.timfo.timcont(1)';
   tmplightimes
   %STARTS WITH DARK
   fill([tmplightimes(1)-tmplightimes(1) tmplightimes(1)-tmplightimes(1), tmplightimes(1) tmplightimes(1)], [0 18 18 0], [0.8 0.8 0.8])
   fill([tmplightimes(2) tmplightimes(2) tmplightimes(3) tmplightimes(3)], [0 18 18 0], [0.8 0.8 0.8])
   fill([tmplightimes(4) tmplightimes(4) tmplightimes(5) tmplightimes(5)], [0 18 18 0], [0.8 0.8 0.8])
   fill([tmplightimes(6) tmplightimes(6) tmplightimes(7) tmplightimes(7)], [0 18 18 0], [0.8 0.8 0.8])

%    %STARTS WITH LIGHT
%    fill([tmplightimes(1) tmplightimes(1), tmplightimes(2) tmplightimes(2)], [0 18 18 0], [0.9 0.9 0.9])
%    fill([tmplightimes(3) tmplightimes(3) tmplightimes(4) tmplightimes(4)], [0 18 18 0], [0.9 0.9 0.9])
%    fill([tmplightimes(5) tmplightimes(5) tmplightimes(6) tmplightimes(6)], [0 18 18 0], [0.9 0.9 0.9])
%    fill([tmplightimes(7) tmplightimes(7) tmplightimes(8) tmplightimes(8)], [0 18 18 0], [0.9 0.9 0.9])

    %ALL DARK
%    fill([tmplightimes(1) tmplightimes(1), tmplightimes(2) tmplightimes(2)], [0 18 18 0], [0.7 0.7 0.7])
%    fill([tmplightimes(3) tmplightimes(3) tmplightimes(4) tmplightimes(4)], [0 18 18 0], [0.7 0.7 0.7])
%    fill([tmplightimes(5) tmplightimes(5) tmplightimes(6) tmplightimes(6)], [0 18 18 0], [0.7 0.7 0.7])
%   fill([tmplightimes(7) tmplightimes(7) tmplightimes(8) tmplightimes(8)], [0 18 18 0], [0.7 0.7 0.7])

%    fill([tmplightimes(1)-tmplightimes(1) tmplightimes(1)-tmplightimes(1), tmplightimes(1)+6 tmplightimes(1)+6], [0 18 18 0], [0.9 0.9 0.9])
%    fill(6+[tmplightimes(2) tmplightimes(2) tmplightimes(3) tmplightimes(3)], [0 18 18 0], [0.9 0.9 0.9])
%    fill(6+[tmplightimes(4) tmplightimes(4) tmplightimes(5) tmplightimes(5)], [0 18 18 0], [0.9 0.9 0.9])
%    fill(6+[tmplightimes(6) tmplightimes(6) tmplightimes(7) tmplightimes(7)], [0 18 18 0], [0.9 0.9 0.9])

  % fill([0 0, 90 90], [0 18 18 0], [0.9 0.9 0.9]);

plot([in1.timfo.timcont]-[in1.timfo.timcont(1)], (medfilt1([in1.ss.velmean], 7)), '.-', 'MarkerSize', 16, 'LineWidth', .2, 'Color',salmon);
%     p1 = plot([in1.timfo.timcont]-[in1.timfo.timcont(1)], (medfilt1([in1.ss.velmean], 7)), '.-', 'MarkerSize', 16, 'LineWidth', .2, 'Color', salmon);
%    p2 =  plot([in2.timfo.timcont]-[in2.timfo.timcont(1)], (medfilt1([in2.ss.velmean], 7)), '.-', 'MarkerSize', 16, 'LineWidth', .2, 'Color', Modred);
  % plot([(in1.timfo.lighttimes-in1.timfo.lighttimes(1))' (in1.timfo.lighttimes-in1.timfo.lighttimes(1))'], ylim, 'k-');
    

   % plot([in1.timfo.lighttimes' in1.timfo.lighttimes'], ylim, 'k-');
   % legend([p1 p2], 'LD', 'DD');

    xlabel('Time (hours)');
    ylabel('Velocity (cm/s)');
    
% figure(50); clf;  title('Standard Deviation'); hold on; xlim([0,85]); %ylim([0,4]);
% 
%     plot([in.timfo.timcont]-[in.timfo.timcont(1)], medfilt1([in.ss.velstd],7), '.', 'LineWidth', 2, 'MarkerSize', 16, 'Color', salmon);
%     plot([(in.timfo.lighttimes-in.timfo.lighttimes(1))' (in.timfo.lighttimes-in.timfo.lighttimes(1))'], ylim, 'k-');
%     %plot([in.timfo.lighttimes' in.timfo.lighttimes'], ylim, 'k-');   
% 
%     xlabel('Time (hours)');
%     ylabel('Standard deviations');
% 
% figure(51); clf;  title('Tank Crossings'); hold on; xlim([0,85]); %ylim([0,18]);
% 
%     plot([in.timfo.timcont]-[in.timfo.timcont(1)], medfilt1([in.sx.midxings], 7), '.', 'LineWidth', 2, 'MarkerSize', 16, 'Color', salmon); %ylim([0, 35]);
%     plot([(in.timfo.lighttimes-in.timfo.lighttimes(1))' (in.timfo.lighttimes-in.timfo.lighttimes(1))'], ylim, 'k-');
%     %plot([in.timfo.lighttimes' in.timfo.lighttimes'], ylim, 'k-');  
% 
%     xlabel('Time (hours)');
%     ylabel('Tank crossings');

% figure(48); clf; hold on;
% 
%     plot([in.ss.timcont], [in.ss.velmean2], '.-');
%     plot([in.timfo.lighttimes' in.timfo.lighttimes'], ylim, 'k-');
