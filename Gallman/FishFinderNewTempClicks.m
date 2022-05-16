%function fish = KatieFishFinder(out)
%% usage
%takes raw fft amp data from each tube and assigns it to high and low freq fish
%kg2(#).fish = KatieFishFinder(kg2(#).s)

%kg2(#).s = KatieSeparationAnxiety('Eigen*');

%% assign amplitude data to fish by frequency


%make better variables to play with
%time
hitube1tim = [out([out.hitube]==1).timcont]/3600;
hitube2tim = [out([out.hitube]==2).timcont]/3600;
lotube1tim = [out([out.lotube]==1).timcont]/3600;
lotube2tim = [out([out.lotube]==2).timcont]/3600;
%amp
hitube1amp = [out([out.hitube]==1).hiamp];
hitube2amp = [out([out.hitube]==2).hiamp];
lotube1amp = [out([out.lotube]==1).loamp];
lotube2amp = [out([out.lotube]==2).loamp];
%freq
hitube1freq = [out([out.hitube]==1).hifreq];
hitube2freq = [out([out.hitube]==2).hifreq];
lotube1freq = [out([out.lotube]==1).lofreq];
lotube2freq = [out([out.lotube]==2).lofreq];

        
%% filter by fish frequency
%hifreq
clear hitube1ampff;
clear hitube1timff;
clear hitube1freqff;
         
figure(1); clf;

    histogram(hitube1freq, 100); hold on;
    
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
    
    for j=1:length(hitube1amp)
         if hitube1freq(j) > cutofffreqL && hitube1freq(j) < cutofffreqH
                hitube1ampff(j) = hitube1amp(j);
                hitube1timff(j) = hitube1tim(j);
                hitube1freqff(j) = hitube1freq(j);
         end
    end

    pause(1);
    
    
figure(1); clf;
clear hitube2ampff;
clear hitube2timff;
clear hitube2freqff;

    histogram(hitube2freq, 100); hold on;
    
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
    
    for j=1:length(hitube2amp)
         if hitube2freq(j) > cutofffreqL && hitube2freq(j) < cutofffreqH
                hitube2ampff(j) = hitube2amp(j);
                hitube2timff(j) = hitube2tim(j);
                hitube2freqff(j) = hitube2freq(j);
         end
    end

    pause(1);

%lofreq
figure(1); clf;
clear lotube1ampff;
clear lotube1timff;
clear lotube1freqff;

    histogram(lotube1freq, 100); hold on;
    
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
    
    for j=1:length(lotube1amp)
         if lotube1freq(j) > cutofffreqL && lotube1freq(j) < cutofffreqH
                lotube1ampff(j) = lotube1amp(j);
                lotube1timff(j) = lotube1tim(j);
                lotube1freqff(j) = lotube1freq(j);
         end
    end

    pause(1);

  
figure(1); clf;
clear lotube2ampff;
clear lotube2timff;
clear lotube2freqff;

    histogram(lotube2freq, 100); hold on;
    
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
    
    for j=1:length(lotube2amp)
         if lotube2freq(j) > cutofffreqL && lotube2freq(j) < cutofffreqH
                lotube2ampff(j) = lotube2amp(j);
                lotube2timff(j) = lotube2tim(j);
                lotube2freqff(j) = lotube2freq(j);
         end
    end

    pause(1);
    close(figure(1));

%% plot to check frequency filtering
%threshold for in-tube data
hifishthresh = 0.05;
lofishthresh = 0.2;

hiloidx = find(hitube2timff > 226 & hitube2timff < 263);

figure(452); clf; hold on;


    ax(1) = subplot(511); title('high frequency fish'); hold on; %ylim([0,2]);
            %raw amp
            plot(hitube1timff, hitube1ampff, 'bo');
            plot(hitube2timff, hitube2ampff, 'mo');
            yline(hifishthresh);

            
    ax(2) = subplot(512); title('low frequency fish'); hold on; %ylim([0,3]);
            %raw amp
            plot(lotube1timff, lotube1ampff, 'bo');
            plot(lotube2timff, lotube2ampff, 'mo');
            plot(hitube2timff(hiloidx), hitube2ampff(hiloidx), 'k.');
            yline(lofishthresh);
            
                     
    ax(3) = subplot(513); title('combined chunks'); hold on; %ylim([300, 700]);
           plot(hitube1tim, hitube1freq, 'k.');
          plot(hitube1timff, hitube1freqff,'b.'); 

            plot(hitube2tim, hitube2freq, 'k.');
         plot(hitube2timff, hitube2freqff,'b.'); 

            plot(lotube1tim, lotube1freq, 'k.');
         plot(lotube1timff, lotube1freqff,'m.'); 

            plot(lotube2tim, lotube2freq, 'k.');
            plot(lotube2timff, lotube2freqff,'r.'); 
    
    ax(4) = subplot(514); title('temperature'); hold on;
            plot([out.timcont]/3600, [out.temp]);
            

    ax(5) = subplot(515); title('light cycle'); hold on;
            plot([out.timcont]/3600, [out.light]);
            

linkaxes(ax, 'x');



%% HIGH FREQUENCY FISH chunking for calibration

%chunk 1 = tim >= 40 & tim < 200
    %tube1
    clear hifishchunk1idx;
    clear hitube2ampchunk1;
    clear hitube2timchunk1;

 %hifishchunk1idx = find(hitube2timff);
%     
        for j = 1:length(hitube2timff)
            hitube2ampchunk1(j) = hitube2ampff((j))*2.7;
            hitube2timchunk1(j) = hitube2timff((j));

        end

%%
  clear hifishchunk2idx;
    clear hitube2ampchunk2;
    clear hitube2timchunk2;

 hifishchunk2idx = find(hitube2timff > 120);
%     
        for j = 1:length(hifishchunk2idx)
            hitube2ampchunk2(j) = hitube2ampff( hifishchunk2idx(j))*3.5;
            hitube2timchunk2(j) = hitube2timff( hifishchunk2idx(j));

        end
%%

  clear hifishchunk3idx;
    clear hitube2ampchunk3;
    clear hitube2timchunk3;

 hifishchunk3idx = find(hitube2timff >  85);
%     
        for j = 1:length(hifishchunk3idx)
            hitube2ampchunk3(j) = hitube2ampff( hifishchunk3idx(j))*1.8;
            hitube2timchunk3(j) = hitube2timff( hifishchunk3idx(j));

        end
 %%       
    clear hifishchunk2idx;
    clear hitube1ampchunk2;
    clear hitube1timchunk2;

 hifishchunk2idx = find(hitube1timff);
%     
        for j = 1:length(hifishchunk2idx)
            hitube1ampchunk2(j) = hitube1ampff(hifishchunk2idx(j))*1.5;
            hitube1timchunk2(j) = hitube1timff(hifishchunk2idx(j));

        end
%%

    clear hifishchunk3idx;
    clear hitube1ampchunk3;
    clear hitube1timchunk3;

 hifishchunk3idx = find(hitube1timff > 57.2 & hitube1timff <= 147);
%     
        for j = 1:length(hifishchunk3idx)
            hitube1ampchunk3(j) = hitube1ampff(hifishchunk3idx(j))*2.7;
            hitube1timchunk3(j) = hitube1timff(hifishchunk3idx(j));

        end


    clear hifishchunk4idx;
    clear hitube1ampchunk4;
    clear hitube1timchunk4;


 hifishchunk4idx = find(hitube1timff > 147);
%     
        for j = 1:length(hifishchunk4idx)
            hitube1ampchunk4(j) = hitube1ampff(hifishchunk4idx(j))*2.3;
            hitube1timchunk4(j) = hitube1timff(hifishchunk4idx(j));

        end

%%
clear HiAmp;
clear HiTim;

% HiAmp = [hitube1ampchunk1, hitube1ampchunk2, hitube1ampchunk3, hitube1ampchunk4, hitube2ampff];
% HiTim = [hitube1timchunk1, hitube1timchunk2, hitube1timchunk3, hitube1timchunk4, hitube2timff];
% HiFreq = [hitube1freqff, hitube2freqff];
HiAmp = [hitube1ampff, hitube2ampff];
HiTim = [hitube1timff, hitube2timff];
HiFreq = [hitube1freqff, hitube2freqff];

%% plot

%hi frequency fish
figure(453); clf; hold on;


    ax(1) = subplot(311); title('tube 1 adjustments'); hold on; %ylim([0,5]);
            %raw amp
            plot(hitube1timff, hitube1ampff, 'bo');
            plot(hitube2timff, hitube2ampff, 'mo');
            %adjusted tube 1
%             plot(hitube1timchunk1, hitube1ampchunk1, 'ko');
            %plot(hitube1timchunk2, hitube1ampchunk2, 'ko');
%              plot(hitube1timchunk3, hitube1ampchunk3, 'ko');
%              plot(hitube1timchunk4, hitube1ampchunk4, 'ko');
%            plot(hitube1timchunk5, hitube1ampchunk5, 'ko');
%             plot(hitube1timchunk6, hitube1ampchunk6, 'ko');
% %             plot(hitube1timchunk4, hitube1ampchunk4, 'ko');
              % plot(hitube2timchunk1, hitube2ampchunk1, 'ko');
%                plot(hitube2timchunk2, hitube2ampchunk2, 'ko');
%              plot(hitube2timchunk3, hitube2ampchunk3, 'ko');
%             plot(hitube2timchunk4, hitube2ampchunk4, 'ko');
%             plot(hitube2timchunk5, hitube2ampchunk5, 'ko');
           
    ax(2) = subplot(312); title('tube 2 adjustments'); hold on; %ylim([0,3]);
            
            %raw amp
            plot(hitube1timff, hitube1ampff, 'bo');
            plot(hitube2timff, hitube2ampff, 'mo');
            %adjusted tube 2
%             plot(hitube2timchunk1, hitube2ampchunk1, 'ko');
%             plot(hitube2timchunk2, hitube2ampchunk2, 'ko');
%             plot(hitube2timchunk3, hitube2ampchunk3, 'ko');
%             plot(hitube2timchunk4, hitube2ampchunk4, 'ko');
%             plot(hitube2timchunk5, hitube2ampchunk5, 'ko');
%             plot(hitube2timchunk6, hitube2ampchunk6, 'ko');
              plot(HiTim, HiAmp, 'k.');
%     ax(3) = subplot(413); title('combined chunks'); hold on;
%             plot(hitube1timcomb, hitube1ampcomb,'bo'); 
%             plot(hitube2timcomb, hitube2ampcomb,'mo'); 
%            % plot([tout.his.HiTim], [tout.his.HiAmp], 'k.');
%             plot(HiTim, HiAmp, 'k.');

    ax(3) = subplot(313); title('light cycle'); hold on;
            plot([out.timcont]/3600, [out.light]);

linkaxes(ax, 'x');



%% LOW FREQUENCY FISH chunking for calibration

  %tube1
    clear lofishchunk1idx;
    clear lotube2ampchunk1;
    clear lotube2timchunk1;

   

    lofishchunk1idx = find(lotube2timff < 167);
    
        for j = 1:length(lofishchunk1idx)
            lotube2ampchunk1(j) = lotube2ampff((j));
            lotube2timchunk1(j) = lotube2timff((j));
            
        end
%%
    %tube2
    clear lofishchunk2idx;
    clear lotube2ampchunk2;
    clear lotube2timchunk2;
    lofishchunk2idx = find(lotube2timff >= 167 & lotube2timff<226);
    
        for j = 1:length(lofishchunk2idx)
            lotube2ampchunk2(j) = lotube2ampff(lofishchunk2idx(j))/1.4;
            lotube2timchunk2(j) = lotube2timff(lofishchunk2idx(j));
        end
 %%       

    %tube2
    clear lofishchunk3idx;
    clear lotube2ampchunk3;
    clear lotube2timchunk3;
    %lofishchunk3idx = find(lotube1timff >= 113);
    hiloidx = find(hitube2timff > 226 & hitube2timff < 263);
       
            lotube2ampchunk3 = hitube2ampff(hiloidx);
            lotube2timchunk3 = hitube2timff(hiloidx);
    
%%
     %tube2
    clear lofishchunk3idx;
    clear lotube2ampchunk3;
    clear lotube2timchunk3;
    lofishchunk4idx = find(lotube2timff >= 263 );
    
        for j = 1:length(lofishchunk4idx)
            lotube2ampchunk4(j) = lotube2ampff(lofishchunk4idx(j))/1.2;
            lotube2timchunk4(j) = lotube2timff(lofishchunk4idx(j));
        end
%%
 %%
clear LoAmp;
clear LoTim;


%combine chunks   
LoAmp = [lotube1ampff, lotube2ampchunk1, lotube2ampchunk2, lotube2ampchunk4];%, lotube1ampchunk2, lotube1ampchunk3];
LoTim = [lotube1timff, lotube2timchunk1, lotube2timchunk2, lotube2timchunk4];%, lotube1timchunk2, lotube1timchunk3];
LoFreq = [lotube1freqff, lotube2freqff];


