
distanceThreshold = 10;
padding = 150;

avgDF(:,1) = zeros(1,1+(padding*2)); 
avgDistance(:,1) = zeros(1,1+(padding*2));

for z = 3


numCloseEncounters = 0;

for j = 1: length(caveDD.pair)

    if ~isempty(find(caveDD.pair(j).descartes < distanceThreshold, 1))
        
        idx = find(caveDD.pair(j).descartes < distanceThreshold);
        didx = diff(idx);

        if ~isempty(find(didx > 2, 1)) % More than one epoch

            % The first epoch.
            bigidxs = find(didx > 2);
            newidx(1) = round(mean(idx(idx(1):bigidxs(1))));
            % The second epoch
            if length(bigidxs) > 2
                newidx(2) = round(mean(idx(bigidxs(2):bigidxs(3))));
            end
            if length(bigidxs) == 2                
                newidx(2) = round(mean(idx(bigidxs(2):end)));
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

numCloseEncounters