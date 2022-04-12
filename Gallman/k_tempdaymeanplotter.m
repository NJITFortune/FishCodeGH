function k_tempdaymeanplotter(in)

% in.tempmean
% in.temptim
% in.tempday
% in.light

figure(756); clf; hold on;

  %play indexing games because temperature is not the length every time
        pmean = in(1).tempmean;
        ptim = in(1).temptim;

        for p = 2:length(in)

            pmean = pmean(1:min([length(pmean), length(in(p).tempmean)]));
            pmean = pmean + (in(p).tempmean(1:length(pmean)));
           
        end

  %average the averages 
        pmean = pmean / length(in);
        ptim = ptim(1:length(pmean));

  %plot mean of means  
        plot(ptim, pmean, 'k', 'LineWidth', 5)

  %plot tempday transition for each individual mean      
        for j = 1:length(in)

            plot([in(j).tempday, in(j).tempday], ylim, 'LineWidth', 2);

        end