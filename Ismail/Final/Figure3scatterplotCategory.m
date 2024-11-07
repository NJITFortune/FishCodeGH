% Figure 4 - the DSI scatterplot
% This shows the relation between selectivity for sensory and motor.
%
% numIDX has a list of neurons that had sufficient spikes for this sort of
% analysis. There are 51 neurons in this list.

for j=length(numIDX):-1:1

    f = neuronsAll(numIDX(j),1);
    n = neuronsAll(numIDX(j),2);

% Calculate the DSIs
evDSI = DSItimeSTA(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).time);
faDSI = DSItimeSTA(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).fish_acc, curfish(f).time);

% Get max or min causal SENSORY (prior to spike)
tt = find(evDSI.dels < 0);
[~, idx] = max(abs(evDSI.dsi(tt)));
    EVout(j,:) = [f,n, evDSI.dels(idx), evDSI.dsi(idx) - mean(evDSI.rdsi)];

% Get max or min causal MOTOR (after spike)
tt = find(faDSI.dels > 0);
offset = length(find(evDSI.dels <= 0));
[~, idx] = max(abs(evDSI.dsi(tt)));
    FAout(j,:) = [f,n, faDSI.dels(idx+offset), faDSI.dsi(idx+offset) - mean(faDSI.rdsi)];

% As explained in the code for Figure 3, we remove the mean of the shuffled
% DSI to account for offsets in the kinematic data. This is important for
% the neurons that are not well driven by the behavior. 

end

%% Make the scatterplot
% This is the max/min DSI of fish acceleration (y-axis) plotted against
% error velocity (x-axis).

figure(104); clf; hold on;
    set(gcf, 'renderer', 'painters')

plot(EVout(:,4), FAout(:,4), '.', 'MarkerSize', 24);
    xline(0); yline(0);
    xlim([-0.4 0.4]); xlabel('error velocity SI')
    ylim([-0.25 0.25]); ylabel('fish acceleration SI')

