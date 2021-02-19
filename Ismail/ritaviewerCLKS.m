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

    Fs = dat(neuronidx).s(idx(1)).pFs;
    sFs = Fs/subsample;
    [b,a] = butter(3, 2/(Fs/2), 'low'); % Filter for velocity
    [d,c] = butter(3, 2/(Fs/2), 'low'); % Filter for acceleration
        
% Show the raw plot for this stimulus
    figure(5); clf; hold on; title('Position');
    figure(6); clf; hold on; title('Velocity');
    figure(7); clf; hold on; title('Acceleration');

    for j=1:length(idx) % For each stimulus entry
            
        if ~isempty(dat(neuronidx).s(idx(j)).pos)
            
    % Make velocity and acceleration plots        
    vel = filtfilt(b,a,diff(dat(neuronidx).s(idx(j)).pos)); % VELOCITY
        vel(end+1) = vel(end);
    acc = filtfilt(d,c,diff(vel)); % ACCELERATION
        acc(end+1) = acc(end);
        vel = 500*vel'; acc = 100000*acc';
            
            
            figure(5); % Position
        % Plot the data at y value *10 of entry number (to separate them)
        tim = 1/dat(neuronidx).s(idx(j)).pFs:1/dat(neuronidx).s(idx(j)).pFs:length(dat(neuronidx).s(idx(j)).pos) / dat(neuronidx).s(idx(j)).pFs;
%        plot(tim, dat(neuronidx).s(idx(j)).pos + 10*j, 'k-');
%        plot(tim, dat(neuronidx).s(idx(j)).pos, 'k-');
        text(1, 10*j, dat(neuronidx).s(idx(j)).size);
            figure(6); % Velocity
        % Plot the data at y value *10 of entry number (to separate them)
%        plot(tim, vel + 10*j, 'k-');
        plot(tim, vel, 'k-');
        text(1, 10*j, dat(neuronidx).s(idx(j)).size);
            figure(7); % Acceleration
        % Plot the data at y value *10 of entry number (to separate them)
%        plot(tim, acc + 10*j, 'k-');
%        plot(tim, acc, 'k-');
        text(1, 10*j, dat(neuronidx).s(idx(j)).size);
        end
        
        if dat(neuronidx).s(idx(j)).pFs ~= 0 % If there is data
            figure(5);
            ySpikes = interp1(tim, dat(neuronidx).s(idx(j)).pos, dat(neuronidx).s(idx(j)).st);
%            plot(dat(neuronidx).s(idx(j)).st, ySpikes + 10*j, 'b.', 'MarkerSize', 8);    
            plot(dat(neuronidx).s(idx(j)).st + 2*(rand-0.5), ySpikes, 'b.', 'MarkerSize', 8);    
            figure(6);
            ySpikes = interp1(tim, vel, dat(neuronidx).s(idx(j)).st);
%            plot(dat(neuronidx).s(idx(j)).st, ySpikes + 10*j, 'r.', 'MarkerSize', 8);    
            plot(dat(neuronidx).s(idx(j)).st + 2*(rand-0.5), ySpikes, 'r.', 'MarkerSize', 8);    
            figure(7);
            ySpikes = interp1(tim, acc, dat(neuronidx).s(idx(j)).st);
%            plot(dat(neuronidx).s(idx(j)).st, ySpikes + 10*j, 'm.', 'MarkerSize', 8);    
            plot(dat(neuronidx).s(idx(j)).st + 2*(rand-0.5), ySpikes, 'm.', 'MarkerSize', 8);    
        end
    end 
    
    out = iu_3DhistA(dat, neuronidx, k);
    
    
        fprintf('Size %i : ', k);
        aa = input('Hit return when ready. \n');
    

    
    end % If we have data for this sample size

end % End cycle for each size

