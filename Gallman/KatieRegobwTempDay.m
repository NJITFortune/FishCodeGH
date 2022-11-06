%function [hotday, coldday] = KatieRegobwTempDay(in, channel, ReFs, td)%multisingleRegobwDay
%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4
 heat = 8;
% 
% %for when i'm too lazy to function
clearvars -except xxkg hkg k xxkg2 hkg2 kg2
% % % 
in = xxkg(k);
ReFs = 20;
heat = 8;
channel = 1;
td = 7;

% light = 4; %start with light
% fish = 5; %lo freq

%heat
    %7 starts with cooling
    %8 starts with warming

%% crop data to temptimes
%define variables
temptims = sort([in.info.temptims]);
poweridx = [in.info.poweridx];
%prepare data variables

%outlier removal
 tto = [in.idx(channel).obwidx]; 
      
%raw data
    timcont = [in.e(channel).s(tto).timcont]; %time in seconds
    obw = [in.e(channel).s(tto).obwAmp]/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
    temp =  [in.e(channel).s(tto).temp];
    fishfreq =  [in.e(channel).s(tto).fftFreq];

%separate warming from cooling lines
%separate rise from fall    
  

%%

if isempty(poweridx) %if there are no values in poweridx []

    for j = 2:length(temptims)
    
    tempidx = find(timcont/3600 >= temptims(j-1) & timcont/3600 < temptims(j));

        if mean(temp(tempidx)) > mean(temp)
            tiz(j-1,:) = temptims(j-1);
            hotter(j-1,:) = temptims(j-1);
        else
            tiz(j-1,:) = -temptims(j-1);
            colder(j-1,:) = temptims(j-1);
        end

    end  

      if heat == 7 && tiz(1) > 0 %we want start with cooling and the experiment starts with warming
        temptims = temptims(2:end); %skip the first temptim so we start with cooling
        tiz = tiz(2:end); hotter = hotter(2:end);
      elseif heat == 8 && tiz(1) < 0 %we want start with warming and the experiment starts with cooling
        temptims = temptims(2:end); %skip the first temptim so we start with cooling
        tiz = tiz(2:end); colder = colder(2:end);
      end

else %we have poweridx values

    %take data from within power idx range
    temptimsidx = find(temptims > poweridx(1) & temptims < poweridx(2));
    temptims = temptims(temptimsidx);
    
       
            for j = 2:length(temptims)
            
            tempidx = find(timcont/3600 >= temptims(j-1) & timcont/3600 < temptims(j));
        
                if mean(temp(tempidx)) > mean(temp)
                    tiz(j-1,:) = temptims(j-1);
                    hotter(j-1,:) = temptims(j-1);
                else
                    tiz(j-1,:) = -temptims(j-1);
                    colder(j-1,:) = temptims(j-1);
                end
        
            end

  
      if heat == 7 && tiz(1) > 0 %we want start with cooling and the experiment starts with warming
        temptims = temptims(2:end); %skip the first temptim so we start with cooling
        tiz = tiz(2:end); hotter = hotter(2:end);
      elseif heat == 8 && tiz(1) < 0 %we want start with warming and the experiment starts with cooling
        temptims = temptims(2:end); %skip the first temptim so we start with cooling
        tiz = tiz(2:end);colder = colder(2:end);
      end

end

%make temptims an integer
    %convert to seconds because xx is in seconds
    temptims = floor(temptims)*3600;
%% calculate duration of tempdays
colder = [colder(colder>0)];
hotter = [hotter(hotter>0)];


    if timcont(1)/3600 > (temptims(1)/3600 -td/2)
        temptims = temptims(2:end);
        if tiz(1) > 0
            hotter = hotter(2:end);
        else
            colder = colder(2:end);
        end
    end



   

%% Define temp day length

 %day
    daylengthSECONDS = td * 3600;  
   
    % This is the number of data samples in a day
    howmanysamplesinaday = floor(daylengthSECONDS / ReFs);
    %how many days in total experiment
   

%% process data

% %Take top of dataset
%     %find peaks
%     [~,LOCS] = findpeaks(obw);
%     %find peaks of the peaks
%     [obwpeaks,cLOCS] = findpeaks(obw(LOCS));
%     peaktim = timcont(LOCS(cLOCS));
%     peakfreq = fishfreq(LOCS(cLOCS));
%     peaktemp = temp(LOCS(cLOCS));
%     
% %Regularize
%     %regularize data to ReFs interval
%     [regobwtim, regobwfreq, regtemp, regobwpeaks] = k_regularmetamucil(peaktim, obwpeaks, timcont, obw, peakfreq, peaktemp,ReFs, temptims);
    
