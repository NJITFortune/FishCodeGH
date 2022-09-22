%function [day] = KatieRegObwDay(in, channel, ReFs, light)%multisingleRegobwDay
%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4


%for when i'm too lazy to function
clearvars -except xxkg hkg k xxkg2 hkg2
% % % 
in = xxkg(k);
ReFs = 20;
heat = 8;
channel = 1;

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

%separate warming from cooling lines
%separate rise from fall    
for j = 2:length(temptims)
    
    tempidx = find(timcont >= temptims(j-1) & timcont < temptims(j));

    if mean(temp(tempidx)) > mean(temp)
        tiz(j-1,:) = temptims(j-1);
        hotter(j-1,:) = temptims(j-1);
    else
        tiz(j-1,:) = -temptims(j-1);
        colder(j-1,:) = temptims(j-1);
    end

end    



if isempty(poweridx) %if there are no values in poweridx []

      if heat == 7 && tiz(1) > 0 %we want start with cooling and the experiment starts with warming
        temptims = temptims(2:end); %skip the first temptim so we start with cooling
      elseif heat == 8 && tiz(1) < 0 %we want start with warming and the experiment starts with cooling
        temptims = temptims(2:end); %skip the first temptim so we start with cooling
      end

else %we have poweridx values

    %take data from within power idx range
    temptimsidx = temptims > poweridx(1) & temptims < poweridx(2);
    temptims = temptims(temptimsidx);
    tiz = tiz(temptimsidx);
    
      if heat == 7 && tiz(1) > 0 %we want start with cooling and the experiment starts with warming
        temptims = temptims(2:end); %skip the first temptim so we start with cooling
      elseif heat == 8 && tiz(1) < 0 %we want start with warming and the experiment starts with cooling
        temptims = temptims(2:end); %skip the first temptim so we start with cooling
      end

end

%make temptims an integer
    %convert to seconds because xx is in seconds
    temptims = floor(temptims*3600);


%% process data
%prepare data variables

% %outlier removal
%  tto = [in.idx(channel).obwidx]; 
%       
% %raw data
%     timcont = [in.e(channel).s(tto).timcont]; %time in seconds
%     obw = [in.e(channel).s(tto).obwAmp]/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize

%Take top of dataset
    %find peaks
    [~,LOCS] = findpeaks(obw);
    %find peaks of the peaks
    [obwpeaks,cLOCS] = findpeaks(obw(LOCS));
    peaktim = timcont(LOCS(cLOCS));
    
%     % plot checking peaks
%     figure(45); clf; hold on;   
%         plot(peaktim, obwpeaks);
%         plot(timcont, obw);
%         plot([lighttimes' lighttimes'], ylim, 'k-');
    
%Regularize
    %regularize data to ReFs interval
    [regtim, regobwminusmean, regobwpeaks] = k_regularmetamucil(peaktim, obwpeaks, timcont, obw, ReFs, temptims);
    
     %filter data
        %cut off frequency
         highWn = 0.005/(ReFs/2); % Original but perhaps too strong for 4 and 5 hour days
        %highWn = 0.001/(ReFs/2);

        %low pass removes spikey-ness
        lowWn = 0.025/(ReFs/2);
        [dd,cc] = butter(5, lowWn, 'low');
        datadata = filtfilt(dd,cc, double(regobwpeaks));

        
%         %high pass removes feeding trend for high frequency experiments
%         if ld < 11
%         [bb,aa] = butter(5, highWn, 'high');
%         datadata = filtfilt(bb,aa, datadata); %double vs single matrix?
% 
%         end
    
    dataminusmean = datadata - mean(datadata);    


    %trim everything to lighttimes
    timidx = regtim >= temptims(1) & regtim <= temptims(end);
    xx = regtim(timidx);
    obwyy = dataminusmean(timidx);  

    rawidx = timcont >= temptims(1) & timcont <= temptims(end);
    timmy = timcont(rawidx);
    obwAmp = obw(rawidx);

%     %plot
%     figure(2);clf; hold on;
%         plot(regtim, regobwminusmean, 'k-');
%         plot(regtim, filtdata, 'm');
%         plot(regtim, datadata, 'b');
%% divide into tempdays

%this is going to suck because the temp doesn't change super consistently

