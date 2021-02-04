function out = ritaviewer(dat, neuronidx)

subsample = 20;

fprintf('There were %i S1 entries 1. \n', length(find([dat(neuronidx).s.sizeDX] == 1)));
fprintf('There were %i S2 entries 2. \n', length(find([dat(neuronidx).s.sizeDX] == 2)));
fprintf('There were %i S3 entries 3. \n', length(find([dat(neuronidx).s.sizeDX] == 3)));
fprintf('There were %i S4 entries 4. \n', length(find([dat(neuronidx).s.sizeDX] == 4)));
fprintf('There were %i M1 entries 5. \n', length(find([dat(neuronidx).s.sizeDX] == 5)));
fprintf('There were %i M2 entries 6. \n', length(find([dat(neuronidx).s.sizeDX] == 6)));
fprintf('There were %i M3 entries 7. \n', length(find([dat(neuronidx).s.sizeDX] == 7)));
fprintf('There were %i L entries 8. \n', length(find([dat(neuronidx).s.sizeDX] == 8)));

% Cycle for the data that we have
for k=1:8
    
    idx = find([dat(neuronidx).s.sizeDX] == k);
    
    if ~isempty(idx) % Is there data for this size stimulus?

    Fs = dat(neuronidx).s(idx(1)).pFs;
    sFs = Fs/subsample;
        
% Show the raw plot for this stimulus
    figure(5); clf; hold on; 

    for j=1:length(idx) % For each stimulus entry
            
        if ~isempty(dat(neuronidx).s(idx(j)).pos)
        % Plot the data at y value *10 of entry number (to separate them)
        tim = 1/dat(neuronidx).s(idx(j)).pFs:1/dat(neuronidx).s(idx(j)).pFs:length(dat(neuronidx).s(idx(j)).pos) / dat(neuronidx).s(idx(j)).pFs;
        plot(tim, dat(neuronidx).s(idx(j)).pos + 10*j, 'k-');
        text(1, 10*j, dat(neuronidx).s(idx(j)).size);
        end
        
        if dat(neuronidx).s(idx(j)).pFs ~= 0 % If there is data
            ySpikes = interp1(tim, dat(neuronidx).s(idx(j)).pos, dat(neuronidx).s(idx(j)).st);
            plot(dat(neuronidx).s(idx(j)).st, ySpikes + 10*j, 'b.', 'MarkerSize', 8);    
        end
    end 
    
    out = iu_3DhistA(dat, neuronidx, k);
    
    
        fprintf('Size %i : ', k);
        aa = input('Hit return when ready. \n');
    

    
    end % If we have data for this sample size

end % End cycle for each size

