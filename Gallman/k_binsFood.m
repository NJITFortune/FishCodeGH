%function out = k_ampbinner(in, channel, binsize, transbinnum)
%% prep 
clearvars -except kg kg2

in = kg(1);
channel = 1;
%kg(12) starts with light

%binsize in minutes
binsize = 10;
transbinnum = 8;
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
ld = in.info.ld;

%trim lighttimes to poweridx
    if isempty(in.info.poweridx) %if there are no values in poweridx []
        lighttimeslesslong = lighttimeslong;
    else %take data from within power idx range

            lighttimesidx = lighttimeslong > in.info.poweridx(1) & lighttimeslong < in.info.poweridx(2);
            lighttimeslesslong = lighttimeslong(lighttimesidx);
        
    end

  
    %only take times for light vectors that have data
%     for j = 1:length(lighttimeslesslong)-1
%             
%             %is there data between j and j+1?    
%             %if ~isempty(find([in.e(1).s(ttsf{1} ).timcont]/(60*60) >= lighttimeslesslong(j) & [in.e(1).s(ttsf{1}).timcont]/(60*60) < (lighttimeslesslong(j+1)),1))  
%                 
%                    lighttrim(j) = lighttimeslesslong(j);
%                  
%             %end 
%     end
%        
    
    lighttimes = lighttimeslesslong;
    %for when we use the computer to find light transistions
    for k = 1:length(lighttimes)
        lighttimes(k) = floor(lighttimes(k));
    end


%trim time and amplitude vectors to light transitions
    
        timcont = [in.e(channel).s(ttsf{channel}).timcont]/3600;
        fftAmp = [in.e(channel).s(ttsf{channel}).sumfftAmp];
        lidx = find(timcont >=(lighttimes(1)-ld/2) & timcont <= (lighttimes(end)-ld/2));

        timcont = timcont(lidx);
        fftAmp = fftAmp(lidx);



fedtim = [in.info.feedingtimes];
%binrange = transbinnum*binsize;

%find time around transitions


for jj = 1:length(fedtim)

    fedidx = find(timcont <= fedtim(jj)+((transbinnum*binsize)/60) & timcont >= fedtim(jj)-((transbinnum*binsize)/60));
    fed(jj).tim = timcont(fedidx);
    fed(jj).amp = fftAmp(fedidx);

end



%% Divide into bins

%length of experiment
totaltimhours = fed(1).tim(end)-fed(1).tim(1);
%bins
%binsize = 10; %minutes
totalnumbins = totaltimhours/(binsize/60);
binz = 1:1:totalnumbins;


for jj = 1:length(fed)

    %data is currently in hours - need minute bins
    bintims = (fed(jj).tim(1)*60) + (binsize * (binz-1))/60;

    %divide data around feeding times into bins
    for j = 2:length(bintims)
    
    
        binidx = find(fed(jj).tim > bintims(j-1) & fed(jj).tim <= bintims(j));
     
        fed(jj).bin(j-1).binAmp(:) = fftAmp(binidx);
        fed(jj).bin(j-1).bintim(:) = timcont(binidx);
      
    end


    %average aplitude data within each bin
    for k = 1:length(fed(jj).bin)

        fed(jj).bin(k).meanAmp(:) = mean(fed(jj).bin(k).binAmp);
    
    end

    for kk = 2:length(fed(jj).bin)

        if fed(jj).bin(kk).meanAmp > fed(jj).bin(kk-1).meanAmp

            fed(jj).bin(kk).binary(:) = 1;
        else
            fed(jj).bin(k).binary(:) = 0;
        end

    
    end


    for i = 1:length(fed(jj).bin)
        
        fedprob(i, jj) = fed(jj).bin(i).binary;
        fedamp(i, jj) = fed(jj).bin(i).binAmp;
        fedtims(i, jj) = fed(jj).bin(i).bintim;

        if fedprob(i, jj) > 0
            upamp(i, jj) = fedamp(i, jj);
        else
            downamp(i, jj) = fedamp(i, jj);
        end

    end

end




%change zeros to nans for plotting
upamp(upamp==0) = nan;
downamp(downamp==0) = nan;




for k = 1:transbinnum * 2
    %calculate proportion of ones (increases in amp from previous bin)
    pctfed(k) =  length(find(fedprob(k,:)>0)) / length(fedprob(k,:));
    %number of ones
    fedonecount(k) = length(find(fedprob(k,:)>0));
    %total amp counts per bin
    fedtotalcount(k) = length(fedprob(k,:));
    %define bins around transition for plotting
    pctfedtim(k) = k*(binsize/60);
   
end



figure(28); clf; title('feeding transition summary');hold on;
    
    %plot proportion of amplitude increases from previous bins
    plot(pctfedtim-((binsize/2)/60), pctfed, '.-');

    %generate random jiggle for amp plotting  through scatter
    for k = 1:(transbinnum * 2)

        scatter(pctfedtim(k)-((binsize/2)/60), fedupamp(k, :), 'jitter', 'on', 'jitterAmount', 0.01, 'MarkerEdgeColor', 'm');%,'m.','MarkerSize', 10);
        scatter(pctfedtim(k)-((binsize/2)/60), feddownamp(k,:),'jitter', 'on', 'jitterAmount', 0.01, 'MarkerEdgeColor', 'k');
       
    end
    %plot bin lines
    plot([pctfedtim', pctfedtim'], ylim, 'm-');
    %plot dark to light transition line
    plot([transtim, transtim], ylim, 'k-');

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
    n1 = fedonecount(k);
    N1 = fedtotalcount(k);
    n2 = fedonecount(k+1);
    N2 = fedtotalcount(k+1);
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
   text(pctfedtim(k), pctfed(k), num2str(pval2sigs(k)));
