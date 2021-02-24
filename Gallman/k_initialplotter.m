function k_initialplotter(out)
% plot the data for fun
% Usage: k_initialplotter(kg(#));
%% Plot the data for fun

% All the data
    tto{1} = 1:length([out.e(1).s.timcont]);
    tto{2} = tto{1};
    ttz{1} = tto{1};
    ttz{2} = tto{1};
    %ttpf{1} = tto{1};
    %ttpf{2} = tto{1};
    ttsf{1} = tto{1};
    ttsf{2} = tto{1};
    
% BUT.. if we have removed outliers, use these...    
    if isfield(out, 'idx')
        tto{1} = out.idx(1).obwidx; tto{2} = out.idx(2).obwidx;
        ttz{1} = out.idx(1).zidx; ttz{2} = out.idx(2).zidx;
        %ttpf{1} = out.idx(1).peakfftidx; ttpf{2} = out.idx(2).peakfftidx;
        ttsf{1} = out.idx(1).sumfftidx; ttsf{2} = out.idx(2).sumfftidx;
    end

% Continuous data plot
figure(1); clf; 
    set(gcf, 'Position', [200 100 2*560 2*420]);

ax(1) = subplot(511); hold on; title('sumfftAmp');
    yyaxis right; plot([out.e(2).s(ttsf{2}).timcont]/(60*60), [out.e(2).s(ttsf{2}).sumfftAmp], '.');
    yyaxis left; plot([out.e(1).s(ttsf{1}).timcont]/(60*60), [out.e(1).s(ttsf{1}).sumfftAmp], '.');
    plot([out.info.feedingtimes' out.info.feedingtimes'], [0 max([out.e(1).s.sumfftAmp])], 'm-', 'LineWidth', 2, 'MarkerSize', 10);
   % plot([out.timcont]/(60*60), [out.Ch3sumAmp], '.');

ax(2) = subplot(512); hold on; title('zAmp');
    yyaxis right; plot([out.e(2).s(ttz{2}).timcont]/(60*60), [out.e(2).s(ttz{2}).zAmp], '.');
    yyaxis left; plot([out.e(1).s(ttz{1}).timcont]/(60*60), [out.e(1).s(ttz{1}).zAmp], '.');
   % plot([out.info.feedingtimes' out.info.feedingtimes'], [0 max([out.e(1).s.sumfftAmp])], 'm-', 'LineWidth', 2, 'MarkerSize', 10);

ax(3) = subplot(513); hold on; title('obwAmp');
    yyaxis right; plot([out.e(2).s(tto{2}).timcont]/(60*60), [out.e(2).s(tto{2}).obwAmp], '.');
    yyaxis left; plot([out.e(1).s(tto{1}).timcont]/(60*60), [out.e(1).s(tto{1}).obwAmp], '.');
   % plot([out.info.feedingtimes' out.info.feedingtimes'], [0 max([out.e(1).s.sumfftAmp])], 'm-', 'LineWidth', 2, 'MarkerSize', 10);

ax(4) = subplot(514); hold on; title('frequency (black) and temperature (red)');   
        yyaxis right; plot([out.e(2).s.timcont]/(60*60), [out.e(2).s.fftFreq], '.k', 'Markersize', 8);
        yyaxis right; plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.fftFreq], '.k', 'Markersize', 8);
        yyaxis left; plot([out.e(2).s.timcont]/(60*60), [out.e(2).s.temp], '.r', 'Markersize', 8);
        yyaxis left; plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.temp], '.r', 'Markersize', 8);
    
ax(5) = subplot(515); hold on; title('light transitions');
    plot([out.e(2).s.timcont]/(60*60), [out.e(1).s.light], '.', 'Markersize', 8);
    ylim([-1, 6]);
    xlabel('Continuous');
    
    
     if isfield(out, 'info')
        subplot(511); plot([out.info.feedingtimes' out.info.feedingtimes'], [0 max([out.e(1).s.sumfftAmp])], 'm-', 'LineWidth', 2, 'MarkerSize', 10);
        subplot(512); plot([out.info.feedingtimes' out.info.feedingtimes'], [0 max([out.e(1).s.sumfftAmp])], 'm-', 'LineWidth', 2, 'MarkerSize', 10);
        subplot(513); plot([out.info.feedingtimes' out.info.feedingtimes'], [0 max([out.e(1).s.sumfftAmp])], 'm-', 'LineWidth', 2, 'MarkerSize', 10);
     end
