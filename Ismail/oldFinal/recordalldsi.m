% Define all fish and neuron combinations
fish_neuron_pairs = [
    1,1; 1,2; 1,3; 1,4; 1,5; 1,6;
    2,1; 2,2; 2,3; 2,4; 2,5; 2,6; 2,7; 2,8;
    3,1; 3,2; 3,3; 3,4; 3,5; 3,6;
    4,1; 4,2; 4,3; 4,4; 4,5; 4,6;
    5,1; 5,2; 5,3; 5,4; 5,5;
    6,1; 6,2; 6,3; 6,4; 6,5; 6,6; 6,7; 6,8;
    7,1; 7,2; 7,3; 7,4;
    8,1; 8,2; 8,3; 8,4; 8,5; 8,6; 8,7;
    9,2; 9,3; 9,4;
    10,1; 10,2; 10,3; 10,4; 10,5; 10,6; 10,7; 10,8; 10,9;
    11,1; 11,2; 11,3; 11,5;
    12,1; 12,2; 12,3;
    13,1; 13,2; 13,3; 13,4; 13,5
];

% Initialize results storage
results = [];

% Loop through each fish-neuron pair
for idx = 1:size(fish_neuron_pairs,1)
    f = fish_neuron_pairs(idx,1);
    n = fish_neuron_pairs(idx,2);

    % Extract spike times for the current neuron
    spikes = curfish(f).spikes.times(curfish(f).spikes.codes == n);

    % Skip if no spikes are found
    if isempty(spikes)
        continue;
    end

    % Prepare kinematic signals
    Esig = u_signalprep(curfish(f).error_pos);
    Fsig = u_signalprep(curfish(f).fish_pos);

    sigEV = Esig.vel;
    sigFA = Fsig.acc;

    % Sampling rate
    Fs = 25;
    time = (0:(length(sigEV)-1))/Fs;

    % Interpolate kinematic signals at spike times
    spike_EV = interp1(time, sigEV, spikes, 'linear', 'extrap');
    spike_FA = interp1(time, sigFA, spikes, 'linear', 'extrap');

    % Define bin edges
    vel_slow = 1.8;
    vel_fast = 5.4;
    acc_slow = 19;
    acc_fast = 57;

    vel_bin_edges = [-vel_fast, -vel_slow, 0, vel_slow, vel_fast];
    acc_bin_edges = [-acc_fast, -acc_slow, 0, acc_slow, acc_fast];

    % Compute occupancy histograms
    occupancy_EV = histcounts(sigEV, vel_bin_edges);
    occupancy_FA = histcounts(sigFA, acc_bin_edges);

    % Calculate average occupancy per bin
    avg_occupancy_EV = mean(occupancy_EV);
    avg_occupancy_FA = mean(occupancy_FA);

    % Set bins with <5% of average occupancy to a small value
    occupancy_EV(occupancy_EV < 0.05 * avg_occupancy_EV) = eps;
    occupancy_FA(occupancy_FA < 0.05 * avg_occupancy_FA) = eps;

    % Compute histograms at actual spike times
    hist_actual_EV = histcounts(spike_EV, vel_bin_edges);
    hist_actual_FA = histcounts(spike_FA, acc_bin_edges);

    % Occupancy correction
    hist_actual_EV_corr = hist_actual_EV ./ (occupancy_EV / 25);
    hist_actual_FA_corr = hist_actual_FA ./ (occupancy_FA  / 25);

    % Handle potential division by zero
    hist_actual_EV_corr(isnan(hist_actual_EV_corr)) = 0;
    hist_actual_FA_corr(isnan(hist_actual_FA_corr)) = 0;

    % Compute DSI for EV
    DSI_slow_EV = (hist_actual_EV_corr(3) - hist_actual_EV_corr(2)) / ...
                  (hist_actual_EV_corr(3) + hist_actual_EV_corr(2));
    DSI_fast_EV = (hist_actual_EV_corr(4) - hist_actual_EV_corr(1)) / ...
                  (hist_actual_EV_corr(4) + hist_actual_EV_corr(1));

    % Compute DSI for FA
    DSI_slow_FA = (hist_actual_FA_corr(3) - hist_actual_FA_corr(2)) / ...
                  (hist_actual_FA_corr(3) + hist_actual_FA_corr(2));
    DSI_fast_FA = (hist_actual_FA_corr(4) - hist_actual_FA_corr(1)) / ...
                  (hist_actual_FA_corr(4) + hist_actual_FA_corr(1));

    % Compute summed normalized firing rates for slow and fast bins
    FR_slow_EV = hist_actual_EV_corr(2) + hist_actual_EV_corr(3);
    FR_fast_EV = hist_actual_EV_corr(1) + hist_actual_EV_corr(4);

    FR_slow_FA = hist_actual_FA_corr(2) + hist_actual_FA_corr(3);
    FR_fast_FA = hist_actual_FA_corr(1) + hist_actual_FA_corr(4);



    % Store all results
    results = [results; f, n, ...
        DSI_slow_EV, DSI_fast_EV, DSI_slow_FA, DSI_fast_FA, ...
        0.5*FR_slow_EV, 0.5*FR_fast_EV, 0.5*FR_slow_FA, 0.5*FR_fast_FA, ...
        hist_actual_EV_corr(1), hist_actual_EV_corr(2), hist_actual_EV_corr(3), hist_actual_EV_corr(4) ];
