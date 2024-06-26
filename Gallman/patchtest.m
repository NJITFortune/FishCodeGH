

%figure(22); clf; title('freq-nonphase adjusted'); hold on

%y1idx = find([out(1).s.pfhi] < 435 );
% y1idx = find([out(1).s.pflo] > 385);
% 
% x = [out(1).s.timcont]/3600;
% x = x(y1idx);
% y2 = [out(1).s.pflo];
% y2 = y2(y1idx);
% y1 = [out(1).s.pfhi];
% y1 = y1(y1idx);
% y3 = [out(1).s.fftFreq];
% y3 = y3(y1idx);
% 
% plot(x, y1);
% plot(x, y2);
% patch([x fliplr(x)], [y1 fliplr(y2)],'r');
% 
% plot(x, [out(1).s(y1idx).fftFreq], 'k-', 'LineWidth',3);
%coral
Coral = [255/255, 127/255, 80/255];
%Bluish green
Bluishgreen = [103/255, 189/255, 170/255];
ylw = [255/255 153/255 204/255];
%teal
teal = [0/255 114/255 178/255];

 %numbercycles = floor([out(1).s(datasubset(2)).timcont]/(4*60*60)); %number of cycles in data
        timz = 1:1:9;
      

lightlines = 1 + (4*(timz-1));
lightlines = lightlines(1:6);
% figure(28);clf; hold on;
%         
%         ax(1) = subplot(311); title('Mean square amplitude'); xlim([27 43]);hold on;
%         plot([out(1).s.timcont]/3600, [out(1).s.sumfftAmp], '.', 'MarkerSize', 30,'Color', teal);
%             plot([out(1).s.timcont]/3600, [out(1).s.obwAmp], '.', 'MarkerSize', 30,'Color', teal);
%             a = ylim;
%             for j = 1:length(lightlines)-1
%                 if mod(j,2) == 0 %if j is even
%                 fill([lightlines(j) lightlines(j) lightlines(j+1) lightlines(j+1)], [0 .15 .15 0], [0.9, 0.9, 0.9]);
%                 end
%             end
%             plot([out(1).s.timcont]/3600, [out(1).s.obwAmp], '.', 'MarkerSize', 30,'LineWidth', 1, 'Color',teal);
%             plot([out(1).s.timcont]/3600, [out(1).s.pobwAmp], '.', 'MarkerSize', 10, 'Color',ylw);
% 
%             plot([out(1).s.timcont]/3600, [out(1).s.sumfftAmp], '.', 'MarkerSize', 30,'Color', 'b');
%             plot([out(1).s.timcont]/3600, [out(1).s.sumfftAmp], '.', 'MarkerSize', 30,'LineWidth', 1, 'Color','r');
%             
%             
%         
%         ax(2) = subplot(312); title('Frequency-nonphase');xlim([27 43]); ylim([300 500]); hold on;
% 
%             plot([out(1).s.timcont]/3600, [out(1).s.flo]);
%             plot([out(1).s.timcont]/3600, [out(1).s.fhi]);
%             a = ylim;
%             for j = 1:length(lightlines)-1
%                 if mod(j,2) == 0 %if j is even
%                 fill([lightlines(j) lightlines(j) lightlines(j+1) lightlines(j+1)], [a(1) 550 550 a(1)], [0.9, 0.9, 0.9]);
%                 end
%             end
% 
%             patch([[out(1).s.timcont]/3600 fliplr([out(1).s.timcont]/3600)], [[out(1).s.flo] fliplr([out(1).s.fhi])],'b');
%             plot([out(1).s.timcont]/3600, [out(1).s.fftFreq], 'k-', 'LineWidth', 2);
%             
%          ax(3) = subplot(313); title('Frequency-phase'); xlim([27 43]); ylim([300 500]);hold on;
%             
%             y1idx = find([out(1).s.pflo] > 385);
% 
%                 x = [out(1).s.timcont]/3600;
%                 x = x(y1idx);
%                 y2 = [out(1).s.pflo];
%                 y2 = y2(y1idx);
%                 y1 = [out(1).s.pfhi];
%                 y1 = y1(y1idx);
%                 y3 = [out(1).s.fftFreq];
%                 y3 = y3(y1idx);
%                 
%                 plot(x, y1);
%                 plot(x, y2);
%             
% 
%             a = ylim;
%             for j = 1:length(lightlines)-1
%                 if mod(j,2) == 0 %if j is even
%                 fill([lightlines(j) lightlines(j) lightlines(j+1) lightlines(j+1)], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
%                 end
%             end
%             patch([x fliplr(x)], [y1 fliplr(y2)],'r');
%             plot(x,y3, 'k-', 'LineWidth', 2);
%             
%        
%     
%     linkaxes(ax, 'x')

channel = 1;

%trim to lightlines
lightidx = find([out(channel).s.timcont]/3600 >= lightlines(1) & [out(channel).s.timcont]/3600 <= lightlines(6));


figure(29);clf; hold on;
        
        ax(1) = subplot(211);  hold on;
           
%             plot([out(1).s.timcont]/3600, [out(1).s.psumfftAmp], '.', 'MarkerSize', 0.1);      
%             plot([out(1).s.timcont]/3600, [out(1).s.ppeakfftAmp], '.', 'MarkerSize', 0.1);
%             plot([out(1).s.timcont]/3600, [out(1).s.pobwAmp], '.', 'MarkerSize', 0.1);
%             plot([out(1).s.timcont]/3600, [out(1).s.zAmp], '.', 'MarkerSize', 0.1);
            a = [0 1];
            for j = 1:length(lightlines)-1
                if mod(j,2) == 1 %if j is even
                fill([lightlines(j)-lightlines(1) lightlines(j)-lightlines(1) lightlines(j+1)-lightlines(1) lightlines(j+1)-lightlines(1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9], 'HandleVisibility','off');
                end
            end
            
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).sumfftAmp], '.', 'MarkerSize', 10, 'DisplayName', 'sumfftAmp');
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).peakfftAmp], '.', 'MarkerSize', 10, 'DisplayName','peakfftAmp');
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).obwAmp], '.', 'MarkerSize', 10, 'DisplayName','obwAmp');
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).zAmp], '.', 'MarkerSize', 10, 'DisplayName','zAmp');
            %legend;
            %('Location','northoutside', 'Orientation','horizontal');
         ax(2) = subplot(212); title('mean square amplitude normalized'); hold on;

            
            for j = 1:length(lightlines)-1
                if mod(j,2) == 1 %if j is even
                fill([lightlines(j)-lightlines(1) lightlines(j)-lightlines(1) lightlines(j+1)-lightlines(1) lightlines(j+1)-lightlines(1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
                end
            end
        
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).sumfftAmp]/max([out(channel).s(lightidx).sumfftAmp]), '.', 'MarkerSize', 10);
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).peakfftAmp]/max([out(channel).s(lightidx).peakfftAmp]), '.', 'MarkerSize', 10);
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).obwAmp]/max([out(channel).s(lightidx).obwAmp]), '.', 'MarkerSize', 10);
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).zAmp]/max([out(channel).s(lightidx).zAmp]), '.', 'MarkerSize', 10);
            %legend('sumfftAmp', 'peakfftAmp', 'obwAmp', 'zAmp');
    
     linkaxes(ax, 'x')

