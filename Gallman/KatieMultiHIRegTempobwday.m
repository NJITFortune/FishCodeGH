%function [day] = KatieMultiHIRegobwDayDessembler(in, channel,  ReFs, light)
%% usage
%[day] = KatieRegobwDayDessembler(kg(#), channel, ReFs)
%
%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4


% % %for when i'm too lazy to function
 clearvars -except kg kg2 rkg k hkg2 hkg
% % 
in = kg2(k);
ReFs = 20;
light = 3; %start with dark
fish = 6; %hi freq
heat = 8; %starts with warming
td = 12;

% light = 4; %start with light
% fish = 5; %lo freq
%% prep

% redefine length of light cycle
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld

temptims = sort([in.info.temptims]);

if fish == 6 %high freq

%outlier removal indicies
    % All the data (set because we may want to plot before running KatieRemover and/or KatieLabeler)
        %obw
        ttohi = 1:length(in.hifish); % tthi is indices for HiAmp
%         %peak amp
%         ttkhi = 1:length(out.hifish);
      
    % If we have removed outliers via KatieRemover, get the indices... 
        %high frequency fish indicies
            if isfield(in, 'hiidx')
                if ~isempty(in.hiidx)
                    ttohi = [in.hiidx.obwidx]; 
                 %   ttkhi = [in.hiidx.pkidx];
                end
            end


%poweridx
    poweridx = [in.info.Hipoweridx];
    

%raw data
    timcont = [in.hifish(ttohi).timcont];
    obw = [in.hifish(ttohi).obwAmp];
    oldfreq = [in.hifish(ttohi).freq];
    temp = [in.s(ttohi).temp];


end

if fish == 5 %low freq

%outlier removal indicies
    ttolo = 1:length(in.lofish); % ttlo is indices for LoAmp
    ttklo = 1:length(in.lofish);
    %low frequency fish indicies
        if isfield(in, 'loidx')
            if ~isempty(in.loidx)
                ttolo = [in.loidx.obwidx]; 
%                ttklo = [in.loidx.pkidx];
            end
        end

%poweridx        
    poweridx = [in.info.Lopoweridx];
 
%raw data
    timcont = [in.lofish(ttolo).timcont];
    obw = [in.lofish(ttolo).obwAmp];
    oldfreq = [in.lofish(ttolo).freq];
      temp = [in.s(ttolo).temp];
    
 
end



%% crop data to temptims
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
%% duration of temp day
colder = [colder(colder>0)];
hotter = [hotter(hotter>0)];



% 
% if  tiz(1) > 0 %we start with hotter
%     td = mean(hotdurs);
% else
%     td = mean(colddurs);
% end


%start temptims with enough data for the first transitions    
 if timcont(1)/3600 > (temptims(1)/3600 -td/2)
        temptims = temptims(2:end);
        if tiz(1) > 0
            hotter = hotter(2:end);
        else
            colder = colder(2:end);
        end
 end

 figure(455); clf; hold on;

    plot(timcont/3600, temp);
    plot([temptims'/3600 temptims'/3600], [2,3], 'k-');

   for j = 1:min(([length(hotter), length(colder)])) 
   plot([colder(j) colder(j)], [2 3], 'c-');
   plot([hotter(j) hotter(j)], [2 3], 'r-');
   end
%% process data

%Take top of dataset
    %find peaks
    [PKS,LOCS] = findpeaks(obw);
    %find peaks of the peaks
    [obwpeaks,cLOCS] = findpeaks(obw(LOCS));
    peaktim = timcont(LOCS(cLOCS));
    peaktemp = temp(LOCS(cLOCS));
    peakfreq = oldfreq(LOCS(cLOCS));
    
%     % plot checking peaks
%     figure(45); clf; hold on;   
%         plot(peaktim, obwpeaks);
%         plot(timcont, obw);
%         plot([lighttimes' lighttimes'], ylim, 'k-');
    
%Regularize
    %regularize data to ReFs interval
    [regtim, regfreq, regtemp,regobwpeaks] = k_regularmetamucil(peaktim, obwpeaks, timcont, obw, peakfreq, peaktemp, ReFs, temptims);
    
   %filter data
        %cut off frequency
        highWn = 0.005/(ReFs/2);

        %low pass removes spikey-ness
        lowWn = 0.025/(ReFs/2);
       % lowWn = 0.05/(ReFs/2);
        [dd,cc] = butter(5, lowWn, 'low');
        datadata = filtfilt(dd,cc, double(regobwpeaks));

        
        %high pass removes feeding trend for high frequency experiments
        if ld < 11
        [bb,aa] = butter(5, highWn, 'high');
        datadata = filtfilt(bb,aa, datadata); %double vs single matrix?

        end
    
    dataminusmean = datadata - mean(datadata);    


    %trim everything to lighttimes
    timidx = regtim >= lighttimes(1) & regtim <= lighttimes(end);
    xx = regtim(timidx);
    obwyy = dataminusmean(timidx);  
    freq = regfreq(timidx);
    newtemp = regtemp(timidx);

    rawidx = timcont >= lighttimes(1) & timcont <= lighttimes(end);
    timmy = timcont(rawidx);
    obwAmp = obw(rawidx);
    rawfreq = oldfreq(rawidx);
    rawtemp = oldtemp(rawidx);


%     %plot
%     figure(2);clf; hold on;
%         plot(regtim, regobwminusmean, 'k-');
%         plot(regtim, filtdata, 'm');
%         plot(regtim, datadata, 'b');

%% Define temp day length

 %day
    daylengthSECONDS = td * 3600;  
   
    % This is the number of data samples in a day
    howmanysamplesinaday = floor(daylengthSECONDS / ReFs);
    %how many days in total experiment
   

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
  