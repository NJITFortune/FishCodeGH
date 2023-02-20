figure(2); clf;
meanDist = avgDistance(:,1);
meanDf = avgDF(:,1);
ll = 0;

for z = [4,5,6,7,8,10,11,12,13,14]
for k=1:length(datum(z).pair)
    if ~isempty(datum(z).pair(k).epoch)
    for j=1:length(datum(z).pair(k).epoch)
        if ~isempty(datum(z).pair(k).epoch(j).avgDistance)
        meanDist = meanDist + datum(z).pair(k).epoch(j).avgDistance; 
        meanDf = meanDf + datum(z).pair(k).epoch(j).avgDF; 

%        figure(2); subplot(211); hold on; plot(datum(z).pair(k).epoch(j).avgDF - mean(datum(z).pair(k).epoch(j).avgDF))
        figure(2); subplot(211); hold on; plot(datum(z).pair(k).epoch(j).avgDF)
        figure(2); subplot(212); hold on; plot(datum(z).pair(k).epoch(j).avgDistance)
        ll = ll+1;
        end
    end
    end
end

end

figure(2); subplot(211); xline(200.5, 'g', 'LineWidth', 4)
    plot(meanDf/ll, 'k', 'LineWidth',6);
    
figure(2); subplot(212); xline(200.5, 'g', 'LineWidth', 4)
    plot(meanDist/ll, 'k', 'LineWidth',6);
    
% [~,ii] = max( [max(diff(datum(4).pair(2).epoch(2).avgDF)), max(-diff(datum(4).pair(2).epoch(2).avgDF))])

