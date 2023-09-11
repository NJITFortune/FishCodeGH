%% Load data
load brown2019_04_14_merged_new2.mat


%% Prep

spikeSampleTime = [49.76 49.87];

nFs = 1/raw_data.interval;
nTim = 1/nFs:1/nFs:raw_data.length/nFs;

sFs = 1/error_velocity.interval;
sTim = 1/sFs:1/sFs:error_velocity.length/sFs;

figure(1); clf; set(gcf, 'renderer', 'painters');

ax(1) = subplot(211); hold on;
    plot(nTim(1:2:end), raw_data.values(1:2:end), 'k-');

    numSpikes = length(find(spikes.codes == 4));
    plot(spikes.times(spikes.codes == 4), 0.0400 * ones(1,numSpikes), 'm.');

    numSpikes = length(find(spikes.codes == 3));
    plot(spikes.times(spikes.codes == 3), 0.0375 * ones(1,numSpikes), 'b.');

    plot(spikeSampleTime, [0.09 0.09], 'LineWidth', 6, 'Color', '#808080');

ax(2) = subplot(212); hold on;
    yyaxis left; plot(sTim, error_velocity.values); ylabel('Error Velocity')
    yyaxis right; plot(sTim, fish_acceleration.values); ylabel('Fish Acceleration')

linkaxes(ax, 'x');

xlim([47 52])

%%
figure(2); clf; hold on; set(gcf, 'renderer', 'painters');

    plot(nTim, raw_data.values, 'k-');

    numSpikes = length(find(spikes.codes == 4));
    plot(spikes.times(spikes.codes == 4), 0.0400 * ones(1,numSpikes), 'mo', 'MarkerSize', 8);

    numSpikes = length(find(spikes.codes == 3));
    plot(spikes.times(spikes.codes == 3), 0.0375 * ones(1,numSpikes), 'bo', 'MarkerSize', 8);

    xlim(spikeSampleTime)