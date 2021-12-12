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
 one= k_phaselaser(exp1idx, exp1xpoint, channel, ReFs, light);
%exp2
 dos = k_phaselaser(exp2idx, exp2xpoint, channel, ReFs, light);
%exp3
 tres = k_phaselaser(exp3idx, exp3xpoint, channel, ReFs, light);
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
multi(1) = k_multiphaselaser(exp1xpoint, multifish124idx(1) , ReFs, light);
multi(2) = k_multiphaselaser(exp2xpoint, multifish124idx(2) , ReFs, light);
multi(3) = k_multiphaselaser(exp3xpoint, multifish124idx(3) , ReFs, light);


%% plots - 
%colors
turq = [64/255, 224/255, 208/255];
darkcy = [0/255, 139/255 139/255];

lightsky = [135/255 206/255 235/255];
deepsky = [0/255 191/255 255/255];

lightsalmon = [255/255 160/255 122/255];
salmon = [250/255 128/255 114/255];

paleV = [219/255 112/255 147/255];
mediumV = [199/255 21/255 133/255];


%see exp1-3phaseisolation for summary plot

%% 1st transistion - expecting 12 dark, get 4

%spline tranistion summary plot 
figure(24); clf; title('expecting 12 dark, get 4'); hold on;

mmean = zeros(1, length(one(1).fftyy1));

%plot all splines on top of eachother
ax(1) = subplot(211); title('single fish'); hold on;
    %experiment 1
    for k = 1:length(one)
        %normalize splines around zero
        normy = (one(k).fftyy1 - mean(one(k).fftyy1))/max(abs((one(k).fftyy1 - mean(one(k).fftyy1))));
        plot(one(k).xx1,normy , 'LineWidth', 2);
        mmean = mmean + normy;
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
        plot(tres(k).xx1, (y - mean(y))/max(abs((y - mean(y)))) , 'LineWidth', 2);
        mmean = mmean + (y - mean(y))/max(abs((y - mean(y))));
    end
    
    j = j + k;

    plot(one(1).xx1, mmean/j, 'k-','LineWidth', 5);
   
%plot light transitions
clear j;
    for j = 1:length(one(1).lighttimes1)
        plot([one(1).lighttimes1(j), one(1).lighttimes1(j)], ylim, 'k-');
      
    end

