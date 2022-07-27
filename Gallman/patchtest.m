

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

 numbercycles = floor(out(1).s(datasubset(2)).timcont/(4*60*60)); %number of cycles in data
        timz = 1:1:numbercycles;
      

lightlines = 0.3914 + (4*(timz-1));

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


figure(29);clf; hold on;
        
        ax(1) = subplot(211); title('Mean square amplitude'); hold on;
           
%             plot([out(1).s.timcont]/3600, [out(1).s.psumfftAmp], '.', 'MarkerSize', 0.1);      
%             plot([out(1).s.timcont]/3600, [out(1).s.ppeakfftAmp], '.', 'MarkerSize', 0.1);
%             plot([out(1).s.timcont]/3600, [out(1).s.pobwAmp], '.', 'MarkerSize', 0.1);
%             plot([out(1).s.timcont]/3600, [out(1).s.zAmp], '.', 'MarkerSize', 0.1);
            a = [0 1];
            for j = 1:length(lightlines)-1
                if mod(j,2) == 1 %if j is even
                fill([lightlines(j) lightlines(j) lightlines(j+1) lightlines(j+1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
                end
            end
            
            plot([out(2).s.timcont]/3600, [out(channel).s.sumfftAmp], '.', 'MarkerSize', 10);
            plot([out(2).s.timcont]/3600, [out(channel).s.peakfftAmp], '.', 'MarkerSize', 10);
            plot([out(2).s.timcont]/3600, [out(channel).s.obwAmp], '.', 'MarkerSize', 10);
            %plot([out(1).s.timcont]/3600, [out(1).s.zAmp], '.', 'MarkerSize', 10);
           % legend('sumfftAmp', 'peakfftAmp', 'obwAmp', 'zAmp');

         ax(2) = subplot(212); title('normalized');  hold on;

            
            for j = 1:length(lightlines)-1
                if mod(j,2) == 1 %if j is even
                fill([lightlines(j) lightlines(j) lightlines(j+1) lightlines(j+1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
                end
            end
        
            plot([out(1).s.timcont]/3600, [out(channel).s.sumfftAmp]/max([out(channel).s.sumfftAmp]), '.', 'MarkerSize', 10);
            plot([out(1).s.timcont]/3600, [out(channel).s.peakfftAmp]/max([out(channel).s.peakfftAmp]), '.', 'MarkerSize', 10);
            plot([out(1).s.timcont]/3600, [out(channel).s.obwAmp]/max([out(channel).s.obwAmp]), '.', 'MarkerSize', 10);
            plot([out(1).s.timcont]/3600, [out(channel).s.zAmp]/max([out(channel).s.zAmp]), '.', 'MarkerSize', 10);
            %legend('sumfftAmp', 'peakfftAmp', 'obwAmp', 'zAmp');
    
     linkaxes(ax, 'x')

figure(4); clf; hold on;

         ax(1) = subplot(211); title('Mean square amplitude');hold on;

            for j = 1:length(lightlines)-1
                if mod(j,2) == 1 %if j is even
                fill([lightlines(j) lightlines(j) lightlines(j+1) lightlines(j+1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
                end
            end
                [timcont, sumfftdata] = k_peaksofpeaksfilt([out(channel).s.timcont], [out(channel).s.sumfftAmp], 20);
                    plot(timcont/3600, sumfftdata);

                [timcont, peakfftdata] = k_peaksofpeaksfilt([out(channel).s.timcont], [out(channel).s.peakfftAmp], 20);
                    plot(timcont/3600, peakfftdata);
            
                [timcont, obwdata] = k_peaksofpeaksfilt([out(channel).s.timcont], [out(channel).s.obwAmp], 20);
                    plot(timcont/3600, obwdata);

%                 [timcont, zdata] = k_peaksofpeaksfilt([out(1).s.timcont], [out(1).s.zAmp], 20);    
%                     plot(timcont/3600, zdata);
%             

         ax(2) = subplot(212); title('Mean square amplitude'); hold on;

            for j = 1:length(lightlines)-1
                if mod(j,2) == 1 %if j is even
                fill([lightlines(j) lightlines(j) lightlines(j+1) lightlines(j+1)], [0 a(2) a(2) 0], [0.9, 0.9, 0.9]);
                end
            end
                [timcont, sumfftdata] = k_peaksofpeaksfilt([out(1).s.timcont], [out(channel).s.sumfftAmp]/max([out(channel).s.sumfftAmp]), 20);
                    plot(timcont/3600, sumfftdata);

                [timcont, peakfftdata] = k_peaksofpeaksfilt([out(1).s.timcont], [out(channel).s.peakfftAmp]/max([out(channel).s.peakfftAmp]), 20);
                    plot(timcont/3600, peakfftdata);
            
                [timcont, obwdata] = k_peaksofpeaksfilt([out(1).s.timcont], [out(channel).s.obwAmp]/max([out(channel).s.obwAmp]), 20);
                    plot(timcont/3600, obwdata);

%                 [timcont, zdata] = k_peaksofpeaksfilt([out(1).s.timcont], [out(1).s.zAmp]/max([out(1).s.zAmp]), 20);    
%                     plot(timcont/3600, zdata); 
%      