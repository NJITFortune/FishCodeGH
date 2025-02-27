clearvars -except kg kg2 cc dd

%% make a function?
light = 3;
channel = 1;
ReFs = 10;

%% kg data index - single fish

%[xpoint1 xpoint2 xpoint3 xpoint4];

exp1idxtwL = [64 66 67]; %65 is too short for easy coding - still good data - use later
    exp1idx = [64 66 67 65];
 
    exp1xpoint = [42 198 114 294];  
    
exp2idxtwD =   [68 69 70];  
    exp2idx = [68 69 70 71]; %71 is too short for easy coding

    exp2xpoint = [186 30 258 101];

exp3idx = [72 74]; %RIP Paco and Cheshire
    exp3xpoint = [66 198 138 270];
    
% %1st transistion
% twLfrDidx = [64 66 67 68 69 70 71 72 74];
% %2nd transition
% frLtwDidx = [64 65 66 67 68 69 70 71 72 74];
% %3rd transition
% twDfrLsidx = [64 65 66 67 68 69 70 72 74];
% %fourth transition
% frDtwLidx = [64 65 66 67 68 69 70 71 72 74];

%multifish124idx = [16 19 18];
%18 is like 71 - doesnt go in twD

%% divide into phase tranition points by experiment
%each exp has different indicies

%exp1
 one = k_phaselaser(exp1idx, exp1xpoint, channel, ReFs, light, kg);
%exp2
 dos = k_phaselaser(exp2idx, exp2xpoint, channel, ReFs, light, kg);
%exp3
 tres = k_phaselaser(exp3idx, exp3xpoint, channel, ReFs, light, kg);
%%
%need to save into something
        addpath('/Users/eric/Documents/MATLAB');
        load("Users/eric/Documents/MATLAB/fouramp.mat");
        load("Users/eric/Documents/MATLAB/twelveamp.mat");
        %in 48 hour chunks... not actually that useful
            %length of kg(64) in hours is 344 = ~ 48 *7
        twelveamp = dd;
        fouramp = cc;

        fourtim = one(1).xx(1):0.1:one(1).xx(1)+((length(fouramp)-1)*0.1);
        twelvetim = one(1).xx(1):0.1:one(1).xx(1)+((length(twelveamp)-1)*0.1);
        fourtim1 = one(1).xx1(1):0.1:one(1).xx1(1)+((length(fouramp)-1)*0.1);
        twelvetim1 = one(1).xx1(1):0.1:one(1).xx1(1)+((length(twelveamp)-1)*0.1);

 
%% multifish data 

% multifish124idx = [16 18 19];
% 
% %for kk = 1: length(multifish124idx);
% %kk = 1
% multi(1) = k_multiphaselaser(exp1xpoint, multifish124idx(1) , ReFs, light, kg2);
% multi(2) = k_multiphaselaser(exp3xpoint, multifish124idx(2) , ReFs, light, kg2);
% multi(3) = k_multiphaselaser(exp2xpoint, multifish124idx(3) , ReFs, light, kg2);
% 

%% plots - 
%colors
turq = [64/255, 224/255, 208/255];
darkcy = [0/255, 139/255 139/255];

lightsky = [135/255 206/255 235/255];
deepsky = [0/255 191/255 255/255];

roseybrown = [188/255 143/255 143/255];
pink = [255/255 182/255 193/255];

paleV = [219/255 112/255 147/255];
mediumV = [199/255 21/255 133/255];


%see exp1-3phaseisolation for summary plot

%% 1st transistion - expecting 12 dark, get 4

%spline tranistion summary plot 
figure(24); clf; title('expecting 12 dark, get 4'); hold on;

%ititialize vector to sum across amp
mmean = zeros(1, length(one(1).fftyy1));
length(mmean)
%plot all splines on top of eachother
ax(1) = subplot(211); title('single fish'); hold on;
    %experiment 1
    for k = 1:(length(one)-1)
        %normalize splines around zero
        normy = (one(k).fftyy1 - mean(one(k).fftyy1))/max(abs((one(k).fftyy1 - mean(one(k).fftyy1))));
        length(normy)
        plot(one(k).xx1,(one(k).fftyy1 - mean(one(k).fftyy1))/max(abs((one(k).fftyy1 - mean(one(k).fftyy1)))) , 'LineWidth', 1);
        mmean = mmean + (one(k).fftyy1 - mean(one(k).fftyy1))/max(abs((one(k).fftyy1 - mean(one(k).fftyy1))));
    end
    
    j = k;
    %experiment 2
    clear k;
    for k = 1:length(dos)
        %normalize splines around zero
        y = dos(k).fftyy1;
        plot(dos(k).xx1, (y - mean(y))/max(abs((y - mean(y)))) , 'LineWidth', 1);
        mmean = mmean + (y - mean(y))/max(abs((y - mean(y))));
    end
    
    j = j+k;
    
    %experiment 3
    clear k;
    for k = 1:length(tres)
        %normalize splines around zero
        y = tres(k).fftyy1;
        plot(tres(k).xx1, (y - mean(y))/max(abs((y - mean(y)))), 'LineWidth', 1);
        mmean = mmean + (y - mean(y))/max(abs((y - mean(y))));
    end
    
    j = j + k;

    plot(one(1).xx1, mmean/j, 'k-','LineWidth', 5);
   
