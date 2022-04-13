%function out = k_ampbinner(in, channel, binsize, transbinnum)
%% prep 
clearvars -except kg kg2

in = kg(114);
channel = 1;
%kg(12) starts with light

ld = in.info.ld;
%binportion = 0.02*ld;

%binsize in minutes
%binsize = floor(binportion*60);
transbinnum = 8;
binsize = 10;
%% outliers

% Prepare the data with outliers

    ttsf{1} = 1:length([in.e(channel).s.timcont]); % tto is indices for obwAmp
    ttsf{2} = ttsf{1};

 
% Prepare the data without outliers

    % If we have removed outliers via KatieRemover, get the indices...    
    if ~isempty(in.idx)
        ttsf{channel} = in.idx(channel).sumfftidx;  % ttsf is indices for sumfftAmp
    end
     
%% define data by light transitions

%create light transistion vector lighttimes
lighttimeslong = abs(in.info.luz);

%trim lighttimes to poweridx
    if isempty(in.info.poweridx) %if there are no values in poweridx []
        lighttimeslesslong = lighttimeslong;
    else %take data from within power idx range

            lighttimesidx = lighttimeslong > in.info.poweridx(1) & lighttimeslong < in.info.poweridx(2);
            lighttimeslesslong = lighttimeslong(lighttimesidx);
        
    end

    
    lighttimes = lighttimeslesslong;
    %for when we use the computer to find light transistions
    for k = 1:length(lighttimes)
        lighttimes(k) = floor(lighttimes(k));
    end


%trim time and amplitude vectors to light transitions
    
        timcont = [in.e(channel).s(ttsf{channel}).timcont]/3600;
        fftAmp = [in.e(channel).s(ttsf{channel}).sumfftAmp];
        lidx = find(timcont >=lighttimes(1)-(ld/2) & timcont <= lighttimes(end)-(ld/2));

        timcont = timcont(lidx);
        fftAmp = fftAmp(lidx);


%plot to check
%     figure(5); clf; hold on;
%         plot(timcont, fftAmp, '.');
%         plot([lighttimes' lighttimes'], ylim, 'k-', 'LineWidth', 0.5);

%% Divide into bins

%length of experiment
totaltimhours = lighttimes(end)-lighttimes(1);
%bins
%binsize = 10; %minutes
totalnumbins = totaltimhours/(binsize/60);
binz = 1:1:totalnumbins;

%data is currently in hours - need 10minute bins
bintimmin = (lighttimes(1)*60) + (binsize * (binz-1));
bintimhour = bintimmin/60;

    
%plot to check
%     figure(5); clf; hold on;
%         plot(timcont, fftAmp, '.');
%         plot([lighttimes' lighttimes'], ylim, 'k-', 'LineWidth', 0.5);
%         plot([bintimhour' bintimhour'], ylim, 'm-');

%% Average amp by bin

%divide amplitude data into bins
    for j = 1:length(bintimhour)-1
    
    
        timidx = find(timcont > bintimhour(j) & timcont <= bintimhour(j+1));
     
        bin(j).Amp(:) = fftAmp(timidx);
        bin(j).tim(:) = timcont(timidx);
       
    end



%average aplitude data within each bin
    for k = 1:length(bin)
        bin(k).meanAmp(:) = mean(bin(k).Amp);
        bin(k).middletim(:) = bintimhour(k+1) - ((binsize/2)/60);
        
       %plot(bin(k).middletim, bin(k).meanAmp, '.', 'MarkerSize', 16, 'Color','r');
    
    end



%% probability estimate

% if the next dot increased in amp over the previous = 1
% if the next dot decreased in amp over previous = 0;

for k = 2:length(bin)
    
    if bin(k).meanAmp > bin(k-1).meanAmp
        bin(k).binary(:) = 1;
    else
        bin(k).binary(:) = 0;
    end

%     text(bin(k).middletim, bin(k).meanAmp, num2str(bin(k).binary)); 
    

end

   
%% dark to light transitions

%divide into days
%index      
daysz = 1:1:floor(totaltimhours/ld);

%dark transistions
darkdays = lighttimes(1) + (ld * (daysz-1));
length(darkdays)
%light transitions
lightdays = lighttimes(2) + (ld * (daysz-1));