figure(30); clf; hold on;

%because tim isn't resetting for a new day or something weird
[timcont, sortidx] = sort([out(channel).s(lightidx).timcont]);
sumamp = [out(channel).s(sortidx).psumfftAmp];
peakamp = [out(channel).s(sortidx).ppeakfftAmp];
obwamp = [out(channel).s(sortidx).pobwAmp];
zamp = [out(channel).s(sortidx).zAmp];

lowWn = 0.1/(ReFs/2);
[dd,cc] = butter(5, lowWn, 'low');

         ax(1) = subplot(211); title('Mean square amplitude');  hold on;
            a = [0 1];
            for j = 1:length(lightlines)-1
                if mod(j,2) == 1 %if j is even
                fill([lightlines(j)-lightlines(1) lightlines(j)-lightlines(1) lightlines(j+1)-lightlines(1) lightlines(j+1)-lightlines(1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
                end
            end
                [stimcont, sumfftdata] = k_peaksofpeaksfilt(timcont, sumamp, 20);
                   % plot(stimcont/3600-lightlines(1), sumfftdata, 'LineWidth', 2.5);
                    
                    sdatadata = filtfilt(dd,cc, double(sumfftdata));
                     plot(stimcont/3600-lightlines(1), sdatadata, 'LineWidth', 2);

                [ptimcont, peakfftdata] = k_peaksofpeaksfilt(timcont, peakamp, 20);
                    %plot(ptimcont/3600-lightlines(1), peakfftdata, 'LineWidth', 2);
                
                    pdatadata = filtfilt(dd,cc, double(peakfftdata));
                     plot(ptimcont/3600-lightlines(1), pdatadata, 'LineWidth', 2);
                    
            
                [otimcont, obwdata] = k_peaksofpeaksfilt(timcont, obwamp, 20);
                   % plot(otimcont/3600-lightlines(1), obwdata, 'LineWidth', 2);

                    odatadata = filtfilt(dd,cc, double(obwdata));
                     plot(otimcont/3600-lightlines(1), odatadata, 'LineWidth', 2);
                    
                    

                [ztimcont, zdata] = k_peaksofpeaksfilt(timcont, zamp, 20);    
                    %plot(ztimcont/3600-lightlines(1), zdata, 'LineWidth', 2);

                    zdatadata = filtfilt(dd,cc, double(zdata));
                     plot(ztimcont/3600-lightlines(1), zdatadata, 'LineWidth', 2);
            

         ax(2) = subplot(212); title('Mean square amplitude');  hold on;
            a = [0 1];
            for j = 1:length(lightlines)-1
                if mod(j,2) == 1 %if j is even
                fill([lightlines(j)-lightlines(1) lightlines(j)-lightlines(1) lightlines(j+1)-lightlines(1) lightlines(j+1)-lightlines(1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
                end
            end
                [stimcont, nsumfftdata] = k_peaksofpeaksfilt(timcont, sumamp/max(sumamp), 20);
                   % plot(stimcont/3600-lightlines(1), nsumfftdata, 'LineWidth', 2.5);

                    nsdatadata = filtfilt(dd,cc, double(nsumfftdata));
                     plot(stimcont/3600-lightlines(1), nsdatadata, 'LineWidth', 2);

                [ptimcont, npeakfftdata] = k_peaksofpeaksfilt(timcont, peakamp/max(peakamp), 20);
                  %  plot(ptimcont/3600-lightlines(1), npeakfftdata, 'LineWidth', 1.5);

                    npdatadata = filtfilt(dd,cc, double(npeakfftdata));
                     plot(ptimcont/3600-lightlines(1), npdatadata, 'LineWidth', 2);
            
                [otimcont, nobwdata] = k_peaksofpeaksfilt(timcont, obwamp/max(obwamp), 20);
                  %  plot(otimcont/3600-lightlines(1), nobwdata, 'LineWidth', 2);

                     datadata = filtfilt(dd,cc, double(nobwdata));
                     plot(otimcont/3600-lightlines(1), datadata, 'LineWidth', 2);


                [ztimcont, nzdata] = k_peaksofpeaksfilt(timcont, zamp/max(zamp), 20);    
                   % plot(ztimcont/3600-lightlines(1), nzdata, 'LineWidth', 2); 
     
                     nzdatadata = filtfilt(dd,cc, double(nzdata));
                     plot(ztimcont/3600-lightlines(1), nzdatadata, 'LineWidth', 2);

 figure(31);clf; hold on;
        
        ax(1) = subplot(211); title('Mean square amplitude'); hold on;
           
            a = [0 1];
            for j = 1:length(lightlines)-1
                if mod(j,2) == 1 %if j is even
                fill([lightlines(j)-lightlines(1) lightlines(j)-lightlines(1) lightlines(j+1)-lightlines(1) lightlines(j+1)-lightlines(1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
                end
            end
            
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).sumfftAmp], '.', 'MarkerSize', 10);
                 plot(stimcont/3600-lightlines(1), sumfftdata, 'LineWidth', 2);
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).peakfftAmp], '.', 'MarkerSize', 10);
                 plot(ptimcont/3600-lightlines(1), peakfftdata, 'LineWidth', 2);
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).obwAmp], '.', 'MarkerSize', 10);
                 plot(otimcont/3600-lightlines(1), obwdata, 'LineWidth', 2);
           plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).zAmp], '.', 'MarkerSize', 10);
                plot(ztimcont/3600-lightlines(1), zdata, 'LineWidth', 2);
                    

         ax(2) = subplot(212); title('normalized'); hold on;

            
            for j = 1:length(lightlines)-1
                if mod(j,2) == 1 %if j is even
                fill([lightlines(j)-lightlines(1) lightlines(j)-lightlines(1) lightlines(j+1)-lightlines(1) lightlines(j+1)-lightlines(1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
                end
            end
        
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).sumfftAmp]/max([out(channel).s(lightidx).sumfftAmp]), '.', 'MarkerSize', 10);
                plot(stimcont/3600-lightlines(1), nsumfftdata, 'LineWidth', 2);

            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).peakfftAmp]/max([out(channel).s(lightidx).peakfftAmp]), '.', 'MarkerSize', 10);
                 plot(ptimcont/3600-lightlines(1), npeakfftdata, 'LineWidth', 2);
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).obwAmp]/max([out(channel).s(lightidx).obwAmp]), '.', 'MarkerSize', 10);
                 plot(otimcont/3600-lightlines(1), nobwdata, 'LineWidth', 2);
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).zAmp]/max([out(channel).s(lightidx).zAmp]), '.', 'MarkerSize', 10);

 %% how peaks of peaks works with obw

