function [hi, lo] = k_multifishfreqtrim(out)%, out2)
%% usage
% out = kg2(k).s
%takes raw fft amp data from each tube and assigns it to high and low freq fish
%kg2(#).s = KatieSeparationAnxiety('Eigen*');

%% assign amplitude data to fish by frequency
%make better variables to play with 
%time
oldhi(1).tim = [out([out.hitube]==1).timcont]/3600;
oldhi(2).tim = [out([out.hitube]==2).timcont]/3600;
oldlo(1).tim = [out([out.lotube]==1).timcont]/3600;
oldlo(2).tim = [out([out.lotube]==2).timcont]/3600;

% amp obw
oldhi(1).obwamp = [out([out.hitube]==1).hiAmpobw];
oldhi(2).obwamp = [out([out.hitube]==2).hiAmpobw];
oldlo(1).obwamp = [out([out.lotube]==1).loAmpobw];
oldlo(2).obwamp = [out([out.lotube]==2).loAmpobw];

%amp fft peak
% oldhi(1).pkamp = [out([out.hitube]==1).hipeakamp];
% oldhi(2).pkamp = [out([out.hitube]==2).hipeakamp];
% oldlo(1).pkamp = [out([out.lotube]==1).lopeakamp];
% oldlo(2).pkamp = [out([out.lotube]==2).lopeakamp];

%freq
oldhi(1).freq = [out([out.hitube]==1).hifreq];
oldhi(2).freq = [out([out.hitube]==2).hifreq];
oldlo(1).freq = [out([out.lotube]==1).lofreq];
oldlo(2).freq = [out([out.lotube]==2).lofreq];


%amp obw
% oldhi(1).obwamp = [out2.hiAmpobw1];
% oldhi(2).obwamp = [out2.hiAmpobw2];
% oldlo(1).obwamp = [out2.loAmpobw1];
% oldlo(2).obwamp = [out2.loAmpobw2];
%% filter by fish frequency

%hifreq
for tube = 2:-1:1
    figure(1); clf;

        histogram(oldhi(tube).freq, 100); hold on;

        %Lower lim
        fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
        [cutofffreqL, ~]  = ginput(1);
        plot([cutofffreqL, cutofffreqL], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
        drawnow; 

        %Upper lim
        fprintf('Click cutoff for eliminating erroneously high amplitude measurements.\n');
        [cutofffreqH, ~]  = ginput(1);
        plot([cutofffreqH, cutofffreqH], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
        drawnow; 



            hifreqidx = find(oldhi(tube).freq > cutofffreqL & oldhi(tube).freq < cutofffreqH);
                    hi(tube).obwamp = oldhi(tube).obwamp(hifreqidx);
                  %  hi(tube).pkamp = oldhi(tube).pkamp(hifreqidx);

                    hi(tube).tim = oldhi(tube).tim(hifreqidx);
                    hi(tube).freq = oldhi(tube).freq(hifreqidx);
                    


        pause(1);
end
%low

for tube = 2:-1:1
    
    figure(1); clf;

        histogram(oldlo(tube).freq , 100); hold on;

        %Lower lim
        fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
        [cutofffreqL, ~]  = ginput(1);
        plot([cutofffreqL, cutofffreqL], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
        drawnow; 

        %Upper lim
        fprintf('Click cutoff for eliminating erroneously high amplitude measurements.\n');
        [cutofffreqH, ~]  = ginput(1);
        plot([cutofffreqH, cutofffreqH], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
        drawnow; 



            lofreqidx = find([oldlo(tube).freq] > cutofffreqL & oldlo(tube).freq < cutofffreqH);
                    lo(tube).obwamp = oldlo(tube).obwamp(lofreqidx);
                  %  lo(tube).pkamp = oldlo(tube).pkamp(lofreqidx);

                    lo(tube).tim = oldlo(tube).tim(lofreqidx);
                    lo(tube).freq = oldlo(tube).freq(lofreqidx);


        pause(1);
end
    

close(1);
%% plot result of frequency filtering

 figure(459); clf; hold on;


    ax(1) = subplot(411); title('high frequency fish'); hold on; %ylim([0,2]);
            
            plot(oldhi(1).tim, oldhi(1).obwamp, 'ko');
            plot(hi(1).tim, hi(1).obwamp, 'bo');

            plot(oldhi(2).tim, oldhi(2).obwamp, 'ko');    
            plot(hi(2).tim, hi(2).obwamp, 'co');
            
%             plot(oldhi(1).tim, oldhi(1).pkamp, 'ko');
%             plot(hi(1).tim, hi(1).pkamp, 'bo');
%             
%             plot(oldhi(2).tim, oldhi(2).pkamp, 'ko');
%             plot(hi(2).tim, hi(2).pkamp, 'co');
%             
          
            
    ax(2) = subplot(412); title('low frequency fish'); hold on; %ylim([0,3]);
            
            plot(oldlo(1).tim, oldlo(1).obwamp, 'ko');
            plot(lo(1).tim, lo(1).obwamp, 'ro');

            
            plot(oldlo(2).tim, oldlo(2).obwamp, 'ko');
            plot(lo(2).tim, lo(2).obwamp, 'mo');

%             plot(oldlo(1).tim, oldlo(1).pkamp, 'ko');
%             plot(lo(1).tim, lo(1).pkamp, 'ro');
%             
%             plot(oldlo(2).tim, oldlo(2).pkamp, 'ko');
%             plot(lo(2).tim, lo(2).pkamp, 'mo');
            
                     
    ax(3) = subplot(413); title('fish frequencies'); hold on; %ylim([300, 700]);
    
            
            plot(oldhi(1).tim, oldhi(1).freq, 'ko');
            plot(hi(1).tim, hi(1).freq, 'bo');
            
            plot(oldhi(2).tim, oldhi(2).freq, 'ko');
            plot(hi(2).tim, hi(2).freq, 'co');
            
            plot(oldlo(1).tim, oldlo(1).freq, 'ko');
            plot(lo(1).tim, lo(1).freq, 'ro');
            
            plot(oldlo(2).tim, oldlo(2).freq, 'ko');   
            plot(lo(2).tim, lo(2).freq, 'mo');
               
        
%     ax(4) = subplot(514); title('temperature'); hold on;
%             plot([out.timcont]/3600, [out.temp]);
%             

    ax(4) = subplot(414); title('light cycle'); hold on;
            plot([out.timcont]/3600, [out.light]);
            

linkaxes(ax, 'x');


