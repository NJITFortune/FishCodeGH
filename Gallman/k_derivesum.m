%function out = k_derivesum(in, channel, ReFs)
%% prep 
clearvars -except kg kg2 hkg hkg2 xxkg xxkg2 k

in = hkg(2);
channel = 1;
ReFs = 20;
%kg(12) starts with light

%binsize in minutes
binsize = 20;
transbinnum = 8;

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
        rawdday(jj-1).tim(:) = timcont(darkidx)-timcont(darkidx(1));
        rawdday(jj-1).amp(:) = obw(darkidx);
        rawdday(jj-1).entiretimcont = timcont(darkidx);

end
%%
%regularize data using trim mean and metamucil
[regtim, regfreq, regtemp, regobw] = k_datatrimmean(in, channel, ReFs);
regtim = regtim/3600; %convert back from seconds to hours

%divide regularized data into days that start with dark
for jj = 2:length(darkdays)

    darkidx = find(regtim >= darkdays(jj-1) & regtim < darkdays(jj));
        dday(jj-1).tim(:) = regtim(darkidx)-regtim(darkidx(1));
        dday(jj-1).amp(:) = regobw(darkidx);
        dday(jj-1).entiretimcont = regtim(darkidx);

end

%take the derivative to test prediction
    %average amplitude 
for j = 1:length(dday)
    darkdayamp(j,:) = dday(j).amp;
end

avgdark = mean(darkdayamp);
%derivative - used instead of diff because its not 1 shorter
darkdy = gradient(avgdark)./gradient(dday(1).tim);

%plot
figure(542); clf; hold on;

    ax(1) = subplot(311);  title('raw data'); hold on;
    
         for jj = 1:length(rawdday)
            for j = 1:length(rawdday(jj).tim)
             if rawdday(jj).tim(j) < ld
                 ddarkhalfamp(j,:) = rawdday(jj).amp(j);
                 ddarkhalftim(j,:) = rawdday(jj).tim(j);
             else
                 dlighthalfamp(j,:) = rawdday(jj).amp(j);
                 dlighthalftim(j,:) = rawdday(jj).tim(j);
             end
            end
            plot(dlighthalftim, dlighthalfamp, 'm.');  
            plot(ddarkhalftim, ddarkhalfamp,'b.');
        
        end
           
            % plot(dday(1).tim, darkampyy, 'k-', 'LineWidth', 3);
        % %     plot(darktimxx, darkdy, 'c-', 'LineWidth', 1.5);
             plot([ld ld], ylim, 'k-', 'LineWidth', 2);
        
        %Calculate chisqu of means
        
        [~,dpvalue] = ttest2(ddarkhalfamp,dlighthalfamp,'Vartype','unequal');
        
        %txt = 'pvalue =' + num2str(pvalue)
        text(ld,min(ylim)+0.1,num2str(dpvalue),'FontSize',14);
    
    ax(2) = subplot(312);  title('trimmean regularized'); hold on;
    
        for jj = 1:length(dday)
            plot(dday(jj).tim, dday(jj).amp);
        end
    
        plot(dday(1).tim, avgdark, 'k-', 'LineWidth', 2);
      
        plot([ld ld], ylim, 'k-', 'LineWidth', 2);

    ax(3) = subplot(313);  title('first derivativen of day average'); hold on;
         plot(dday(1).tim, darkdy, 'b-', 'LineWidth', 2);
         plot([ld ld], ylim, 'k-', 'LineWidth', 2);


linkaxes(ax, 'x');