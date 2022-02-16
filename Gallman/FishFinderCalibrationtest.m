%function out = KatieFishFinder(in)
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
% figure(1); clf;
% 
%     histogram(hitube1freq, 100); hold on;
%     
%     %Lower lim
%     fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
%     [cutofffreqL, ~]  = ginput(1);
%     plot([cutofffreqL, cutofffreqL], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
%     drawnow; 
%     
%     %Upper lim
%     fprintf('Click cutoff for eliminating erroneously high amplitude measurements.\n');
%     [cutofffreqH, ~]  = ginput(1);
%     plot([cutofffreqH, cutofffreqH], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
%     drawnow; 
%     
%     for j=1:length(hitube1amp)
%          if hitube1freq(j) > cutofffreqL && hitube1freq(j) < cutofffreqH
%                 hitube1ampff(j) = hitube1amp(j);
%                 hitube1timff(j) = hitube1tim(j);
%                 hitube1freqff(j) = hitube1freq(j);
%          end
%     end
% 
%     pause(1);
%     
%     
% figure(1); clf;
% 
%     histogram(hitube2freq, 100); hold on;
%     
%     %Lower lim
%     fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
%     [cutofffreqL, ~]  = ginput(1);
%     plot([cutofffreqL, cutofffreqL], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
%     drawnow; 
%     
%     %Upper lim
%     fprintf('Click cutoff for eliminating erroneously high amplitude measurements.\n');
%     [cutofffreqH, ~]  = ginput(1);
%     plot([cutofffreqH, cutofffreqH], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
%     drawnow; 
%     
%     for j=1:length(hitube2amp)
%          if hitube2freq(j) > cutofffreqL && hitube2freq(j) < cutofffreqH
%                 hitube2ampff(j) = hitube2amp(j);
%                 hitube2timff(j) = hitube2tim(j);
%                 hitube2freqff(j) = hitube2freq(j);
%          end
%     end
% 
%     pause(1);
% 
% %lofreq
% figure(1); clf;
% 
%     histogram(lotube1freq, 100); hold on;
%     
%     %Lower lim
%     fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
%     [cutofffreqL, ~]  = ginput(1);
%     plot([cutofffreqL, cutofffreqL], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
%     drawnow; 
%     
%     %Upper lim
%     fprintf('Click cutoff for eliminating erroneously high amplitude measurements.\n');
%     [cutofffreqH, ~]  = ginput(1);
%     plot([cutofffreqH, cutofffreqH], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
%     drawnow; 
%     
%     for j=1:length(lotube1amp)
%          if lotube1freq(j) > cutofffreqL && lotube1freq(j) < cutofffreqH
%                 lotube1ampff(j) = lotube1amp(j);
%                 lotube1timff(j) = lotube1tim(j);
%                 lotube1freqff(j) = lotube1freq(j);
%          end
%     end
% 
%     pause(1);
% 
%   
% figure(1); clf;
% 
%     histogram(lotube2freq, 100); hold on;
%     
%     %Lower lim
%     fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
%     [cutofffreqL, ~]  = ginput(1);
%     plot([cutofffreqL, cutofffreqL], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
%     drawnow; 
%     
%     %Upper lim
%     fprintf('Click cutoff for eliminating erroneously high amplitude measurements.\n');
%     [cutofffreqH, ~]  = ginput(1);
%     plot([cutofffreqH, cutofffreqH], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
%     drawnow; 
%     
%     for j=1:length(lotube2amp)
%          if lotube2freq(j) > cutofffreqL && lotube2freq(j) < cutofffreqH
%                 lotube2ampff(j) = lotube2amp(j);
%                 lotube2timff(j) = lotube2tim(j);
%                 lotube2freqff(j) = lotube2freq(j);
%          end
%     end
% 
%     pause(1);

%% chunking for calibration

%hi freq fish
%chunk 1 = tim < 63
    %tube1
    hifishchunk1idx = find(hitube1timff < 63);
    
        for j = 1:length(hifishchunk1idx)
            hitube1ampchunk1(j) = hitube1ampff(hifishchunk1idx(j)) * 3;
            hitube1timchunk1(j) = hitube1timff(hifishchunk1idx(j));
        end

    %tube2
    clear hifishchunk1idx;
    hifishchunk1idx = find(hitube2timff < 63);
    
        for j = 1:length(hifishchunk1idx)
            hitube2ampchunk1(j) = hitube2ampff(hifishchunk1idx(j)) * 2.5;
            hitube2timchunk1(j) = hitube2timff(hifishchunk1idx(j));
        end

%chunk 2 = tim > 65 and tim < 157
    %tube 1
    hifishchunk2idx = find(hitube1timff > 63 & hitube1timff <= 157);
    
        for j = 1:length(hifishchunk2idx)
            hitube1ampchunk2(j) = hitube1ampff(hifishchunk2idx(j)) ;
            hitube1timchunk2(j) = hitube1timff(hifishchunk2idx(j));
        end

    clear hifishchunk2idx;
    clear hitube2ampchunk2;
    clear hitube2timchunk2;
    %tube 2
    hifishchunk2idx = find(hitube2timff > 65 & hitube2timff <= 157);
    
        for j = 1:length(hifishchunk2idx)
            hitube2ampchunk2(j) = hitube2ampff(hifishchunk2idx(j)) * 1.8;
            hitube2timchunk2(j) = hitube2timff(hifishchunk2idx(j));
        end

%chunk 3 = tim > 157 & tim < 219;
clear hifishchunk3idx;
clear hitube1ampchunk3;
clear hitube1timchunk3;

    %tube1
    hifishchunk3idx = find(hitube1timff > 157 & hitube1timff <= 219);
    
        for j = 1:length(hifishchunk3idx)
            hitube1ampchunk3(j) = hitube1ampff(hifishchunk3idx(j)) * 5.5;
            hitube1timchunk3(j) = hitube1timff(hifishchunk3idx(j));
        end
    
    %tube2
    clear hifishchunk3idx;
    hifishchunk3idx = find(hitube2timff > 157 & hitube2timff <= 219);
    
        for j = 1:length(hifishchunk3idx)
            hitube2ampchunk3(j) = hitube2ampff(hifishchunk3idx(j)) * 2;
            hitube2timchunk3(j) = hitube2timff(hifishchunk3idx(j));
        end

%chunk 4 = tim > 219 & tim < 229
    %tube 1
    hifishchunk4idx = find(hitube1timff > 219 & hitube1timff <= 229);
    
        for j = 1:length(hifishchunk4idx)
            hitube1ampchunk4(j) = hitube1ampff(hifishchunk4idx(j)) * 3.5;
            hitube1timchunk4(j) = hitube1timff(hifishchunk4idx(j));
        end

    %tube 2
    clear hifishchunk4idx;
    hifishchunk4idx = find(hitube2timff > 219 & hitube2timff <= 229);
    
        for j = 1:length(hifishchunk4idx)
            hitube2ampchunk4(j) = hitube2ampff(hifishchunk4idx(j)) * 1.25;
            hitube2timchunk4(j) = hitube2timff(hifishchunk4idx(j));
        end

%chunk 5 tube 1= tim > 229
clear hifishchunk5idx;
clear hitube1ampchunk5;
clear hitube1timchunk5;
clear hitube2ampchunk5;
clear hitube2timchunk5;

    %tube 1
    hifishchunk5idx = find(hitube1timff > 229);
    
        for j = 1:length(hifishchunk5idx)
            hitube1ampchunk5(j) = hitube1ampff(hifishchunk5idx(j));
            hitube1timchunk5(j) = hitube1timff(hifishchunk5idx(j));
        end

%chunk 5 tube 2 = tim > 229 & tim < 238       
    %tube 2
    clear hifishchunk5idx;
    hifishchunk5idx = find(hitube2timff > 229 & hitube2timff <= 238);
    
        for j = 1:length(hifishchunk5idx)
            hitube2ampchunk5(j) = hitube2ampff(hifishchunk5idx(j)) * 1.5;
            hitube2timchunk5(j) = hitube2timff(hifishchunk5idx(j));
        end
            
 
%chunk 6 tube 2 = tim > 238 
    %tube 2
    hifishchunk6idx = find(hitube2timff > 238);
    
        for j = 1:length(hifishchunk6idx)
            hitube2ampchunk6(j) = hitube2ampff(hifishchunk6idx(j)) * 2;
            hitube2timchunk6(j) = hitube2timff(hifishchunk6idx(j));
        end


%combine chunks
    %tube 1
    hitube1ampcomb = [hitube1ampchunk1, hitube1ampchunk2, hitube1ampchunk3, hitube1ampchunk4, hitube1ampchunk5];
    hitube1timcomb = [hitube1timchunk1, hitube1timchunk2, hitube1timchunk3, hitube1timchunk4, hitube1timchunk5];
    hitube2ampcomb = [hitube2ampchunk1, hitube2ampchunk2, hitube2ampchunk3, hitube2ampchunk4, hitube2ampchunk5, hitube2ampchunk6];
    hitube2timcomb = [hitube2timchunk1, hitube2timchunk2, hitube2timchunk3, hitube2timchunk4, hitube2timchunk5, hitube2timchunk6];


HiAmp = [hitube1ampcomb, hitube2ampcomb];
HiTim = [hitube1timcomb, hitube2timcomb];
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

    ax(1) = subplot(411); title('tube 1 adjustments'); hold on;
            %raw amp
            plot(hitube1timff, hitube1ampff, 'bo');
            plot(hitube2timff, hitube2ampff, 'mo');
            %adjusted tube 1
            plot(hitube1timchunk1, hitube1ampchunk1, 'ko');
            plot(hitube1timchunk3, hitube1ampchunk3, 'ko');
            plot(hitube1timchunk4, hitube1ampchunk4, 'ko');
            plot(hitube2timchunk2, hitube2ampchunk2, 'ko');
            plot(hitube2timchunk5, hitube2ampchunk5, 'ko');
           
    ax(2) = subplot(412); title('tube 2 adjustments'); hold on;
            %raw amp
            plot(hitube1timff, hitube1ampff, 'bo');
            plot(hitube2timff, hitube2ampff, 'mo');
            %adjusted tube 2
            plot(hitube2timchunk1, hitube2ampchunk1, 'ko');
            plot(hitube2timchunk2, hitube2ampchunk2, 'ko');
            plot(hitube2timchunk3, hitube2ampchunk3, 'ko');
            plot(hitube2timchunk4, hitube2ampchunk4, 'ko');
            plot(hitube2timchunk5, hitube2ampchunk5, 'ko');
            plot(hitube2timchunk6, hitube2ampchunk6, 'ko');

    ax(3) = subplot(413); title('combined chunks'); hold on;
            plot(hitube1timcomb, hitube1ampcomb,'bo'); 
            plot(hitube2timcomb, hitube2ampcomb,'mo'); 
           % plot([tout.his.HiTim], [tout.his.HiAmp], 'k.');
            plot(HiTim, HiAmp, 'k.');
    ax(4) = subplot(414); title('light cycle'); hold on;
            plot([out.timcont]/3600, [out.light]);

linkaxes(ax, 'x');





%low frequency fish
% figure(454); clf; hold on;
% 
%     ax(1) = subplot(311); title('high freq fish'); hold on;
%             plot(hitube1timff, hitube1ampff, 'bo');
%             plot(hitube2timff, hitube2ampff, 'mo');
%             plot(hitube1timchunk1, hitube1ampchunk1, 'ko');
%             plot(hitube1timchunk3, hitube1ampchunk3, 'ko');
%             plot(hitube1timchunk4, hitube1ampchunk4, 'ko');
%             plot(hitube2timchunk2, hitube2ampchunk2, 'ko');
%             plot(hitube2timchunk5, hitube2ampchunk5, 'ko');
%            
%     ax(2) = subplot(312); title('low freq fish'); hold on;
%             plot(lotube1timff, lotube1ampff, 'bo');
%             plot(lotube2timff, lotube2ampff, 'mo');
% 
%     ax(3) = subplot(313); title('light cycle'); hold on;
%             plot([out.timcont]/3600, [out.light]);

