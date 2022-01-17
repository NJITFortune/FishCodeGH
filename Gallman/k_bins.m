%function later
%% prep 
clearvars -except kg kg2

in = kg(2);
channel = 1;

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
    
        timcont = [in.e(channel).s.timcont]/3600;
        lidx = find(timcont >=lighttimes(1) & timcont <= lighttimes(end));

        timcont = timcont(lidx);
        fftAmp = [in.e(channel).s(lidx).sumfftAmp];


%plot to check
    figure(5); clf; hold on;
        plot(timcont, fftAmp, '.');
        plot([lighttimes' lighttimes'], ylim, 'k-', 'LineWidth', 0.5);

%% Divide into bins

%length of experiment
totaltimhours = lighttimes(end)-lighttimes(1);
%bins
binsize = 5; %minutes
totalnumbins = totaltimhours/(binsize/60);
binz = 1:1:totalnumbins;

%data is currently in hours - need 10minute bins
bintimmin = (lighttimes(1)*60) + (binsize * (binz-1));
bintimhour = bintimmin/60;

    
%plot to check
    figure(5); clf; hold on;
        plot(timcont, fftAmp, '.');
        plot([lighttimes' lighttimes'], ylim, 'k-', 'LineWidth', 0.5);
        plot([bintimhour' bintimhour'], ylim, 'm-');

%% Average amp by bin

for j = 1:length(bintimhour)-1

    timidx = find(timcont > bintimhour(j) & timcont <= bintimhour(j+1));
    bin(j).Amp(:) = fftAmp(timidx);
    bin(j).tim(:) = timcont(timidx);

end

%figure(4); clf; title('Average Amp by 10 minute bin'); hold on;

for k = 1:length(bin)-1
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

for jj = 2:length(darkdays)


    predidx = find([bin.middletim] <= darkdays(jj)+((transbinnum*binsize)/60) & [bin.middletim] >= darkdays(jj)-((transbinnum*binsize)/60));
    
    %jj-1 so we start at 1
    darkd(jj-1).binary(:) = [bin(predidx).binary];
    darkd(jj-1).bintims(:) = [bin(predidx).middletim];
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

%% Averages for dark to light tranistions

    
for jj = 1:length(darkd)

    for k = 1:(transbinnum * 2)
        darkprob(k,jj) = darkd(jj).binary(k); 
        darkamp(k,jj) = darkd(jj).binAmps(k);
    end

end

%     darkprob2
%     darkprob3
%     darkprob4
% 
% 
%     darkprob5
%     darkprob6
%     darkprob7
%     darkprob8

for k = 1:transbinnum * 2
    pctdark(k) =  length(find(darkprob(k,:)>0)) / length(darkprob(k,:));
end

figure(27); clf; hold on;

    plot(pctdark)
    for k = 1:transbinnum * 2
        plot(k*ones(length(darkamp(k,:)),1), darkamp(k,:), 'k.');
    end

%%

for k = 1:(transbinnum * 2)
 
    sig(k) = chi2pdf(pctdark(k), 1);

end