obw = obwamp/max(obwamp);

 %Take top of dataset
    %find peaks
    [obwfirstpeak,LOCS] = findpeaks(obw);
    firstpeaktim = timcont(LOCS);
    %find peaks of the peaks
    [obwpeaks,cLOCS] = findpeaks(obw(LOCS));
    peaktim = timcont(LOCS(cLOCS));
    
figure(33); clf; hold on;
    a = [0 1];
            for j = 1:length(lightlines)-1
                if mod(j,2) == 1 %if j is even
                fill([lightlines(j)-lightlines(1) lightlines(j)-lightlines(1) lightlines(j+1)-lightlines(1) lightlines(j+1)-lightlines(1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
                end
            end

        plot(timcont/3600-lightlines(1), obw, '.', 'MarkerSize', 10);
        plot(peaktim/3600-lightlines(1), obwpeaks, 'LineWidth',2);
        plot(firstpeaktim/3600-lightlines(1), obwfirstpeak);
       
       
        %plot([lighttimes' lighttimes'], ylim, 'k-');



figure(34); clf;

    ax(1) = subplot(211); title('peaks of amplitude values');hold on
        a = [0 1];
            for j = 1:length(lightlines)-1
                if mod(j,2) == 1 %if j is even
                fill([lightlines(j)-lightlines(1) lightlines(j)-lightlines(1) lightlines(j+1)-lightlines(1) lightlines(j+1)-lightlines(1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
                end
            end

        plot(timcont/3600-lightlines(1), obw, '.', 'MarkerSize', 10);
        plot(firstpeaktim/3600-lightlines(1), obwfirstpeak, 'LineWidth',1);
        
    
    ax(2) = subplot(212); title('peaks of the peaks'); hold on
        a = [0 1];
            for j = 1:length(lightlines)-1
                if mod(j,2) == 1 %if j is even
                fill([lightlines(j)-lightlines(1) lightlines(j)-lightlines(1) lightlines(j+1)-lightlines(1) lightlines(j+1)-lightlines(1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
                end
            end
        
       
        plot(peaktim/3600-lightlines(1), obwpeaks, 'LineWidth',2);
         plot(firstpeaktim/3600-lightlines(1), obwfirstpeak);
      %  plot(timcont/3600-lightlines(1), obw, '.', 'MarkerSize', 8);


%% peaks with regtim 

[otimcont, nobwdata] = k_peaksofpeaksfilt(timcont, obwamp/max(obwamp), 20);

figure(35); clf; hold on;
        a = [0 1];
            for j = 1:length(lightlines)-1
                if mod(j,2) == 1 %if j is even
                fill([lightlines(j)-lightlines(1) lightlines(j)-lightlines(1) lightlines(j+1)-lightlines(1) lightlines(j+1)-lightlines(1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
                end
            end
    plot(otimcont/3600-lightlines(1), nobwdata, '.', 'MarkerSize', 10);
    plot(peaktim/3600-lightlines(1), obwpeaks, '.', 'MarkerSize', 15);

%%  spline above the spline
ReFs = 20;
p = 0.9;
%subspline subtraction
splinexx = lightlines(1)*3600:ReFs:lightlines(end)*3600;

        %spline of raw data
        spliney1 = csaps(timcont, obw, p);
        %estimate without resample
        obwall = fnval(timcont, spliney1);

        %first spline with resample
        obwyy = fnval(splinexx, spliney1);

        %take raw data above the spline
        topidx = find(obw > obwall);
        topobw = obw(topidx);
        toptim = timcont(topidx);

        %spline of above spline data
        spliney2 = csaps(toptim, topobw, p);
        %resample based on regularized time data
        subobwyy = fnval(splinexx, spliney2);


  figure(36); clf; hold on; %ylim([0,1]);
    a = [0 1];
         
        
        %fill boxes
            %a = ylim; %all of above is just to get the max for the plot lines...
            
                for j = 1:length(lightlines)-1
                    if mod(j,2) == 1 %if j is odd
                     fill([lightlines(j)-lightlines(1) lightlines(j)-lightlines(1) lightlines(j+1)-lightlines(1) lightlines(j+1)-lightlines(1)], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
                    end
                end
            
           
        plot(timcont/3600-lightlines(1), obw, '.', 'MarkerSize', 10);
        plot(toptim/3600-lightlines(1), topobw, '.', 'MarkerSize', 10);

      %  plot(timcont/3600, obwall);
        plot(splinexx/3600-lightlines(1), subobwyy,  'LineWidth',1);

%% trim mean
obw = obwamp/max(obwamp);
%trimmed mean
 window = 5;
  fcn = @(x) trimmean(x,33);
  obwtrim = matlab.tall.movingWindow(fcn, window, obw');
 
    
    
%Regularize
    %regularize data to ReFs interval
    [regtim,  regobwtrim] = k_amponlymetamucil(timcont, obwtrim', ReFs);

 figure(98);clf;hold on; title('trim mean reg'); xlim([11 12.5]);ylim([-1 3]);
 set(gcf, 'renderer', 'painters');

       plot(timcont/3600-lightlines(1), obw, '.', 'MarkerSize', 15);
       plot(regtim/3600-lightlines(1), regobwtrim,'LineWidth',2);
        plot(splinexx/3600-lightlines(1), obwyy,  'LineWidth',2);

        legend('Obw', 'Trim mean', 'Cubic spline', 'Location','northwest');
        xlabel('Time (hours)');
        ylabel('Mean square amplitude');