function out = PVA(in, ent, sz)
%Usage: out = postvelaccTOT(spikes, stim, Fs)

pFs = in(ent).s(1).pFs;

idx = find([in(ent).s.sizeDX] == sz);

tim = 0;
spikes = [];
stimPOS = [];

%% Concatonate data
if ~isempty(idx)

    for j = 1:length(idx)

        stimPOS = [stimPOS in(ent).s(idx(j)).pos'];

        spikes = [spikes (in(ent).s(idx(j)).st + tim(end))'];
        
        currtim = 1/pFs:1/pFs:length(in(ent).s(idx(j)).pos)/pFs;
        tim = [tim (currtim + tim(end))];
        
    end
        
    tim = tim(2:end); % Remove the initial zero
    
end

buff = 0.100; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[b,a] = butter(3, 30/Fs, 'low'); 
[d,c] = butter(5, 20/Fs, 'low'); 

% Make stimuli

    firstorder = filtfilt(b,a,diff(stimPOS)); % VELOCITY
    secondorder = filtfilt(d,c,diff(firstorder)); % ACCELERATION

    cpos = []; cvel = []; cacc = [];

for ss = length(spikes):-1:1
    
    tt = find(tim < spikes(ss) & tim > spikes(ss) - buff);
    cpos(ss) = mean(stimPOS(tt));
    cvel(ss) = mean(firstorder(tt));
    cacc(ss) = mean(secondorder(tt));

    pv(ss,:) = [cpos(ss) cvel(ss)];
    av(ss,:) = [cacc(ss) cvel(ss)];
    
end


%out.posvel = hist3(pv,{-6:0.01:6 -0.0012:.0024/128:0.0012});
out.posvel = hist3(pv,[20 20]);
out.accvel = hist3(av,[20 20]);

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
% figure(1); subplot(121); surf(oogabuug.posvel'); view(0,90); subplot(122); surf(oogabuug.accvel'); view(0,90);
% colormap('HOT');
% caxis([0 10]);

% figure(2); subplot(121); plot(oogabuug.pos, oogabuug.vel,'*'); subplot(122); plot(oogabuug.acc, oogabuug.vel, '*');


% save filename.mat oogabuug
end