%% low frequency fish
 figure(455); clf; hold on;
% 
    ax(1) = subplot(311); title('low freq fish'); hold on; %ylim([0,1]);
            plot(lotube1timff, lotube1ampff, 'bo');
            plot(lotube2timff, lotube2ampff, 'mo');
            plot(lotube2timchunk1, lotube2ampchunk1, 'ko');
         
              plot(lotube2timchunk2, lotube2ampchunk2, 'ko');
              plot(lotube2timchunk3, lotube2ampchunk3, 'ko');
              plot(lotube2timchunk4, lotube2ampchunk4, 'ko');

%           %    % plot(lotube1timchunk1, lotube1ampchunk1, 'ko');
%              plot(lotube1timchunk2, lotube1ampchunk2, 'ko');
%              plot(lotube1timchunk3, lotube1ampchunk3, 'ko');
%             
           
    ax(2) = subplot(312); title('low freq fish'); hold on; %ylim([0,3]);
            plot(lotube1timff, lotube1ampff, 'bo');
            plot(lotube2timff, lotube2ampff, 'mo');
            plot(LoTim, LoAmp, 'k.');
    ax(3) = subplot(313); title('light cycle'); hold on;
            plot([out.timcont]/3600, [out.light]);
            
linkaxes(ax, 'x');


