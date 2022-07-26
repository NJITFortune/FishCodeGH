

figure(22); clf; title('freq-nonphase adjusted'); hold on

y1idx = find([out(1).s.pflo] > 400 & [out(1).s.pflo]<430);
x = [out(1).s(y1idx).timcont]/3600;
y1 = [out(1).s(y1idx).pflo];
y2 = [out(1).s(y1idx).pfhi];

plot(x, y1);
plot(x, y2);
patch([x fliplr(x)], [y1 fliplr(y2)],'r');

plot([out(1).s.timcont]/3600, [out(1).s.fftFreq], 'k-', 'LineWidth',3);


% figure(28);clf; hold on;
%         
%         ax(1) = subplot(411); title('Mean square amplitude'); hold on;
%             plot([out(2).s.timcont]/3600, [out(1).s.obwAmp], 'o');
%             a = ylim;
%             for j = 1:length(lightlines)-1
%                 if mod(j,2) == 0 %if j is even
%                 fill([lightlines(j) lightlines(j) lightlines(j+1) lightlines(j+1)], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
%                 end
%             end
% 
%             plot([out(2).s.timcont]/3600, [out(1).s.pobwAmp], '.', 'MarkerSize', 10);
%             plot([out(2).s.timcont]/3600, [out(1).s.obwAmp], 'o');
%         
%         ax(2) = subplot(412); title('Frequency-nonphase'); hold on;
%             plot([out(1).s.timcont]/3600, [out(1).s.flo]);
%             plot([out(1).s.timcont]/3600, [out(1).s.fhi]);
%             patch([[out(1).s.timcont]/3600 fliplr([out(1).s.timcont]/3600)], [[out(1).s.flo] fliplr([out(1).s.fhi])],'r');
%             plot([out(1).s.timcont]/3600, [out(1).s.fftFreq], 'k-');
%             
%          ax(3) = subplot(413); title('Frequency-phase'); hold on;
%             y1idx = find([out(1).s.pflo] > 400 & [out(1).s.pflo]<430);
%             
%             plot([out(1).s.timcont]/3600, [out(1).s.pflo]);
%             plot([out(1).s.timcont]/3600, [out(1).s.pfhi]);
%             patch([[out(1).s.timcont]/3600 fliplr([out(1).s.timcont]/3600)], [[out(1).s.pflo] fliplr([out(1).s.pfhi])],'b');
%             plot([out(1).s.timcont]/3600, [out(1).s.fftFreq], 'k-');
%             
%         ax(4) = subplot(515); title('light'); hold on;ylim([-1, 6]);
%             plot([out(1).s.timcont]/3600, [out(1).s.light]);
%             plot([out(2).s.timcont]/3600, [out(2).s.light]);
%     
%     linkaxes(ax, 'x')