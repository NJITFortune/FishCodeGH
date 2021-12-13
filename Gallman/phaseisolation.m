clearvars -except kg kg2 cc

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

multifish124idx = [16 18 19];
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
%         addpath('/Users/eric/Documents/MATLAB');
%         load("Users/eric/Documents/MATLAB/fouramp.mat");
%         load("Users/eric/Documents/MATLAB/twelveamp.mat");
%         %in 48 hour chunks... not actually that useful
%             %length of kg(64) in hours is 344 = ~ 48 *7
%         twelveamp = [dd dd dd dd dd dd dd];
%         fouramp = [cc cc cc cc cc cc cc];
% 
%         fourtim = one(1).xx(1):0.1:one(1).xx(1)+((length(fouramp)-1)*0.1);
%         twelvetim = one(1).xx(1):0.1:one(1).xx(1)+((length(twelveamp)-1)*0.1);
%     fourtim1 = one(1).xx1(1):0.1:one(1).xx1(1)+((length(fouramp)-1)*0.1);
%         twelvetim1 = one(1).xx1(1):0.1:one(1).xx1(1)+((length(twelveamp)-1)*0.1);

 
%% multifish data 

multifish124idx = [16 18 19];

%for kk = 1: length(multifish124idx);
%kk = 1
multi(1) = k_multiphaselaser(exp1xpoint, multifish124idx(1) , ReFs, light, kg2);
multi(2) = k_multiphaselaser(exp2xpoint, multifish124idx(2) , ReFs, light, kg2);
multi(3) = k_multiphaselaser(exp3xpoint, multifish124idx(3) , ReFs, light, kg2);


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
        plot(one(k).xx1,(one(k).fftyy1 - mean(one(k).fftyy1))/max(abs((one(k).fftyy1 - mean(one(k).fftyy1)))) , 'LineWidth', 2);
        mmean = mmean + (one(k).fftyy1 - mean(one(k).fftyy1))/max(abs((one(k).fftyy1 - mean(one(k).fftyy1))));
    end
    
    j = k;
    %experiment 2
    clear k;
    for k = 1:length(dos)
        %normalize splines around zero
        y = dos(k).fftyy1;
        plot(dos(k).xx1, (y - mean(y))/max(abs((y - mean(y)))) , 'LineWidth', 2);
        mmean = mmean + (y - mean(y))/max(abs((y - mean(y))));
    end
    
    j = j+k;
    
    %experiment 3
    clear k;
    for k = 1:length(tres)
        %normalize splines around zero
        y = tres(k).fftyy1;
        plot(tres(k).xx1, (y - mean(y))/max(abs((y - mean(y)))), 'LineWidth', 2);
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
multimean = zeros(1, length(multi(1).Hifftyy1));
    
ax(2) = subplot(212); title('multiple fish'); hold on; 
    for kk = 1:length(multi)
        
        yhi = multi(kk).Hifftyy1;
        ylo = multi(kk).Lofftyy1;
        
        %high amplitude fish
        plot(multi(kk).hixx1, (yhi - mean(yhi))/max(abs((yhi - mean(yhi)))), 'LineWidth', 2);
        multimean = multimean + (yhi - mean(yhi))/max(abs((yhi - mean(yhi))));
        
        %low amplitude fish
        plot(multi(kk).loxx1, (ylo - mean(ylo))/max(abs((ylo - mean(ylo)))), 'LineWidth', 2);
        multimean = multimean + (ylo - mean(ylo))/max(abs((ylo - mean(ylo))));
        
    end
    
    jj = kk *2;
    
         plot(multi(1).hixx1, multimean/jj, 'k-','LineWidth', 5);
    
%plot light transitions
clear j;
    for j = 1:length(multi(1).Hilighttimes1)
        plot([multi(1).Hilighttimes1(j), multi(1).Hilighttimes1(j)], ylim, 'k-');
      
    end
    
linkaxes(ax, 'x');


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
   
   ax(k+1) = subplot(5,1,(k+1)); title('exp1 multi'); hold on;
              plot(multi(1).
   
linkaxes(ax, 'x');

figure(26); clf; hold on; 
        
    %experiment 2
    clear k;
    clear ax;

    for k = 1:length(dos)
        
        ax(k) = subplot(4,1,k); title('exp2 expecting 12 get 4'); hold on;
   
                plot(dos(k).timcont1, dos(k).fft1, '.', 'Color', turq);
                plot(dos(k).xx1, dos(k).fftyy1, 'LineWidth', 3, 'Color', mediumV);
        clear j;
        for j = 1:length(dos(k).lighttimes1)
                   
                   plot([dos(k).lighttimes1(j), dos(k).lighttimes1(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
        end
    end
 
linkaxes(ax, 'x');
 
figure(27); clf; hold on;

    %experiment 3
    clear k;
    clear ax;
    clear j;
    for k = 1:length(tres)
        
        ax(k) = subplot(length(tres),1, k); title('exp3 expecting 12 get 4'); hold on;
   
        plot(tres(k).timcont1, tres(k).fft1, '.', 'Color', pink);
        plot(tres(k).xx1, tres(k).fftyy1, 'LineWidth', 3, 'Color', roseybrown);
    end
   
   
linkaxes(ax, 'x');
 







