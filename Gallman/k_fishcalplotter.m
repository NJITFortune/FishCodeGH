function  k_fishcalplotter(in, out, str) 
% in = hi; %lo
% out = kg2(k).s;
% str = 'high frequency fish';

% thresh.upper = 2;
% thresh.lower = 0.7;

figure(455); clf; title(str); hold on;


    ax(1) = subplot(311); title(str); hold on; ylim([0,.05]);
            plot(in(1).tim, in(1).obwamp, 'bo');
            plot(in(2).tim, in(2).obwamp, 'mo');
           
%             plot(in(1).tim, in(1).pkamp, 'bo');
%             plot(in(2).tim, in(2).pkamp, 'mo');
          
            
    ax(2) = subplot(312); title('postcal'); hold on; ylim([0,.05]);
            plot(in(1).tim, in(1).obwamp, 'bo');
            plot(in(2).tim, in(2).obwamp*1.6, 'mo');
          
%             plot(in(1).tim, in(1).pkamp, 'bo');
%             plot(in(2).tim, in(2).pkamp*1.1, 'mo');
            
%             yline(thresh.lower, 'k-');
%             yline(thresh.upper, 'k-');
    
    ax(3) = subplot(313); title('light cycle'); hold on;
            plot([out.timcont]/3600, [out.light]);
            

linkaxes(ax, 'x');
