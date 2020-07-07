dat = AL(16).s;

Fs = dat(1).pFs;
[b,a] = butter(3, 1 / (Fs/2), 'low');

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
figure(1); 
    clf;
    hold on; 
    for j=1:length(dat)
        yy = ones(length(dat(j).st));
        plot(dat(j).st, yy*j, 'k.', 'MarkerSize', 2);        
    end
    
figure(2); 
    clf;
    hold on; 
    for j=1:length(dat)
        if dat(j).pFs ~=0
        tim = 1/dat(j).pFs:1/dat(j).pFs:length(dat(j).pos)/dat(j).pFs;
        plot(tim, dat(j).pos + 10*j, 'k-');
        end
    end
   
    
%% Concatonate all

spiketimes = dat(1).st;
pos = dat(1).pos;

% Is the data vertical (1) or not (0)?
    v=0;
    if length(pos(1,:)) == 1
        pos = pos';
        spiketimes = spiketimes';
        v = 1;
    end
    
    tim = 1/dat(1).pFs:1/dat(1).pFs:length(dat(1).pos)/dat(1).pFs;

for j=2:length(dat)
    
    if ~isempty(dat(j).pFs) % Make sure that we have data first
        
        % Make the edges of the stimuli meet up so that we don't have
        % problems
        
        if dat(j).pos(1) ~= pos(end) % The position data has a jump between trials
            % Take 100 samples (1/10 second) before and and after the jump.
            if v == 0
                samp = pos(end-100:end); 
                samp = [samp, dat(j).pos(1:100)];
            end
            if v == 1
            	samp = pos(end-100:end); 
                samp = [samp, dat(j).pos(1:100)'];
            end

            ff = filtfilt(b,a,samp); 
            length(ff)
            
            pos(end-100:end+100) = ff;
            
            if v == 0
                pos = [pos, dat(j).pos(100:end)];
                spiketimes = [spiketimes dat(j).st+tim(end)];
            end
            if v == 1
                pos = [pos, dat(j).pos(100:end)'];
                spiketimes = [spiketimes dat(j).st'+tim(end)];
            end
            
        end
        
        if dat(j).pos(1) == pos(end)        
            if v == 0 
                pos = [pos, dat(j).pos]; 
                spiketimes = [spiketimes dat(j).st+tim(end)];
            end
            if v == 1
                pos = [pos, dat(j).pos']; 
                spiketimes = [spiketimes dat(j).st'+tim(end)];
            end
        end    
    
        tim = [tim tim(end)+(1/dat(j).pFs:1/dat(j).pFs:length(dat(j).pos)/dat(j).pFs)];
        
    end % We had data
end % For every stimulus


    vel = smooth(diff(pos)); vel(end+1) = vel(end);
    acc = smooth(diff(vel)); acc(end+1) = acc(end);

% Make random spike train    
    ISIs = diff(spiketimes);
    randspikes(1) = spiketimes(1);
    for k = randperm(length(ISIs))
        randspikes(end+1) = randspikes(end) + ISIs(k);
    end
    
%% Get the STAs

    asdf = iu_sta(spiketimes, randspikes, pos(1:10:end), 100, 4);
    figure(3); clf; hold on; plot(asdf.time, asdf.MEAN, 'b-'); plot(asdf.time, asdf.randMEAN, 'r-');


%% Get     
    
    