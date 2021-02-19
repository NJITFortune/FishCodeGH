function out = ritaviewerCLKS(dat, neuronidx)

subsample = 20;

fprintf('There were %i S1 entries 1. \n', length(find([dat(neuronidx).s.sizeDX] == 1)));
fprintf('There were %i S2 entries 2. \n', length(find([dat(neuronidx).s.sizeDX] == 2)));
fprintf('There were %i S3 entries 3. \n', length(find([dat(neuronidx).s.sizeDX] == 3)));
fprintf('There were %i S4 entries 4. \n', length(find([dat(neuronidx).s.sizeDX] == 4)));
fprintf('There were %i M1 entries 5. \n', length(find([dat(neuronidx).s.sizeDX] == 5)));
fprintf('There were %i M2 entries 6. \n', length(find([dat(neuronidx).s.sizeDX] == 6)));
fprintf('There were %i M3 entries 7. \n', length(find([dat(neuronidx).s.sizeDX] == 7)));
fprintf('There were %i L entries 8. \n', length(find([dat(neuronidx).s.sizeDX] == 8)));
fprintf('\n');
fprintf('Hopefully there are %i total entries.\n', length(find([dat(neuronidx).s.sizeDX])));

% Cycle for the data that we have
for k=1:8
    
    idx = [];
    for omg = length(dat(neuronidx).s):-1:1
        if dat(neuronidx).s(omg).sizeDX == k 
            idx(end+1) = omg;
        end
    end
    
    if ~isempty(idx) % Is there data for this size stimulus?

    totalspikes = [];        
%     Fs = dat(neuronidx).s(idx(1)).pFs;
%     sFs = Fs/subsample;
%     [b,a] = butter(3, 2/(Fs/2), 'low'); % Filter for velocity
%     [d,c] = butter(3, 2/(Fs/2), 'low'); % Filter for acceleration
        
% Show the raw plot for this stimulus
    figure(1); clf; hold on; title('Position spikes');
    figure(2); clf; hold on; title('Position histogram');

    for j=1:length(idx) % For each stimulus entry
                    
        if dat(neuronidx).s(idx(j)).pFs ~= 0 % If there is data
        tim = 1/dat(neuronidx).s(idx(j)).pFs:1/dat(neuronidx).s(idx(j)).pFs:length(dat(neuronidx).s(idx(j)).pos) / dat(neuronidx).s(idx(j)).pFs;
            
            figure(1); text(1, 10*j, dat(neuronidx).s(idx(j)).size);
            ySpikes = interp1(tim, dat(neuronidx).s(idx(j)).pos, dat(neuronidx).s(idx(j)).st);
            tmp = size(ySpikes); if tmp(1) ~= 1; ySpikes = ySpikes'; end
            plot(ySpikes, dat(neuronidx).s(idx(j)).st + 2*(rand(1,length(dat(neuronidx).s(idx(j)).st))-0.5),  'b.', 'MarkerSize', 8);    
            xlim([-5 5]);
            
            totalspikes = [totalspikes ySpikes];
                       
            
        end
    end 

            figure(2);    
            POSedges = -5:0.5:5;
            spikebins = histcounts(ySpikes, POSedges);

            bar(-4.37:0.46:4.5, spikebins); xlim([-5 5]);

    
        aa = input('Hit return when ready. \n');
    

    
    end % If we have data for this sample size

end % End cycle for each size

