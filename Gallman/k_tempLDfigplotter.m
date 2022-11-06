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
lightstart = 3;

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

if channel < 3 %single fish
    %outlier removal
     tto = [in.idx(channel).obwidx]; 
      
    %raw data
    timcont = [in.e(channel).s(tto).timcont]; %time in seconds
    obw = [in.e(channel).s(tto).obwAmp];%/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
    oldfreq = [in.e(channel).s(tto).fftFreq];
    oldtemp = [in.e(channel).s(tto).temp];


else %multifish

    %outlier removal
     tto = [in.idx.obwidx]; 
      
    %raw data
    timcont = [in.s(tto).timcont]; %time in seconds
    obw = [in.s(tto).obwAmp];%/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
    oldfreq = [in.s(tto).freq];
    oldtemp = [in.s(tto).temp];

end

lighttimes = k_lighttimes(in, lightstart);
  

%%

if isempty(poweridx) %if there are no values in poweridx []

    for j = 2:length(temptims)
    
    tempidx = find(timcont/3600 >= temptims(j-1) & timcont/3600 < temptims(j));

        if mean(oldtemp(tempidx)) > mean(oldtemp)
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
        
                if mean(oldtemp(tempidx)) > mean(oldtemp)
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
  freqtrim = matlab.tall.movingWindow(fcn, window, oldfreq');
  temptrim = matlab.tall.movingWindow(fcn, window, oldtemp');

    
    
%Regularize
    %regularize data to ReFs interval
    [regobwtim, regobwfreq, regtemp, regobwpeaks] = k_regularmetamucil(timcont, obwtrim', timcont, obw, freqtrim', temptrim', ReFs, temptims);

     %filter data
        %cut off frequency
         highWn = 0.005/(ReFs/2); % Original but perhaps too strong for 4 and 5 hour days
        %highWn = 0.001/(ReFs/2);

        %low pass removes spikey-ness
        lowWn = 0.025/(ReFs/2);
        [dd,cc] = butter(5, lowWn, 'low');
        datadata = filtfilt(dd,cc, double(regobwpeaks));
       

        %high pass removes feeding trend for high frequency experiments

        [bb,aa] = butter(5, highWn, 'high');
        datadata = filtfilt(bb,aa, datadata); %double vs single matrix?
        lightdata = filtfilt(dd,cc, double(regobwpeaks));%lowpassonly
        
 %trim everything to temptims


    %amp
    timidx = regobwtim >= temptims(1)-daylengthSECONDS & regobwtim <= temptims(end)+daylengthSECONDS;
    tempxx = regobwtim(timidx);
    %obwyy = regobwpeaks(timidx);  
    tempobwyy = datadata(timidx); 
    tempfreq = regobwfreq(timidx);  
    temptemp = regtemp(timidx);
 


    rawidx = timcont >= temptims(1)-daylengthSECONDS/2 & timcont <= temptims(end)+daylengthSECONDS/2;
    temptimmy = timcont(rawidx);
    tempobwAmp = obw(rawidx);
    tempfreqRaw = oldfreq(rawidx);

%trim everything to lighttimes
    timidx = regobwtim >= lighttimes(1) & regobwtim <= lighttimes(end);
    lightxx = regobwtim(timidx);
   % obwyy = regobwpeaks(timidx);
    lightobwyy = lightdata(timidx); 
  
    lightfreq = regobwfreq(timidx);
    lighttemp = regtemp(timidx);


    rawidx = timcont >= lighttimes(1) & timcont <= lighttimes(end);
    lighttimmy = timcont(rawidx);
    lightobwAmp = obw(rawidx);
    lightrawfreq = oldfreq(rawidx);
    rawtemp = oldtemp(rawidx);


%% Divide sample into half day temp transitions

% needs to be in seconds
%refstim = ReFs:ReFs:(shortest)*3600;

%hotter (colder to hotter tranistions)
hotter = hotter*3600;

    for j = 1:length(hotter)
        
                  %resampled data  
        %         % Get the index of the start time of the day
                    hdayidx = find(tempxx >= hotter(j) - (daylengthSECONDS/2) & tempxx <= hotter(j) +  (daylengthSECONDS/2));
                    if length(hdayidx) >= howmanysamplesinaday %important so that we know when to stop
    
                        hotday(j).obw = tempobwyy(hdayidx);
    
                        hotday(j).entiretimcont = tempxx(hdayidx);
    
                        hotday(j).freq = tempfreq(hdayidx);

                        hotday(j).temp = temptemp(hdayidx);
                        
                        hotday(j).tim(:) = tempxx(hdayidx)-tempxx(hdayidx(1));
                        
                        hotday(j).amprange = max(tempobwyy(hdayidx));
                    
                        hotday(j).td = td;
                        
    
                    end
    end

%colder (hotter to colder tranistions)
colder = colder*3600;
for j = 1:length(colder)
    
              %resampled data  
    %         % Get the index of the start time of the day
                cdayidx = find(tempxx >= colder(j) - (daylengthSECONDS/2) & tempxx <= colder(j) +  (daylengthSECONDS/2));
                if length(cdayidx) >= howmanysamplesinaday %important so that we know when to stop

                    coldday(j).obw = tempobwyy(cdayidx);

                    coldday(j).entiretimcont = tempxx(cdayidx);

                    coldday(j).freq = tempfreq(cdayidx);

                    coldday(j).temp = temptemp(cdayidx);
                    
                    coldday(j).tim(:) = tempxx(cdayidx)-tempxx(cdayidx(1));
                    
                    coldday(j).amprange = max(tempobwyy(cdayidx));
                
                    coldday(j).td = td;
                    

                end
end

ld = floor(lighttimes(2)/3600 -lighttimes(1)/3600);

%% divide into days
 %define day length
    daylengthSECONDS = (ld*2) * 3600;  
    lengthofsampleHOURS = (lighttimes(end) - lighttimes(1)) / 3600; 
    % This is the number of data samples in a day
    howmanysamplesinaday = floor(daylengthSECONDS / ReFs);
    %how many days in total experiment
    howmanydaysinsample = (floor(lengthofsampleHOURS / (ld*2)));


%Divide sample into days based on light
% needs to be in seconds
tim = ReFs:ReFs:(ld*2)*3600;

for j = 1:howmanydaysinsample
    
              %resampled data  
    %         % Get the index of the start time of the day
                ddayidx = find(lightxx >= lightxx(1) + (j-1) * daylengthSECONDS & lightxx < lightxx(1) + j* daylengthSECONDS); % k-1 so that we start at zero

                if length(ddayidx) >= howmanysamplesinaday %important so that we know when to stop

                    %amplitude data
                    day(j).Sobwyy = lightobwyy(ddayidx);
                    %frequency data
                    day(j).freq = lightfreq(ddayidx);
                    %temperature data
                    day(j).temp = lighttemp(ddayidx);
                    %new time base from 0 the length of day by ReFS
                    day(j).tim = tim;
                    %old time base divided by day for plotting chronologically
                    day(j).entiretimcont = lightxx(ddayidx);
                    %not sure why we need how long the day is in hours...
                    day(j).ld = in.info.ld;
                    %max amp of each day
                    day(j).amprange = max(lightobwyy(ddayidx));
                    day(j).ampmin = min(lightobwyy(ddayidx));
                    
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
    plot(temptimmy/3600, tempfreqRaw, '.');
    plot(tempxx/3600, tempfreq);
    

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

         plot(temptimmy/3600, tempfreqRaw, '.');
         plot(tempxx/3600, tempfreq);
  
         for j = 1:length(hotday)
          plot(hotday(j).entiretimcont/3600, hotday(j).freq, 'LineWidth',2);
         end

         for j = 1:length(coldday)
          plot(coldday(j).entiretimcont/3600, coldday(j).freq,'LineWidth',2);
         end
%%
  %days over experiment time
figure(796); clf; title('amplitude over time');hold on;

    plot(temptimmy/3600, tempobwAmp, '.');
    plot(tempxx/3600, tempobwyy);
    
   
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
     plot(temptimmy/3600, tempobwAmp, '.');
     plot(tempxx/3600, tempobwyy);
    for j = 1:length(hotday)
        plot(hotday(j).entiretimcont/3600, hotday(j).obw, 'LineWidth', 2);
    end     

    for j = 1:length(coldday)
        plot(coldday(j).entiretimcont/3600, coldday(j).obw, 'LineWidth', 2);
    end   

%%    
figure(55); clf; hold on;

    xa(1) = subplot(311); hold on;
    
            %  plot(timmy/3600, obwAmp, '.');
            plot(lighttimmy/3600, lightobwAmp, '.');
            for j = 1:length(day)
                plot(day(j).entiretimcont/3600, day(j).Sobwyy);
            end
            
            
            % plot([lighttimes'/3600 lighttimes'/3600], ylim, 'k-');
            
            a = ylim; %all of above is just to get the max for the plot lines...
            if lightstart < 4 %the first lighttime is dark
                for j = 1:length(lighttimes)-1
                    if mod(j,2) == 1 %if j is odd
                        fill([lighttimes(j)/3600 lighttimes(j)/3600 lighttimes(j+1)/3600 lighttimes(j+1)/3600], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
                    end
                end
            else %the second lighttime is dark
                for j = 1:length(lighttimes)-1
                    if mod(j,2) == 0 %if j is even
                        fill([lighttimes(j)/3600 lighttimes(j)/3600 lighttimes(j+1)/3600 lighttimes(j+1)/3600], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
                    end
                end
            end

             plot(lighttimmy/3600, lightobwAmp, '.');
            for j = 1:length(day)
                plot(day(j).entiretimcont/3600, day(j).Sobwyy, 'LineWidth', 1.5);
            end
            
           
    xa(2) = subplot(312); hold on;
    
            plot(tempxx/3600, tempobwyy);
            
            
            % plot([lighttimes'/3600 lighttimes'/3600], ylim, 'k-');
            
            a = ylim; %all of above is just to get the max for the plot lines...
            if lightstart < 4 %the first lighttime is dark
                for j = 1:length(lighttimes)-1
                    if mod(j,2) == 1 %if j is odd
                        fill([lighttimes(j)/3600 lighttimes(j)/3600 lighttimes(j+1)/3600 lighttimes(j+1)/3600], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
                    end
                end
            else %the second lighttime is dark
                for j = 1:length(lighttimes)-1
                    if mod(j,2) == 0 %if j is even
                        fill([lighttimes(j)/3600 lighttimes(j)/3600 lighttimes(j+1)/3600 lighttimes(j+1)/3600], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
                    end
                end
            end

             plot(tempxx/3600, tempobwyy);
                for j = 1:length(hotday)
                    plot(hotday(j).entiretimcont/3600, hotday(j).obw, 'LineWidth', 2);
                end     
            
                for j = 1:length(coldday)
                    plot(coldday(j).entiretimcont/3600, coldday(j).obw, 'LineWidth', 2);
                end   
            


    xa(3) = subplot(313); hold on;

        hot = [255/255, 204/255, 204/255];
        cold = [204/255, 238/255, 255/255];


            plot(tempxx/3600, tempobwyy);
            
            % plot([lighttimes'/3600 lighttimes'/3600], ylim, 'k-');
            
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

        plot(tempxx/3600, tempobwyy);
                for j = 1:length(hotday)
                    plot(hotday(j).entiretimcont/3600, hotday(j).obw, 'LineWidth', 2);
                end     
            
                for j = 1:length(coldday)
                    plot(coldday(j).entiretimcont/3600, coldday(j).obw, 'LineWidth', 2);
                end   
            
           
            
          
linkaxes(xa, 'x');           


%% temp day sum

figure(4566); clf ; hold on;

    for j = 1:length(hotday)
        plot(hotday(j).tim/3600, hotday(j).obw, 'LineWidth', 1);
        hots(j,:) = hotday(j).obw;
    end  
    
    a = ylim;
    fill([0 0 td/2 td/2], [a(1) a(2) a(2) a(1)], hot);
    fill([td/2 td/2 td td],[a(1) a(2) a(2) a(1)], cold );

    hotmean = mean(hots);

    for j = 1:length(hotday)
        plot(hotday(j).tim/3600, hotday(j).obw, 'LineWidth', 1);
    end  

    plot(hotday(1).tim/3600, hotmean, 'k-','LineWidth', 2 );


%%

 figure(4567); clf ; hold on;

    for j = 1:length(coldday)
        plot(coldday(j).tim/3600, coldday(j).obw, 'LineWidth', 1);
        colds(j,:) = coldday(j).obw;
    end  
    
    a = ylim;
    fill([0 0 td/2 td/2], [a(1) a(2) a(2) a(1)], cold);
    fill([td/2 td/2 td td],[a(1) a(2) a(2) a(1)], hot );

    coldmean = mean(colds);

    for j = 1:length(hotday)
        plot(coldday(j).tim/3600, coldday(j).obw, 'LineWidth', 1);
    end  

    plot(coldday(1).tim/3600, coldmean, 'k-','LineWidth', 2 );
   

%%

figure(57); clf; hold on; 

 
        for j = 1:length(day)
                    plot(day(j).tim/3600, day(j).Sobwyy);
                    meanday(j,:) = day(j).Sobwyy;
        end
        a = ylim;
    %create fill box 
    if lightstart < 4 %we start with dark
        fill([0 0 ld ld], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
    else %we start with light
        fill([ld ld ld*2 ld*2], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
    end
    
        
     for j = 1:length(day)
            plot(day(j).tim/3600, day(j).Sobwyy);
            meanday(j,:) = day(j).Sobwyy;
     end
        
            mmday= mean(meanday);
            %othermday = mday/(length(day));
            plot(day(1).tim/3600, mmday, 'k-', 'LineWidth', 3);
           
            %plot(day(1).tim/3600, othermday, 'b-', 'LineWidth', 3);
            plot([ld ld], ylim, 'k-', 'LineWidth', 3);
