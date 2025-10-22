%% This is a script to make the initial raw data plot for Figure 1

%% Load data
% load brown2019_04_14_merged_new2.mat
% load /Users/eric/Downloads/uyanik_neurophys/raw/brown2019_04_14_merged_new2.mat
% load /Users/eric/NotCloudy/UyanikFinalPutsch/uyanik_neurophys/raw/brown2019_04_14_merged_new2.mat
% load /Users/eric/Downloads/brown2019_04_14_merged_new2.mat
% load /Users/efortune/Downloads/brown2019_04_14_merged_new2.mat
load /Users/eric/Documents/uyanik_neurophys/raw/brown2019_04_14_merged_new2.mat


%% Preparations

% This is a very nice window to show activity relative to the kinematics
spikeSampleTime = [49.76 49.87];

nFs = 1/raw_data.interval; % Sample rate
nTim = 1/nFs:1/nFs:raw_data.length/nFs; % Time steps for plotting
tt = find(nTim > 45 & nTim < 55); %

sFs = 1/error_velocity.interval;
sTim = 1/sFs:1/sFs:error_velocity.length/sFs;
stt = find(sTim > 45 & sTim < 55);


%% Plot the raw data plot with spikes, spike times, and kinematics
figure(1); clf; set(gcf, 'renderer', 'painters');

% Neurophysiology
ax(1) = subplot(211); hold on;

    % Raw neurophysiology trace
    plot(nTim(tt(1:2:end)), raw_data.values(tt(1:2:end)), 'k-'); 

    % Plot the spike times for units 4 and 3
    tmpSpikes = spikes.times(spikes.codes == 4);
    tmpSpikes = tmpSpikes(tmpSpikes > 45 & tmpSpikes < 55);
    for j=1:length(tmpSpikes)
        plot([tmpSpikes(j), tmpSpikes(j)], [0.0900, 0.0950], 'm');
    end
    
    tmpSpikes = spikes.times(spikes.codes == 3);
    tmpSpikes = tmpSpikes(tmpSpikes > 45 & tmpSpikes < 55);
    for j=1:length(tmpSpikes)
        plot([tmpSpikes(j), tmpSpikes(j)], [0.0800, 0.0850], 'b');
    end

    % This is the bar that indicates our cutout window inset (figure(2))
    plot(spikeSampleTime, [0.0875 0.0875], 'LineWidth', 6, 'Color', '#808080'); 

% Kinematics
ax(2) = subplot(212); hold on;
    yyaxis left; plot(sTim(stt), error_velocity.values(stt)); ylabel('Error Velocity')
    yyaxis right; plot(sTim(stt), fish_acceleration.values(stt)); ylabel('Fish Acceleration')

linkaxes(ax, 'x');

% A nice 5 second duration window for the paper
xlim([47 52])

%% Plot the inset that shows relations between spike times and raw physiology trace
figure(2); clf; hold on; set(gcf, 'renderer', 'painters');

    plot(nTim, raw_data.values, 'k-');

    numSpikes = length(find(spikes.codes == 4));
    plot(spikes.times(spikes.codes == 4), 0.0400 * ones(1,numSpikes), 'mo', 'MarkerSize', 8);

    numSpikes = length(find(spikes.codes == 3));
    plot(spikes.times(spikes.codes == 3), 0.0375 * ones(1,numSpikes), 'bo', 'MarkerSize', 8);

    xlim(spikeSampleTime)


%% Plot 100 example waveforms of each of the two spikes to show clustering
figure(3); clf; set(gcf, 'renderer', 'painters');

tmpSpikes = spikes.times(spikes.codes == 3);
subplot(121); hold on; for j=1:100;plot(raw_data.values(nTim > tmpSpikes(j)-0.00001 & nTim < tmpSpikes(j)+0.0081)); end 
xlim([1 25]); ylim([-0.06 0.1]);
tmpSpikes = spikes.times(spikes.codes == 4);
subplot(122); hold on; for j=1:100;plot(raw_data.values(nTim > tmpSpikes(j)-0.0001 & nTim < tmpSpikes(j)+0.0009)); end 
xlim([1 25]); ylim([-0.06 0.1]);

