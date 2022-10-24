function [ddarkhalf, dlighthalf, ldarkhalf, llighthalf] = KatieRawObwDay(in, channel)
%% prep 
% clearvars -except kg kg2 hkg hkg2 xxkg xxkg2 k
% 
% in = hkg(2);
% channel = 1;
% ReFs = 20;
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
        timcont = [in.s(tto).timcont]/3600; %time in seconds
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

%how many bins around the transistion 
%transbinnum = 8;
transtim = transbinnum*binsize/60;


%% dark summary by day for stats

%divide raw data into days that start with dark
for jj = 2:length(darkdays)

    darkidx = find(timcont >= darkdays(jj-1) & timcont < darkdays(jj));
        dday(jj-1).tim(:) = timcont(darkidx)-timcont(darkidx(1));
        dday(jj-1).amp(:) = obw(darkidx);
        dday(jj-1).entiretimcont = timcont(darkidx);

end

    
         for jj = 1:length(dday)
            for j = 1:length(dday(jj).tim)
             if dday(jj).tim(j) < ld
                 ddarkhalfamp(j,:) = dday(jj).amp(j);
                 ddarkhalftim(j,:) = dday(jj).tim(j);
             else
                 dlighthalfamp(j,:) = dday(jj).amp(j);
                 dlighthalftim(j,:) = dday(jj).tim(j);
             end
            end
%             plot(dlighthalftim, dlighthalfamp, 'm.');  
%             plot(ddarkhalftim, ddarkhalfamp,'b.');
        
        end
      
ddarkhalf.amp = ddarkhalfamp;       
ddarkhalf.tim = ddarkhalftim;

dlighthalf.amp = dlighthalfamp;
dlighthalf.tim = dlighthalftim;
  

%light
for kk = 2:length(lightdays)

    lightidx = find(timcont >= lightdays(kk-1) & timcont < lightdays(kk));
    lday(kk-1).tim(:) = timcont(lightidx) - timcont(lightidx(1));
    lday(kk-1).amp(:) = obw(lightidx);
    lday(kk-1).entiretimcont(:) = timcont(lightidx);

end


for kk = 1:length(lday)
    for k = 1:length(lday(kk).tim)
     if lday(kk).tim(k) < ld
         llighthalfamp(k,:) = lday(kk).amp(k);
         llighthalftim(k,:) = lday(kk).tim(k);
     else
         ldarkhalfamp(k,:) = lday(kk).amp(k);
         ldarkhalftim(k,:) = lday(kk).tim(k);
     end
    end
   

end

llighthalf.amp = llighthalfamp;
llighthalf.tim =  llighthalftim;

ldarkhalf.amp = ldarkhalfamp;
ldarkhalf.tim = ldarkhalftim;





