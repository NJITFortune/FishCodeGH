

% figure(22); clf; title('freq-nonphase adjusted'); hold on
% 
% x = [out(1).s.timcont]/3600;
% y1 = [out(1).s.flo];
% y2 = [out(1).s.fhi];
% 
% plot([out(1).s.timcont]/3600, [out(1).s.flo]);
% plot([out(1).s.timcont]/3600, [out(1).s.fhi]);
% patch([x fliplr(x)], [y1 fliplr(y2)],'r');
% 
% plot([out(1).s.timcont]/3600, [out(1).s.fftFreq], 'k-', 'LineWidth',3);


figure(28);clf; hold on;
        
        ax(1) = subplot(411); title('Mean square amplitude'); hold on;
            plot([out(2).s.timcont]/3600, [out(1).s.pobwAmp], '.', 'MarkerSize', 8);
            plot([out(2).s.timcont]/3600, [out(1).s.obwAmp], 'o');
        
        ax(2) = subplot(412); title('Frequency-nonphase'); hold on;
            plot([out(1).s.timcont]/3600, [out(1).s.flo]);
            plot([out(1).s.timcont]/3600, [out(1).s.fhi]);
            patch([[out(1).s.timcont]/3600 fliplr([out(1).s.timcont]/3600)], [[out(1).s.flo] fliplr([out(1).s.fhi])],'r');
            plot([out(1).s.timcont]/3600, [out(1).s.fftFreq], 'k-');
            
         ax(3) = subplot(413); title('Frequency-phase'); hold on;
            plot([out(1).s.timcont]/3600, [out(1).s.pflo]);
            plot([out(1).s.timcont]/3600, [out(1).s.pfhi]);
            patch([[out(1).s.timcont]/3600 fliplr([out(1).s.timcont]/3600)], [[out(1).s.pflo] fliplr([out(1).s.pfhi])],'b');
            plot([out(1).s.timcont]/3600, [out(1).s.fftFreq], 'k-');
            
        ax(4) = subplot(515); title('light'); hold on;ylim([-1, 6]);
            plot([out(1).s.timcont]/3600, [out(1).s.light]);
            plot([out(2).s.timcont]/3600, [out(2).s.light]);
    
    linkaxes(ax, 'x')