%% plot for final check
hifishthresh = 0.05;
lofishthresh = 0.15;
figure(487); clf; hold on;
% 
    ax(1) = subplot(311); title('high freq fish'); hold on; %ylim([0,3]);
            plot(HiTim, HiAmp, 'bo');
            plot(LoTim, LoAmp, 'mo');
            yline(hifishthresh, 'b-');
            yline(lofishtresh, 'm-');
            
           
    ax(2) = subplot(312); title('low freq fish'); hold on; %ylim([0,3]);
            plot(HiTim, HiFreq, 'bo');
            plot(LoTim, LoFreq, 'mo');

    ax(3) = subplot(313); title('light cycle'); hold on;
            plot([out.timcont]/3600, [out.light]);
            
linkaxes(ax, 'x');
%% threshold for in-tube data

hitube1idx = find(hitube1amp > hifishthresh);
hitube2idx = find(hitube2amp > hifishthresh);

%make better variables to play with
%time
hitube1tim = [out([out.hitube]==1).timcont]/3600;
hitube2tim = [out([out.hitube]==2).timcont]/3600;
lotube1tim = [out([out.lotube]==1).timcont]/3600;
lotube2tim = [out([out.lotube]==2).timcont]/3600;
%amp
hitube1amp = [out([out.hitube]==1).hiamp];
hitube2amp = [out([out.hitube]==2).hiamp];
lotube1amp = [out([out.lotube]==1).loamp];
lotube2amp = [out([out.lotube]==2).loamp];
%freq
hitube1freq = [out([out.hitube]==1).hifreq];
hitube2freq = [out([out.hitube]==2).hifreq];
lotube1freq = [out([out.lotube]==1).lofreq];
lotube2freq = [out([out.lotube]==2).lofreq];
%% save into output structure
%hi freq fish
% out.HiAmp = HiAmp;
% out.HiTim = HiTim;
% out.LoAmp = LoAmp;
% out.LoTim = LoTim;


for j = 1:length(HiAmp)
    fish.his(j).HiAmp(:) = HiAmp(j);
    fish.his(j).HiTim(:) = HiTim(j);
    fish.his(j).HiFreq(:) = HiFreq(j);
end

%lo freq fish
for j = 1:length(LoAmp)
    fish.los(j).LoAmp(:) = LoAmp(j);
    fish.los(j).LoTim(:) = LoTim(j);
    fish.los(j).LoFreq(:) = LoFreq(j);
end

