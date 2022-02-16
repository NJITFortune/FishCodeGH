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

hifishchunk1idx = find(hitube1timff < 63);

for j = 1:length(hifishchunk1idx)
    hitube1ampchunk1(j) = hitube1ampff(hifishchunk1idx(j)) * 3;
    hitube1timchunk1(j) = hitube1timff(hifishchunk1idx(j));
end

clear hifishchunk3idx;
clear hitube1ampchunk3;
clear hitube1timchunk3;

hifishchunk3idx = find(hitube1timff > 157 & hitube1timff < 219);

for j = 1:length(hifishchunk3idx)
    hitube1ampchunk3(j) = hitube1ampff(hifishchunk3idx(j)) * 5.5;
    hitube1timchunk3(j) = hitube1timff(hifishchunk3idx(j));
end


%% plot

figure(453); clf; hold on;

    ax(1) = subplot(311); title('high freq fish'); hold on;
            plot(hitube1timff, hitube1ampff, 'bo');
            plot(hitube2timff, hitube2ampff, 'mo');
            plot(hitube1timchunk1, hitube1ampchunk1, 'ko');
            plot(hitube1timchunk3, hitube1ampchunk3, 'ko');
           
    ax(2) = subplot(312); title('low freq fish'); hold on;
            plot(lotube1timff, lotube1ampff, 'bo');
            plot(lotube2timff, lotube2ampff, 'mo');

    ax(3) = subplot(313); title('light cycle'); hold on;
            plot([out.timcont]/3600, [out.light]);
