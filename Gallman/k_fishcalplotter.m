function  k_fishcalplotter(hi, lo, out) 
% in = hi; %lo
% out = kg2(k).s;
% str = 'high frequency fish';

% thresh.upper = 2;
% thresh.lower = 0.7;
%106.484

figure(455); clf; hold on;
in = hi;

    ax(1) = subplot(311); title('High frequency fish'); hold on; %ylim([0,1]);
            plot(in(1).tim, in(1).obwamp, 'bo');
            plot(in(2).tim, in(2).obwamp, 'mo');
           
%             plot(in(1).tim, in(1).pkamp, 'bo');
%             plot(in(2).tim, in(2).pkamp, 'mo');
%           
            
    ax(2) = subplot(312); title('postcal'); hold on; %ylim([0,1]);
            plot(in(1).tim, in(1).obwamp, 'bo');
            plot(in(2).tim, in(2).obwamp/2.5, 'mo');
          
%             plot(in(1).tim, in(1).pkamp, 'bo');
%             plot(in(2).tim, in(2).pkamp, 'mo');
            
%             yline(thresh.lower, 'k-');
%             yline(thresh.upper, 'k-');
    
    ax(3) = subplot(313); title('light cycle'); hold on;
            plot([out.timcont]/3600, [out.light]);
            

linkaxes(ax, 'x');

%%
figure(543); clf; hold on;
clear in
in = lo;

    ax(1) = subplot(311); title('Low frequency fish'); hold on; %ylim([0,1]);
            plot(in(1).tim, in(1).obwamp, 'bo');
            plot(in(2).tim, in(2).obwamp, 'mo');%1.75
%            
%             plot(in(1).tim, in(1).pkamp, 'bo');
%             plot(in(2).tim, in(2).pkamp, 'mo');
          
            
    ax(2) = subplot(312); title('postcal'); hold on; %ylim([0,1]);
            plot(in(1).tim, in(1).obwamp, 'bo');%*2
            plot(in(2).tim, in(2).obwamp/2.5, 'mo');
          
%             plot(in(1).tim, in(1).pkamp, 'bo');
%             plot(in(2).tim, in(2).pkamp, 'mo');
            
%             yline(thresh.lower, 'k-');
%             yline(thresh.upper, 'k-');
    
    ax(3) = subplot(313); title('light cycle'); hold on;
            plot([out.timcont]/3600, [out.light]);
            

linkaxes(ax, 'x');