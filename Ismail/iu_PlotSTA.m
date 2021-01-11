function asdf = iu_PlotSTA(data, entry, tims)
% asdf = iu_PlotSTA(data, entry, tims)
% Plots spike triggered averages
% asdf is our output structure (not set at the moment)
% data should be the variable 'ismail' loaded from merged_data.mat (rita1assignment)
% entry is the index number
% tims are the start and end times, e.g. [30 60] would be between 30 and 60 seconds
% Load data first! Relies on iu_sta.m

%% Setup
    strtim = tims(1); % Start time 
    endtim = tims(2); % End time

    % Get the spikes within the time window defined by the user in tims
    spks = data(entry).spikes.times(data(entry).spikes.times > strtim & data(entry).spikes.times < endtim);
    rspks = data(entry).spikes_rand.times(data(entry).spikes_rand.times > strtim & data(entry).spikes_rand.times < endtim);

    % tt is a list of indices for the tracking data in the time window of interest
    tt = find(data(entry).time > tims(1) & data(entry).time < tims(2));
    % ss is a list of indices for spike data in the time window of interest
    ss = find(data(entry).spikes.times > strtim & data(entry).spikes.times < endtim);

asdf  = 0;



% k=1% Entry number
% startim = 0;
% endtim = 90;
% % Load your data first (downsampled_data.mat)
% 


% spks = spikes.times(spikes.times > strtim & spikes.times < endtim);
% rspks = spikes_rand.times(spikes_rand.times > endtim & spikes_rand.times < strtim);

% spks = ismail(k).spikes.times;
% rspks = ismail(k).spikes_rand.times;

% spks = spikes.times;
% rspks = spikes_rand.times;

%% Calculate spike triggered averages
    fprintf('Calculating fish_pos STA.\n');
    fpos = iu_sta(spks, rspks, data(entry).fish_pos, data(entry).Fs, 2);
    fprintf('Calculating fish_vel STA.\n');
    fvel = iu_sta(spks, rspks, data(entry).fish_vel, data(entry).Fs, 2);
    fprintf('Calculating fish_acc STA.\n');
    facc = iu_sta(spks, rspks, data(entry).fish_acc, data(entry).Fs, 2);
    fprintf('Calculating Fish_jerk STA.\n');
    fjerk = iu_sta(spks, rspks, data(entry).fish_jerk, data(entry).Fs, 2);

    fprintf('Calculating error_pos STA.\n');
    epos = iu_sta(spks, rspks, data(entry).error_pos, data(entry).Fs, 2);
    fprintf('Calculating error_vel STA.\n');
    evel = iu_sta(spks, rspks, data(entry).error_vel, data(entry).Fs, 2);
    fprintf('Calculating error_acc STA.\n');
    eacc = iu_sta(spks, rspks, data(entry).error_acc, data(entry).Fs, 2);
    fprintf('Calculating error_jerk STA.\n');
    ejerk = iu_sta(spks, rspks, data(entry).error_jerk, data(entry).Fs, 2);
    
    fprintf('And we are done!!!\n');

    %% Figure 1: Fish
    figure(1); clf; 

    subplot(2,2,1); title('Fish Position'); hold on;
    plot([0, 0], [min(fpos.MEAN), max(fpos.MEAN)], 'k-', 'LineWidth',1);
    plot(fpos.time, fpos.MEAN, 'b-', 'LineWidth', 3);
    plot(fpos.time, fpos.randMEAN,'r-','LineWidth',3);

    subplot(222); title('Fish Acceleration'); hold on;
    plot([0, 0], [min(facc.MEAN), max(facc.MEAN)], 'k-', 'LineWidth',1);
    plot(facc.time, facc.MEAN, 'b-', 'LineWidth', 3);
    plot(facc.time, facc.randMEAN,'r-','LineWidth',3);

    subplot(223); title('Fish Velocity'); hold on;
    plot([0, 0], [min(fvel.MEAN), max(fvel.MEAN)], 'k-', 'LineWidth',1);
    plot(fvel.time, fvel.MEAN, 'b-', 'LineWidth', 3);
    plot(fvel.time, fvel.randMEAN,'r-','LineWidth',3);
    
    subplot(224); title('Fish Jerk'); hold on;
    plot([0, 0], [min(fjerk.MEAN), max(fjerk.MEAN)], 'k-', 'LineWidth',1);
    plot(fjerk.time, fjerk.MEAN, 'b-', 'LineWidth', 3);
    plot(fjerk.time, fjerk.randMEAN,'r-','LineWidth',3);

    %% Figure 2: Error
    figure(2); clf; 

    subplot(2,2,1); title('Error Position'); hold on;
    plot([0, 0], [min(epos.MEAN), max(epos.MEAN)], 'k-', 'LineWidth',1);
    plot(epos.time, epos.MEAN, 'b-', 'LineWidth', 3);
    plot(epos.time, epos.randMEAN,'r-','LineWidth',3);

    subplot(222); title('Error Acceleration'); hold on;
    plot([0, 0], [min(eacc.MEAN), max(eacc.MEAN)], 'k-', 'LineWidth',1);
    plot(eacc.time, eacc.MEAN, 'b-', 'LineWidth', 3);
    plot(eacc.time, eacc.randMEAN,'r-','LineWidth',3);

    subplot(223); title('Error Velocity'); hold on;
    plot([0, 0], [min(evel.MEAN), max(evel.MEAN)], 'k-', 'LineWidth',1);
    plot(evel.time, evel.MEAN, 'b-', 'LineWidth', 3);
    plot(evel.time, evel.randMEAN,'r-','LineWidth',3);
    
    subplot(224); title('Error Jerk'); hold on;
    plot([0, 0], [min(ejerk.MEAN), max(ejerk.MEAN)], 'k-', 'LineWidth',1);
    plot(ejerk.time, ejerk.MEAN, 'b-', 'LineWidth', 3);
    plot(ejerk.time, ejerk.randMEAN,'r-','LineWidth',3);

