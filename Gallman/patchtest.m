

%figure(22); clf; title('freq-nonphase adjusted'); hold on

%y1idx = find([out(1).s.pfhi] < 435 );
% y1idx = find([out(1).s.pflo] > 385);
% 
% x = [out(1).s.timcont]/3600;
% x = x(y1idx);
% y2 = [out(1).s.pflo];
% y2 = y2(y1idx);
% y1 = [out(1).s.pfhi];
% y1 = y1(y1idx);
% y3 = [out(1).s.fftFreq];
% y3 = y3(y1idx);
% 
% plot(x, y1);
% plot(x, y2);
% patch([x fliplr(x)], [y1 fliplr(y2)],'r');
% 
% plot(x, [out(1).s(y1idx).fftFreq], 'k-', 'LineWidth',3);
%coral
Coral = [255/255, 127/255, 80/255];
%Bluish green
Bluishgreen = [103/255, 189/255, 170/255];

figure(28);clf; hold on;
        
        ax(1) = subplot(311); title('Mean square amplitude'); hold on;
            plot([out(2).s.timcont]/3600, [out(1).s.obwAmp], 'o', 'MarkerSize', 8,'Color', Bluishgreen);
            a = ylim;
            for j = 1:length(lightlines)-1
                if mod(j,2) == 0 %if j is even
                fill([lightlines(j) lightlines(j) lightlines(j+1) lightlines(j+1)], [a(1) .15 .15 a(1)], [0.9, 0.9, 0.9]);
                end
            end

            plot([out(2).s.timcont]/3600, [out(1).s.pobwAmp], '.', 'MarkerSize', 10, 'Color',Coral);
            plot([out(2).s.timcont]/3600, [out(1).s.obwAmp], 'o', 'Color',Bluishgreen);
        
        ax(2) = subplot(312); title('Frequency-nonphase'); hold on;

            plot([out(1).s.timcont]/3600, [out(1).s.flo]);
            plot([out(1).s.timcont]/3600, [out(1).s.fhi]);
            a = ylim;
            for j = 1:length(lightlines)-1
                if mod(j,2) == 0 %if j is even
                fill([lightlines(j) lightlines(j) lightlines(j+1) lightlines(j+1)], [a(1) 550 550 a(1)], [0.9, 0.9, 0.9]);
                end
            end

            patch([[out(1).s.timcont]/3600 fliplr([out(1).s.timcont]/3600)], [[out(1).s.flo] fliplr([out(1).s.fhi])],'b');
            plot([out(1).s.timcont]/3600, [out(1).s.fftFreq], 'k-');
            
         ax(3) = subplot(313); title('Frequency-phase'); hold on;
            
            y1idx = find([out(1).s.pflo] > 385);

                x = [out(1).s.timcont]/3600;
                x = x(y1idx);
                y2 = [out(1).s.pflo];
                y2 = y2(y1idx);
                y1 = [out(1).s.pfhi];
                y1 = y1(y1idx);
                y3 = [out(1).s.fftFreq];
                y3 = y3(y1idx);
                
                plot(x, y1);
                plot(x, y2);
            

            a = ylim;
            for j = 1:length(lightlines)-1
                if mod(j,2) == 0 %if j is even
                fill([lightlines(j) lightlines(j) lightlines(j+1) lightlines(j+1)], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
                end
            end
            patch([x fliplr(x)], [y1 fliplr(y2)],'r');
            plot(x,y3, 'k-');
            
       
    
    linkaxes(ax, 'x')