%         darkidx = find(out.info.luz < 0); lightidx = find(out.info.luz > 0);
%         for j=1:length(darkidx); plot([abs(out.info.luz(darkidx(j))) abs(out.info.luz(darkidx(j)))], [0 5], 'k-'); end
%         for j=1:length(lightidx); plot([abs(out.info.luz(lightidx(j))) abs(out.info.luz(lightidx(j)))], [0 5], 'c-'); end
%         
        
linkaxes(ax, 'x');

%% 24 hour plot 
% tim24 based off of computer midnight

figure(2); clf; 
    set(gcf, 'Position', [200 100 2*560 2*420]);

xa(1) = subplot(511); hold on; title('sumfftAmp');
    plot([out.e(2).s(ttsf{2}).tim24]/(60*60), [out.e(2).s(ttsf{2}).sumfftAmp], '.');
    plot([out.e(1).s(ttsf{1}).tim24]/(60*60), [out.e(1).s(ttsf{1}).sumfftAmp], '.');

xa(2) = subplot(512); hold on; title('zAmp');
    plot([out.e(2).s(ttz{2}).tim24]/(60*60), [out.e(2).s(ttz{2}).zAmp], '.');
    plot([out.e(1).s(ttz{1}).tim24]/(60*60), [out.e(1).s(ttz{1}).zAmp], '.');
   
xa(3) = subplot(513); hold on; title('obwAmp');
    plot([out.e(2).s(tto{2}).tim24]/(60*60), [out.e(2).s(tto{2}).obwAmp], '.');
    plot([out.e(1).s(tto{1}).tim24]/(60*60), [out.e(1).s(tto{1}).obwAmp], '.');
    
xa(4) = subplot(514); hold on; title('frequency (black) and temperature (red)'); 
    yyaxis right; plot([out.e(2).s.tim24]/(60*60), -[out.e(2).s.temp], '.');
    yyaxis left; ylim([200 800]);
        plot([out.e(2).s.tim24]/(60*60), [out.e(2).s.fftFreq], '.', 'Markersize', 8);      
    
xa(5) = subplot(515); hold on; title('light transitions');
    plot([out.e(2).s.tim24]/(60*60), [out.e(1).s.light], '.', 'Markersize', 8);
    xlabel('24 Hour');
    ylim([-1, 6]);

linkaxes(xa, 'x'); xlim([0 24]); 
    for ll=1:4
        subplot(5,1,ll); plot([5 5], [0 1], 'g'); plot([17 17], [0 1], 'r');
    end