%how many bins around the transistion 
%transbinnum = 8;
transtim = transbinnum*binsize/60;

%dark transistions
for jj = 2:length(darkdays)


    predidx = find(bintimhour <= darkdays(jj)+((transbinnum*binsize)/60) & bintimhour >= darkdays(jj)-((transbinnum*binsize)/60));
    
    %jj-1 so we start at 1
    darkd(jj-1).binary(:) = [bin(predidx).binary];
    darkd(jj-1).bintims(:) = [bin(predidx).tim]; 
   
    darkd(jj-1).binmidtims(:) = [bin(predidx).middletim];
    darkd(jj-1).binAmps(:) = [bin(predidx).meanAmp];
    
        
end
      
%light transitions
for kk = 1:length(lightdays)

    transidx = find(bintimhour <= lightdays(kk)+((transbinnum*binsize)/60) & bintimhour >= lightdays(kk)-((transbinnum*binsize)/60));

    lightd(kk).binary(:) = [bin(transidx).binary];
    lightd(kk).bintims(:) = [bin(transidx).tim]; 
    lightd(kk).binAmps(:) = [bin(transidx).meanAmp];
end


%plot to check
% figure(7); clf; hold on;
%     
%     plot([bin.middletim], [bin.meanAmp], '.', 'MarkerSize', 16, 'Color','r');
%     plot([darkdays' darkdays'], ylim, 'k-', 'LineWidth', 1.5);
%     plot([bintimhour' bintimhour'], ylim, 'm-');
% 
%     clear jj;
%     clear j;
%     for jj = 1:length(darkd)
%         for j = 1:length(darkd(jj).binary)
% 
%     text(darkd(jj).bintims(j), darkd(jj).binAmps(j), num2str(darkd(jj).binary(j)), 'FontSize', 12);
%         end
%     end

 

%% dark summary by day for stats

%dark
for jj = 2:length(darkdays)

    darkidx = find(timcont >= darkdays(jj-1) & timcont < darkdays(jj));
    dday(jj-1).tim(:) = timcont(darkidx)-timcont(darkidx(1));
    dday(jj-1).amp(:) = fftAmp(darkidx);

end

[Tim, Mean] = KatieRegPulseDayTrialDessemblersingledaymean(in, channel,  60, 3);
darkdy= gradient(Mean)./gradient(Tim);

%plot darkday amp
figure(8); clf; title('Dark to light transition average'); hold on; 
    plot([dday.tim], [dday.amp], 'm.');
   

for jj = 1:length(dday)
    for j = 1:length(dday(jj).tim)
     if dday(jj).tim(j) > ld/2 && dday(jj).tim(j) <= (ld/2)+1 
         ddarkhalfamp(j,:) = dday(jj).amp(j);
         ddarkhalftim(j,:) = dday(jj).tim(j);
     else
         dlighthalfamp(j,:) = dday(jj).amp(j);
         dlighthalftim(j,:) = dday(jj).tim(j);
     end
    end
    plot(ddarkhalftim, ddarkhalfamp, 'b.');    

end
   
    plot(Tim, Mean, 'k-', 'LineWidth', 3);
   % plot(Tim, darkdy, 'b-', 'LineWidth', 2)
     plot([ld/2 (ld/2)], ylim, 'k-', 'LineWidth', 2);
     plot([(ld/2)+1 (ld/2)+1], ylim, 'k-', 'LineWidth', 2);

%Calculate chisqu of means

%[~,dpvalue] = ttest2(ddarkhalfamp,dlighthalfamp,'Vartype','unequal');

%txt = 'pvalue =' + num2str(pvalue)
%text(ld,min(ylim)+0.1,num2str(dpvalue),'FontSize',14);

% out.dldarkhalfamp = ddarkhalfamp;
% out.dldarkhalftim = ddarkhalftim;
% out.dllighthalfamp = dlighthalfamp;
% out.dllighthalftim = dlighthalftim;
% out.dlpvaluettest = dpvalue;



%% Bin summary for dark tranistions
   
