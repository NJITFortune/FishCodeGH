function out = iu_sta(spikes, randspikes, sig, Fs, wid)
% Function out = iu_sta(spikes, randspikes, sig, Fs, wid)
% spikes are the spike times
% randspikes are shuffled spike times
% sig is the signal (e.g. error_vel) of interest. Behavior...
% Fs is the sample rate (usually 25 for these data, fs = 25
% wid is the width of the spike triggered average in seconds (1 or 2 seconds is good)

tim = 1/Fs:1/Fs:length(sig)/Fs; % Time stamps for the duration of the signal.


% Generate one set of random spikes. We should probably do this several times.
if isempty(randspikes)
    randspikes(1) = 0.0027; % Just a "random" first spike time to get things started.
    ISIs = diff(spikes);
    for k = randperm(length(ISIs))
        randspikes(end+1) = randspikes(end) + ISIs(k);
    end
end

% For every spike get the time "wid" before and after
% the time of the spike.
parfor idx = 1:length(spikes)
    if spikes(idx) > wid && spikes(idx) < tim(end)-wid % Make sure that the window does not go before or after the signal.
        temp = interp1(tim, sig, spikes(idx)-wid:1/Fs:spikes(idx)+wid); % Copy the signal 
        sta(idx,:) = temp; % Put the signal into a temporary structure
    end
    if randspikes(idx) > wid && randspikes(idx) < tim(end)-wid % Make sure that the window does not go before or after the signal.
        temp = interp1(tim, sig, randspikes(idx)-wid:1/Fs:randspikes(idx)+wid);    
        sta_rand(idx,:) = temp;
    end
end

%% Finish up
    out.stadata = sta;
    out.MEAN  = nanmean(sta,1); % Calculate the mean (which is the STA)
    out.STD  = nanstd(sta,0,1); % Get the standard deviation for each point.

    out.randdata = sta_rand;
    out.randMEAN  = nanmean(sta_rand,1);
    out.randSTD  = nanstd(sta_rand,0,1);

    out.time = -wid:1/Fs:wid; % Give the user a time base for plotting.

% Get the Pvalue for each time bin - when was it different?
for j=length(out.stadata(1,:)):-1:1 
    [~, out.Pval(j), ~, ~] = ttest2(out.stadata(:,j),out.randdata(:,j)); 
end


% figure(10); clf
% hold on;
% for j=1:200:length(sta(:,1))
%     plot(out.time, sta(j,:));
% end
%     plot(out.time, out.MEAN, 'b-', 'LineWidth', 3);
%     plot(out.time, out.randMEAN,'r-','LineWidth',3);
%     xlabel('Time (s)')

 
