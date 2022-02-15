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
            %plot([out(intube2hi).timcont]/3600, [out(intube2hi).e2hiamp], 'b.');
        intube2lo = find([out.e2loamp] ./ [out.e1loamp] > 2.5);
            %plot([out(intube2lo).timcont]/3600, [out(intube2lo).e2loamp], 'm.');

        %when each fish was in tube 1
        intube1hi = find([out.e1hiamp] ./ [out.e2hiamp] > 2.5);
             %plot([out(intube1hi).timcont], [out(intube1hi).e1hiamp], 'bo');
        intube1lo = find([out.e1loamp] ./ [out.e2loamp] > 2.5);
            %plot([out(intube1lo).timcont], [out(intube1lo).e1loamp], 'mo');


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



figure(987); clf; hold on;

    ax(1) = subplot(211); title('high freq fish'); hold on;
            plot([out(intube1hi).timcont]/3600, [out(intube1hi).e1hiamp], 'bo');
            plot([out(intube2hi).timcont]/3600, [out(intube2hi).e2hiamp], 'mo');
    ax(2) = subplot(212); title('low freq fish'); hold on;
            plot([out(intube1lo).timcont]/3600, [out(intube1lo).e1loamp], 'bo');
            plot([out(intube2lo).timcont]/3600, [out(intube2lo).e2loamp], 'mo');


%     %test alternative eric
%         %hi frequency fish
%         %out.HiAmp = zeros(1, length(intube2hi));
%             %tube 2
%             for j=1:length(intube2hi)
%                 tout.his(intube2hi(j)).HiAmp1 = out(intube2hi(j)).e2hiamp; %* calibrationfactor;
%                 tout.his(intube2hi(j)).HiTim1 = out(intube2hi(j)).timcont/3600;
%                 tout.his(intube2hi(j)).HIfreq1 = [out(intube2hi(j)).hifreq];
%             end
%             %tube 1
%             for j=1:length(intube1hi)
%                 tout.his(intube1hi(j)).HiAmp1 = out(intube1hi(j)).e1hiamp;
%                 tout.his(intube1hi(j)).HiTim1 =out(intube1hi(j)).timcont/3600;
%                 tout.his(intube1hi(j)).HIfreq1 = [out(intube1hi(j)).hifreq];
%             end
% 
%             
%         %low frequency fish
%        % out.LoAmp = zeros(1, length(intube2lo));
%             %tube 2    
%             for j=1:length(intube2lo)
%                 tout.los(intube2lo(j)).LoAmp1 = out(intube2lo(j)).e2loamp;% * calibrationfactor;
%                 tout.los(intube2lo(j)).LoTim1 = out(intube2lo(j)).timcont/3600;
%                 tout.los(intube2lo(j)).LOfreq1 = [out(intube2lo(j)).lofreq];
%             end
%             %tube 1
%             for j=1:length(intube1lo)
%                 tout.los(intube1lo(j)).LoAmp1 = out(intube1lo(j)).e1loamp;
%                 tout.los(intube1lo(j)).LoTim1 = out(intube1lo(j)).timcont/3600;
%                 tout.los(intube1lo(j)).LOfreq1 = [out(intube1lo(j)).lofreq];
%             end 
%             
% 
% %% filter by fish frequency
% % figure(1); clf;
% % 
% %     histogram([tout.his.HIfreq1], 100); hold on;
% %     
% %     %Lower lim
% %     fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
% %     [cutofffreqL, ~]  = ginput(1);
% %     plot([cutofffreqL, cutofffreqL], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
% %     drawnow; 
% %     
% %     %Upper lim
% %     fprintf('Click cutoff for eliminating erroneously high amplitude measurements.\n');
% %     [cutofffreqH, ~]  = ginput(1);
% %     plot([cutofffreqH, cutofffreqH], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
% %     drawnow; 
% %     
% %     for j=1:length(tout.his)
% %          if tout.his(j).HIfreq1 > cutofffreqL & tout.his(j).HIfreq1 < cutofffreqH
% %                 out.his(j).HiAmp = tout.his(j).HiAmp1;
% %                 out.his(j).HiTim = tout.his(j).HiTim1;
% %                 out.his(j).HIfreq = tout.his(j).HIfreq1;
% %          end
% %     end
% % 
% %     pause(1);
% %     
% %     
% % figure(1); clf;
% % 
% %     histogram([tout.los.LOfreq1], 100); hold on;
% %     
% %     %Lower lim
% %     fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
% %     [cutofffreqL, ~]  = ginput(1);
% %     plot([cutofffreqL, cutofffreqL], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
% %     drawnow; 
% %     
% %     %Upper lim
% %     fprintf('Click cutoff for eliminating erroneously high amplitude measurements.\n');
% %     [cutofffreqH, ~]  = ginput(1);
% %     plot([cutofffreqH, cutofffreqH], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
% %     drawnow; 
% %     for j=1:length(tout.los)
% %          if tout.los(j).LOfreq1 > cutofffreqL & tout.los(j).LOfreq1 < cutofffreqH
% %              out.los(j).LoAmp = tout.los(j).LoAmp1;
% %              out.los(j).LoTim = tout.los(j).LoTim1;
% %              out.los(j).LOfreq = tout.los(j).LOfreq1;
% %          end
% %     end
% %     pause(1);
% 
% %adapted from KatieMultiFreqRemover.m
% %% Plot fish against light/temp
% figure(1); clf; hold on;
% 
%     
%     assx(1) = subplot(511); hold on; 
%         %plot([tout.his.HiTim1], [tout.his.HiAmp1], 'k.');
%         plot([tout.his.HiTim1], [tout.his.HiAmp1], '.');
%        
% 
%     assx(2) = subplot(512); hold on; 
%        % plot([tout.los.LoTim1], [tout.los.LoAmp1], 'k.');
%         plot([tout.los.LoTim1], [tout.los.LoAmp1], '.');
%         
%     assx(3) = subplot(513); hold on;
%        % plot([tout.his.HiTim1], [tout.his.HIfreq1], 'k.'); 
%         plot([tout.his.HiTim1], [tout.his.HIfreq1], '.'); 
%         %plot([tout.los.LoTim1], [tout.los.LOfreq1], 'k.');
%         plot([tout.los.LoTim1], [tout.los.LOfreq1], '.');
%         
%     
%     assx(4) = subplot(514); hold on; 
%             plot([out.timcont]/(60*60), [out.temp], '.');
%     
%     assx(5) = subplot(515); hold on;
%         plot([out.timcont]/(60*60), [out.light]);
%         ylim([-1, 6]);
%         
% linkaxes(assx, 'x');