% load ~/NotCloudy/FrontiersCaveFish2023/CaveDataRev2018a.mat
% load ~/NotCloudy/FrontiersCaveFish2023/SurfaceDataRev2018a.mat
% load /Users/eric/Desktop/RecoverySSD2020/Downloads/SurfaceDataRev2018a.mat
% load /Users/eric/Desktop/RecoverySSD2020/Downloads/CaveDataRev2018a.mat

clear avgDF avgDistance a ax b bigidxs caveDD didx distanceThreshold idx j k newidx numCloseEncounters padding z


distanceThreshold = 5;
padding = 200;


[b,a] = butter(3,0.05,'low');

avgDF(:,1) = zeros(1,1+(padding*2)); 
avgDistance(:,1) = zeros(1,1+(padding*2));

numCloseEncounters = 0;

for z = [3,4,5,6,7,8,10,11,12,13,14]

    [caveDD, ~] = dFanalysis(cave(z));

for j = 1: length(caveDD.pair)

    filtereDistance = filtfilt(b,a,caveDD.pair(j).descartes);

    if ~isempty(find(filtereDistance < distanceThreshold, 1))
        
        idx = find(filtereDistance < distanceThreshold);
            didx = diff(idx);

        if ~isempty(find(didx > 2, 1)) % More than one epoch

             bigidxs = find(didx > 10);

             bigidxs = [1 bigidxs' length(idx)];

            for rr=2:length(bigidxs) 
                newidx(rr-1) = idx(bigidxs(rr)) - round((idx(bigidxs(rr))-idx(1+bigidxs(rr-1)))/2); 
            end

        else % we have one epoch

            newidx = round(mean(idx));

        end
        
       % Take only those epochs in the middle of a recording

for k=1:length(newidx)

       if newidx(k) - padding > 0 && newidx(k) + padding < length(caveDD.pair(j).descartes)

        numCloseEncounters = numCloseEncounters + 1;

        avgDF(:,end+1) = caveDD.pair(j).dF(newidx(k)-padding:newidx(k)+padding);
        avgDistance(:,end+1) = caveDD.pair(j).descartes(newidx(k)-padding:newidx(k)+padding);

       end
end

    end

end

end

figure(1); clf; 
    ax(1) = subplot(311); hold on; for j=1:length(avgDF(1,:)); plot(avgDF(:,j)-mean(avgDF(:,j))); end
    ax(2) = subplot(312); plot(avgDF); 
    ax(3) = subplot(313); plot(avgDistance);
    subplot(312); hold on; plot(mean(avgDF'), 'k', 'LineWidth', 2);
    subplot(312); hold on; plot(median(avgDF'), 'g', 'LineWidth', 2);
    subplot(313); hold on; plot(mean(avgDistance'), 'k', 'LineWidth', 2);
    subplot(313); hold on; plot(median(avgDistance'), 'g', 'LineWidth', 2);

    linkaxes(ax, 'x')
numCloseEncounters