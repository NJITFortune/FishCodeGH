% load ~/NotCloudy/FrontiersCaveFish2023/CaveDataRev2018a.mat
% load ~/NotCloudy/FrontiersCaveFish2023/SurfaceDataRev2018a.mat
% load /Users/eric/Desktop/RecoverySSD2020/Downloads/SurfaceDataRev2018a.mat
% load /Users/eric/Desktop/RecoverySSD2020/Downloads/CaveDataRev2018a.mat

clear avgDF avgDistance allZs a ax b bigidxs caveDD didx dFThreshold idx j k newidx numCloseEncounters padding zSample usethese datum

dFThreshold = 6;
%distanceThreshold = 10;
padding = 250; % 200 is default
zz(199).pairs.epochs = [];

[b,a] = butter(3,0.05,'low');
[f,e] = butter(3,0.005,'high');
[hh,gg] = butter(3,0.2,'low');

avgDF(:,1) = zeros(1,1+(padding*2)); 
avgDistance(:,1) = zeros(1,1+(padding*2));
allZs = 0;

numCloseEncounters = 0;

for zSample = [3,4,5,6,7,8,10,11,12,13,14] % For every recording with more than one fish
%for z = [4]

    [caveDD, ~] = dFanalysis(cave(zSample)); % Make the array of pairwise encounters for that recordings

for j = 1:length(caveDD.pair) % For each pair in a recording

    filteredF = abs(filtfilt(f,e,filtfilt(b,a,(caveDD.pair(j).dF - mean(caveDD.pair(j).dF)))));

    if ~isempty(find(filteredF > dFThreshold, 1)) % If we find an appropriate dF
        
        idx = find(filteredF > dFThreshold);
            didx = diff(idx);

        if ~isempty(find(didx > 10, 1)) % More than one epoch

             bigidxs = find(didx > 10);

             bigidxs = [1 bigidxs' length(idx)];

            for rr=2:length(bigidxs) 
                newidx(rr-1) = idx(bigidxs(rr)) - round((idx(bigidxs(rr))-idx(1+bigidxs(rr-1)))/2); 
            end

        else % We found one epoch

            newidx = round(mean(idx));

        end
        

for k=1:length(newidx) % For each epoch that we found

       % Take only those epochs in the middle of a recording
       if newidx(k) - padding > 0 && newidx(k) + padding < length(caveDD.pair(j).descartes)

        numCloseEncounters = numCloseEncounters + 1;

% Now we will figure out if it is an up or down dF chirp, and center on the
% peak delta F

        deltaF = diff(caveDD.pair(j).dF(newidx(k)-padding:newidx(k)+padding));

         % MicroAdjustment of dF window (may run into indexing problems...)
         [maxdF, maxIDX] = max(abs(deltaF));

         tmpx = newidx(k) + (maxIDX - padding);
         if tmpx - padding > 0 && tmpx + padding < length(caveDD.pair(j).descartes)
            newidx(k) = tmpx; 
         end

            clear tmpx

        % Swap sign if the chirp dF is downwards
        datum(zSample).pair(j).epoch(k).avgDF = caveDD.pair(j).dF(newidx(k)-padding:newidx(k)+padding);
            if abs(min(deltaF)) == maxdF
                meanY = mean(datum(zSample).pair(j).epoch(k).avgDF);
                datum(zSample).pair(j).epoch(k).avgDF = meanY + (-1 * (datum(zSample).pair(j).epoch(k).avgDF - meanY));
            end


        datum(zSample).pair(j).epoch(k).avgDistance = filtfilt(hh,gg,caveDD.pair(j).descartes(newidx(k)-padding:newidx(k)+padding));
%        avgDistance(:,end+1) = filtfilt(hh,gg,caveDD.pair(j).descartes(newidx(k)-padding:newidx(k)+padding));

        %allZs(end+1) = zSample; 
        %zz(zSample).pairs(j).epochs(end+1) = k; 

       end

end


    end

end

end

% figure(1); clf; 
%     ax(1) = subplot(311); hold on; for j=1:length(avgDF(1,:)); plot(avgDF(:,j)-mean(avgDF(:,j))); end
%     ax(2) = subplot(312); plot(avgDF); 
%     ax(3) = subplot(313); plot(avgDistance);
%     subplot(312); hold on; plot(mean(avgDF'), 'k', 'LineWidth', 6);
%     subplot(313); hold on; plot(mean(avgDistance'), 'k', 'LineWidth', 6);
% 
%     linkaxes(ax, 'x')
% numCloseEncounters
% 
% ppa = unique(allZs(2:end));
% 
% for j=1:length(ppa)  % For each pair
%     curidxs = find(allZs==ppa(j));
%     for k = 1:length(curidxs) % Get the indices for each pair
%         tmpmindist(k) = mean(avgDistance(:,curidxs(k)));
%     end
%     [~,zzz] = min(tmpmindist);
%     usethese(j) = curidxs(zzz);
% end
% 
% figure(2); clf; 
%     axx(1) = subplot(311); hold on; for j=1:length(usethese); plot(avgDF(:,usethese(j))-mean(avgDF(:,usethese(j)))); end
%     axx(2) = subplot(312); plot(avgDF(:,usethese)); 
%     axx(3) = subplot(313); plot(avgDistance(:,usethese));
%     subplot(312); hold on; plot(mean(avgDF(:,usethese)'), 'k', 'LineWidth', 6);
%     subplot(313); hold on; plot(mean(avgDistance(:,usethese)'), 'k', 'LineWidth', 6);

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

figure(3); clf; xline(padding, 'g', 'LineWidth', 4);
    hold on; plot(meanDf/ll, 'k', 'LineWidth',6); hold off; 
    
figure(4); clf; xline(200.5, 'g', 'LineWidth', 4)
    hold on; plot(meanDist/ll, 'k', 'LineWidth',6); hold off;
