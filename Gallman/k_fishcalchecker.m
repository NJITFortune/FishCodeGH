
function k_fishcalchecker(in, out, str, tube) 
% in = hi; %lo
% out = kg2(k).s;
% str = 'high frequency fish';

if tube == 1
    othertube = 2;
else
    othertube = 1;
end

upperthresh = .65;
lowerthresh = 0.01;

figure(456); clf; title(str); hold on;


    ax(1) = subplot(311); title(str); hold on; %ylim([0,2]);
            plot(in(1).tim, in(1).obwamp, 'bo');
            plot(in(2).tim, in(2).obwamp, 'co');
           
%             plot(in(1).tim, in(1).pkamp, 'bo');
%             plot(in(2).tim, in(2).pkamp, 'mo');
          
            
    ax(2) = subplot(312); title('postcal'); hold on; %ylim([0,3]);
%             plot(in(1).tim, in(1).obwamp, 'bo');
%             plot(lo(2).tim, in(2).obwamp, 'mo');
          
            %plot(in(tube).tim, in(tube).pkamp, 'bo');
            plot(in(tube).timchunk1, in(tube).pkampchunk1, 'co');
            plot(in(tube).timchunk2, in(tube).pkampchunk2, 'co');
           
            
            plot(in(othertube).tim, in(othertube).pkamp, 'ro');
            
            yline(lowerthresh, 'k-');
            yline(upperthresh, 'k-');
    
    ax(3) = subplot(313); title('light cycle'); hold on;
            plot([out.timcont]/3600, [out.light]);
            

linkaxes(ax, 'x');
