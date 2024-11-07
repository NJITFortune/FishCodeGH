%% This is the mean DSI plot for positive EV going to positive FA.

% Plot the individual data first for fun, then average and plot the figure
% for the paper. Here we have 6 neurons and we only use 5 for the paper.

maxY = 0.4; % Selectivity Index

%% Fish 9, neuron 3 • positive EV to postive FA

f = 9; n = 3;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    Penn3EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    Penn3EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    Penn3FA = u_DSItimeplot(spiketimes, sig, tim);

figure(1); clf; subplot(2,3,1); hold on;
    plot([Penn3EV.dels], [Penn3EV.dsi], 'b', 'LineWidth', 3);
    plot([Penn3EA.dels], [Penn3EA.dsi], 'g', 'LineWidth', 3);
    plot([Penn3FA.dels], [Penn3FA.dsi], 'm', 'LineWidth', 3);
    xline(0); yline(0); ylim([-maxY, maxY]);
    title('Fish 9, neuron 3')


%% Fish 9, neuron 4 • positive EV to postive FA

f = 9; n = 4;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    Penn4EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    Penn4EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    Penn4FA = u_DSItimeplot(spiketimes, sig, tim);

figure(1); subplot(2,3,2); hold on;
    plot([Penn4EV.dels], [Penn4EV.dsi], 'b', 'LineWidth', 3);
    plot([Penn4EA.dels], [Penn4EA.dsi], 'g', 'LineWidth', 3);
    plot([Penn4FA.dels], [Penn4FA.dsi], 'm', 'LineWidth', 3);
    xline(0); yline(0); ylim([-maxY, maxY]);
    title('Fish 9, neuron 4')


%% Fish 3, neuron 1 • Centered positive EV to postive FA - delayed relative to others

f = 3; n = 1;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f3n1EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f3n1EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f3n1FA = u_DSItimeplot(spiketimes, sig, tim);

figure(1); subplot(2,3,3); hold on;
    plot([f3n1EV.dels], [f3n1EV.dsi], 'b', 'LineWidth', 3);
    plot([f3n1EA.dels], [f3n1EA.dsi], 'g', 'LineWidth', 2);
    plot([f3n1FA.dels], [f3n1FA.dsi], 'm', 'LineWidth', 3);
    xline(0); yline(0); ylim([-maxY, maxY]);
    title('Fish 3, neuron 1')


%% Fish 3, neuron 2 • Centered positive EV to postive FA - delayed relative to others
f = 3; n = 2;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f3n2EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f3n2EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f3n2FA = u_DSItimeplot(spiketimes, sig, tim);

figure(1); subplot(2,3,4); hold on;
    plot([f3n2EV.dels], [f3n2EV.dsi], 'b', 'LineWidth', 3);
    plot([f3n2EA.dels], [f3n2EA.dsi], 'g', 'LineWidth', 3);
    plot([f3n2FA.dels], [f3n2FA.dsi], 'm', 'LineWidth', 3);
    xline(0); yline(0); ylim([-maxY, maxY]);
    title('Fish 3, neuron 2')

%% Fish 3, neuron 3 • Centered positive EV to postive FA - delayed relative to others
f = 3; n = 3;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f3n3EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f3n3EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f3n3FA = u_DSItimeplot(spiketimes, sig, tim);

figure(1); subplot(2,3,5); hold on;
    plot([f3n3EV.dels], [f3n3EV.dsi], 'b', 'LineWidth', 3);
    plot([f3n3EA.dels], [f3n3EA.dsi], 'g', 'LineWidth', 2);
    plot([f3n3FA.dels], [f3n3FA.dsi], 'm', 'LineWidth', 3);
    xline(0); yline(0); ylim([-maxY, maxY]);
    title('Fish 3, neuron 3')

%% Fish 7, neuron 1 • Very weak Centered positive EV to postive FA - but normal level motor
f = 7; n = 1;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f7n1EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f7n1EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f7n1FA = u_DSItimeplot(spiketimes, sig, tim);

figure(1); subplot(2,3,6); hold on;
    plot([f7n1EV.dels], [f7n1EV.dsi], 'b', 'LineWidth', 3);
    plot([f7n1EA.dels], [f7n1EA.dsi], 'g', 'LineWidth', 2);
    plot([f7n1FA.dels], [f7n1FA.dsi], 'm', 'LineWidth', 3);
    xline(0); yline(0); ylim([-maxY, maxY]);
    title('Fish 7, neuron 1');