%trimmed mean
 window = 5;
  fcn = @(x) trimmean(x,33);
  obwtrim = matlab.tall.movingWindow(fcn, window, obw');
  freqtrim = matlab.tall.movingWindow(fcn, window, fishfreq');
  temptrim = matlab.tall.movingWindow(fcn, window, temp');

    
    
%Regularize
    %regularize data to ReFs interval
    [regobwtim, regobwfreq, regtemp, regobwpeaks] = k_regularmetamucil(timcont, obwtrim', timcont, obw, freqtrim', temptrim', ReFs, temptims);

     %filter data
        %cut off frequency
         highWn = 0.005/(ReFs/2); % Original but perhaps too strong for 4 and 5 hour days
        %highWn = 0.001/(ReFs/2);

        %low pass removes spikey-ness
        lowWn = 0.05/(ReFs/2);
        [dd,cc] = butter(5, lowWn, 'low');
        datadata = filtfilt(dd,cc, double(regobwpeaks));
       

        %high pass removes feeding trend for high frequency experiments

        [bb,aa] = butter(5, highWn, 'high');
        datadata = filtfilt(bb,aa, datadata); %double vs single matrix?
        

    %trim everything to temptims


    %amp
    timidx = regobwtim >= temptims(1)-daylengthSECONDS & regobwtim <= temptims(end)+daylengthSECONDS;
    xx = regobwtim(timidx);
    %obwyy = regobwpeaks(timidx);  
     obwyy = datadata(timidx); 
    freq = regobwfreq(timidx);  
    newtemp = regtemp(timidx);
 


    rawidx = timcont >= temptims(1)-daylengthSECONDS/2 & timcont <= temptims(end)+daylengthSECONDS/2;
    timmy = timcont(rawidx);
    obwAmp = obw(rawidx);
    freqRaw = fishfreq(rawidx);

%     %plot
%     figure(2);clf; hold on;
%         plot(regtim, regobwminusmean, 'k-');
%         plot(regtim, filtdata, 'm');
%         plot(regtim, datadata, 'b');


%% Divide sample into half day transitions

% needs to be in seconds
%refstim = ReFs:ReFs:(shortest)*3600;

%hotter (colder to hotter tranistions)
hotter = hotter*3600;

    for j = 1:length(hotter)
        
                  %resampled data  
        %         % Get the index of the start time of the day
                    hdayidx = find(xx >= hotter(j) - (daylengthSECONDS/2) & xx <= hotter(j) +  (daylengthSECONDS/2));
                    if length(hdayidx) >= howmanysamplesinaday %important so that we know when to stop
    
                        hotday(j).obw = obwyy(hdayidx);
    
                        hotday(j).entiretimcont = xx(hdayidx);
    
                        hotday(j).freq = freq(hdayidx);

                        hotday(j).temp = newtemp(hdayidx);
                        
                        hotday(j).tim(:) = xx(hdayidx)-xx(hdayidx(1));
                        
                        hotday(j).amprange = max(obwyy(hdayidx));
                    
                        hotday(j).td = td;
                        
    
                    end
    end

%colder (hotter to colder tranistions)
colder = colder*3600;
for j = 1:length(colder)
    
              %resampled data  
    %         % Get the index of the start time of the day
                cdayidx = find(xx >= colder(j) - (daylengthSECONDS/2) & xx <= colder(j) +  (daylengthSECONDS/2));
                if length(cdayidx) >= howmanysamplesinaday %important so that we know when to stop

                    coldday(j).obw = obwyy(cdayidx);

                    coldday(j).entiretimcont = xx(cdayidx);

                    coldday(j).freq = freq(cdayidx);

                    coldday(j).temp = newtemp(cdayidx);
                    
                    coldday(j).tim(:) = xx(cdayidx)-xx(cdayidx(1));
                    
                    coldday(j).amprange = max(obwyy(cdayidx));
                
                    coldday(j).td = td;
                    

                end
end


%% plot to check
%time vectors currently in seconds, divide by 3600 to get hours

%fill colors for plotting
hot = [255/255, 204/255, 204/255];
cold = [204/255, 238/255, 255/255];

%days over experiment time
figure(795); clf; title('frequency over time');hold on;

    %get ylim
    plot(timmy/3600, freqRaw, '.');
    plot(xx/3600, freq);
    

    %draw boxes
     freqlim = ylim; %all of above is just to get the max for the plot lines...

        if  tiz(1) > 0 %we start with warming
            for j = 1:length(temptims)-1
                if mod(j,2) == 1 %if j is odd
            fill([temptims(j)/3600 temptims(j)/3600 temptims(j+1)/3600 temptims(j+1)/3600], [freqlim(1) freqlim(2) freqlim(2) freqlim(1)], hot);
                else
            fill([temptims(j)/3600 temptims(j)/3600 temptims(j+1)/3600 temptims(j+1)/3600], [freqlim(1) freqlim(2) freqlim(2) freqlim(1)], cold);
                end
            end
        else
            for j = 1:length(temptims)-1
                if mod(j,2) == 1 %if j is odd
            fill([temptims(j)/3600 temptims(j)/3600 temptims(j+1)/3600 temptims(j+1)/3600], [freqlim(1) freqlim(2) freqlim(2) freqlim(1)], cold);
                else
            fill([temptims(j)/3600 temptims(j)/3600 temptims(j+1)/3600 temptims(j+1)/3600], [freqlim(1) freqlim(2) freqlim(2) freqlim(1)], hot);
                end
            end
        end

        %actual plotting starts here

         plot(timmy/3600, freqRaw, '.');
         plot(xx/3600, freq);
  
         for j = 1:length(hotday)
          plot(hotday(j).entiretimcont/3600, hotday(j).freq, 'LineWidth',2);
         end

         for j = 1:length(coldday)
          plot(coldday(j).entiretimcont/3600, coldday(j).freq,'LineWidth',2);
         end
%%
  %days over experiment time
figure(796); clf; title('amplitude over time');hold on;

    plot(timmy/3600, obwAmp, '.');
    plot(xx/3600, obwyy);
    
   
     amplim = ylim; %all of above is just to get the max for the plot lines...

        if  tiz(1) > 0 %we start with warming
            for j = 1:length(temptims)-1
                if mod(j,2) == 1 %if j is odd
            fill([temptims(j)/3600 temptims(j)/3600 temptims(j+1)/3600 temptims(j+1)/3600], [amplim(1) amplim(2) amplim(2) amplim(1)], hot);
                else
            fill([temptims(j)/3600 temptims(j)/3600 temptims(j+1)/3600 temptims(j+1)/3600], [amplim(1) amplim(2) amplim(2) amplim(1)], cold);
                end
            end
        else
            for j = 1:length(temptims)-1
                if mod(j,2) == 1 %if j is odd
            fill([temptims(j)/3600 temptims(j)/3600 temptims(j+1)/3600 temptims(j+1)/3600], [amplim(1) amplim(2) amplim(2) amplim(1)], cold);
                else
            fill([temptims(j)/3600 temptims(j)/3600 temptims(j+1)/3600 temptims(j+1)/3600], [amplim(1) amplim(2) amplim(2) amplim(1)], hot);
                end
            end
        end
    
     %actual plotting of datums
     plot(timmy/3600, obwAmp, '.');
     plot(xx/3600, obwyy);
    for j = 1:length(hotday)
        plot(hotday(j).entiretimcont/3600, hotday(j).obw, 'LineWidth', 2);
    end     

    for j = 1:length(coldday)
        plot(coldday(j).entiretimcont/3600, coldday(j).obw, 'LineWidth', 2);
    end   
  

    %% temp day sum

figure(4566); clf ; hold on; title('hot to cold');ylim([-.4 .4]);
set(gcf, 'Renderer', 'painters');
    for j = 1:length(hotday)
      %  plot(hotday(j).tim/3600, hotday(j).obw, 'LineWidth', 1);
        hots(j,:) = hotday(j).obw;
    end  
    
%     a = ylim;
%     fill([0 0 td/2 td/2], [a(1) a(2) a(2) a(1)], hot);
%     fill([td/2 td/2 td td],[a(1) a(2) a(2) a(1)], cold );

    hotmean = mean(hots);

    for j = 1:length(hotday)
      %  plot(hotday(j).tim/3600, hotday(j).obw, 'LineWidth', 1);
    end  

    plot(hotday(1).tim/3600, hotmean, 'Color', hot,'LineWidth', 3 );
    xline(td/2, 'k', 'LineWidth', 3);
    ylabel('Mean square amplitude');
    xlabel('Time (hours)');
%% 
figure(4566); clf ; hold on; title('hot to cold freq');ylim([370 580]);
set(gcf, 'Renderer', 'painters');
    for j = 1:length(hotday)
      %  plot(hotday(j).tim/3600, hotday(j).obw, 'LineWidth', 1);
        hots(j,:) = hotday(j).freq;
    end  
    
%     a = ylim;
%     fill([0 0 td/2 td/2], [a(1) a(2) a(2) a(1)], hot);
%     fill([td/2 td/2 td td],[a(1) a(2) a(2) a(1)], cold );

    hotmean = mean(hots);

    for j = 1:length(hotday)
      %  plot(hotday(j).tim/3600, hotday(j).obw, 'LineWidth', 1);
    end  

    plot(hotday(1).tim/3600, hotmean, 'k-','LineWidth', 3 );
    xline(td/2, 'k', 'LineWidth', 3);
    ylabel('Frequency (Hz)');
    xlabel('Time (hours)');
%% 

figure(4567); clf ; hold on; title('hot to cold temp');ylim([25 31]);
set(gcf, 'Renderer', 'painters');
    for j = 1:length(hotday)
      %  plot(hotday(j).tim/3600, hotday(j).obw, 'LineWidth', 1);
        hots(j,:) = hotday(j).temp;
    end  
    
%     a = ylim;
%     fill([0 0 td/2 td/2], [a(1) a(2) a(2) a(1)], hot);
%     fill([td/2 td/2 td td],[a(1) a(2) a(2) a(1)], cold );

    hotmean = mean(hots);

    for j = 1:length(hotday)
      %  plot(hotday(j).tim/3600, hotday(j).obw, 'LineWidth', 1);
    end  
 tempC = k_temptocelcius(hotmean, 11000);

    plot(hotday(1).tim/3600, tempC, 'r-','LineWidth', 3 );
    xline(td/2, 'k', 'LineWidth', 3);
    ylabel('degrees Celcius');
    xlabel('Time (hours)');


%%

 figure(4567); clf ; hold on; title('cold to hot transitions'); ylim([-.4 .4]);%ylim([-0.08 .06]);
set(gcf, 'Renderer', 'painters');
    for j = 1:length(coldday)
       % plot(coldday(j).tim/3600, coldday(j).obw, 'LineWidth', 1);
        colds(j,:) = coldday(j).obw;
    end  
%     
%     a = ylim;
%     fill([0 0 td/2 td/2], [a(1) a(2) a(2) a(1)], cold);
%     fill([td/2 td/2 td td],[a(1) a(2) a(2) a(1)], hot );

    coldmean = mean(colds);

%     for j = 1:length(hotday)
%         plot(coldday(j).tim/3600, coldday(j).obw, 'LineWidth', 1);
%     end  

    plot(coldday(1).tim/3600, coldmean, 'Color', cold,'LineWidth', 3 );

 xline(td/2, 'k', 'LineWidth', 3);

 ylabel('Mean square amplitude');
    xlabel('Time (hours)');

%%

 figure(4567); clf ; hold on; title('cold to hot freq'); ylim([420 520]) %ylim([-.4 .4]);%ylim([-0.08 .06]);
set(gcf, 'Renderer', 'painters');
    for j = 1:length(coldday)
       % plot(coldday(j).tim/3600, coldday(j).obw, 'LineWidth', 1);
        colds(j,:) = coldday(j).freq;
    end  
%     
%     a = ylim;
%     fill([0 0 td/2 td/2], [a(1) a(2) a(2) a(1)], cold);
%     fill([td/2 td/2 td td],[a(1) a(2) a(2) a(1)], hot );

    coldmean = mean(colds);

%     for j = 1:length(hotday)
%         plot(coldday(j).tim/3600, coldday(j).obw, 'LineWidth', 1);
%     end  

    plot(coldday(1).tim/3600, coldmean, 'k-','LineWidth', 3 );

 xline(td/2, 'k', 'LineWidth', 3);

 ylabel('Frequency (Hz)');
    xlabel('Time (hours)');
