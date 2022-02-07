%function later
%% prep 
clearvars -except kg kg2

in = kg(2);
channel = 1;

%% outliers

% Prepare the data with outliers

    ttsf{1} = 1:length([in.e(1).s.timcont]); % tto is indices for obwAmp
    ttsf{2} = ttsf{1};

 
% Prepare the data without outliers

    % If we have removed outliers via KatieRemover, get the indices...    
    if ~isempty(in.idx)
        ttsf{1} = in.idx(1).sumfftidx; ttsf{2} = in.idx(2).sumfftidx; % ttsf is indices for sumfftAmp
    end
     
%% define data by light transitions

%create light transistion vector lighttimes
lighttimeslong = abs(in.info.luz);
ld = in.info.ld;

%trim lighttimes to poweridx
    if isempty(in.info.poweridx) %if there are no values in poweridx []
        lighttimeslesslong = lighttimeslong;
    else %take data from within power idx range

            lighttimesidx = lighttimeslong > in.info.poweridx(1) & lighttimeslong < in.info.poweridx(2);
            lighttimeslesslong = lighttimeslong(lighttimesidx);
        
    end

  
    %only take times for light vectors that have data
    for j = 1:length(lighttimeslesslong)-1
            
            %is there data between j and j+1?    
            %if ~isempty(find([in.e(1).s(ttsf{1} ).timcont]/(60*60) >= lighttimeslesslong(j) & [in.e(1).s(ttsf{1}).timcont]/(60*60) < (lighttimeslesslong(j+1)),1))  
                
                   lighttrim(j) = lighttimeslesslong(j);
                 
            %end 
    end
       
    
    lighttimes = lighttimeslesslong;
    %for when we use the computer to find light transistions
    for k = 1:length(lighttimes)
        lighttimes(k) = floor(lighttimes(k));
    end


%trim time and amplitude vectors to light transitions
    
        timcont = [in.e(channel).s(ttsf{channel}).timcont]/3600;
        fftAmp = [in.e(channel).s(ttsf{channel}).sumfftAmp];
        lidx = find(timcont >=lighttimes(1) & timcont <= lighttimes(end));

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
binsize = 10; %minutes
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

for j = 1:length(bintimhour)-1


    timidx = find(timcont > bintimhour(j) & timcont <= bintimhour(j+1));
 
    bin(j).Amp(:) = fftAmp(timidx);
    bin(j).tim(:) = timcont(timidx);
   
end



% figure(4); clf; title('Average Amp by 10 minute bin'); hold on;
% 
% 
%     plot([bin.tim], [bin.Amp], '.');

for k = 1:length(bin)
    bin(k).meanAmp(:) = mean(bin(k).Amp);
    bin(k).middletim(:) = bintimhour(k+1) - ((binsize/2)/60);
    
   %plot(bin(k).middletim, bin(k).meanAmp, '.', 'MarkerSize', 16, 'Color','r');

end

%      plot([bintimhour' bintimhour'], ylim, 'm-');
%      plot([lighttimes' lighttimes'], ylim, 'k-', 'LineWidth', 1.5);


%% probability estimate?


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

darkz = 1:1:floor(totaltimhours/(ld*2));
darkdays = lighttimes(1) + ((2*ld) * (darkz-1));

transbinnum = 8;
transtim = transbinnum*binsize/60;

for jj = 2:length(darkdays)


    predidx = find(bintimhour <= darkdays(jj)+((transbinnum*binsize)/60) & bintimhour>= darkdays(jj)-((transbinnum*binsize)/60));
    
    %jj-1 so we start at 1
    darkd(jj-1).binary(:) = [bin(predidx).binary];
    darkd(jj-1).bintims(:) = [bin(predidx).tim]; 
   
    darkd(jj-1).binmidtims(:) = [bin(predidx).middletim];
    darkd(jj-1).binAmps(:) = [bin(predidx).meanAmp];
    
        
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


%% summary by day for stats

for jj = 2:length(darkdays)

    darkidx = find(timcont>= darkdays(jj-1) & timcont < darkdays(jj));
    dday(jj-1).tim(:) = timcont(darkidx)-timcont(darkidx(1));
    dday(jj-1).amp(:) = fftAmp(darkidx);

end

 

%plot day amp
figure(8); clf; hold on;

    plot([dday.tim], [dday.amp], '.');
for jj = 1:length(dday)
    for j = 1:length(dday(jj).tim)
     if dday(jj).tim(j) < 4
         darkhalfamp(j,:) = dday(jj).amp(j);
         darkhalftim(j,:) = dday(jj).tim(j);
     else
         lighthalfamp(j,:) = dday(jj).amp(j);
         lighthalftim(j,:) = dday(jj).tim(j);
     end
    end
    plot(darkhalftim, darkhalfamp, 'm.');    
end
    
%% Calculate chisqu of means

[hypothesis,pvalue] = ttest2(darkhalfamp,lighthalfamp,'Vartype','unequal')

%% Averages for dark to light tranistions

    
for jj = 1:length(darkd)

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


% upamps = upamp(upamp > 0);
% downamps = downamp(downamp >0);

for k = 1:transbinnum * 2
    pctdark(k) =  length(find(darkprob(k,:)>0)) / length(darkprob(k,:));
    onecount(k) = length(find(darkprob(k,:)>0));
    totalcount(k) = length(darkprob(k,:));
    pcttim(k) = k*(binsize/60);

    
end

figure(27); clf; hold on;

    plot(pcttim-((binsize/2)/60), pctdark, '.-');
    
    for k = 1:transbinnum * 2
       
        %plot(k*ones(length(darkamp(k,:)),1), darkamp(k,:), 'k.');
        plot(pcttim(k)-((binsize/2)/60), darkamp(k,:), 'k.', 'MarkerSize', 10);
        plot(pcttim(k)-((binsize/2)/60), upamp(k, :), 'm.','MarkerSize', 10);
        %plot(pcttim(k)-((binsize/2)/60),meandarkamp(k,:),'r.', 'MarkerSize', 5);
       
        plot([pcttim(k), pcttim(k)], ylim, 'm-');
    end
    plot([transtim, transtim], ylim, 'k-');

%% crosstab on unsummarized data (pre-percent of ones)
    
clear k;
for k = 2:size(darkprob,1)

   [~,chi2(k-1,:),pval(k-1,:)] = crosstab(darkprob(k-1,:), darkprob(k,:));
   pval3sigs = round(pval(k-1,:), 2, 'significant');
   text(pcttim(k-1), pctdark(k-1), num2str(pval3sigs));
  
end


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
    
   text(pcttim(k), 1, num2str(p(k)));
end

%% chi square by hand method 2
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
       [h(k,:), p2(k,:), stats(k,:)] = chi2gof([1 2 3 4],'freq',observed,'expected',expected,'ctrs',[1 2 3 4],'nparams',2);
    text(pcttim(k), 0.8, num2str(p2(k)));
        
end

%%

% for k = 1:(transbinnum * 2)
%  
% %    handsig(k) = ((length(find(darkprob(k,:)>0)) - length(darkprob(k,:))/2)^2 / length(darkprob(k,:))/2) + ((length(find(darkprob(k,:)<1)) - length(darkprob(k,:))/2)^2/length(darkprob(k,:))/2);
% %    sig(k) = chi2pdf(pctdark(k), 1);
% 
% end
