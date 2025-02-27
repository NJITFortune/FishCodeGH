 function [tday] = KatieRegobwTempDay(in, channel, ReFs, heat)%multisingleRegobwDay
%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4


%for when i'm too lazy to function
% clearvars -except xxkg hkg k xxkg2 hkg2
% % % % 
% in = xxkg(k);
% ReFs = 20;
% heat = 8;
% channel = 1;

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
    oldfreq =  [in.e(channel).s(tto).fftFreq];

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
    temptims = floor(temptims*3600);
%% calculate average duration of tempdays
colder = [colder(colder>0)];
hotter = [hotter(hotter>0)];


for j = 2:min(([length(hotter), length(colder)]))
    if tiz(1) > 0 %we start with hotter

        hotdurs(j-1,:) = colder(j-1) -  hotter(j-1);
        colddurs(j-1,:) = hotter(j) - colder(j-1);

    else    %we start with colder

        colddurs(j-1,:) = hotter(j-1) - colder(j-1);
        hotdurs(j-1,:) = colder(j) -  hotter(j-1);
        
    end

end


if  tiz(1) > 0 %we start with hotter
    td = mean(hotdurs);
else
    td = mean(colddurs);
end


%% process data
%prepare data variables

% %outlier removal
%  tto = [in.idx(channel).obwidx]; 
%       
% %raw data
%     timcont = [in.e(channel).s(tto).timcont]; %time in seconds
%     obw = [in.e(channel).s(tto).obwAmp]/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize

%Take top of dataset
    %find peaks of amplitude data
    [~,LOCS] = findpeaks(obw);
    %find peaks of the peaks
    [obwpeaks,cLOCS] = findpeaks(obw(LOCS));
    peaktim = timcont(LOCS(cLOCS));

    %take the peaks of the frequency data
    %find peaks
    [freqpeak1,fLOCS] = findpeaks(oldfreq);
    freqtim1 = timcont(fLOCS);
    
    
%Regularize
    %regularize data to ReFs interval
    [regtim, regobwpeaks] = k_regularmetamucil(peaktim, obwpeaks, timcont, obw, ReFs, temptims);

     %regularize data to ReFs interval
    [regfreqtim, regfreqpeaks] = k_regularmetamucil(freqtim1, freqpeak1, timcont, oldfreq, ReFs, temptims);

    
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

    dataminusmean = datadata - mean(datadata);    


    %trim everything to temptims
    timidx = regtim >= temptims(1) & regtim <= temptims(end);
    xx = regtim(timidx);
    obwyy = regobwpeaks(timidx);  
    obwyy = dataminusmean(timidx);  
    

    %freq
    frqidx = regfreqtim >= temptims(1) & regfreqtim <= temptims(end);
  %  freqxx = regfreqtim(frqidx);
    freq = regfreqpeaks(frqidx);  

    rawidx = timcont >= temptims(1) & timcont <= temptims(end);
    timmy = timcont(rawidx);
    obwAmp = obw(rawidx);
    freqRaw = oldfreq(rawidx);

%     %plot
%     figure(2);clf; hold on;
%         plot(regtim, regobwminusmean, 'k-');
%         plot(regtim, filtdata, 'm');
%         plot(regtim, datadata, 'b');
%% divide into tempdays

%this is going to suck because the temp doesn't change super consistently
% 
% figure(78); clf; hold on;
%     plot(xx/3600, obwyy); 
%     plot([temptims'/3600 temptims'/3600], ylim, 'k-');

for j = 2:2:length(temptims)-1

    
    %define index overwhich to divide data
    tidx = find(xx >= temptims(j-1) & xx < temptims(j+1));   

    tday(j/2).obw(:) = obwyy(tidx);

    tday(j/2).entiretimcont(:) = xx(tidx);

    tday(j/2).freq = freq(tidx);
    
    tday(j/2).tim(:) = xx(tidx)-xx(tidx(1));
    
    tday(j/2).amprange = max(obwyy(tidx));

    tday(j/2).td = td;
end

% %calculate mean for plotting
%         tmean = tday(1).obw - mean(tday(1).obw);
%         ttim = tday(1).tim;
% 
%         for p = 2:length(tday)
% 
%             tmean = tmean(1:min([length(tmean), length(tday(p).obw)]));
%             tmean = tmean + (tday(p).obw(1:length(tmean)) - mean(tday(p).obw(1:length(tmean))));
%            
%         end
% % 
%         tmean = tmean / length(tday);
%         ttim = ttim(1:length(tmean));

%  
  %% plot to check
% %time vectors currently in seconds, divide by 3600 to get hours
% 
% %fill colors for plotting
% hot = [255/255, 204/255, 204/255];
% cold = [204/255, 238/255, 255/255];
% 
% %days over experiment time
% figure(795); clf; hold on;
% 
%     plot(timmy/3600, obwAmp-mean(obwAmp), '.');
%     for j = 1:length(tday)
%         plot(tday(j).entiretimcont/3600, tday(j).obw);
%     end
%    
%      a = ylim; %all of above is just to get the max for the plot lines...
% 
%         if  tiz(1) > 0 %we start with warming
%             for j = 1:length(temptims)-1
%                 if mod(j,2) == 1 %if j is odd
%             fill([temptims(j)/3600 temptims(j)/3600 temptims(j+1)/3600 temptims(j+1)/3600], [a(1) a(2) a(2) a(1)], hot);
%                 else
%             fill([temptims(j)/3600 temptims(j)/3600 temptims(j+1)/3600 temptims(j+1)/3600], [a(1) a(2) a(2) a(1)], cold);
%                 end
%             end
%         else
%             for j = 1:length(temptims)-1
%                 if mod(j,2) == 1 %if j is odd
%             fill([temptims(j)/3600 temptims(j)/3600 temptims(j+1)/3600 temptims(j+1)/3600], [a(1) a(2) a(2) a(1)], cold);
%                 else
%             fill([temptims(j)/3600 temptims(j)/3600 temptims(j+1)/3600 temptims(j+1)/3600], [a(1) a(2) a(2) a(1)], hot);
%                 end
%             end
%         end
% 
%      plot(timmy/3600, obwAmp-mean(obwAmp), '.');
%     for j = 1:length(tday)
%         plot(tday(j).entiretimcont/3600, tday(j).obw, 'LineWidth', 2);
%     end    
%      
% 
%             
%   
% figure(778); clf; hold on; ylim([-.5,.5]); xlim([0, ttim(end)/3600]);
% 
% a = ylim;
%         
% if  tiz(1) > 0 %we start with warming
%     fill([0 0 td td], [a(1) a(2) a(2) a(1)], hot);
%     fill([td td (td*2) (td*2)], [a(1) a(2) a(2) a(1)], cold);
% else
%     fill([0 0 td td], [a(1) a(2) a(2) a(1)], cold);
%     fill([td td (td*2)+1.5 (td*2)+1.5], [a(1) a(2) a(2) a(1)], hot);
% end
%         plot(tday(1).tim/3600, tday(1).obw - mean(tday(1).obw));
%        
%         for p = 2:length(tday)
% 
%             plot(tday(p).tim/3600, tday(p).obw - mean(tday(p).obw), 'LineWidth', 2);
%            
%         end
% % 
%       
% 
%         plot(ttim/3600, tmean, 'k', 'LineWidth', 5)
% %calculate temp ld equivalent
%     
%         plot([td, td], ylim, 'k-', 'LineWidth', 2);          
% 
% 
% 
