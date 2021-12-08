clearvars -except kg kg2 cc
%% single fish test case
in = kg(64);
channel = 1; 
ReFs = 10;
light = 3;

[xx, fftyy, lighttimes] =  k_fftsubspliner(in, channel, ReFs, light);




twidx1 = find(xx >= lighttimes(3) & xx <= (lighttimes(3) + 48));
twlightidx = find(lighttimes >= lighttimes(3) & lighttimes <= (lighttimes(3) + 48));
    


figure(23); clf; hold on;
plot(xx(twidx1), fftyy(twidx1));
lesslight = lighttimes(twlightidx);
for k = 1:length(lesslight)
    plot([lesslight(k), lesslight(k)], ylim, 'k-');
    
end

%% run for real...
light = 3;
channel = 1;
ReFs = 10;

%% kg data index - single fish
 exp1idx = [64 66 67];
 
 %get the spline estimates for each sample
        for k = 1:length(exp1idx)
    
       
        %[one(k).xx, one(k).fftyy, one(k).lighttimes] =  k_fftsubspliner(kg(onefish124idx(k)), channel, ReFs, light);
        [one(k).xx, one(k).fftyy, one(k).lighttimes] =  k_fftsubspliner(kg(exp1idx(k)), channel, ReFs, light);
  
%need to save into something
        load("Users/eric/Documents/MATLAB/fouramp.mat");
        load("Users/eric/Documents/MATLAB/twelveamp.mat");
        %in 48 hour chunks... not actually that useful
            %length of kg(64) in hours is 328 = ~ 48 *7
        twelveamp = [dd dd dd dd dd dd dd];
        fouramp = [cc cc cc cc cc cc cc];

        fourtim = one(1).xx(1):0.1:one(1).xx(1)+((length(fouramp)-1)*0.1);
        twelvetim = one(1).xx(1):0.1:one(1).xx(1)+((length(twelveamp)-1)*0.1);
    

  %twelve hour to four hour transistions
     %first transistion idx - expecting 12 dark, get 4
        twidx1 = find(one(k).xx >= one(k).lighttimes(3) & one(k).xx <= (one(k).lighttimes(3) + 48));
        twlightidx1 = find(one(k).lighttimes >= one(k).lighttimes(3) & one(k).lighttimes <= (one(k).lighttimes(3) + 48));
       
        
        one(k).lighttimes1 = one(k).lighttimes(twlightidx1);
        one(k).xx1 = one(k).xx(twidx1);
        one(k).fftyy1 = one(k).fftyy(twidx1);
    
        fourtim1 = one(1).xx1(1):0.1:one(1).xx1(1)+((length(fouramp)-1)*0.1);
        twelvetim1 = one(1).xx1(1):0.1:one(1).xx1(1)+((length(twelveamp)-1)*0.1);
    
    
        %raw data for plotting/spline check
        one(k).timcont = [kg(exp1idx(k)).e(1).s.timcont]/3600;  
        timcontidx = find(one(k).timcont >= one(k).lighttimes(3) & one(k).timcont <= (one(k).lighttimes(3) + 48));
        one(k).timcont1 = one(k).timcont(timcontidx);
        one(k).fft = [kg(exp1idx(k)).e(1).s.sumfftAmp];
        one(k).fft1 = one(k).fft(timcontidx);
    
    
     %third transition - expecting 12 hours light, get 4
        twidx2 = find(one(k).xx >= 198 & one(k).xx <= (198 + 48));
        twlightidx2 = find(one(k).lighttimes >= 198 & one(k).lighttimes <= (198 + 48));
        timcontidx2 = find(one(k).timcont >= 198 & one(k).timcont <= (198 + 48));
        
        %spline
        one(k).lighttimes2 = one(k).lighttimes(twlightidx2);
        one(k).xx2 = one(k).xx(twidx2);
        one(k).fftyy2 = one(k).fftyy(twidx2);
        
    
        %raw data for plotting/spline check
        one(k).timcont2 = one(k).timcont(timcontidx2);
        one(k).fft2 = one(k).fft(timcontidx2);
    
   %four hour to twelve hour transitions 
     %second transition - 4 hours to 12 hours
        twidx3 = find(one(k).xx >= 113 & one(k).xx <= (114 + 48));
        twlightidx3 = find(one(k).lighttimes >= 113 & one(k).lighttimes <= (114 + 48));
        timcontidx3 = find(one(k).timcont >= 113 & one(k).timcont <= (114 + 48));
    
        %spline
        one(k).lighttimes3 = one(k).lighttimes(twlightidx3);
        one(k).xx3 = one(k).xx(twidx3);
        one(k).fftyy3 = one(k).fftyy(twidx3);
        
    
        %raw data for plotting/spline check
        one(k).timcont3 = one(k).timcont(timcontidx3);
        one(k).fft3 = one(k).fft(timcontidx3);
    
      %fourth transition - 4 hours to 12 hours
        twidx4 = find(one(k).xx >= 294 & one(k).xx <= (294 + 48));
        twlightidx4 = find(one(k).lighttimes >= 294 & one(k).lighttimes <= (294 + 48));
        timcontidx4 = find(one(k).timcont >= 294 & one(k).timcont <= (294 + 48));
    
        %spline
        one(k).lighttimes4 = one(k).lighttimes(twlightidx4);
        one(k).xx4 = one(k).xx(twidx4);
        one(k).fftyy4 = one(k).fftyy(twidx4);
        
    
        %raw data for plotting/spline check
        one(k).timcont4 = one(k).timcont(timcontidx4);
        one(k).fft4 = one(k).fft(timcontidx4);
    
        end