end

out.pctfedpvalues = pval2sigs;

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

%% Bin summary for light tranistions
   
% for jj = 1:length(lightd)
% 
%     for k = 1:(transbinnum * 2)
%         lightprob(k,jj) = lightd(jj).binary(k); 
%         lightamp(k,jj) = lightd(jj).binAmps(k);
%         lighttims(k,jj) = lightd(jj).bintims(k);
%      
%         if lightprob(k,jj) > 0
%         lupamp(k, jj) = lightamp(k,jj);
%         
%         else
%         ldownamp(k, jj) = lightamp(k,jj);
%         end
%     end
% 
% end
% 
% %change zeros to nans for plotting
% lupamp(lupamp==0) = nan;
% ldownamp(ldownamp==0) = nan;
% 
% 
% for k = 1:transbinnum * 2
%     %calculate proportion of ones (increases in amp from previous bin)
%     pctlight(k) =  length(find(lightprob(k,:)>0)) / length(lightprob(k,:));
%     %number of ones
%     lonecount(k) = length(find(lightprob(k,:)>0));
%     %total amp counts per bin
%     ltotalcount(k) = length(lightprob(k,:));
%     %define bins around transition for plotting
%     pctlighttim(k) = k*(binsize/60);
%    
% end
% 
% 
% 
% figure(28); clf; title('Dark to Light transition summary'); hold on;
%     
%     %plot proportion of amplitude increases from previous bins
%     plot(pctlighttim-((binsize/2)/60), pctlight, '.-');
% 
%     %generate random jiggle for amp plotting  through scatter
%     for k = 1:transbinnum * 2
% 
%         scatter(pctlighttim(k)-((binsize/2)/60), lupamp(k, :), 'jitter', 'on', 'jitterAmount', 0.01, 'MarkerEdgeColor', 'm');%,'m.','MarkerSize', 10);
%         scatter(pctlighttim(k)-((binsize/2)/60), ldownamp(k,:),'jitter', 'on', 'jitterAmount', 0.01, 'MarkerEdgeColor', 'k');
%        
%     end
%     %plot bin lines
%     plot([pctlighttim', pctlighttim'], ylim, 'm-');
%     %plot dark to light transition line
%     plot([transtim, transtim], ylim, 'k-');

% out.pctlight = pctlight;
% out.pctlighttim = pcttim;
% out.lightupamp = upamp;
% out.lightdownamp = downamp;
% out.transtim = transtim;
% %% chi square by hand for number check
% for k = 1:(transbinnum * 2)-1
% %     clear n1; clear n2;
% %     clear N1;clear N2;
% %   
%     %observed data
%     n1 = lonecount(k);
%     N1 = ltotalcount(k);
%     n2 = lonecount(k+1);
%     N2 = ltotalcount(k+1);
%     %pooled estimate of proportion
%     p0 = (n1+n2)/(N1+N2);
%     %expected counts under null
%     n10 = N1 * p0;
%     n20 = N2 * p0;
%    % Chi-square test, by hand
%    observed = [n1 N1-n1 n2 N2-n2];
%    expected = [n10 N1-n10 n20 N2-n20];
%    chi2stat(k,:) = sum((observed-expected).^2 ./ expected);
%    lp(k,:) = 1 - chi2cdf(chi2stat(k),1);
%     
%    lpval2sigs(k,:) = round(lp(k,:), 2, 'significant');
% 
%    %plot p-values on summary plot
%    text(pcttim(k), pctlight(k), num2str(lpval2sigs(k)));
% end
% 
% %out.pctlightpvalues = lpval2sigs;
% 
% % %% chi square by hand method 2
% % %basically just checks math
% % for k = 1:(transbinnum * 2)-1
% % %     clear n1; clear n2;
% % %     clear N1;clear N2;
% % %   
% %     %observed data
% %     n1 = onecount(k);
% %     N1 = totalcount(k);
% %     n2 = onecount(k+1);
% %     N2 = totalcount(k+1);
% %     %pooled estimate of proportion
% %     p0 = (n1+n2)/(N1+N2);
% %     %expected counts under null
% %     n10 = N1 * p0;
% %     n20 = N2 * p0;
% %     % Chi-square test, by hand
% %        observed = [n1 N1-n1 n2 N2-n2];
% %        expected = [n10 N1-n10 n20 N2-n20];
% %        [h(k,:), p2(k,:), stats(k,:)] = chi2gof([1 2 3 4],'freq',observed,'expected',expected,'ctrs',[1 2 3 4],'nparams',2);
% %     text(pcttim(k), pctdark(k), num2str(p2(k)));
% %         
% % end
% 