for j = 2:2:length(temptims)-1
    %define index overwhich to divide data
    tidx = find(xx >= temptims(j-1) & xx < temptims(j+1));   

    tday(j/2).obw(:) = obwyy(tidx);

    tday(j/2).entiretimcont(:) = xx(tidx);
    
    tday(j/2).tim(:) = xx(tidx)-xx(tidx(1));
    
    
end


        tmean = tday(1).obw - mean(tday(1).obw);
        ttim = tday(1).tim;

        for p = 2:length(tday)

            tmean = tmean(1:min([length(tmean), length(tday(p).obw)]));
            tmean = tmean + (tday(p).obw(1:length(tmean)) - mean(tday(p).obw(1:length(tmean))));
           
        end
% 
        tmean = tmean / length(tday);
        ttim = ttim(1:length(tmean));

%% calculate average duration of tempdays
colder = [colder(colder>0)];
hotter = [hotter(hotter>0)];


for j = 2:length(hotter)
    if tiz(1) > 0 %we start with hotter

        hotdurs(j-1,:) = colder(j-1) -  hotter(j-1);
        colddurs(j-1,:) = hotter(j) - colder(j-1);

    else    %we start with colder

        colddurs(j-1,:) = hotter(j-1) - colder(j-1);
        hotdurs(j-1,:) = colder(j) -  hotter(j-1);
        
    end

end


colddur = mean(colddurs);
hotdur = mean(hotdurs);

if  tiz(1) > 0 %we start with hotter
    td = hotdur;
else
    td = colddur;
end

%  
  %% plot to check
%time vectors currently in seconds, divide by 3600 to get hours

%fill colors for plotting
hot = [255/255, 204/255, 204/255];
cold = [204/255, 238/255, 255/255];
 
%days over experiment time
figure(95); clf; hold on;

    plot(timmy/3600, obwAmp-mean(obwAmp), '.');
    for j = 1:length(tday)
        plot(tday(j).entiretimcont/3600, tday(j).obw);
    end
   
%     a = ylim; %all of above is just to get the max for the plot lines...
%     if heat == 8 %the first lighttime is dark
%         for j = 1:length(temptims)-1
%             if mod(j,2) == 1 %if j is odd
%             fill([lighttimes(j)/3600 lighttimes(j)/3600 lighttimes(j+1)/3600 lighttimes(j+1)/3600], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
%             end
%         end
%     else %the second lighttime is dark 
%         for j = 1:length(lighttimes)-1
%             if mod(j,2) == 0 %if j is even
%             fill([lighttimes(j)/3600 lighttimes(j)/3600 lighttimes(j+1)/3600 lighttimes(j+1)/3600], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
%             end
%         end
%     end
%     
%     for j = 1:length(day)
%         plot(day(j).entiretimcont/3600, day(j).Sobwyy, 'LineWidth', 1.5);
%     end
% 
%      plot(timmy/3600, obwAmp-mean(obwAmp), '.');

% %average over single day    
% figure(56); clf; hold on; 
% 
%  
% %     %create fill box 
% %     if light < 4 %we start with dark
% %         fill([0 0 ld ld], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
% %     else %we start with light
% %         fill([ld ld ld*2 ld*2], [a(1) a(2) a(2) a(1)], [0.9, 0.9, 0.9]);
% %     end
%     
%     %mean two ways to prove math
%     mday = zeros(1, length(tday(1).tim));        
%      for j = 1:length(tday)
%             plot(tday(j).tim/3600, tday(j).obw);
%             meanday(j,:) = tday(j).obw;
%             mday = mday + tday(j).obw;
%             
%      end
%         
%             mmday= mean(meanday);
%             othermday = mday/(length(tday));
%             plot(tday(1).tim/3600, mmday, 'k-', 'LineWidth', 3);
%             plot(tday(1).tim/3600, othermday, 'b-', 'LineWidth', 3);
%             plot([ld ld], ylim, 'k-', 'LineWidth', 3);
            
  
figure(778); clf; hold on;


        plot(tday(1).tim, tday(1).obw - mean(pday(1).obw));
       
        for p = 2:length(pday)

            plot(tday(p).tim, tday(p).obw - mean(tday(p).obw), 'LineWidth', 2);
           
        end
% 
      

        plot(ttim, tmean, 'k', 'LineWidth', 5)
%calculate temp ld equivalent
    
        plot([td, td], ylim, 'k-', 'LineWidth', 2);          



