%function fish = KatieFishFinder(out)
%% usage
%takes raw fft amp data from each tube and assigns it to high and low freq fish
%kg2(#).fish = KatieFishFinder(kg2(#).s)

%kg2(#).s = KatieSeparationAnxiety('Eigen*');

%% assign amplitude data to fish by frequency

   
%Indicies when each fish was in each tube
    %threshold for ratio at 2.5
        %when each fish was in tube 2
        intube2hi = find([out.e2hiamp] ./ [out.e1hiamp] > 2.5);
        intube2lo = find([out.e2loamp] ./ [out.e1loamp] > 2.5);
            
        %when each fish was in tube 1
        intube1hi = find([out.e1hiamp] ./ [out.e2hiamp] > 2.5);      
        intube1lo = find([out.e1loamp] ./ [out.e2loamp] > 2.5);

%make better variables to play with
%time
hitube1tim = [out(intube1hi).timcont]/3600;
hitube2tim = [out(intube2hi).timcont]/3600;
lotube1tim = [out(intube1lo).timcont]/3600;
lotube2tim = [out(intube2lo).timcont]/3600;
%amp
hitube1amp = [out(intube1hi).e1hiamp];
hitube2amp = [out(intube2hi).e2hiamp];
lotube1amp = [out(intube1lo).e1loamp];
lotube2amp = [out(intube2lo).e2loamp];
%freq
hitube1freq = [out(intube1hi).hifreq];
hitube2freq = [out(intube2hi).hifreq];
lotube1freq = [out(intube1lo).lofreq];
lotube2freq = [out(intube2lo).lofreq];
        
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
figure(452); clf; hold on;


    ax(1) = subplot(411); title('high frequency fish'); hold on; %ylim([0,2]);
            %raw amp
            plot(hitube1timff, hitube1ampff, 'bo');
            plot(hitube2timff, hitube2ampff, 'mo');
            
    ax(2) = subplot(412); title('low frequency fish'); hold on; %ylim([0,3]);
            %raw amp
            plot(lotube1timff, lotube1ampff, 'bo');
            plot(lotube2timff, lotube2ampff, 'mo');
            
          
            
    ax(3) = subplot(413); title('combined chunks'); hold on; ylim([300, 700]);
           plot(hitube1tim, hitube1freq, 'k.');
          plot(hitube1timff, hitube1freqff,'b.'); 

            plot(hitube2tim, hitube2freq, 'k.');
         plot(hitube2timff, hitube2freqff,'b.'); 

            plot(lotube1tim, lotube1freq, 'k.');
         plot(lotube1timff, lotube1freqff,'m.'); 

            plot(lotube2tim, lotube2freq, 'k.');
            plot(lotube2timff, lotube2freqff,'r.'); 

    ax(4) = subplot(414); title('light cycle'); hold on;
            plot([out.timcont]/3600, [out.light]);

linkaxes(ax, 'x');

%% HIGH FREQUENCY FISH chunking for calibration

%chunk 1 = tim >= 40 & tim < 200
    %tube1
    clear hifishchunk1idx;
    clear hitube2ampchunk1;
    clear hitube2timchunk1;

 hifishchunk1idx = find(hitube2timff < 101);
%     
        for j = 1:length(hifishchunk1idx)
            hitube2ampchunk1(j) = hitube2ampff(hifishchunk1idx(j))*2;
            hitube2timchunk1(j) = hitube2timff(hifishchunk1idx(j));

        end
    clear hifishchunk2idx;
    clear hitube2ampchunk2;
    clear hitube2timchunk2;

 hifishchunk2idx = find(hitube2timff >= 101 & hitube2timff < 125);
%     
        for j = 1:length(hifishchunk2idx)
            hitube2ampchunk2(j) = hitube2ampff(hifishchunk2idx(j))*1.6;
            hitube2timchunk2(j) = hitube2timff(hifishchunk2idx(j));

        end


    clear hifishchunk3idx;
    clear hitube2ampchunk3;
    clear hitube2timchunk3;

 hifishchunk3idx = find(hitube2timff >= 125 & hitube2timff < 125);
%     
        for j = 1:length(hifishchunk3idx)
            hitube2ampchunk3(j) = hitube2ampff(hifishchunk3idx(j))*1.4;
            hitube2timchunk3(j) = hitube2timff(hifishchunk3idx(j));

        end
%%
     clear hifishchunk2idx;
 hifishchunk2idx = find(hitube1timff >= 223);
%     
        for j = 1:length(hifishchunk2idx)
            hitube1ampchunk2(j) = hitube1ampff(hifishchunk2idx(j))/3.5;
            hitube1timchunk2(j) = hitube1timff(hifishchunk2idx(j));
        end


   clear hifishchunk3idx;
    clear hitube2ampchunk3;
    clear hitube2timchunk3;
 hifishchunk3idx = find(hitube2timff >= 0);
    
        for j = 1:length(hifishchunk3idx)
            hitube2ampchunk3(j) = hitube2ampff(hifishchunk3idx(j))/3;
            hitube2timchunk3(j) = hitube2timff(hifishchunk3idx(j));
        end


%combine chunks
clear HiAmp;
clear HiTim;
clear HiFreq;

% HiAmp = [hitube1ampchunk1, hitube1ampchunk2, hitube2ampchunk3];
% HiTim = [hitube1timchunk1, hitube1timchunk2, hitube2timchunk3];
% HiFreq = [hitube1freqff, hitube2freqff];

HiAmp = [hitube1ampff,  hitube2ampff];
HiTim = [hitube1timff,  hitube2timff];
HiFreq = [hitube1freqff, hitube2freqff];
% %combine tubes
% %hi frequency fish
% clear tout.his.HiAmp
% clear tout.his.HiTim
%             %tube 2
%          
%             for j=1:length(hitube2ampcomb)
%                 tout.his(j).HiAmp(:) = hitube2ampcomb(j);
%                 tout.his(j).HiTim(:) = hitube2timcomb(j);
%                 %tout.his(j).HiFreq = hitube2freqff(j);
%             end
%             %tube 1
%             for j=1:length(hitube1ampcomb)
%                 tout.his(j).HiAmp(:) = hitube1ampcomb(j);
%                 tout.his(j).HiTim(:) = hitube1timcomb(j);
%                 %tout.his(j).HiFreq = hitube1freqff(j);
%             end
%             

%% plot

%hi frequency fish
figure(453); clf; hold on;


    ax(1) = subplot(311); title('tube 1 adjustments'); hold on; ylim([0,1.5]);
            %raw amp
            plot(hitube1timff, hitube1ampff, 'bo');
            plot(hitube2timff, hitube2ampff, 'mo');
            %adjusted tube 1
            plot(hitube2timchunk1, hitube2ampchunk1, 'ko');
            plot(hitube2timchunk2, hitube2ampchunk2, 'ko');
           % plot(hitube1timchunk2, hitube1ampchunk2, 'ko');
%             plot(hitube1timchunk3, hitube1ampchunk3, 'ko');
%             plot(hitube1timchunk4, hitube1ampchunk4, 'ko');
%             plot(hitube2timchunk2, hitube2ampchunk2, 'ko');
            %plot(hitube2timchunk3, hitube2ampchunk3, 'ko');
%             plot(hitube2timchunk5, hitube2ampchunk5, 'ko');
           
    ax(2) = subplot(312); title('tube 2 adjustments'); hold on; ylim([0,3]);
            
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
%chunk 1 = tim => 40 & tim < 200
%   %tube1
%     clear lofishchunk1idx;
%     lofishchunk1idx = find(lotube1timff >= 15 & lotube1timff < 200);
%     
%         for j = 1:length(lofishchunk1idx)
%             lotube1ampchunk1(j) = lotube1ampff(lofishchunk1idx(j))*3;
%             lotube1timchunk1(j) = lotube1timff(lofishchunk1idx(j));
%         end

%     %tube2
%     clear lofishchunk1idx;
%     clear lotube2ampchunk1;
%     clear lotube2timchunk1;
%     lofishchunk1idx = find(lotube2timff >= 15 & lotube2timff < 65);
%     
%         for j = 1:length(lofishchunk1idx)
%             lotube2ampchunk1(j) = lotube2ampff(lofishchunk1idx(j))*13;
%             lotube2timchunk1(j) = lotube2timff(lofishchunk1idx(j));
%         end
% 
%chunk 2
    %tube2
%     clear lofishchunk1idx;
%     clear lotube2ampchunk1;
%     clear lotube2timchunk1;
    %lofishchunk2idx = find(lotube2timff >= 65);
    
        for j = 1:length(lotube1ampff)
            lotube1ampff(j) = lotube1ampff(j)*1.5;
            lotube1timff(j) = lotube1timff(j);
        end


%%


%combine chunks   
LoAmp = [lotube1ampff, lotube2ampff];
LoTim = [lotube1timff, lotube2timff];
LoFreq = [lotube1freqff, lotube2freqff];


%% low frequency fish
 figure(455); clf; hold on;
% 
    ax(1) = subplot(311); title('low freq fish'); hold on; %ylim([0,3]);
            plot(lotube1timff, lotube1ampff, 'bo');
            plot(lotube2timff, lotube2ampff, 'mo');
%             plot(lotube2timchunk1, lotube2ampchunk1, 'ko');
%             plot(lotube2timchunk2, lotube2ampchunk2, 'ko');
            plot(LoTim, LoAmp, 'k.');
            
           
    ax(2) = subplot(312); title('low freq fish'); hold on; %ylim([0,3]);
            plot(lotube1timff, lotube1ampff, 'bo');
            plot(lotube2timff, lotube2ampff, 'mo');

    ax(3) = subplot(313); title('light cycle'); hold on;
            plot([out.timcont]/3600, [out.light]);
            
linkaxes(ax, 'x');


%% plot for final check
figure(487); clf; hold on;
% 
    ax(1) = subplot(311); title('high freq fish'); hold on; %ylim([0,3]);
            plot(HiTim, HiAmp, 'bo');
            plot(LoTim, LoAmp, 'mo');
            
           
    ax(2) = subplot(312); title('low freq fish'); hold on; %ylim([0,3]);
            plot(HiTim, HiFreq, 'bo');
            plot(LoTim, LoFreq, 'mo');

    ax(3) = subplot(313); title('light cycle'); hold on;
            plot([out.timcont]/3600, [out.light]);
            
linkaxes(ax, 'x');

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

