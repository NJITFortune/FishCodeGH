%function k_phaseplotter(in)

light = 3;
channel = 1;
ReFs = 10;

%% kg data index
 onefish124idx = [64 65 66 67 68 69 70 71 72 74];
 
 %get the spline estimates for each sample
    for k = 1:length(onefish124idx)

    %[one(k).xx, one(k).fftyy, one(k).lighttimes] =  k_fftsubspliner(kg(onefish124idx(k)), channel, ReFs, light);
    [one(k).xx, one(k).fftyy, ~] =  k_fftsubspliner(kg(onefish124idx(k)), channel, ReFs, light);

    one(k).lighttimes = abs(kg(onefish124idx(k)).info.luz);
    one(k).timcont = [kg(onefish124idx(k)).e(1).s.timcont]/3600;
    one(k).fft = [kg(onefish124idx(k)).e(1).s.sumfftAmp];

    end
%% kg data exp2

 exp2idx = [68 69 70 71];
 
 %get the spline estimates for each sample
 clear k;
    for k = 1:length(exp2idx)

    %[one(k).xx, one(k).fftyy, one(k).lighttimes] =  k_fftsubspliner(kg(onefish124idx(k)), channel, ReFs, light);
    [dos(k).xx, dos(k).fftyy, ~] =  k_fftsubspliner(kg(exp2idx(k)), channel, ReFs, light);

    dos(k).lighttimes = abs(kg(exp2idx(k)).info.luz);
    dos(k).timcont = [kg(exp2idx(k)).e(1).s.timcont]/3600;
    dos(k).fft = [kg(exp2idx(k)).e(1).s.sumfftAmp];

    end

%% kg2 data index
 multifish124idx = [16 18 19];
 
    for kk = 1:length(multifish124idx)
        
      [two(kk).hixx, two(kk).loxx, two(kk).HiAmp, two(kk).HiTim, two(kk).LoAmp, two(kk).LoTim, two(kk).Hifftyy, ~,  two(kk).Lofftyy, ~, two(kk).Hilighttimes, two(kk).Lolighttimes] =  k_multifftsubspliner(kg2(multifish124idx(kk)), ReFs, light);
      
    end
    
 