for jj = 1:length(darkd)
clear k;
    for k = 1:(transbinnum * 2)
        darkprob(k,jj) = darkd(jj).binary(k); 
        darkamp(k,jj) = darkd(jj).binAmps(k);
        darktims(k,jj) = darkd(jj).bintims(k);
     
        if darkprob(k,jj) > 0
        upamp(k, jj) = darkamp(k,jj);
        
        else
        downamp(k, jj) = darkamp(k,jj);
        end
    end

end

%change zeros to nans for plotting
upamp(upamp==0) = nan;
downamp(downamp==0) = nan;


for k = 1:(transbinnum * 2)
    %calculate proportion of ones (increases in amp from previous bin)
    pctdark(k) =  length(find(darkprob(k,:)>0)) / length(darkprob(k,:));
    %number of ones
    onecount(k) = length(find(darkprob(k,:)>0));
    %total amp counts per bin
    totalcount(k) = length(darkprob(k,:));
    %define bins around transition for plotting
    pcttim(k) = k*(binsize/60);
   
end

transtim2 = ((transbinnum*binsize)+60)/60;

figure(27); clf; title('Light to Dark transition summary');hold on;
    
    %plot proportion of amplitude increases from previous bins
    plot(pcttim-((binsize/2)/60), pctdark, '.-');

    %generate random jiggle for amp plotting  through scatter
    for k = 1:(transbinnum * 2)-1

        scatter(pcttim(k)-((binsize/2)/60), upamp(k, :), 'jitter', 'on', 'jitterAmount', 0.01, 'MarkerEdgeColor', 'm');%,'m.','MarkerSize', 10);
        scatter(pcttim(k)-((binsize/2)/60), downamp(k,:),'jitter', 'on', 'jitterAmount', 0.01, 'MarkerEdgeColor', 'k');
       
    end
    %plot bin lines
    plot([pcttim', pcttim'], ylim, 'm-');
    %plot dark to light transition line
    plot([transtim, transtim], ylim, 'k-', 'LineWidth', 2);
     plot([transtim2, transtim2], ylim, 'k-', 'LineWidth', 2);

% out.pctdark = pctdark;
% out.pctdarktim = pcttim;
% out.darkupamp = upamp;
% out.darkdownamp = downamp;

%% chi square by hand for number check
for k = 1:(transbinnum * 2)-1
%     clear n1; clear n2;
%     clear N1;clear N2;
%   
    %observed data
    n1 = onecount(k);
    N1 = totalcount(k);
    n2 = onecount(k+1);
    N2 = totalcount(k+1);
    %pooled estimate of proportion
    p0 = (n1+n2)/(N1+N2);
    %expected counts under null
    n10 = N1 * p0;
    n20 = N2 * p0;
   % Chi-square test, by hand
   observed = [n1 N1-n1 n2 N2-n2];
   expected = [n10 N1-n10 n20 N2-n20];
   chi2stat(k,:) = sum((observed-expected).^2 ./ expected);
   p(k,:) = 1 - chi2cdf(chi2stat(k),1);
    
   pval2sigs(k,:) = round(p(k,:), 2, 'significant');

   %plot p-values on summary plot
   text(pcttim(k), pctdark(k), num2str(pval2sigs(k)));
end

out.pctdarkpvalues = pval2sigs;

% %% chi square by hand method 2
% %basically just checks math
% for k = 1:(transbinnum * 2)-1
% %     clear n1; clear n2;
% %     clear N1;clear N2;
% %   
%     %observed data
%     n1 = onecount(k);
%     N1 = totalcount(k);
%     n2 = onecount(k+1);
%     N2 = totalcount(k+1);
%     %pooled estimate of proportion
%     p0 = (n1+n2)/(N1+N2);
%     %expected counts under null
%     n10 = N1 * p0;
%     n20 = N2 * p0;
%     % Chi-square test, by hand
%        observed = [n1 N1-n1 n2 N2-n2];
%        expected = [n10 N1-n10 n20 N2-n20];
%        [h(k,:), p2(k,:), stats(k,:)] = chi2gof([1 2 3 4],'freq',observed,'expected',expected,'ctrs',[1 2 3 4],'nparams',2);
%     text(pcttim(k), pctdark(k), num2str(p2(k)));
%         
% end

