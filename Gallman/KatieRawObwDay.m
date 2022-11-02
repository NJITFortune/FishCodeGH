%function [darkhalfamp, darkhalftim, lighthalfamp, lighthalftim] = KatieRawObwDay(in, channel, light)
% %% prep 

% 
 clearvars -except kg kg2 hkg hkg2 xxkg xxkg2 k
% 
in = hkg(k);
channel = 1;
light = 3;

% %kg(12) starts with light
% 
% %binsize in minutes
% binsize = 20;
% transbinnum = 8;

%% data

ld = in.info.ld;

lighttimes = k_lighttimes(in, 3);
lighttimes = lighttimes/3600;


 if channel < 3 %single fish data has two channel

    %outlier removal
     tto = [in.idx(channel).obwidx]; 
          
    %raw data
        timcont = [in.e(channel).s(tto).timcont]/3600; %time in hours
        obw = [in.e(channel).s(tto).obwAmp]/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
        oldfreq = [in.e(channel).s(tto).fftFreq];
        oldtemp = [in.e(channel).s(tto).temp];

  else %multifish data only has one channel
    %outlier removal
     tto = [in.idx.obwidx]; 
          
    %raw data
        timcont = [in.s(tto).timcont]/3600; %time in hours
        obw = [in.s(tto).obwAmp]/max([in.s(tto).obwAmp]); %divide by max to normalize
        oldfreq = [in.s(tto).freq];
        oldtemp = [in.s(tto).temp];

  end
            
%% dark to light transitions

%length of experiment
totaltimhours = lighttimes(end)-lighttimes(1);
%divide into days
%index      
daysz = 1:1:floor(totaltimhours/(ld*2));

%dark transistions
darkdays = lighttimes(1) + ((2*ld) * (daysz-1));

%light transitions
lightdays = lighttimes(2) + ((2*ld) * (daysz-1));


%% dark summary by day for stats

if light == 3

    %divide raw data into days that start with dark
    for jj = 2:length(darkdays)
  
        darkidx = find(timcont >= darkdays(jj-1) & timcont < darkdays(jj));
            dday(jj-1).tim(:) = timcont(darkidx)-timcont(darkidx(1));
            dday(jj-1).amp(:) = obw(darkidx);
            dday(jj-1).entiretimcont = timcont(darkidx);
    
    end
    
    
    ddayamp = dday(1).amp;
    ddaytim = dday(1).tim;
    
    for j = 2:length(dday)
        ddayamp = [ddayamp, dday(j).amp];
        ddaytim = [ddaytim, dday(j).tim];
    end
    
    [ddaytim, sortidx] = sort(ddaytim);
    ddayamp = ddayamp(sortidx);
    
    darkhalfidx = find(ddaytim < ld);
    darkhalfamp = ddayamp(darkhalfidx);
    darkhalftim = ddaytim(darkhalfidx);
    
    lighthalfidx = find(ddaytim >= ld);
    lighthalfamp = ddayamp(lighthalfidx);
    lighthalftim = ddaytim(lighthalfidx);

end
%% light summary by day for stats

if light == 4

    %divide raw data into days that start with dark
    for jj = 2:length(lightdays)
    
        lightidx = find(timcont >= lightdays(jj-1) & timcont < lightdays(jj));
            lday(jj-1).tim(:) = timcont(lightidx)-timcont(lightidx(1));
            lday(jj-1).amp(:) = obw(lightidx);
            lday(jj-1).entiretimcont = timcont(lightidx);
    
    end
    
    
    ldayamp = lday(1).amp;
    ldaytim = lday(1).tim;
    
    for j = 2:length(lday)
        ldayamp = [ldayamp, lday(j).amp];
        ldaytim = [ldaytim, lday(j).tim];
    end
    
    [ldaytim, sortidx] = sort(ldaytim);
    ldayamp = ldayamp(sortidx);
    
    darkhalfidx = find(ldaytim >= ld);
    darkhalfamp = ldayamp(darkhalfidx);
    darkhalftim = ldaytim(darkhalfidx);
    
    lighthalfidx = find(ldaytim<ld);
    lighthalfamp = ldayamp(lighthalfidx);
    lighthalftim = ldaytim(lighthalfidx);

end

%% plot to check



% figure(45); clf; hold on;
% 
%     plot(darkhalftim, darkhalfamp, '.', 'Color', [0.7, 0.7, 0.7]);
%     plot(lighthalftim, lighthalfamp, 'm.');
%     plot([ld ld], ylim, 'k-', 'LineWidth', 2);


% figure(68);clf; hold on;
% 
%     for j = 1:length(dday)
%         plot(dday(j).entiretimcont, dday(j).amp, '.');
%     end
%     
%     plot([darkdays' darkdays'], ylim, 'k-');