%% Plot the error

figure(3); clf; 

    subplot(221); title('STD Error Position'); hold on;
    plot([0, 0], [min(epos.STD), max(epos.STD)], 'k-', 'LineWidth',1);
    plot(epos.time, epos.STD, 'b-', 'LineWidth', 3);
    plot(epos.time, epos.randSTD, 'r-', 'LineWidth', 3);

    subplot(222); title('STD Error Acceleration'); hold on;
    plot([0, 0], [min(eacc.STD), max(eacc.STD)], 'k-', 'LineWidth',1);
    plot(eacc.time, eacc.STD, 'b-', 'LineWidth', 3);
    plot(eacc.time, eacc.randSTD, 'r-', 'LineWidth', 3);

    subplot(223); title('STD Error Velocity'); hold on;
    plot([0, 0], [min(evel.STD), max(evel.STD)], 'k-', 'LineWidth',1);
    plot(evel.time, evel.STD, 'b-', 'LineWidth', 3);
    plot(evel.time, evel.randSTD, 'r-', 'LineWidth', 3);

    subplot(224); title('STD Error Jerk'); hold on;
    plot([0, 0], [min(ejerk.STD), max(ejerk.STD)], 'k-', 'LineWidth',1);
    plot(ejerk.time, ejerk.STD, 'b-', 'LineWidth', 3);
    plot(ejerk.time, ejerk.randSTD, 'r-', 'LineWidth', 3);

    %% Plot the raw data
    
    figure(4); clf;
    
    ax(1) = subplot(311); hold on; title('Position');
        plot(data(entry).time(tt), data(entry).shuttle_pos(tt), 'b-'); 
        plot(data(entry).time(tt), data(entry).fish_pos(tt), 'm-'); 
        plot(spks, data(entry).spikes.fish_pos(ss), 'k.', 'MarkerSize',6);
    
    ax(2) = subplot(312); hold on; title('Velocity');
        plot(data(entry).time(tt), data(entry).shuttle_vel(tt), 'b-'); 
        plot(data(entry).time(tt), data(entry).fish_vel(tt), 'm-'); 
        plot(spks, data(entry).spikes.fish_vel(ss), 'k.', 'MarkerSize',6);

    ax(3) = subplot(313); hold on; title('Acceleration');
        plot(data(entry).time(tt), data(entry).shuttle_acc(tt), 'b-'); 
        plot(data(entry).time(tt), data(entry).fish_acc(tt), 'm-'); 
        plot(spks, data(entry).spikes.fish_acc(ss), 'k.', 'MarkerSize',6);
        
    linkaxes(ax, 'x');