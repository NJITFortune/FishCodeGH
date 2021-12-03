%function k_phaseplotter(in)

light = 3;
channel = 1;
ReFs = 10;

%% kg data index
 onefish124idx = [64 65 66 67 68 69 70 71];
 
 %get the spline estimates for each sample
    for k = 1:length(onefish124idx)

    %[one(k).xx, one(k).fftyy, one(k).lighttimes] =  k_fftsubspliner(kg(onefish124idx(k)), channel, ReFs, light);
    [one(k).xx, one(k).fftyy, ~] =  k_fftsubspliner(kg(onefish124idx(k)), channel, ReFs, light);

    one(k).lighttimes = abs(kg(onefish124idx(k)).info.luz);
    one(k).timcont = [kg(onefish124idx(k)).e(1).s.timcont]/3600;
    one(k).fft = [kg(onefish124idx(k)).e(1).s.sumfftAmp];

    end

%% kg2 data index
 multifish124idx = [16 18];
 
    for kk = 1:length(multifish124idx)
        
      [two(kk).hixx, two(kk).loxx, two(kk).HiAmp, two(kk).HiTim, two(kk).LoAmp, two(kk).LoTim, two(kk).Hifftyy, ~,  two(kk).Lofftyy, ~, two(kk).Hilighttimes, two(kk).Lolighttimes] =  k_multifftsubspliner(kg2(multifish124idx(kk)), ReFs, light);
      
    end
    
 
%% plots
%all together
figure(42); clf; title('phase plots by fish'); hold on;

    for k = 1:length(one)
        
       ax(k) = subplot(12,1,k);hold on; 
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

    
        
        ax(k +kk) = subplot(12,1,(k +kk)); hold on;

                    plot(two(kk).HiTim, two(kk).HiAmp, '.');
                    plot(two(kk).hixx, two(kk).Hifftyy,  'LineWidth', 2);
                    clear j;
                    for j = 1:length(two(kk).Hilighttimes)

                        plot([two(kk).Hilighttimes(j), two(kk).Hilighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
                    end

        
    end
    
    for kkk = 1:length(two)
        
        a = (k + kk + kkk);
        
        ax(k+ kk + kkk) = subplot(12,1,a); hold on;

                        plot(two(kk).LoTim, two(kk).LoAmp, '.');
                        plot(two(kkk).loxx, two(kkk).Lofftyy, 'LineWidth', 2);
                        
                        clear j;
                        for j = 1:length(two(kkk).Lolighttimes)
                            
                            plot([two(kkk).Lolighttimes(j), two(kkk).Lolighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
                            
                        end
                    
    end
%     
 
linkaxes(ax, 'x');


%by experiment
%exp 1
figure(43); clf; title('phase plots by fish'); hold on;
clear k;
clear ax;
    for k = 1:4
        
       ax(k) = subplot(6,1,k);hold on; 
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
clear kk;    
    for kk = 1:1

    
        
        ax(k +kk) = subplot(6,1,(k +kk)); hold on;

                    plot(two(kk).HiTim, two(kk).HiAmp, '.');
                    plot(two(kk).hixx, two(kk).Hifftyy,  'LineWidth', 2);
                    clear j;
                    for j = 1:length(two(kk).Hilighttimes)

                        plot([two(kk).Hilighttimes(j), two(kk).Hilighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
                    end

        
    end
    clear kkk;
    for kkk = 1:1
        
        a = (k + kk + kkk);
        
        ax(k+ kk + kkk) = subplot(6,1,a); hold on;

                        plot(two(kk).LoTim, two(kk).LoAmp, '.');
                        plot(two(kkk).loxx, two(kkk).Lofftyy, 'LineWidth', 2);
                        
                        clear j;
                        for j = 1:length(two(kkk).Lolighttimes)
                            
                            plot([two(kkk).Lolighttimes(j), two(kkk).Lolighttimes(j)], ylim, 'k-', 'LineWidth', 0.5);
                            
                        end
                    
    end
%     
 
linkaxes(ax, 'x');
                    
                    
                    
                    
                    
                    
                    
                    

