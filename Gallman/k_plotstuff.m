%function k_lightbinplotterfig(out)
% plot the data for fun
% Usage: k_initialplotter(kg(#));
%close all;
%[pks, locs] = findpeaks(datadata, regtim, 'MinPeakProminence',.05);

in = xxkg(k);
%% Preparations

if channel < 3 %single fish
    %outlier removal
     tto = [in.idx(channel).obwidx]; 
      
    %raw data
    timcont = [in.e(channel).s(tto).timcont]; %time in seconds
    obw = [in.e(channel).s(tto).obwAmp];%/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
    oldfreq = [in.e(channel).s(tto).fftFreq];
    oldtemp = [in.e(channel).s(tto).temp];


else %multifish

    %outlier removal
     tto = [in.idx.obwidx]; 
      
    %raw data
    timcont = [in.s(tto).timcont]; %time in seconds
    obw = [in.s(tto).obwAmp];%/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
    oldfreq = [in.s(tto).freq];
    oldtemp = [in.s(tto).temp];

end

luz = [in.info.luz];
lighttimes = abs(luz)*3600;


%trimmed mean
 window = 5;
  fcn = @(x) trimmean(x,33);
  obwtrim = matlab.tall.movingWindow(fcn, window, obw');
  freqtrim = matlab.tall.movingWindow(fcn, window, oldfreq');
  temptrim = matlab.tall.movingWindow(fcn, window, oldtemp');

 [regtim, regfreq, regtemp, regobwpeaks] = k_regularmetamucil(timcont, obwtrim', timcont, obw, freqtrim', temptrim', ReFs, lighttimes);

  %low pass removes spikey-ness
        lowWn = 0.025/(ReFs/2);
        [dd,cc] = butter(5, lowWn, 'low');
        datadata = filtfilt(dd,cc, double(regobwpeaks));
%% Continuous data plot

figure(4); clf; hold on;
set(gcf, 'renderer', 'painters');


    %set(gcf, 'Position', [200 100 2*560 2*420]);

totplot = 2;
plotorder = 1;
colnum = 1;
binwidth = 1;
% timcont = [out.e(1).s(tto{1}).timcont]/(60*60);
% luz = [out.info.luz];
% lidx = find(timcont >= abs(luz(1)) & timcont <= abs(luz(end)));
% obw = [out.e(1).s(tto{1}).obwAmp];
% obw = obw(lidx);
% timcont = timcont(lidx);
timcont = timcont/3600;
regtim = regtim/3600;

ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('ch1 obwAmp'); %xlim([160 275]);%ylim([0,5]);

       plot(timcont-timcont(1), obw, '.', 'Color', [0.3010 0.7450 0.9330], 'MarkerSize', 8);
       plot(regtim-timcont(1), datadata, 'k-', 'LineWidth',1); 

       xlim([0 timcont(end)-timcont(1)]);
       plotorder = plotorder + 1;
 

if length(luz) > 1
ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('tube triggers'); %xlim([160 275]);%ylim([0,5]);
       % plot([out.e(2).s(tto{2}).timcont]/(60*60), [out.e(2).s(tto{2}).obwAmp], '.', 'Color', [0.4660 0.6740 0.1880], 'MarkerSize', 5);

       
            for k = 2:length(luz)
            
                if luz(k-1) < 0
                  
                  d = histogram(timcont-timcont(1), 'BinWidth', binwidth,'BinLimits',[abs(luz(k-1))-timcont(1),abs(luz(k))-timcont(1)]);
                  d.Normalization = 'countdensity';
                  d.FaceColor = [0.9 0.9 0.9];
                else
                    
                   l = histogram(timcont-timcont(1),'BinWidth', binwidth, 'BinLimits',[abs(luz(k-1))-timcont(1),abs(luz(k))-timcont(1)]);
                   l.Normalization = 'countdensity';
                   l.FaceColor = 'y';
                end
            end
             xlim([0 timcont(end)-timcont(1)]);

        plotorder = plotorder + 1;
end
% ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('frequency');   
%     
%         plot([out.e(2).s(tto{2}).timcont]/(60*60), [out.e(2).s(tto{2}).fftFreq], '.k', 'Markersize', 8);
%         plot([out.e(1).s(tto{1}).timcont]/(60*60), [out.e(1).s(tto{1}).fftFreq], '.k', 'Markersize', 8);
% 
%         plotorder = plotorder + 1;
% 
% ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('temp');
%     
%     plot([out.e(2).s(tto{2}).timcont]/(60*60), [out.e(2).s(tto{2}).temp], '-r', 'Markersize', 8);
%     plot([out.e(1).s(tto{1}).timcont]/(60*60), [out.e(1).s(tto{1}).temp], '-r', 'Markersize', 8);
% 
%         % Add temptimes, if we have them... 
%            if isfield(out.info, 'temptims')
%             if ~isempty([out.info.temptims])
%                ax(plotorder) = subplot(totplot, colnum, plotorder);
%                for j = 1:length([out.info.temptims])
%                     plot([out.info.temptims(j), out.info.temptims(j)], ylim, 'b-');
%                end         
%             end
%            end  
% 
% %     ch2tempC = real(k_voltstodegC(out, 2));
% %     ch1tempC = real(k_voltstodegC(out, 1));
% %     
% %     plot([out.e(2).s.timcont]/(60*60), ch2tempC, '-r', 'Markersize', 8);
% %     plot([out.e(1).s.timcont]/(60*60), ch1tempC, '-r', 'Markersize', 8);
% 
%     plotorder = plotorder + 1;
% 
% ax(plotorder) = subplot(totplot, colnum, plotorder); hold on; title('light');  
%     plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.light], '.', 'Markersize', 8);
%     ylim([-1, 6]);
%     xlabel('Continuous');
% 
%         % Add light transitions times to check luz if we have programmed it
%             if isfield(out.info, 'luz')
%                 if  ~isempty(out.info.luz)
%                     
%                     %luz by transition type
%                         %separate by transition type
%                         lighton = out.info.luz(out.info.luz > 0);
%                         darkon = out.info.luz(out.info.luz < 0);
%                         
%                         %plot
%                         plot([lighton' lighton']', [0 6], 'y-', 'LineWidth', 2);
%                         plot([abs(darkon)' abs(darkon)']', [0 6], 'k-', 'LineWidth', 2);
%                 end    
%             end
% 

linkaxes(ax, 'x'); 
  