% % Light / Dark plot
% 
% figure(2); clf;
% set(gcf, 'Position', [400 100 2*560 2*420]);
% 
%     ld = [out.light];
%     ldOnOff = diff(ld);
%     tim = [out.timcont];
%     dat1 = [out.Ch1obwAmp];
%     dat2 = [out.Ch2obwAmp];
%     
%     Ons = find(ldOnOff > 1); % lights turned on
%     Offs = find(ldOnOff < -1); % lights turned on
% 
% subplot(411); hold on; subplot(412); hold on;   
%     for j = 2:length(Ons) % Synchronize at light on
%     subplot(411);
%         plot(tim(Ons(j-1):Ons(j))-tim(Ons(j-1)), dat1(Ons(j-1):Ons(j)), '.');
%         plot(tim(Ons(j-1):Ons(j))-tim(Ons(j-1)), dat2(Ons(j-1):Ons(j)), '.');
%     subplot(412);
%         plot(tim(Ons(j-1):Ons(j))-tim(Ons(j-1)), ld(Ons(j-1):Ons(j)), '.');
%     end
% 
% subplot(413); hold on; subplot(414); hold on;   
%     for j = 2:length(Offs) % Synchronize at light off
%     subplot(413);
%         plot(tim(Offs(j-1):Offs(j))-tim(Offs(j-1)), dat1(Offs(j-1):Offs(j)), '.');
%         plot(tim(Offs(j-1):Offs(j))-tim(Offs(j-1)), dat2(Offs(j-1):Offs(j)), '.');
%     subplot(414);
%         plot(tim(Offs(j-1):Offs(j))-tim(Offs(j-1)), ld(Offs(j-1):Offs(j)), '.');
%     end
% 
%     
% % Detrend the data
% 
% resampFs = 0.005; % May need to change this
% cutfreq =  0.00001; % Low pass filter for detrend - need to adjust re resampFs
% 
%     [dat1r, newtim] = resample(dat1, tim, resampFs);
%     [dat2r, ~] = resample(dat2, tim, resampFs);
%     [ldr, ~] = resample(ld, tim, resampFs);
% 
%     [h,g] = butter(5,cutfreq/(resampFs/2),'low');
%     
%     % Filter the data
%     dat1rlf = filtfilt(h,g,dat1r);
%     dat2rlf = filtfilt(h,g,dat2r);
% 
%     % Remove the low frequency information
%     datrend1 = dat1r-dat1rlf;
%     datrend2 = dat2r-dat2rlf;
%     
% figure(4); clf;
% set(gcf, 'Position', [400 100 2*560 2*420]);
% 
% subplot(611); hold on; subplot(612); hold on;   subplot(613); hold on;
%     for j = 2:length(Ons) % Synchronize at light on
%         
%     ttOn = find(newtim > tim(Ons(j-1)) & newtim < tim(Ons(j)));
%         
%     subplot(611);
%         plot(newtim(ttOn)-newtim(ttOn(1)), datrend1(ttOn), '.');
%     subplot(612);
%         plot(newtim(ttOn)-newtim(ttOn(1)), datrend2(ttOn), '.');
%     subplot(613);
%         plot(newtim(ttOn)-newtim(ttOn(1)), ldr(ttOn), '.');
%     end
% 
% subplot(614); hold on; subplot(615); hold on; subplot(616); hold on;
%     for j = 2:length(Offs) % Synchronize at light off
%         
%     ttOff = find(newtim > tim(Offs(j-1)) & newtim < tim(Offs(j)));
%         
%     subplot(614);
%         plot(newtim(ttOff)-newtim(ttOff(1)), datrend1(ttOff), '.');
%     subplot(615);
%         plot(newtim(ttOff)-newtim(ttOff(1)), datrend2(ttOff), '.');
%     subplot(616);
%         plot(newtim(ttOff)-newtim(ttOff(1)), ldr(ttOff), '.');
%     end
% 
%     
% % Continuous data plot with OBW and SineAmp data
% figure(5); clf; 
%     set(gcf, 'Position', [200 100 2*560 2*420]);
% 
% ax(1) = subplot(411); hold on;
%     plot([out.timcont]/(60*60), [out.Ch1obwAmp], '.');
%     plot([out.timcont]/(60*60), [out.Ch2obwAmp], '.');
% %    plot([out.timcont]/(60*60), [out.Ch3sumAmp], '.');
% 
% ax(2) = subplot(412); hold on;
%     plot([out.timcont]/(60*60), [out.Ch1sAmp], '.');
%     plot([out.timcont]/(60*60), [out.Ch2sAmp], '.');
% 
% ax(3) = subplot(413); hold on;
%         ylim([200 800]);
%         plot([out.timcont]/(60*60), [out.Ch1sFreq], '.', 'Markersize', 8);
%         plot([out.timcont]/(60*60), [out.Ch2sFreq], '.', 'Markersize', 8);
% %        plot([out.timcont]/(60*60), [out.Ch3peakFreq], '.', 'Markersize', 8);
%     
% ax(4) = subplot(414); hold on;
%     plot([out.timcont]/(60*60), [out.light], '.', 'Markersize', 8);
%     ylim([-1, 6]);
%     xlabel('Continuous');
% 
% linkaxes(ax, 'x');   
% 
% end
% 
% function [amp, freq] = sinAnal(datums, FsF)
% 
% x = 1/FsF:1/FsF:length(datums)/FsF;
% 
% yu = max(datums);
% yl = min(datums);
% yr = (yu-yl);                               % Range of ‘y’
% yz = datums-yu+(yr/2);
% zx = x(yz .* circshift(yz,[0 1]) <= 0);     % Find zero-crossings
% per = 2*mean(diff(zx));                     % Estimate period
% ym = mean(datums);                               % Estimate offset
% 
%     fit = @(b,x)  b(1).*(sin(2*pi*x./b(2) + 2*pi/b(3))) + b(4);     % Function to fit
%     fcn = @(b) sum((fit(b,x) - datums).^2);                            % Least-Squares cost function
%     s = fminsearch(fcn, [yr;  per;  -1;  ym]);                      % Minimise Least-Squares
% 
% amp = s(1) * 1000;
% freq = 1/s(2);
% 
% 
% 
% end