%% multifish data 
[hixx, loxx, HiAmp, HiTim, LoAmp, LoTim, Hifftyy, ~,  Lofftyy, ~, Hilighttimes, Lolighttimes] =  k_multifftsubspliner(kg2(16), ReFs, light);

%% plots - 
salmon = [250/255 128/255 114/255];
mediumV = [199/255 21/255 133/255];
deepsky = [0/255 191/255 255/255];


figure(4); clf; title("the whole enchilada..."); hold on;

    xa(1) = subplot(211); title("single fish"); hold on;

        %initialize variable to store amp sum to calculate mean
         allmean = zeros(1, length(one(1).fftyy));

         %plot all splines on top of eachother
            for k = 1:length(one)
            %normalized to eachother around 0 
            plot(one(k).xx, (one(k).fftyy - mean(one(k).fftyy))/max(abs((one(k).fftyy - mean(one(k).fftyy)))), 'LineWidth', 2);
            allmean = allmean + (one(k).fftyy - mean(one(k).fftyy))/max(abs((one(k).fftyy - mean(one(k).fftyy))));
            end

            %plot the mean
            plot(one(1).xx, allmean/3, 'k-','LineWidth', 5);

            %plot the averages for four and twelve hours - around 1
            plot(fourtim, fouramp, 'c-', 'LineWidth', 3);
            plot(twelvetim, twelveamp, '-', 'LineWidth', 3, 'Color', salmon);

        %plot light transitions
            for j = 1:length(one(1).lighttimes)
                plot([one(1).lighttimes(j), one(1).lighttimes(j)], ylim, 'k-');
              
            end

     xa(2) = subplot(212); title("multiple fish"); hold on;

            plot(hixx, (Hifftyy-mean(Hifftyy))/max(abs(Hifftyy- mean(Hifftyy))), 'LineWidth', 2, 'Color', mediumV);
            plot(loxx, (Lofftyy-mean(Lofftyy))/max(abs(Lofftyy- mean(Lofftyy))), 'LineWidth', 2, 'Color', deepsky);

            for j = 1:length(Hilighttimes)
                plot([Hilighttimes(j), Hilighttimes(j)], ylim, 'k-');
            end

            %plot the averages for four and twelve hours - around 1
            plot(fourtim, fouramp, 'c-', 'LineWidth', 3);
            plot(twelvetim, twelveamp, '-', 'LineWidth', 3, 'Color', salmon);


%% 1st transistion

%spline tranistion summary plot
figure(24); clf; title('expecting 12 dark, get 4'); hold on;

mmean = zeros(1, length(one(1).fftyy1));
%plot all splines on top of eachother
    for k = 1:length(one)
    plot(one(k).xx1, (one(k).fftyy1 - mean(one(k).fftyy1))/max(abs((one(k).fftyy1 - mean(one(k).fftyy1)))), 'LineWidth', 2);
    mmean = mmean + (one(k).fftyy1 - mean(one(k).fftyy1))/max(abs((one(k).fftyy1 - mean(one(k).fftyy1))));
    end

    plot(one(1).xx1, mmean/3, 'k-','LineWidth', 5);
    plot(fourtim, fouramp, 'c-', 'LineWidth', 5);
%plot light transitions
    for j = 1:length(one(1).lighttimes1)
        plot([one(1).lighttimes1(j), one(1).lighttimes1(j)], ylim, 'k-');
      
    end

 

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