end

results(results > 1000) = 0;

% Convert to table
results_table = array2table(results, ...
    'VariableNames', {'Fish', 'Neuron', ...
    'DSI_Slow_EV', 'DSI_Fast_EV', 'DSI_Slow_FA', 'DSI_Fast_FA', ...
    'FR_Slow_EV', 'FR_Fast_EV', 'FR_Slow_FA', 'FR_Fast_FA', ...
    'FR_Slow_EVn', 'FR_Fast_EVn','FR_Slow_EVp', 'FR_Fast_EVp'});

% Display table
disp(results_table);

% --- Original DSI Plot ---
figure;
tiledlayout(1, 2, 'TileSpacing', 'Compact', 'Padding', 'Compact');

% DSI EV
nexttile;
hold on; box on;
scatter(abs(results_table.DSI_Slow_EV), abs(results_table.DSI_Fast_EV), 40, 'filled');
plot([0 1], [0 1], 'k--', 'LineWidth', 1.2);
xlabel('|DSI Slow EV|'); ylabel('|DSI Fast EV|');
title('Sensory Slip Velocity'); xlim([0 0.4]); ylim([0 0.4]);
axis square; set(gca, 'LineWidth', 1.5);

% DSI FA
nexttile;
hold on; box on;
scatter(abs(results_table.DSI_Slow_FA), abs(results_table.DSI_Fast_FA), 40, 'filled');
plot([0 1], [0 1], 'k--', 'LineWidth', 1.2);
xlabel('|DSI Slow FA|'); ylabel('|DSI Fast FA|');
title('Fish Acceleration'); xlim([0 0.4]); ylim([0 0.4]);
axis square; set(gca, 'LineWidth', 1.5);

% --- New Firing Rate Sum Plot ---
figure;
tiledlayout(1, 2, 'TileSpacing', 'Compact', 'Padding', 'Compact');

% Firing Rate EV
nexttile;
hold on; box on;
scatter(results_table.FR_Slow_EV, results_table.FR_Fast_EV, 40, 'filled');
plot([0 1.5], [0 1.5], 'k--', 'LineWidth', 1.2);
xlabel('FR Slow EV'); ylabel('FR Fast EV');
title('Normalized Firing Rate: EV'); 
% xlim([0.75 1.5]); ylim([0.75 1.5]);
axis square; set(gca, 'LineWidth', 1.5);

% Firing Rate FA
nexttile;
hold on; box on;
scatter(results_table.FR_Slow_FA, results_table.FR_Fast_FA, 40, 'filled');
plot([0 1.5], [0 1.5], 'k--', 'LineWidth', 1.2);
xlabel('FR Slow FA'); ylabel('FR Fast FA');
title('Normalized Firing Rate: FA'); 
% xlim([0.75 1.5]); ylim([0.75 1.5]);
axis square; set(gca, 'LineWidth', 1.5);

% %%
% % --- New Firing Rate Sum Plot ---
% figure;
% tiledlayout(1, 2, 'TileSpacing', 'Compact', 'Padding', 'Compact');
% 
% % Firing Rate EV
% nexttile;
% hold on; box on;
% scatter(results_table.FR_Slow_EVn, results_table.FR_Fast_EVn, 40, 'filled');
% plot([0 60], [0 60], 'k--', 'LineWidth', 1.2);
% xlabel('FR Slow EV'); ylabel('FR Fast EV');
% title('Normalized Firing Rate: EV'); 
% % xlim([0.75 1.5]); ylim([0.75 1.5]);
% axis square; set(gca, 'LineWidth', 1.5);
% 
% % Firing Rate FA
% nexttile;
% hold on; box on;
% scatter(results_table.FR_Slow_EVp, results_table.FR_Fast_EVp, 40, 'filled');
% plot([0 60], [0 60], 'k--', 'LineWidth', 1.2);
% xlabel('FR Slow EV'); ylabel('FR Fast EV');
% title('Normalized Firing Rate: EV'); 
% % xlim([0.75 1.5]); ylim([0.75 1.5]);
% axis square; set(gca, 'LineWidth', 1.5);

