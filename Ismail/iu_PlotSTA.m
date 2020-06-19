function asdf = iu_PlotSTA(data, entry, tims)
strtim = tims(1);
endtim = tims(2);
spks = data(entry).spikes.times(data(entry).spikes.times > strtim & data(entry).spikes.times < endtim);
rspks = data(entry).spikes_rand.times(data(entry).spikes_rand.times > strtim & data(entry).spikes_rand.times < endtim);
tt = find(data(entry).time>tims(1) & data(entry).time<tims(2));
% function asdf = iu_PlotSTA(data, entry, tims)
% Plots spike triggered averages
% asdf is our output structure (not set at the moment)
% data is ismail
% entry is the index for ismail, e.g. 3 for ismail(3)
% tims are the start and end times, e.g. [30 60] would be between 30 and 60 seconds
% Plot spike triggered averages for error_pos, error_vel, error_acc, and error_jerk
% Load data first! Relies on iu_sta.m

%entry=1;
%strtim = 0;
%endtim = 30;

%spks = data(entry).spikes.times(data(entry).spikes.times > tims(strtim) & data(entry).spikes.times < tims(endtim));
%rspks = data(entry).spikes_rand.times(data(entry).spikes_rand.times > tims(strtim) & data(entry).spikes_rand.times < tims(endtim));


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
    fprintf('Calculating error_pos STA.\n');
    epos = iu_sta(spks, rspks, data(entry).fish_pos, data(entry).Fs, 2);
    fprintf('Calculating error_vel STA.\n');
    evel = iu_sta(spks, rspks, data(entry).fish_vel, data(entry).Fs, 2);
    fprintf('Calculating error_acc STA.\n');
    eacc = iu_sta(spks, rspks, data(entry).fish_acc, data(entry).Fs, 2);
    fprintf('Calculating error_jerk STA.\n');
    ejerk = iu_sta(spks, rspks, data(entry).fish_jerk, data(entry).Fs, 2);
    fprintf('And we are done!!!\n');

    %% Plot them all in one figure
    figure(1); clf; 

    subplot(2,2,1); title('Position'); hold on;
    plot([0, 0], [min(epos.MEAN), max(epos.MEAN)], 'k-', 'LineWidth',1);
    plot(epos.time, epos.MEAN, 'b-', 'LineWidth', 3);
    plot(epos.time, epos.randMEAN,'r-','LineWidth',3);

    subplot(222); title('Acceleration'); hold on;
    plot([0, 0], [min(eacc.MEAN), max(eacc.MEAN)], 'k-', 'LineWidth',1);
    plot(eacc.time, eacc.MEAN, 'b-', 'LineWidth', 3);
    plot(eacc.time, eacc.randMEAN,'r-','LineWidth',3);

    subplot(223); title('Velocity'); hold on;
    plot([0, 0], [min(evel.MEAN), max(evel.MEAN)], 'k-', 'LineWidth',1);
    plot(evel.time, evel.MEAN, 'b-', 'LineWidth', 3);
    plot(evel.time, evel.randMEAN,'r-','LineWidth',3);
    
    subplot(224); title('Jerk'); hold on;
    plot([0, 0], [min(ejerk.MEAN), max(ejerk.MEAN)], 'k-', 'LineWidth',1);
    plot(ejerk.time, ejerk.MEAN, 'b-', 'LineWidth', 3);
    plot(ejerk.time, ejerk.randMEAN,'r-','LineWidth',3);

%% Plot the error

figure(2); clf; 

    subplot(221); title('Position'); hold on;
    plot([0, 0], [min(epos.STD), max(epos.STD)], 'k-', 'LineWidth',1);
    plot(epos.time, epos.STD, 'b-', 'LineWidth', 3);
    plot(epos.time, epos.randSTD, 'r-', 'LineWidth', 3);

    subplot(222); title('Acceleration'); hold on;
    plot([0, 0], [min(eacc.STD), max(eacc.STD)], 'k-', 'LineWidth',1);
    plot(eacc.time, eacc.STD, 'b-', 'LineWidth', 3);
    plot(eacc.time, eacc.randSTD, 'r-', 'LineWidth', 3);

    subplot(223); title('Velocity'); hold on;
    plot([0, 0], [min(evel.STD), max(evel.STD)], 'k-', 'LineWidth',1);
    plot(evel.time, evel.STD, 'b-', 'LineWidth', 3);
    plot(evel.time, evel.randSTD, 'r-', 'LineWidth', 3);

    subplot(224); title('Jerk'); hold on;
    plot([0, 0], [min(ejerk.STD), max(ejerk.STD)], 'k-', 'LineWidth',1);
    plot(ejerk.time, ejerk.STD, 'b-', 'LineWidth', 3);
    plot(ejerk.time, ejerk.randSTD, 'r-', 'LineWidth', 3);

    %% Plot the raw data
    
    figure(3); clf;
    
    plot(data(entry).time(tt), data(entry).shuttle_vel(tt), 'b-'); 
    hold on; 
    z=zeros(1,length(spks));
    plot(spks,z,'.','MarkerSize',6);