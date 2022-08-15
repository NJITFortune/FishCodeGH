function [hi, lo] = k_multifishfreqtrim(out)
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

%amp obw
oldhi(1).obwamp = [out([out.hitube]==1).hiAmpobw];
oldhi(2).obwamp = [out([out.hitube]==2).hiAmpobw];
oldlo(1).obwamp = [out([out.lotube]==1).loAmpobw];
oldlo(2).obwamp = [out([out.lotube]==2).loAmpobw];

%amp fft peak
oldhi(1).pkamp = [out([out.hitube]==1).hipeakamp];
oldhi(2).pkamp = [out([out.hitube]==2).hipeakamp];
oldlo(2).pkamp = [out([out.lotube]==1).lopeakamp];
oldlo(2).pkamp = [out([out.lotube]==2).lopeakamp];

%freq
oldhi(1).freq = [out([out.hitube]==1).hifreq];
oldhi(2).freq = [out([out.hitube]==2).hifreq];
oldlo(1).freq = [out([out.lotube]==1).lofreq];
oldlo(2).freq = [out([out.lotube]==2).lofreq];

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



            hifreqidx = find(oldhi(tube).freq > cutofffreqL && oldhi(tube).freq < cutofffreqH);
                    hi(tube).obwamp = oldhi(tube).obwamp(hifreqidx);
                    hi(tube).pkamp = oldhi(tube).pkamp(hifreqidx);

                    hi(tube).tim = oldhi(tube).tim(hifreqidx);
                    hi(tube).freq = oldhi(tube).freq(hifreqidx);


        pause(1);
end
%low
%hifreq
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



            lofreqidx = find(oldlo(tube).freq > cutofffreqL && oldlo(tube).freq < cutofffreqH);
                    lo(tube).obwamp = oldlo(tube).obwamp(lofreqidx);
                    lo(tube).pkamp = oldlo(tube).pkamp(lofreqidx);

                    lo(tube).tim = oldlo(tube).tim(lofreqidx);
                    lo(tube).freq = oldlo(tube).freq(lofreqidx);


        pause(1);
end
    
close(1);

%% plot result of frequency filtering

for tube = 2:-1:1
 
    figure(452); clf; hold on;


    ax(1) = subplot(511); title('high frequency fish'); hold on; %ylim([0,2]);
            plot(hitube1timff, hitube1ampff, 'bo')
            plot(hitube2timff, hitube2ampff, 'mo');
          
            
    ax(2) = subplot(512); title('low frequency fish'); hold on; %ylim([0,3]);
            %raw amp
            plot(lo(tube).tim, lo(tube).obwamp, 'bo');
           
            
                     
    ax(3) = subplot(513); title('combined chunks'); hold on; %ylim([300, 700]);
           plot(hitube1tim, hitube1freq, 'k.');
             plot(hitube1timff, hitube1freqff,'b.'); 

           plot(hitube2tim, hitube2freq, 'k.');
             plot(hitube2timff, hitube2freqff,'c.'); 

           plot(lotube1tim, lotube1freq, 'k.');
             plot(lotube1timff, lotube1freqff,'r.'); 

           plot(lotube2tim, lotube2freq, 'k.');
             plot(lotube2timff, lotube2freqff,'m.'); 
        
    ax(4) = subplot(514); title('temperature'); hold on;
            plot([out.timcont]/3600, [out.temp]);
            

    ax(5) = subplot(515); title('light cycle'); hold on;
            plot([out.timcont]/3600, [out.light]);
            

linkaxes(ax, 'x');