%plot light transitions
clear j;
    for j = 1:length(one(1).lighttimes1)
        plot([one(1).lighttimes1(j), one(1).lighttimes1(j)], ylim, 'k-');
      
    end

%ititialize mean vector
% multimean = zeros(1, length(multi(1).Hifftyy1));
%     
% ax(2) = subplot(312); title('multiple fish'); hold on; 
%     for kk = 1:length(multi)
%         
%         yhi = multi(kk).Hifftyy1;
%         ylo = multi(kk).Lofftyy1;
%         
%         %high amplitude fish
%         plot(multi(kk).hixx1, (yhi - mean(yhi))/max(abs((yhi - mean(yhi)))), 'LineWidth', 2);
%         multimean = multimean + (yhi - mean(yhi))/max(abs((yhi - mean(yhi))));
%         
%         %low amplitude fish
%         plot(multi(kk).loxx1, (ylo - mean(ylo))/max(abs((ylo - mean(ylo)))), 'LineWidth', 2);
%         multimean = multimean + (ylo - mean(ylo))/max(abs((ylo - mean(ylo))));
%         
%     end
%     
%     jj = kk *2;
%     
%          plot(multi(1).hixx1, multimean/jj, 'k-','LineWidth', 5);
%     
% %plot light transitions
% clear j;
%     for j = 1:length(multi(1).Hilighttimes1)
%         plot([multi(1).Hilighttimes1(j), multi(1).Hilighttimes1(j)], ylim, 'k-');
%       
%     end

ax(2) = subplot(212); title('avg single fish amplitude'); hold on;
        plot(fourtim1, fouramp, 'LineWidth',2);
        plot(twelvetim1, twelveamp, 'LineWidth', 2);
        legend('four hour', 'twelve hour');
        legend('AutoUpdate','off');
        legend('Box','off');

    %plot light transitions
    clear j;
        for j = 1:length(one(1).lighttimes1)
            plot([one(1).lighttimes1(j), one(1).lighttimes1(j)], ylim, 'k-');
          
        end


linkaxes(ax, 'x');