%% plots
%all together
figure(42); clf; title('phase plots by fish'); hold on;
    for k = 1:length(one)
        
       ax(k) = subplot(16,1,k); title(num2str(onefish124idx(k))); hold on;
               %plot raw data for each fish
               plot(one(k).timcont, one(k).fft, '.');
               %plot spline for each fish
               plot(one(k).xx, one(k).fftyy, 'LineWidth', 2);
               %add light transistion times as vertical lines
               clear j;
               for j = 1:length(one(k).lighttimes)
                   
                   plot([one(k).lighttimes(j), one(k).lighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
               end
                
    end
    
    
    for kk = 1:length(two)

    
        
        ax(k +kk) = subplot(16,1,(k +kk)); hold on;

                    plot(two(kk).HiTim, two(kk).HiAmp, '.');
                    plot(two(kk).hixx, two(kk).Hifftyy,  'LineWidth', 2);
                    clear j;
                    for j = 1:length(two(kk).Hilighttimes)

                        plot([two(kk).Hilighttimes(j), two(kk).Hilighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
                    end

        
    end
    
    for kkk = 1:length(two)
        
        a = (k + kk + kkk);
        
        ax(k+ kk + kkk) = subplot(16,1,a); hold on;

                        plot(two(kk).LoTim, two(kk).LoAmp, '.');
                        plot(two(kkk).loxx, two(kkk).Lofftyy, 'LineWidth', 2);
                        
                        clear j;
                        for j = 1:length(two(kkk).Lolighttimes)
                            
                            plot([two(kkk).Lolighttimes(j), two(kkk).Lolighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
                            
                        end
                    
    end
%     
 
linkaxes(ax, 'x');

%% by experiment

%by experiment
%exp 1
%colors
%single fish
turq = [64/255, 224/255, 208/255];
darkcy = [0/255, 139/255 139/255];
%multi fish
lightsky = [135/255 206/255 235/255];
deepsky = [0/255 191/255 255/255];
%colors
%single fish
lightsalmon = [255/255 160/255 122/255];
salmon = [250/255 128/255 114/255];
%multi fish
paleV = [219/255 112/255 147/255];
mediumV = [199/255 21/255 133/255];


figure(43); clf; title('phase plots by fish'); hold on;
clear k;
clear ax;
    for k = 1:4
        
       ax(k) = subplot(6,1,k); title(num2str(onefish124idx(k)));hold on; 
               %plot raw data for each fish
               plot(one(k).timcont, one(k).fft, '.', 'Color', turq);
               %plot spline for each fish
               plot(one(k).xx, one(k).fftyy, 'LineWidth', 2, 'Color', mediumV);
               %add light transistion times as vertical lines
               clear j;
               for j = 1:length(one(k).lighttimes)
                   
                   plot([one(k).lighttimes(j), one(k).lighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
               end
                
    end
clear kk;    
    for kk = 1:1

    
        
        ax(k +kk) = subplot(6,1,(k +kk)); title(num2str(multifish124idx(kk))); hold on;

                    plot(two(kk).HiTim, two(kk).HiAmp, '.', 'Color', lightsky);
                    plot(two(kk).hixx, two(kk).Hifftyy,  'LineWidth', 2, 'Color', mediumV);
                    clear j;
                    for j = 1:length(two(kk).Hilighttimes)

                        plot([two(kk).Hilighttimes(j), two(kk).Hilighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
                    end

        
    end
    clear kkk;
    for kkk = 1:1
        
        a = (k + kk + kkk);
        
        ax(k+ kk + kkk) = subplot(6,1,a); hold on;

                        plot(two(kk).LoTim, two(kk).LoAmp, '.', 'Color', lightsky);
                        plot(two(kkk).loxx, two(kkk).Lofftyy, 'LineWidth', 2, 'Color', mediumV);
                        
                        clear j;
                        for j = 1:length(two(kkk).Lolighttimes)
                            
                            plot([two(kkk).Lolighttimes(j), two(kkk).Lolighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
                            
                        end
                    
    end
%     
 
linkaxes(ax, 'x');







                    
                    
                    
%exp 2
%colors
%single fish
lightsalmon = [255/255 160/255 122/255];
salmon = [250/255 128/255 114/255];
%multi fish
paleV = [219/255 112/255 147/255];
mediumV = [199/255 21/255 133/255];

figure(44); clf; title('phase plots by fish'); hold on;
clear k;
clear ax;
    for k = 1:length(dos)
        
       ax(k) = subplot(6,1,k);hold on; 
               %plot raw data for each fish
               plot(one(k).timcont, one(k).fft, '.', 'Color', lightsalmon);
               %plot spline for each fish
               plot(one(k).xx, one(k).fftyy, 'LineWidth', 2, 'Color', salmon);
               %add light transistion times as vertical lines
               clear j;
               for j = 1:length(one(k).lighttimes)
                   
                   plot([one(k).lighttimes(j), one(k).lighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
                   
               end
                
    end
clear kk;    
        kk = 18;

    
        
        ax(5) = subplot(6,1,5); hold on;

                    plot(two(kk).HiTim, two(kk).HiAmp, '.', 'Color', paleV);
                    plot(two(kk).hixx, two(kk).Hifftyy,  'LineWidth', 2, 'Color', mediumV);
                    clear j;
                    for j = 1:length(two(kk).Hilighttimes)

                        plot([two(kk).Hilighttimes(j), two(kk).Hilighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
                    end

        
 
    clear kkk;
     kkk = 18;
        
        
        
        ax(6) = subplot(6,1,6); hold on;

                        plot(two(kk).LoTim, two(kk).LoAmp, '.', 'Color', paleV);
                        plot(two(kkk).loxx, two(kkk).Lofftyy, 'LineWidth', 2, 'Color', mediumV);
                        
                        clear j;
                        for j = 1:length(two(kkk).Lolighttimes)
                            
                            plot([two(kkk).Lolighttimes(j), two(kkk).Lolighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
                            
                        end
                    
    
 
linkaxes(ax, 'x');
                                       
                    
                    
                    
                    

