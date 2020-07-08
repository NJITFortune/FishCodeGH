dat = AL(32).s;

subsample = 20;

Fs = dat(1).pFs;
sFs = Fs/subsample;

fprintf('There were %i S1 entries. \n', length(find([dat.sizeDX] == 1)));
fprintf('There were %i S2 entries. \n', length(find([dat.sizeDX] == 2)));
fprintf('There were %i S3 entries. \n', length(find([dat.sizeDX] == 3)));
fprintf('There were %i S4 entries. \n', length(find([dat.sizeDX] == 4)));
fprintf('There were %i M1 entries. \n', length(find([dat.sizeDX] == 5)));
fprintf('There were %i M2 entries. \n', length(find([dat.sizeDX] == 6)));
fprintf('There were %i M3 entries. \n', length(find([dat.sizeDX] == 7)));
fprintf('There were %i L entries. \n', length(find([dat.sizeDX] == 8)));

%fprintf('There were %i S1 entries. \n', length(find([dat.sizeDX] == 1)));

% Show the data from this neuron
figure(1); clf; hold on; 

    for j=1:length(dat) % For each stimulus entry
        if dat(j).pFs ~=0 % If there is data
            
        % Plot the data at y value *10 of entry number (to separate them)
        tim = 1/dat(j).pFs:1/dat(j).pFs:length(dat(j).pos)/dat(j).pFs;
        plot(tim, dat(j).pos + 10*j, 'k-');

        ySpikes = interp1(tim, dat(j).pos, dat(j).st);
        plot(dat(j).st, ySpikes + 10*j, 'b.', 'MarkerSize', 8);    
        end
    end
       
    
%% Concatonate all

        spiketimes = dat(1).st;
        pos = dat(1).pos(1:subsample:end);
        
        v = 0;
% Is the data vertical (1) or not (0)?

    if length(pos(1,:)) == 1
        pos = pos';
        spiketimes = spiketimes';
        v = 1;
    end
    
    vel = smooth(diff(pos)); vel(end+1) = vel(end);
    acc = smooth(diff(vel)); acc(end+1) = acc(end);
    vel = vel'; acc = acc';
    tim = 1/sFs:1/sFs:length(dat(1).pos(1:subsample:end))/sFs;

for j=2:length(dat)

    if ~isempty(dat(j).pFs)
        
            if v == 0 
                pos = [pos, dat(j).pos(1:subsample:end)];
                    vtmp = smooth(diff(dat(j).pos(1:subsample:end)));
                    vtmp(end+1) = vtmp(end);
                    atmp = smooth(diff(vtmp));
                    atmp(end+1) = atmp(end);
                vel = [vel, vtmp'];
                acc = [acc, atmp'];
                spiketimes = [spiketimes dat(j).st+tim(end)];
            end
            if v == 1
                pos = [pos, dat(j).pos(1:subsample:end)']; 
                    vtmp = smooth(diff(dat(j).pos(1:subsample:end)'));
                    vtmp(end+1) = vtmp(end);
                    atmp = smooth(diff(vtmp));
                    atmp(end+1) = atmp(end);
                vel = [vel, vtmp'];
                acc = [acc, atmp'];
                spiketimes = [spiketimes dat(j).st'+tim(end)];
            end
                                    
        tim = [tim tim(end)+(1/sFs:1/sFs:length(dat(j).pos(1:subsample:end))/sFs)];
        %length(pos)-length(tim)
        
    end % We had data
end % For every stimulus

% Make random spike train    
    ISIs = diff(spiketimes);
    randspikes(1) = spiketimes(1);
    for k = randperm(length(ISIs))
        randspikes(end+1) = randspikes(end) + ISIs(k);
    end
    
%% Get the STAs

    pSTA = iu_sta(spiketimes, randspikes, pos, sFs, 2);
    vSTA = iu_sta(spiketimes, randspikes, vel, sFs, 2);
    aSTA = iu_sta(spiketimes, randspikes, acc, sFs, 2);
    figure(3); clf; 
        subplot(311); hold on; plot(pSTA.time, pSTA.MEAN, 'b-'); plot(pSTA.time, pSTA.randMEAN, 'r-');
        subplot(312); hold on; plot(vSTA.time, vSTA.MEAN, 'b-'); plot(vSTA.time, vSTA.randMEAN, 'r-');
        subplot(313); hold on; plot(aSTA.time, aSTA.MEAN, 'b-'); plot(aSTA.time, aSTA.randMEAN, 'r-');


%% Histogram

asdf = iu_hist(spiketimes, randspikes, pos, vel, acc, sFs);


    
    