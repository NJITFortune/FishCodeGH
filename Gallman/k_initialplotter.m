function k_initialplotter(out)
% plot the data for fun

%% Plot the data for fun

% Continuous data plot
figure(1); clf; 
    set(gcf, 'Position', [200 100 2*560 2*420]);

ax(1) = subplot(511); hold on;
    yyaxis right; plot([out(2).sampl.timcont]/(60*60), [out(2).sampl.sumfftAmp], '.');
    yyaxis left; plot([out(1).sampl.timcont]/(60*60), [out(1).sampl.sumfftAmp], '.');
   % plot([out.timcont]/(60*60), [out.Ch3sumAmp], '.');

ax(2) = subplot(512); hold on;
    yyaxis right; plot([out(2).sampl.timcont]/(60*60), [out(2).sampl.zAmp], '.');
    yyaxis left; plot([out(1).sampl.timcont]/(60*60), [out(1).sampl.zAmp], '.');

ax(3) = subplot(513); hold on;
    yyaxis right; plot([out(2).sampl.timcont]/(60*60), [out(2).sampl.obwAmp], '.');
    yyaxis left; plot([out(1).sampl.timcont]/(60*60), [out(1).sampl.obwAmp], '.');

ax(4) = subplot(514); hold on;    
        yyaxis right; plot([out(2).sampl.timcont]/(60*60), [out(2).sampl.fftFreq], '.k', 'Markersize', 8);
        yyaxis right; plot([out(1).sampl.timcont]/(60*60), [out(1).sampl.fftFreq], '.k', 'Markersize', 8);
        yyaxis left; plot([out(2).sampl.timcont]/(60*60), [out(2).sampl.temp], '.r', 'Markersize', 8);
        yyaxis left; plot([out(1).sampl.timcont]/(60*60), [out(1).sampl.temp], '.r', 'Markersize', 8);
    
ax(5) = subplot(515); hold on;
    plot([out(2).sampl.timcont]/(60*60), [out(1).sampl.light], '.', 'Markersize', 8);
    ylim([-1, 6]);
    xlabel('Continuous');

linkaxes(ax, 'x');

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
