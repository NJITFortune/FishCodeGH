clearvars -except kg kg2
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

%% multiple fish
light = 3;
channel = 1;
ReFs = 10;

%% kg data index
 exp1idx = [64 66 67];
 
 %get the spline estimates for each sample
    for k = 1:length(exp1idx)

   
    %[one(k).xx, one(k).fftyy, one(k).lighttimes] =  k_fftsubspliner(kg(onefish124idx(k)), channel, ReFs, light);
    [one(k).xx, one(k).fftyy, one(k).lighttimes] =  k_fftsubspliner(kg(exp1idx(k)), channel, ReFs, light);

    %first transistion idx - expecting 12 dark, get 4
    twidx1 = find(one(k).xx >= one(k).lighttimes(3) & one(k).xx <= (one(k).lighttimes(3) + 48));
    twlightidx1 = find(one(k).lighttimes >= one(k).lighttimes(3) & one(k).lighttimes <= (one(k).lighttimes(3) + 48));
   
    

    one(k).lighttimes1 = one(k).lighttimes(twlightidx1);
    one(k).xx1 = one(k).xx(twidx1);
    one(k).fftyy1 = one(k).fftyy(twidx1);

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


    end


 

%% plots - 1st transistion

%spline tranistion summary plot
figure(24); clf; title('expecting 12 dark, get 4'); hold on;

%plot all splines on top of eachother
    for k = 1:length(one)
    plot(one(k).xx1, one(k).fftyy1, 'LineWidth', 3);
    end
%plot light transitions
    for j = 1:length(one(1).lighttimes1)
        plot([one(1).lighttimes1(j), one(1).lighttimes1(j)], ylim, 'k-');
      
    end

%individual splines plus raw data    
figure(25); clf; hold on;

   for k = 1:length(one)
        
       ax(k) = subplot(3,1,k);hold on; 
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


%% 3rd transistion

%spline tranistion summary plot
figure(28); clf; title('expecting 12 light get 4'); hold on;

%plot all splines on top of eachother
    for k = 1:length(one)
    plot(one(k).xx2, one(k).fftyy2, 'LineWidth', 3);
    end
%plot light transitions
    for j = 1:length(one(1).lighttimes2)
        plot([one(1).lighttimes2(j), one(1).lighttimes2(j)], ylim, 'k-');
      
    end

%individual splines plus raw data    
figure(29); clf; hold on;

   for k = 1:length(one)
        
       ax(k) = subplot(3,1,k);hold on; 
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
   