%%
%individual splines plus raw data    
figure(25); clf; hold on;

   %experiment 1
   clear j;
   clear k;
   clear ax;
   for k = 1:(length(one)-1)
        
       ax(k) = subplot(5,1,k); title('exp1 expecting 12 dark, get 4'); hold on; 
               %plot raw data for each fish
               plot(one(k).timcont1, one(k).fft1, '.', 'Color', paleV);
               %plot spline for each fish
               plot(one(k).xx1, one(k).fftyy1, 'LineWidth', 3, 'Color', turq);
               %add light transistion times as vertical lines
               clear j;
               for j = 1:length(one(k).lighttimes1)
                   
                   plot([one(k).lighttimes1(j), one(k).lighttimes1(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
               end
                
   end
   
%    ax(k+1) = subplot(5,1,(k+1)); title('exp1 multi high freq fish'); hold on;
%               plot(multi(1).HiTim1, multi(1).HiAmp1, '.', 'Color', turq);
%               plot(multi(1).hixx1, multi(1).Hifftyy1,  'LineWidth', 3, 'Color', paleV);
%                clear j;
%                for j = 1:length(multi(1).Hilighttimes1)
%                    
%                    plot([multi(1).Hilighttimes1(j), multi(1).Hilighttimes1(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
%                
%    ax(k+2) = subplot(515);  title('exp1 multi low freq fish'); hold on;
%               plot(multi(1).LoTim1, multi(1).LoAmp1, '.', 'Color', turq);
%               plot(multi(1).loxx1, multi(1).Lofftyy1,  'LineWidth', 3, 'Color', paleV);
%                clear j;
%                for j = 1:length(multi(1).Hilighttimes1)
%                    
%                    plot([multi(1).Hilighttimes1(j), multi(1).Hilighttimes1(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
   
linkaxes(ax, 'x');

figure(26); clf; hold on; 
        
    %experiment 2
    clear k;
    clear ax;

    for k = 1:length(dos)
        
        ax(k) = subplot(6,1,k); title('exp2 expecting 12 get 4'); hold on;
   
                plot(dos(k).timcont1, dos(k).fft1, '.', 'Color', turq);
                plot(dos(k).xx1, dos(k).fftyy1, 'LineWidth', 3, 'Color', mediumV);
        clear j;
        for j = 1:length(dos(k).lighttimes1)
                   
                   plot([dos(k).lighttimes1(j), dos(k).lighttimes1(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
        end
    end
    
%     ax(k+1) = subplot(6,1,(k+1)); title('exp2 multi high freq fish'); hold on;
%               plot(multi(3).HiTim1, multi(3).HiAmp1, '.', 'Color', mediumV);
%               plot(multi(3).hixx1, multi(3).Hifftyy1,  'LineWidth', 3, 'Color', turq);
%                clear j;
%                for j = 1:length(multi(3).Hilighttimes1)
%                    
%                    plot([multi(3).Hilighttimes1(j), multi(3).Hilighttimes1(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
%                
%    ax(k+2) = subplot(616);  title('exp2 multi low freq fish'); hold on;
%               plot(multi(3).LoTim1, multi(3).LoAmp1, '.', 'Color', mediumV);
%               plot(multi(3).loxx1, multi(3).Lofftyy1,  'LineWidth', 3, 'Color', turq);
%                clear j;
%                for j = 1:length(multi(3).Hilighttimes1)
%                    
%                    plot([multi(3).Hilighttimes1(j), multi(3).Hilighttimes1(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
   
 
linkaxes(ax, 'x');
 
figure(27); clf; hold on;

    %experiment 3
    clear k;
    clear ax;
    clear j;
    for k = 1:length(tres)
        
        ax(k) = subplot(4,1, k); title('exp3 expecting 12 get 4'); hold on;
   
        plot(tres(k).timcont1, tres(k).fft1, '.', 'Color', pink);
        plot(tres(k).xx1, tres(k).fftyy1, 'LineWidth', 3, 'Color', roseybrown);
    
   
        clear j;
        for j = 1:length(tres(k).lighttimes1)
                   
                   plot([tres(k).lighttimes1(j), tres(k).lighttimes1(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
        end
    end

%     ax(k+1) = subplot(4,1,(k+1)); title('exp3 multi high freq fish'); hold on;
%               plot(multi(2).HiTim1, multi(2).HiAmp1, '.', 'Color', roseybrown);
%               plot(multi(2).hixx1, multi(2).Hifftyy1,  'LineWidth', 3, 'Color', pink);
%                clear j;
%                for j = 1:length(multi(2).Hilighttimes1)
%                    
%                    plot([multi(2).Hilighttimes1(j), multi(2).Hilighttimes1(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
%                
%    ax(k+2) = subplot(414);  title('exp3 multi low freq fish'); hold on;
%               plot(multi(2).LoTim1, multi(2).LoAmp1, '.', 'Color', roseybrown);
%               plot(multi(2).loxx1, multi(2).Lofftyy1,  'LineWidth', 3, 'Color', pink);
%                clear j;
%                for j = 1:length(multi(2).Hilighttimes1)
%                    
%                    plot([multi(2).Hilighttimes1(j), multi(2).Hilighttimes1(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
    
   
linkaxes(ax, 'x');
 
%% 3rd transistion - expecting 12 light, get 4
%exp 2 loses 1

%spline tranistion summary plot 
figure(28); clf; title('expecting 12 light, get 4'); hold on;

%ititialize vector to sum across amp
mmean2 = zeros(1, length(one(1).fftyy2));

%plot all splines on top of eachother
ax(1) = subplot(211); title('single fish'); hold on;
    %experiment 1
    for k = 1:length(one)
        %normalize splines around zero
        y = one(k).fftyy2;
        plot(one(k).xx2, (y - mean(y))/max(abs((y - mean(y)))) , 'LineWidth', 1);
        mmean2 = mmean2 + (y - mean(y))/max(abs((y - mean(y))));
    end
    
    j = k;
    %experiment 2
    clear k;
    for k = 1:(length(dos)-1)
        %normalize splines around zero
        y = dos(k).fftyy2;
        plot(dos(k).xx2, (y - mean(y))/max(abs((y - mean(y)))) , 'LineWidth', 1);
        mmean2 = mmean2 + (y - mean(y))/max(abs((y - mean(y))));
    end
    
    j = j+k;
    
    %experiment 3
    clear k;
    for k = 1:length(tres)
        %normalize splines around zero
        y = tres(k).fftyy2;
        plot(tres(k).xx2, (y - mean(y))/max(abs((y - mean(y)))), 'LineWidth', 2);
        mmean2 = mmean2 + (y - mean(y))/max(abs((y - mean(y))));
    end
    
    j = j + k;

    plot(one(1).xx2, mmean2/j, 'k-','LineWidth', 5);
   
%plot light transitions
clear j;
    for j = 1:length(one(1).lighttimes2)
        plot([one(1).lighttimes2(j), one(1).lighttimes2(j)], ylim, 'k-');
      
    end

% %ititialize mean vector
% multimean2 = zeros(1, length(multi(1).Hifftyy2));
%     
% ax(2) = subplot(312); title('multiple fish'); hold on; 
%     for kk = 1:(length(multi)-1)
%         
%         yhi = multi(kk).Hifftyy2;
%         ylo = multi(kk).Lofftyy2;
%         
%         
%         %high amplitude fish
%         plot(multi(kk).hixx2, (yhi - mean(yhi))/max(abs((yhi - mean(yhi)))), 'LineWidth', 2);
%         multimean2 = multimean2 + (yhi - mean(yhi))/max(abs((yhi - mean(yhi))));
%         
%         %low amplitude fish
%         plot(multi(kk).loxx2, (ylo - mean(ylo))/max(abs((ylo - mean(ylo)))), 'LineWidth', 2);
%         multimean2 = multimean2 + (ylo - mean(ylo))/max(abs((ylo - mean(ylo))));
%         
%     end
%     
%     jj = kk * 2;
%     
%          plot(multi(1).hixx2, multimean2/jj, 'k-','LineWidth', 5);
%     
% %plot light transitions
% clear j;
%     for j = 1:length(multi(1).Hilighttimes2)
%         plot([multi(1).Hilighttimes2(j), multi(1).Hilighttimes2(j)], ylim, 'k-');
%       
%     end
    

ax(2) = subplot(212); title('avg single fish amplitude'); hold on;
        plot(fourtim1, fouramp, 'LineWidth',2);
        plot(twelvetim1, twelveamp, 'LineWidth', 2);
        legend('four hour', 'twelve hour');
        legend('AutoUpdate','off');
        legend('Box','off');

    %plot light transitions
    clear j;
        for j = 1:length(one(1).lighttimes2)
            plot([one(1).lighttimes2(j), one(1).lighttimes2(j)], ylim, 'k-');
          
        end


linkaxes(ax, 'x');

%%
%individual splines plus raw data    
figure(29); clf; hold on;

   %experiment 1
   clear j;
   clear k;
   clear ax;
   for k = 1:length(one)
        
       ax(k) = subplot(6,1,k); title('exp1 expecting 12 light, get 4'); hold on; 
               %plot raw data for each fish
               plot(one(k).timcont2, one(k).fft2, '.', 'Color', paleV);
               %plot spline for each fish
               plot(one(k).xx2, one(k).fftyy2, 'LineWidth', 3, 'Color', turq);
               %add light transistion times as vertical lines
               clear j;
               for j = 1:length(one(k).lighttimes2)
                   
                   plot([one(k).lighttimes2(j), one(k).lighttimes2(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
               end
                
   end
   
%    ax(k+1) = subplot(6,1,(k+1)); title('exp1 multi high freq fish'); hold on;
%               plot(multi(1).HiTim2, multi(1).HiAmp2, '.', 'Color', turq);
%               plot(multi(1).hixx2, multi(1).Hifftyy2,  'LineWidth', 3, 'Color', paleV);
%                clear j;
%                for j = 1:length(multi(1).Hilighttimes2)
%                    
%                    plot([multi(1).Hilighttimes2(j), multi(1).Hilighttimes2(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
%                
%    ax(k+2) = subplot(616);  title('exp1 multi low freq fish'); hold on;
%               plot(multi(1).LoTim2, multi(1).LoAmp2, '.', 'Color', turq);
%               plot(multi(1).loxx2, multi(1).Lofftyy2,  'LineWidth', 3, 'Color', paleV);
%                clear j;
%                for j = 1:length(multi(1).Hilighttimes2)
%                    
%                    plot([multi(1).Hilighttimes2(j), multi(1).Hilighttimes2(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
   
linkaxes(ax, 'x');

figure(30); clf; hold on; 
        
    %experiment 2
    clear k;
    clear ax;

    for k = 1:(length(dos)-1)
        
        ax(k) = subplot(5,1,k); title('exp2 expecting 12 light get 4'); hold on;
   
                plot(dos(k).timcont2, dos(k).fft2, '.', 'Color', turq);
                plot(dos(k).xx2, dos(k).fftyy2, 'LineWidth', 3, 'Color', mediumV);
        clear j;
        for j = 1:length(dos(k).lighttimes2)
                   
                   plot([dos(k).lighttimes2(j), dos(k).lighttimes2(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
        end
    end
    
   
linkaxes(ax, 'x');
 
figure(31); clf; hold on;

    %experiment 3
    clear k;
    clear ax;
    clear j;
    for k = 1:length(tres)
        
        ax(k) = subplot(4,1, k); title('exp3 expecting 12 light, get 4'); hold on;
   
        plot(tres(k).timcont2, tres(k).fft2, '.', 'Color', pink);
        plot(tres(k).xx2, tres(k).fftyy2, 'LineWidth', 3, 'Color', roseybrown);
    

        clear j;
        for j = 1:length(tres(k).lighttimes2)
                   
                   plot([tres(k).lighttimes2(j), tres(k).lighttimes2(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
        end

   
    end

%     ax(k+1) = subplot(4,1,(k+1)); title('exp3 multi high freq fish'); hold on;
%               plot(multi(2).HiTim2, multi(2).HiAmp2, '.', 'Color', roseybrown);
%               plot(multi(2).hixx2, multi(2).Hifftyy2,  'LineWidth', 3, 'Color', pink);
%                clear j;
% 
%                for j = 1:length(multi(2).Hilighttimes2)
%                    
%                    plot([multi(2).Hilighttimes2(j), multi(2).Hilighttimes2(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
%                
%    ax(k+2) = subplot(414);  title('exp3 multi low freq fish'); hold on;
%               plot(multi(2).LoTim2, multi(2).LoAmp2, '.', 'Color', roseybrown);
%               plot(multi(2).loxx2, multi(2).Lofftyy2,  'LineWidth', 3, 'Color', pink);
%                clear j;
%                for j = 1:length(multi(2).Hilighttimes2)
%                    
%                    plot([multi(2).Hilighttimes2(j), multi(2).Hilighttimes2(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
%     
   
linkaxes(ax, 'x');




%% 2nd transistion - expecting 4 dark, get 12
clear jj;
clear k;
clear j;
clear ax;
%spline tranistion summary plot 
figure(32); clf; title('expecting 4 dark, get 12'); hold on;

%ititialize vector to sum across amp
mmean3 = zeros(1, length(one(1).fftyy3));

%plot all splines on top of eachother
ax(1) = subplot(311); title('single fish'); hold on;
    %experiment 1
    for k = 1:length(one)
        %normalize splines around zero
        y = one(k).fftyy3;
        plot(one(k).xx3, (y - mean(y))/max(abs((y - mean(y)))) , 'LineWidth', 1);
        mmean3 = mmean3 +  (y - mean(y))/max(abs((y - mean(y))));
    end
    
    j = k;
    %experiment 2
    clear k;
    for k = 1:length(dos)
        %normalize splines around zero
        y = dos(k).fftyy3;
        plot(dos(k).xx3, (y - mean(y))/max(abs((y - mean(y)))) , 'LineWidth', 1);
        mmean3 = mmean3 + (y - mean(y))/max(abs((y - mean(y))));
    end
    
    j = j+k;
    
    %experiment 3
    clear k;
    for k = 1:length(tres)
        %normalize splines around zero
        y = tres(k).fftyy3;
        plot(tres(k).xx3, (y - mean(y))/max(abs((y - mean(y)))), 'LineWidth', 1);
        mmean3 = mmean3 + (y - mean(y))/max(abs((y - mean(y))));
    end
    
    j = j + k;

    plot(one(1).xx3, mmean3/j, 'k-','LineWidth', 5);
   
%plot light transitions
clear j;
    for j = 1:length(one(1).lighttimes3)
        plot([one(1).lighttimes3(j), one(1).lighttimes3(j)], ylim, 'k-');
      
    end

%ititialize mean vector
%multimean3 = zeros(1, length(multi(1).Hifftyy3));
    
% ax(2) = subplot(312); title('multiple fish'); hold on; 
%     for kk = 1:length(multi)
%         
%         yhi = multi(kk).Hifftyy3;
%         ylo = multi(kk).Lofftyy3;
%         
%         %high amplitude fish
%         plot(multi(kk).hixx3, (yhi - mean(yhi))/max(abs((yhi - mean(yhi)))), 'LineWidth', 1);
%         multimean3 = multimean3 + (yhi - mean(yhi))/max(abs((yhi - mean(yhi))));
%         
%         %low amplitude fish
%         plot(multi(kk).loxx3, (ylo - mean(ylo))/max(abs((ylo - mean(ylo)))), 'LineWidth', 1);
%         multimean3 = multimean3 + (ylo - mean(ylo))/max(abs((ylo - mean(ylo))));
%         
%     end
%     
%     jj = kk * 2;
%     
%          plot(multi(1).hixx3, multimean3/jj, 'k-','LineWidth', 5);
%     
%plot light transitions
% clear j;
%     for j = 1:length(multi(1).Hilighttimes3)
%         plot([multi(1).Hilighttimes3(j), multi(1).Hilighttimes3(j)], ylim, 'k-');
%       
%     end

ax(2) = subplot(212); title('avg single fish amplitude'); hold on;
        plot(fourtim1, fouramp, 'LineWidth',2);
        plot(twelvetim1, twelveamp, 'LineWidth', 2);
        legend('four hour', 'twelve hour');
        legend('AutoUpdate','off');
        legend('Box','off');

    %plot light transitions
    clear j;
        for j = 1:length(one(1).lighttimes3) 
            plot([one(1).lighttimes3(j), one(1).lighttimes3(j)], ylim, 'k-');
          
        end

linkaxes(ax, 'x');

%%
%individual splines plus raw data    
figure(33); clf; hold on;

   %experiment 1
   clear j;
   clear k;
   clear ax;
   for k = 1:length(one)
        
       ax(k) = subplot(6,1,k); title('exp1 expecting 4 dark, get 12'); hold on; 
               %plot raw data for each fish
               plot(one(k).timcont3, one(k).fft3, '.', 'Color', paleV);
               %plot spline for each fish
               plot(one(k).xx3, one(k).fftyy3, 'LineWidth', 3, 'Color', turq);
               %add light transistion times as vertical lines
               clear j;
               for j = 1:length(one(k).lighttimes3)
                   
                   plot([one(k).lighttimes3(j), one(k).lighttimes3(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
               end
                
   end
   
%    ax(k+1) = subplot(6,1,(k+1)); title('exp1 multi high freq fish'); hold on;
%               plot(multi(1).HiTim3, multi(1).HiAmp3, '.', 'Color', turq);
%               plot(multi(1).hixx3, multi(1).Hifftyy3,  'LineWidth', 3, 'Color', paleV);
%                clear j;
%                for j = 1:length(multi(1).Hilighttimes3)
%                    
%                    plot([multi(1).Hilighttimes3(j), multi(1).Hilighttimes3(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
%                
%    ax(k+2) = subplot(616);  title('exp1 multi low freq fish'); hold on;
%               plot(multi(1).LoTim3, multi(1).LoAmp3, '.', 'Color', turq);
%               plot(multi(1).loxx3, multi(1).Lofftyy3,  'LineWidth', 3, 'Color', paleV);
%                clear j;
%                for j = 1:length(multi(1).Hilighttimes3)
%                    
%                    plot([multi(1).Hilighttimes3(j), multi(1).Hilighttimes3(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
   
linkaxes(ax, 'x');

figure(34); clf; hold on; 
        
    %experiment 2
    clear k;
    clear ax;

    for k = 1:length(dos)
        
        ax(k) = subplot(6,1,k); title('exp2 expecting 12 get 4'); hold on;
   
                plot(dos(k).timcont3, dos(k).fft3, '.', 'Color', turq);
                plot(dos(k).xx3, dos(k).fftyy3, 'LineWidth', 3, 'Color', mediumV);
        clear j;
        for j = 1:length(dos(k).lighttimes3)
                   
                   plot([dos(k).lighttimes3(j), dos(k).lighttimes3(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
        end
    end
    
%     ax(k+1) = subplot(6,1,(k+1)); title('exp2 multi high freq fish'); hold on;
%               plot(multi(3).HiTim3, multi(3).HiAmp3, '.', 'Color', mediumV);
%               plot(multi(3).hixx3, multi(3).Hifftyy3,  'LineWidth', 3, 'Color', turq);
%                clear j;
%                for j = 1:length(multi(3).Hilighttimes3)
%                    
%                    plot([multi(3).Hilighttimes3(j), multi(3).Hilighttimes3(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
%                
%    ax(k+2) = subplot(616);  title('exp2 multi low freq fish'); hold on;
%               plot(multi(3).LoTim3, multi(3).LoAmp3, '.', 'Color', mediumV);
%               plot(multi(3).loxx3, multi(3).Lofftyy3,  'LineWidth', 3, 'Color', turq);
%                clear j;
%                for j = 1:length(multi(3).Hilighttimes3)
%                    
%                    plot([multi(3).Hilighttimes3(j), multi(3).Hilighttimes3(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
   
 
linkaxes(ax, 'x');
 
figure(35); clf; hold on;

    %experiment 3
    clear k;
    clear ax;
    clear j;
    for k = 1:length(tres)
        
        ax(k) = subplot(4,1, k); title('exp3 expecting 12 get 4'); hold on;
   
        plot(tres(k).timcont3, tres(k).fft3, '.', 'Color', pink);
        plot(tres(k).xx3, tres(k).fftyy3, 'LineWidth', 3, 'Color', roseybrown);


        clear j;
        for j = 1:length(tres(k).lighttimes3)
                   
                   plot([tres(k).lighttimes3(j), tres(k).lighttimes3(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
        end
    end
   
    
%     ax(k+1) = subplot(4,1,(k+1)); title('exp3 multi high freq fish'); hold on;
%               plot(multi(2).HiTim3, multi(2).HiAmp3, '.', 'Color', roseybrown);
%               plot(multi(2).hixx3, multi(2).Hifftyy3,  'LineWidth', 3, 'Color', pink);
%                clear j;
%                for j = 1:length(multi(2).Hilighttimes3)
%                    
%                    plot([multi(2).Hilighttimes3(j), multi(2).Hilighttimes3(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
%                
%    ax(k+2) = subplot(414);  title('exp3 multi low freq fish'); hold on;
%               plot(multi(2).LoTim3, multi(2).LoAmp3, '.', 'Color', roseybrown);
%               plot(multi(2).loxx3, multi(2).Lofftyy3,  'LineWidth', 3, 'Color', pink);
%                clear j;
%                for j = 1:length(multi(2).Hilighttimes3)
%                    
%                    plot([multi(2).Hilighttimes3(j), multi(2).Hilighttimes3(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
    
   
linkaxes(ax, 'x');
 
%% 4th transistion - expecting 4 light, get 12
clear jj;
clear k;
clear j;
clear ax;
%spline tranistion summary plot 
figure(36); clf; title('expecting 4 light, get 12'); hold on;

%ititialize vector to sum across amp
mmean4 = zeros(1, length(one(1).fftyy4));

%plot all splines on top of eachother
ax(1) = subplot(211); title('single fish'); hold on;
    %experiment 1
    for k = 1:length(one)
        %normalize splines around zero
        y = one(k).fftyy4;
        plot(one(k).xx4, (y - mean(y))/max(abs((y - mean(y)))) , 'LineWidth', 1);
        mmean4 = mmean4 +  (y - mean(y))/max(abs((y - mean(y))));
    end
    
    j = k;
    %experiment 2
    clear k;
    for k = 1:length(dos)
        %normalize splines around zero
        y = dos(k).fftyy4;
        plot(dos(k).xx4, (y - mean(y))/max(abs((y - mean(y)))) , 'LineWidth', 1);
        mmean4 = mmean4 + (y - mean(y))/max(abs((y - mean(y))));
    end
    
    j = j+k;
    
    %experiment 3
    clear k;
    for k = 1:length(tres)
        %normalize splines around zero
        y = tres(k).fftyy4;
        plot(tres(k).xx4, (y - mean(y))/max(abs((y - mean(y)))), 'LineWidth', 1);
        mmean4 = mmean4 + (y - mean(y))/max(abs((y - mean(y))));
    end
    
    j = j + k;

    plot(one(1).xx4, mmean4/j, 'k-','LineWidth', 5);
   
%plot light transitions
clear j;
    for j = 1:length(one(1).lighttimes4)
        plot([one(1).lighttimes4(j), one(1).lighttimes4(j)], ylim, 'k-');
      
    end

%ititialize mean vector
%multimean4 = zeros(1, length(multi(2).Hifftyy4));
    
% ax(2) = subplot(312); title('multiple fish'); hold on; 
%     for kk = 2:length(multi)
%         
%         yhi = multi(kk).Hifftyy4;
%         ylo = multi(kk).Lofftyy4;
%        
%         
%         %high amplitude fish
%         plot(multi(kk).hixx4, (yhi - mean(yhi))/max(abs((yhi - mean(yhi)))), 'LineWidth', 1);
%         multimean4 = multimean4 + (yhi - mean(yhi))/max(abs((yhi - mean(yhi))));
%         
%         %low amplitude fish
%         plot(multi(kk).loxx4, (ylo - mean(ylo))/max(abs((ylo - mean(ylo)))), 'LineWidth', 1);
%         multimean4 = multimean4 + (ylo - mean(ylo))/max(abs((ylo - mean(ylo))));
%         
%     end
%     
%     jj = kk * 2;
%     
%          plot(multi(2).hixx4, multimean4/jj, 'k-','LineWidth', 5);
%     
% %plot light transitions
% clear j;
%     for j = 1:length(multi(2).Hilighttimes4)
%         plot([multi(2).Hilighttimes4(j), multi(2).Hilighttimes4(j)], ylim, 'k-');
%       
%     end
%  

ax(2) = subplot(212); title('avg single fish amplitude'); hold on;
        plot(fourtim1, fouramp, 'LineWidth',2);
        plot(twelvetim1, twelveamp, 'LineWidth', 2);
        legend('four hour', 'twelve hour');
        legend('AutoUpdate','off');
        legend('Box','off');

    %plot light transitions
    clear j;
        for j = 1:length(one(1).lighttimes4)
            plot([one(1).lighttimes4(j), one(1).lighttimes4(j)], ylim, 'k-');
          
        end

linkaxes(ax, 'x');

%%
%individual splines plus raw data    
figure(37); clf; hold on;

   %experiment 1
   clear j;
   clear k;
   clear ax;
   for k = 1:length(one)
        
       ax(k) = subplot(4,1,k); title('exp1 expecting 4 light, get 12'); hold on; 
               %plot raw data for each fish
               plot(one(k).timcont4, one(k).fft4, '.', 'Color', paleV);
               %plot spline for each fish
               plot(one(k).xx4, one(k).fftyy4, 'LineWidth', 3, 'Color', turq);
               %add light transistion times as vertical lines
               clear j;
               for j = 1:length(one(k).lighttimes4)
                   
                   plot([one(k).lighttimes4(j), one(k).lighttimes4(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
               end
                
   end
   
 
   
linkaxes(ax, 'x');

figure(38); clf; hold on; 
        
    %experiment 2
    clear k;
    clear ax;

    for k = 1:length(dos)
        
        ax(k) = subplot(6,1,k); title('exp2 expecting 12 get 4'); hold on;
   
                plot(dos(k).timcont4, dos(k).fft4, '.', 'Color', turq);
                plot(dos(k).xx4, dos(k).fftyy4, 'LineWidth', 3, 'Color', mediumV);
        clear j;
        for j = 1:length(dos(k).lighttimes4)
                   
                   plot([dos(k).lighttimes4(j), dos(k).lighttimes4(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
        end
    end
    
%     ax(k+1) = subplot(6,1,(k+1)); title('exp2 multi high freq fish'); hold on;
%               plot(multi(3).HiTim4, multi(3).HiAmp4, '.', 'Color', mediumV);
%               plot(multi(3).hixx4, multi(3).Hifftyy4,  'LineWidth', 3, 'Color', turq);
%                clear j;
%                for j = 1:length(multi(3).Hilighttimes4)
%                    
%                    plot([multi(3).Hilighttimes4(j), multi(3).Hilighttimes4(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
%                
%    ax(k+2) = subplot(616);  title('exp2 multi low freq fish'); hold on;
%               plot(multi(3).LoTim4, multi(3).LoAmp4, '.', 'Color', mediumV);
%               plot(multi(3).loxx4, multi(3).Lofftyy4,  'LineWidth', 3, 'Color', turq);
%                clear j;
%                for j = 1:length(multi(3).Hilighttimes4)
%                    
%                    plot([multi(3).Hilighttimes4(j), multi(3).Hilighttimes4(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
%    
 
linkaxes(ax, 'x');
 
figure(39); clf; hold on;

    %experiment 3
    clear k;
    clear ax;
    clear j;
    for k = 1:length(tres)
        
        ax(k) = subplot(4,1, k); title('exp3 expecting 12 get 4'); hold on;
   
        plot(tres(k).timcont4, tres(k).fft4, '.', 'Color', pink);
        plot(tres(k).xx4, tres(k).fftyy4, 'LineWidth', 3, 'Color', roseybrown);
  
        for j = 1:length(tres(k).lighttimes4)
                   
                   plot([tres(k).lighttimes4(j), tres(k).lighttimes4(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
        end
    end
%     ax(k+1) = subplot(4,1,(k+1)); title('exp3 multi high freq fish'); hold on;
%               plot(multi(2).HiTim4, multi(2).HiAmp4, '.', 'Color', roseybrown);
%               plot(multi(2).hixx4, multi(2).Hifftyy4,  'LineWidth', 3, 'Color', pink);
%                clear j;
%                for j = 1:length(multi(2).Hilighttimes4)
%                    
%                    plot([multi(2).Hilighttimes4(j), multi(2).Hilighttimes4(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
%                
%    ax(k+2) = subplot(414);  title('exp3 multi low freq fish'); hold on;
%               plot(multi(2).LoTim4, multi(2).LoAmp4, '.', 'Color', roseybrown);
%               plot(multi(2).loxx4, multi(2).Lofftyy4,  'LineWidth', 3, 'Color', pink);
%                clear j;
%                for j = 1:length(multi(2).Hilighttimes4)
%                    
%                    plot([multi(2).Hilighttimes4(j), multi(2).Hilighttimes4(j)], ylim, 'k-', 'LineWidth', 0.5);
%                    
%                end
%     
   
linkaxes(ax, 'x');
 



