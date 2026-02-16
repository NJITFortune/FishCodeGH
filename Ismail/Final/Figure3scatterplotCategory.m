%% The Selectivity Index scatterplots.
% This shows the relation between selectivity for sensory slip (Error Velocity) and 
% premotor activity (Fish Acceleration).
%
% This script requires that you 1) load the data and 2) run the list script
% u_allNeuronsListBA. This script provides, among other things, numIDX and neuronsAll.
%
% numIDX has a list of neurons that had sufficient spikes for this sort of
% analysis. There are 51 neurons in this list.
%
% This script depends on DSItimeSTA. Through DSItimeSTA this script also requires
% u_randspikegen and u_tim2stim.
%
% This highlights our 11 favorite neurons.
% The favorite neurons are (pp) 3,1 3,2 3,2 4,6 9,3 9,4 and (nn) 3,4 3,5 6,1 6,5 12,1
%

%% Loop through every neuron included in numIDX. This takes too long. Be patient.
for j=length(numIDX):-1:1

    % This gets the fish (f) and neuron (n) indices for each valid neuron.
    f = neuronsAll(numIDX(j),1);
    n = neuronsAll(numIDX(j),2);

    % Calculate the DSIs
    
    evDSI = DSItimeSTA(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).time);
    faDSI = DSItimeSTA(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).fish_acc, curfish(f).time);
    
    % Get max or min causal SENSORY (prior to spike)
    tt = find(evDSI.dels < 0);
    [~, idx] = max(abs(evDSI.dsi(tt)));
        EVout(j,:) = [f,n, evDSI.dels(idx), evDSI.dsi(idx) - mean(evDSI.rdsi)];
        EVrand(j,:) = [f,n, evDSI.dels(idx), evDSI.rdsi(idx) - mean(evDSI.rdsi)];

    % Get max or min causal MOTOR (after spike)
    tt = find(faDSI.dels > 0);
    offset = length(find(evDSI.dels <= 0));
    [~, idx] = max(abs(evDSI.dsi(tt)));
        FAout(j,:) = [f,n, faDSI.dels(idx+offset), faDSI.dsi(idx+offset) - mean(faDSI.rdsi)];
        FArand(j,:) = [f,n, faDSI.dels(idx+offset), faDSI.rdsi(idx+offset) - mean(faDSI.rdsi)];
    
    % As explained in the code for Figure 3, we remove the mean of the shuffled
    % DSI to account for offsets in the kinematic data. This is important for
    % the neurons that are not well driven by the behavior. 

end

%% Make the scatterplots
% This is the max/min DSI of fish acceleration (y-axis) plotted against
% error velocity (x-axis).

% These are our 11 best neurons.
posposIDX = find(EVout(:,4) > 0.1);
negnegIDX = find(EVout(:,4) < -0.08);


% Scatterplot for normal spike data
figure(114); clf; hold on;
    set(gcf, 'renderer', 'painters')

plot(EVout(:,4), FAout(:,4), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'b');
    % Highlight our 11 best neurons
    plot(EVout(posposIDX,4), FAout(posposIDX,4), '.', 'MarkerSize', 12, 'Color', 'Magenta');
    plot(EVout(negnegIDX,4), FAout(negnegIDX,4), '.', 'MarkerSize', 12, 'Color', 'Cyan');

    xline(0); yline(0);
    xlim([-0.4 0.4]); xlabel('error velocity SI')
    ylim([-0.25 0.25]); ylabel('fish acceleration SI')


% Scatterplot for shuffled spike data
figure(115); clf; hold on;
    set(gcf, 'renderer', 'painters')

plot(EVrand(:,4), FArand(:,4), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'b');
    % Highlight our 11 best neurons
    plot(EVrand(posposIDX,4), FArand(posposIDX,4), '.', 'MarkerSize', 12, 'Color', 'Magenta');
    plot(EVrand(negnegIDX,4), FArand(negnegIDX,4), '.', 'MarkerSize', 12, 'Color', 'Cyan');

    xline(0); yline(0);
    xlim([-0.4 0.4]); xlabel('Shuffled error velocity SI')
    ylim([-0.25 0.25]); ylabel('Shuffled fish acceleration SI')
