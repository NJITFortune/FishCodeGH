function out = k_tempdayLL(in, channel, p)
% clearvars -except kg
% 
% in = kg(109); %[108 109-ch2 103 104 105 50 51 52 53]
% channel = 2;
%p = 0.5;
ReFs = 10;  %resample once every minute (Usually 60)


%% Take spline estimate of entire data set

%detrendspliner uses csaps to estimate cubic spline of data 
    %subtracts trend from data
    %uses new time base defined by ReFs
[xx, sumfftyy, temperaturetimes] = k_tempspliner(in,channel, ReFs, p);

    
%% divide into tempdays

%this is going to suck because the temp doesn't change super consistently

for k = 2:2:length(temperaturetimes)-1
    %define index overwhich to divide data
    tidx = find(xx >= temperaturetimes(k-1) & xx < temperaturetimes(k+1));   

%     pday(k/2).obw(:) = obwyy(tidx);
%     pday(k/2).zAmp(:) = zyy(tidx);
    pday(k/2).sumfft(:) = sumfftyy(tidx);

    pday(k/2).entiretim(:) = xx(tidx);
    
    pday(k/2).tim(:) = xx(tidx)-xx(tidx(1));
    
    
end






        %plot(pday(1).tim, pday(1).sumfft - mean(pday(1).sumfft));
        pmean = pday(1).sumfft - mean(pday(1).sumfft);
        ptim = pday(1).tim;

        for p = 2:length(pday)

            %plot(pday(p).tim, pday(p).sumfft - mean(pday(p).sumfft), 'LineWidth', 2);
            pmean = pmean(1:min([length(pmean), length(pday(p).sumfft)]));
            pmean = pmean + (pday(p).sumfft(1:length(pmean)) - mean(pday(p).sumfft(1:length(pmean))));
           
        end
% 
        pmean = pmean / length(pday);
        ptim = ptim(1:length(pmean));

        %plot(ptim, pmean, 'k', 'LineWidth', 5)
%calculate temp ld equivalent
    td = floor(temperaturetimes(3)-temperaturetimes(2));
        %plot([td, td], ylim, 'k-', 'LineWidth', 2);

out.tempmean = pmean;
out.temptim = ptim;
out.tempday = td;
        