%% Fish 4, neuron 6 • Something isn't quite right here.
f = 4; n = 6;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f4n6EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f4n6EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f4n6FA = u_DSItimeplot(spiketimes, sig, tim);

figure(111); hold on;
    plot([f4n6EV.dels], [f4n6EV.dsi], 'b', 'LineWidth', 3);
    plot([f4n6EA.dels], [f4n6EA.dsi], 'g', 'LineWidth', 2);
    plot([f4n6FA.dels], [f4n6FA.dsi], 'm', 'LineWidth', 3);
    xline(0); yline(0); ylim([-maxY, maxY]);
    title('Fish 6, neuron 6');

%% Fish 8, neuron 6 • Something isn't quite right here.
f = 8; n = 6;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f8n6EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f8n6EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f8n6FA = u_DSItimeplot(spiketimes, sig, tim);

figure(112); hold on;
    plot([f8n6EV.dels], [f8n6EV.dsi], 'b', 'LineWidth', 3);
    plot([f8n6EA.dels], [f8n6EA.dsi], 'g', 'LineWidth', 2);
    plot([f8n6FA.dels], [f8n6FA.dsi], 'm', 'LineWidth', 3);
    xline(0); yline(0); ylim([-maxY, maxY]);
    title('Fish 8, neuron 6');


%% Average across 7 of these neurons from 4 fish
% They are 9-3, 9-4, 3-1, 3-2, 3-3, 4-6, 8-6. (Can include 7-1 if you want...)
% We aren't using 7-1 because it isn't easily discriminated in the
% scatterplot.

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

mDSIev = [Penn3EV.dsi] - mean(Penn3EV.rdsi);
mDSIev = mDSIev + [Penn4EV.dsi] - mean(Penn4EV.rdsi);
mDSIev = mDSIev + [f3n1EV.dsi] - mean(f3n1EV.rdsi);
mDSIev = mDSIev + [f3n2EV.dsi] - mean(f3n2EV.rdsi);
mDSIev = mDSIev + [f3n3EV.dsi] - mean(f3n3EV.rdsi);
% mDSIev = mDSIev + [f7n1EV.dsi] - mean(f7n1EV.rdsi);

mDSIev = mDSIev + [f4n6EV.dsi] - mean(f4n6EV.rdsi);
mDSIev = mDSIev + [f8n6EV.dsi] - mean(f8n6EV.rdsi);
mDSIev = mDSIev ./ 7;

mDSIfa = [Penn3FA.dsi] - mean(Penn3FA.rdsi);
mDSIfa = mDSIfa + [Penn4FA.dsi] - mean(Penn4FA.rdsi);
mDSIfa = mDSIfa + [f3n1FA.dsi] - mean(f3n1FA.rdsi);
mDSIfa = mDSIfa + [f3n2FA.dsi] - mean(f3n2FA.rdsi);
mDSIfa = mDSIfa + [f3n3FA.dsi] - mean(f3n3FA.rdsi);
% mDSIfa = mDSIfa + [f7n1FA.dsi] - mean(f7n1FA.rdsi);

mDSIfa = mDSIfa + [f4n6FA.dsi] - mean(f4n6FA.rdsi);
mDSIfa = mDSIfa + [f8n6FA.dsi] - mean(f8n6FA.rdsi);
mDSIfa = mDSIfa ./ 7;

figure(101); clf; hold on;
    plot(f3n2EV.dels(f3n2EV.dels >= 0), mDSIev(f3n2EV.dels >= 0), 'b-.', 'LineWidth', 3);
    plot(f3n2EV.dels(f3n2EV.dels <= 0), mDSIev(f3n2EV.dels <= 0), 'b-', 'LineWidth', 4);
    plot(f3n2FA.dels(f3n2EV.dels <= 0), mDSIfa(f3n2EV.dels <= 0), 'r-.', 'LineWidth', 3);
    plot(f3n2FA.dels(f3n2EV.dels >= 0), mDSIfa(f3n2EV.dels >= 0), 'r-', 'LineWidth', 4);

    xlabel('delay, seconds'); ylabel('selectivity index');
    text(0.15, -0.15, 'N = 7','FontSize', 18);
    title('error velocity and fish acceleration: pos -> pos')
    xline(0); yline(0);
    ylim([-0.20 0.20])
    set(gcf, 'renderer', 'painters')

