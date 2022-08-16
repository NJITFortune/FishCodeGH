
in = hi; %lo
out = kg2(k).s;
str = 'high frequency fish';

upperthresh = 2;
lowerthresh = 0.01;

figure(455); clf; title(str); hold on;


    ax(1) = subplot(311); title(str); hold on; %ylim([0,2]);
%             plot(in(1).tim, in(1).obwamp, 'bo');
%             plot(in(2).tim, in(2).obwamp, 'co');
           
            plot(in(1).tim, in(1).pkamp, 'bo');
            plot(in(2).tim, in(2).pkamp, 'mo');
          
            
    ax(2) = subplot(312); title('postcal'); hold on; %ylim([0,3]);
%             plot(in(1).tim, in(1).obwamp, 'bo');
%             plot(lo(2).tim, in(2).obwamp, 'mo');
          
            plot(in(1).tim, in(1).pkamp, 'bo');
            plot(in(2).tim, in(2).pkamp, 'mo')/2.3;
            
            yline(lowerthresh, 'k-');
            yline(upperthresh, 'k-');
    
    ax(3) = subplot(313); title('light cycle'); hold on;
            plot([out.timcont]/3600, [out.light]);
            

linkaxes(ax, 'x');