ax(2) = subplot(212); title('multiple fish'); hold on; 
    for kk = 1:length(multi)
        yhi = multi(kk).Hifftyy1;
        ylo = multi(kk).Lofftyy1;
        plot(multi(kk).
        

%individual splines plus raw data    
figure(25); clf; hold on;

   for k = 1:length(one)
        
       ax(k) = subplot(3,1,k); title('expecting 12 dark, get 4'); hold on; 
               %plot raw data for each fish
               plot(one(k).timcont1, one(k).fft1, '.');
               %plot spline for each fish
               plot(one(k).xx1, one(k).fftyy1, 'LineWidth', 3);
               %add light transistion times as vertical lines
               clear j;
               for j = 1:length(one(k).lighttimes1)
                   
                   plot([one(k).lighttimes1(j), one(k).lighttimes1(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
               end
                
   end
linkaxes(ax, 'x');
 figure(26); clf; hold on;

    plot(one(1).xx1(1:end-1), diff(mmean/3), 'k-','LineWidth', 5);
    for j = 1:length(one(1).lighttimes1)
        plot([one(1).lighttimes1(j), one(1).lighttimes1(j)], ylim, 'k-');
      
    end





%% 3rd transistion

%spline tranistion summary plot
figure(28); clf; title('expecting 12 light get 4'); hold on;

mmean2 = zeros(1, length(one(1).fftyy2));
%plot all splines on top of eachother
    for k = 1:length(one)
    plot(one(k).xx2, (one(k).fftyy2 - mean(one(k).fftyy2))/max(abs((one(k).fftyy2 - mean(one(k).fftyy2)))), 'LineWidth', 2);
     mmean2 = mmean2 + (one(k).fftyy2 - mean(one(k).fftyy2))/max(abs((one(k).fftyy2 - mean(one(k).fftyy2))));
    end
    plot(one(1).xx2, mmean2/3, 'k-','LineWidth', 5);
%plot light transitions
    for j = 1:length(one(1).lighttimes2)
        plot([one(1).lighttimes2(j), one(1).lighttimes2(j)], ylim, 'k-');
      
    end

%individual splines plus raw data    
figure(29); clf; hold on;

   for k = 1:length(one)
        
       ax(k) = subplot(3,1,k); title('expecting 12 light get 4'); hold on; 
               %plot raw data for each fish
               plot(one(k).timcont2, one(k).fft2, '.');
               %plot spline for each fish
               plot(one(k).xx2, one(k).fftyy2, 'LineWidth', 3);
               %add light transistion times as vertical lines
               clear j;
               for j = 1:length(one(k).lighttimes2)
                   
                   plot([one(k).lighttimes2(j), one(k).lighttimes2(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
               end
                
   end
linkaxes(ax, 'x');

 figure(27); clf; hold on;

plot(one(1).xx2(1:end-1), diff(mmean2/3), 'k-','LineWidth', 5);
%plot light transitions
    for j = 1:length(one(1).lighttimes2)
        plot([one(1).lighttimes2(j), one(1).lighttimes2(j)], ylim, 'k-');
      
    end


   
%% 2nd transition
clear ax;

%spline tranistion summary plot
figure(30); clf; title('expecting 4 hours of dark and get 12'); hold on;

mmean3 = zeros(1, length(one(1).fftyy3));
%plot all splines on top of eachother
    for k = 1:length(one)
    plot(one(k).xx3, (one(k).fftyy3 - mean(one(k).fftyy3))/max(abs((one(k).fftyy3 - mean(one(k).fftyy3)))), 'LineWidth', 2);
     mmean3 = mmean3 + (one(k).fftyy3 - mean(one(k).fftyy3))/max(abs((one(k).fftyy3 - mean(one(k).fftyy3))));
    end
    plot(one(1).xx3, mmean3/3, 'k-','LineWidth', 5);
%plot light transitions
    for j = 1:length(one(1).lighttimes3)
        plot([one(1).lighttimes3(j), one(1).lighttimes3(j)], ylim, 'k-');
      
    end

%individual splines plus raw data    
figure(31); clf; hold on;

   for k = 1:length(one)
        
       ax(k) = subplot(3,1,k);title('expecting 4 hours of dark and get 12'); hold on; 
               %plot raw data for each fish
               plot(one(k).timcont3, one(k).fft3, '.');
               %plot spline for each fish
               plot(one(k).xx3, one(k).fftyy3, 'LineWidth', 3);
               %add light transistion times as vertical lines
               clear j;
               for j = 1:length(one(k).lighttimes3)
                   
                   plot([one(k).lighttimes3(j), one(k).lighttimes3(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
               end
                
   end


linkaxes(ax, 'x');

figure(32); clf; hold on;
    plot(one(1).xx3(1:end-1), diff(mmean3/3), 'k-','LineWidth', 5);
    %plot light transitions
    for j = 1:length(one(1).lighttimes3)
        plot([one(1).lighttimes3(j), one(1).lighttimes3(j)], ylim, 'k-');
      
    end


%% 4th transition

clear ax;

%spline tranistion summary plot
figure(33); clf; title('expecting 4 hours of light and get 12'); hold on;

mmean4 = zeros(1, length(one(1).fftyy4));
%plot all splines on top of eachother
    for k = 1:length(one)
    plot(one(k).xx4, (one(k).fftyy4 - mean(one(k).fftyy4))/max(abs((one(k).fftyy4 - mean(one(k).fftyy4)))), 'LineWidth', 2);
     mmean4 = mmean4 + (one(k).fftyy4 - mean(one(k).fftyy4))/max(abs((one(k).fftyy4 - mean(one(k).fftyy4))));
    end
    plot(one(1).xx4, mmean4/3, 'k-','LineWidth', 5);
%plot light transitions
    for j = 1:length(one(1).lighttimes4)
        plot([one(1).lighttimes4(j), one(1).lighttimes4(j)], ylim, 'k-');
      
    end

%individual splines plus raw data    
figure(34); clf; hold on;

   for k = 1:length(one)
        
       ax(k) = subplot(3,1,k); title('expecting 4 hours of light and get 12'); hold on; 
               %plot raw data for each fish
               plot(one(k).timcont4, one(k).fft4, '.');
               %plot spline for each fish
               plot(one(k).xx4, one(k).fftyy4, 'LineWidth', 3);
               %add light transistion times as vertical lines
               clear j;
               for j = 1:length(one(k).lighttimes4)
                   
                   plot([one(k).lighttimes4(j), one(k).lighttimes4(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
               end
                
   end


linkaxes(ax, 'x');

figure(35); clf; hold on;

    plot(one(1).xx4(1:end-1), diff(mmean4/3), 'k-','LineWidth', 5);
    %plot light transitions
    for j = 1:length(one(1).lighttimes4)
        plot([one(1).lighttimes4(j), one(1).lighttimes4(j)], ylim, 'k-');
      
    end
