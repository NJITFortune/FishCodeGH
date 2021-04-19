function out = PVA(in, ent, sz)
% Usage: out = PVA(structure, entry, sizeDX)

% Get the sample rate for position
pFs = in(ent).s(1).pFs;

% Get the entries for the size selected by the user
idx = find([in(ent).s.sizeDX] == sz);

% Preparations
tim = 0; % Starting time for the next sample as we concatonate
spikes = []; % List of spike times
stimPOS = []; % Position over time

%% Concatonate data
if ~isempty(idx) % just make sure that the user isn't an idiot 

    for j = 1:length(idx) % cycle to concatonate all of the correct entries

        stimPOS = [stimPOS in(ent).s(idx(j)).pos']; % Concatonate position
        currtim = 1/pFs:1/pFs:length(in(ent).s(idx(j)).pos)/pFs; % A time base for the currently added position

        spikes = [spikes (in(ent).s(idx(j)).st + tim(end))']; % Concatonate spike times, adding the time from the end of previous
        
        tim = [tim (currtim + tim(end))]; % Update the time base 
        
    end
        
    tim = tim(2:end); % When we are all done, we remove the initial zero
    
end

%% Derive the velocity and acceleration from position

    [b,a] = butter(3, 30/pFs, 'low'); % Filter for velocity
    [d,c] = butter(5, 20/pFs, 'low'); % Filter for acceleration

    vel = filtfilt(b,a,diff(stimPOS)); % VELOCITY
    acc = filtfilt(d,c,diff(vel)); % ACCELERATION

    
%% Get the pos/vel/acc values associated with each spike

windw = 0.100; % Time in seconds prior to spike to integrate
    
for ss = length(spikes):-1:1
    
    tt = find(tim < spikes(ss) & tim > spikes(ss) - windw);
    
    cpos(ss) = mean(stimPOS(tt));
    cvel(ss) = mean(vel(tt));
    cacc(ss) = mean(acc(tt));

    posVvel(ss,:) = [cpos(ss) cvel(ss)];
    accVvel(ss,:) = [cacc(ss) cvel(ss)];
    
end


%out.posvel = hist3(pv,{-6:0.01:6 -0.0012:.0024/128:0.0012});
out.posvel = hist3(posVvel,[20 20]);
out.accvel = hist3(accVvel,[20 20]);

out.pos = cpos;
out.vel = cvel;
out.acc = cacc;

%surf(out.posvel');view(0,90); caxis([0 5]);
%xlim([0 120]);
%ylim([0 102]);
%% Useful Commands

% Fs = 1/bg_2015_Ch2.interval; 
% tim = 1/Fs:1/Fs:bg_2015_Ch2.length/Fs;
% plot(tim, bg_2015_Ch2.values);
%
% oogabuug = posvelacc(bg_2015_Ch405.times, bg_2015_Ch2.values, bg_2015_Ch31.times, 20, Fs);
figure(1); clf;
    subplot(121); surf(out.posvel'); view(0,90); 
    subplot(122); surf(out.accvel'); view(0,90);
colormap('HOT');
figure(27); clf;
    subplot(311); histogram(out.pos);
    subplot(312); histogram(out.vel);
    subplot(313); histogram(out.acc);

% caxis([0 10]);

% figure(2); subplot(121); plot(oogabuug.pos, oogabuug.vel,'*'); subplot(122); plot(oogabuug.acc, oogabuug.vel, '*');


% save filename.mat oogabuug
end