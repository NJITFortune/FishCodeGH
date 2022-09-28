

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
        
        ax(1) = subplot(211); title('Mean square amplitude'); hold on;
           
%             plot([out(1).s.timcont]/3600, [out(1).s.psumfftAmp], '.', 'MarkerSize', 0.1);      
%             plot([out(1).s.timcont]/3600, [out(1).s.ppeakfftAmp], '.', 'MarkerSize', 0.1);
%             plot([out(1).s.timcont]/3600, [out(1).s.pobwAmp], '.', 'MarkerSize', 0.1);
%             plot([out(1).s.timcont]/3600, [out(1).s.zAmp], '.', 'MarkerSize', 0.1);
            a = [0 1];
            for j = 1:length(lightlines)-1
                if mod(j,2) == 1 %if j is even
                fill([lightlines(j)-lightlines(1) lightlines(j)-lightlines(1) lightlines(j+1)-lightlines(1) lightlines(j+1)-lightlines(1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
                end
            end
            
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).sumfftAmp], '.', 'MarkerSize', 10, 'DisplayName', 'sumfftAmp');
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).peakfftAmp], '.', 'MarkerSize', 10);
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).obwAmp], '.', 'MarkerSize', 10);
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).zAmp], '.', 'MarkerSize', 10);
            legend;
         ax(2) = subplot(212); title('normalized'); hold on;

            
            for j = 1:length(lightlines)-1
                if mod(j,2) == 1 %if j is even
                fill([lightlines(j)-lightlines(1) lightlines(j)-lightlines(1) lightlines(j+1)-lightlines(1) lightlines(j+1)-lightlines(1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
                end
            end
        
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).sumfftAmp]/max([out(channel).s(lightidx).sumfftAmp]), '.', 'MarkerSize', 10);
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).peakfftAmp]/max([out(channel).s(lightidx).peakfftAmp]), '.', 'MarkerSize', 10);
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).obwAmp]/max([out(channel).s(lightidx).obwAmp]), '.', 'MarkerSize', 10);
            plot([out(channel).s(lightidx).timcont]/3600-lightlines(1), [out(channel).s(lightidx).zAmp]/max([out(channel).s(lightidx).zAmp]), '.', 'MarkerSize', 10);
            legend('sumfftAmp', 'peakfftAmp', 'obwAmp', 'zAmp');
    
     linkaxes(ax, 'x')

figure(30); clf; hold on;

%because tim isn't resetting for a new day or something weird
[timcont, sortidx] = sort([out(channel).s(lightidx).timcont]);
sumamp = [out(channel).s(sortidx).psumfftAmp];
peakamp = [out(channel).s(sortidx).ppeakfftAmp];
obwamp = [out(channel).s(sortidx).pobwAmp];
zamp = [out(channel).s(sortidx).zAmp];

         ax(1) = subplot(211); title('Mean square amplitude');  hold on;
            a = [0 1];
            for j = 1:length(lightlines)-1
                if mod(j,2) == 1 %if j is even
                fill([lightlines(j)-lightlines(1) lightlines(j)-lightlines(1) lightlines(j+1)-lightlines(1) lightlines(j+1)-lightlines(1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
                end
            end
                [stimcont, sumfftdata] = k_peaksofpeaksfilt(timcont, sumamp, 20);
                    plot(stimcont/3600-lightlines(1), sumfftdata, 'LineWidth', 2);

                [ptimcont, peakfftdata] = k_peaksofpeaksfilt(timcont, peakamp, 20);
                    plot(ptimcont/3600-lightlines(1), peakfftdata, 'LineWidth', 2);
            
                [otimcont, obwdata] = k_peaksofpeaksfilt(timcont, obwamp, 20);
                    plot(otimcont/3600-lightlines(1), obwdata, 'LineWidth', 2);

                [ztimcont, zdata] = k_peaksofpeaksfilt(timcont, zamp, 20);    
                    plot(ztimcont/3600-lightlines(1), zdata, 'LineWidth', 2);
            

         ax(2) = subplot(212); title('Mean square amplitude');  hold on;
            a = [0 1];
            for j = 1:length(lightlines)-1
                if mod(j,2) == 1 %if j is even
                fill([lightlines(j)-lightlines(1) lightlines(j)-lightlines(1) lightlines(j+1)-lightlines(1) lightlines(j+1)-lightlines(1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
                end
            end
                [stimcont, sumfftdata] = k_peaksofpeaksfilt(timcont, sumamp/max(sumamp), 20);
                    plot(stimcont/3600-lightlines(1), sumfftdata, 'LineWidth', 2);

                [ptimcont, peakfftdata] = k_peaksofpeaksfilt(timcont, peakamp/max(peakamp), 20);
                    plot(ptimcont/3600-lightlines(1), peakfftdata, 'LineWidth', 2);
            
                [otimcont, obwdata] = k_peaksofpeaksfilt(timcont, obwamp/max(obwamp), 20);
                    plot(otimcont/3600-lightlines(1), obwdata, 'LineWidth', 2);

                [ztimcont, zdata] = k_peaksofpeaksfilt(timcont, zamp/max(zamp), 20);    
                    plot(ztimcont/3600-lightlines(1), zdata, 'LineWidth', 2); 
     