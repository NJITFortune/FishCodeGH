%% This is the mean DSI plot for negative EV going to negative FA.

maxY = 0.4; % Selectivity Index plot range

% Plot the individual data first for fun, then average and plot the figure
% for the paper. 
% The neurons are
% 3, 4; 3, 5; 3, 6
% 8, 3; 8, 4

%% Fish 3, neuron 4 • negative EV to negative FA
f = 3; n = 4;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f3n4EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f3n4EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f3n4FA = u_DSItimeplot(spiketimes, sig, tim);

figure(3); clf; subplot(2,3,1); hold on;
    plot([f3n4EV.dels], [f3n4EV.dsi], 'b', 'LineWidth', 3);
    plot([f3n4EA.dels], [f3n4EA.dsi], 'g', 'LineWidth', 2);
    plot([f3n4FA.dels], [f3n4FA.dsi], 'm', 'LineWidth', 3);
    xline(0); yline(0); ylim([-maxY, maxY]);
    title('Fish 3, neuron 4')


%% Fish 3, neuron 5 • negative EV to negative FA
f = 3; n = 5;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f3n5EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f3n5EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f3n5FA = u_DSItimeplot(spiketimes, sig, tim);

figure(3); subplot(2,3,2); hold on;
    plot([f3n5EV.dels], [f3n5EV.dsi], 'b', 'LineWidth', 3);
    plot([f3n5EA.dels], [f3n5EA.dsi], 'g', 'LineWidth', 2);
    plot([f3n5FA.dels], [f3n5FA.dsi], 'm', 'LineWidth', 3);
    xline(0); yline(0); ylim([-maxY, maxY]);
    title('Fish 3, neuron 5')

%% Fish 3, neuron 6 • Centered negative EV to negative FA - delayed relative others
f = 3; n = 6;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f3n6EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f3n6EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f3n6FA = u_DSItimeplot(spiketimes, sig, tim);

figure(3); subplot(2,3,3); hold on;
    plot([f3n6EV.dels], [f3n6EV.dsi], 'b', 'LineWidth', 3);
    plot([f3n6EA.dels], [f3n6EA.dsi], 'g', 'LineWidth', 2);
    plot([f3n6FA.dels], [f3n6FA.dsi], 'm', 'LineWidth', 3);
    xline(0); yline(0); ylim([-maxY, maxY]);
    title('Fish 3, neuron 6')

%% Fish 8, neuron 3 • Centered negative EV to negative FA - delayed relative to others
f = 8; n = 3;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f8n3EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f8n3EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f8n3FA = u_DSItimeplot(spiketimes, sig, tim);

figure(3); subplot(2,3,4); hold on;
    plot([f8n3EV.dels], [f8n3EV.dsi], 'b', 'LineWidth', 3);
    plot([f8n3EA.dels], [f8n3EA.dsi], 'g', 'LineWidth', 2);
    plot([f8n3FA.dels], [f8n3FA.dsi], 'm', 'LineWidth', 3);
    xline(0); yline(0); ylim([-maxY, maxY]);
    title('Fish 8, neuron 3')

%% Fish 8, neuron 4 • Centered negative EV to negative FA - delayed relative to others
f = 8; n = 4;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f8n4EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f8n4EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f8n4FA = u_DSItimeplot(spiketimes, sig, tim);

figure(3); subplot(2,3,5); hold on;
    plot([f8n4EV.dels], [f8n4EV.dsi], 'b', 'LineWidth', 3);
    plot([f8n4EA.dels], [f8n4EA.dsi], 'g', 'LineWidth', 2);
    plot([f8n4FA.dels], [f8n4FA.dsi], 'm', 'LineWidth', 3);
    xline(0); yline(0); ylim([-maxY, maxY]);
    title('Fish 8, neuron 4')

%% Take the mean for our 5 Neg EV - Neg FA cases

% You will notice that we subtract the mean "random DSI" from our DSI plot.
% Example: mDSIev = [f3n4EV.dsi] - mean([f3n4EV.rdsi]); 
% This is because for some fish, there were offsets in the kinematic data.
% For example, the fish might have spent more time moving backwards than
% forwards. When you compute the DSIs for the shuffled spike train, you 
% see a rather flat offset in plot. But, you say, this shouldn't matter if
% the neuron is truly selective... and that is true. For our most selective
% neurons, this adjustment doesn't matter. But since we are dealing with
% many neurons with weak DSIs and a significant spontaneous rate, the
% offsets give a false impression of selectivity where there is none. We
% also tried a couple of other methods for eliminating these offsets,
% including subtracting the mean from the kinematic signal. That also has
% the same effect as what was done here - removes the offsets in the DSI
% analyses. 

% Error velocity
mDSIev = [f3n4EV.dsi] - mean([f3n4EV.rdsi]);
mDSIev = mDSIev + [f3n5EV.dsi] - mean([f3n5EV.rdsi]);
mDSIev = mDSIev + [f3n6EV.dsi] - mean([f3n6EV.rdsi]);
mDSIev = mDSIev + [f8n3EV.dsi] - mean([f8n3EV.rdsi]);
mDSIev = mDSIev + [f8n4EV.dsi] - mean([f8n4EV.rdsi]);
mDSIev = mDSIev ./ 5;

mDSIfa = [f3n4FA.dsi] - mean([f3n4FA.rdsi]);
mDSIfa = mDSIfa + [f3n5FA.dsi] - mean([f3n5FA.rdsi]);
mDSIfa = mDSIfa + [f3n6FA.dsi] - mean([f3n6FA.rdsi]);
mDSIfa = mDSIfa + [f8n3FA.dsi] - mean([f8n3FA.rdsi]);
mDSIfa = mDSIfa + [f8n4FA.dsi] - mean([f8n4FA.rdsi]);
mDSIfa = mDSIfa ./ 5;

figure(102); clf; hold on;
    plot(f3n2EV.dels(f3n2EV.dels >= 0), mDSIev(f3n2EV.dels >= 0), 'b-.', 'LineWidth', 3);
    plot(f3n2EV.dels(f3n2EV.dels <= 0), mDSIev(f3n2EV.dels <= 0), 'b-', 'LineWidth', 4);
    plot(f3n2FA.dels(f3n2EV.dels <= 0), mDSIfa(f3n2EV.dels <= 0), 'r-.', 'LineWidth', 3);
    plot(f3n2FA.dels(f3n2EV.dels >= 0), mDSIfa(f3n2EV.dels >= 0), 'r-', 'LineWidth', 4);

    xlabel('delay, seconds'); ylabel('selectivity index');
    text(0.15, -0.2, 'N = 5','FontSize', 18);
    title('error velocity and fish acceleration: neg -> neg')
    xline(0); yline(0);
    ylim([-0.25 0.25])
    set(gcf, 'renderer', 'painters')
    
