function [hi, lo] = k_multifishfreqtrim(out)
%% usage
% out = kg2(k).s
%takes raw fft amp data from each tube and assigns it to high and low freq fish
%kg2(#).s = KatieSeparationAnxiety('Eigen*');

%% assign amplitude data to fish by frequency
%make better variables to play with 
%time
hi(1).tim = [out([out.hitube]==1).timcont]/3600;
hi(2).tim = [out([out.hitube]==2).timcont]/3600;
lo(1).tim = [out([out.lotube]==1).timcont]/3600;
lo(2).tim = [out([out.lotube]==2).timcont]/3600;

%amp obw
hi(1).obwamp = [out([out.hitube]==1).hiAmpobw];
hi(2).obwamp = [out([out.hitube]==2).hiAmpobw];
lo(1).obwamp = [out([out.lotube]==1).loAmpobw];
lo(2).obwamp = [out([out.lotube]==2).loAmpobw];

%amp fft peak
hi(1).pkamp = [out([out.hitube]==1).hipeakamp];
hi(2).pkamp = [out([out.hitube]==2).hipeakamp];
lo(2).pkamp = [out([out.lotube]==1).lopeakamp];
lo(2).pkamp = [out([out.lotube]==2).lopeakamp];

%freq
hi(1).freq = [out([out.hitube]==1).hifreq];
hi(2).freq = [out([out.hitube]==2).hifreq];
lo(1).freq = [out([out.lotube]==1).lofreq];
lo(2).freq = [out([out.lotube]==2).lofreq];

%% filter by fish frequency

%hifreq
for tube = 2:-1:1
    figure(1); clf;

        histogram([out([out.hitube]== tube).hifreq], 100); hold on;

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



            hifreqidx = find(out([out.hitube]== tube).hifreq > cutofffreqL && out([out.hitube]== tube).hifreq < cutofffreqH);
                    hi(tube).obwampff = hi(tube).obwamp(hifreqidx);
                    hi(tube).pkampff = hi(tube).pkamp(hifreqidx);

                    hi(tube).tim = out([out.hitube]== tube).timcont(hifreqidx)/3600;
                    hi(tube).freq = out([out.hitube]== tube).hifreq(hifreqidx);


        pause(1);
end
%low
%hifreq
for tube = 2:-1:1
    figure(1); clf;

        histogram([out([out.lotube]== tube).lofreq], 100); hold on;

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



            lofreqidx = find(out([out.lotube]== tube).lofreq > cutofffreqL && out([out.lotube]== tube).lofreq < cutofffreqH);
                    lo(tube).obwamp = out([out.lotube]== tube).loAmpobw(lofreqidx);
                    lo(tube).pkamp = out([out.lotube]== tube).lopeakamp(lofreqidx);

                    lo(tube).tim = out([out.lotube]== tube).timcont(lofreqidx)/3600;
                    lo(tube).freq = out([out.lotube]== tube).hifreq(lofreqidx);


        pause(1);
end
    
close(1);

%% plot result of frequency filtering
