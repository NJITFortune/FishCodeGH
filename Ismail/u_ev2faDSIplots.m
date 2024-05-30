% Make plots for each fish

maxY = 0.4;

%% Fish 9, neuron 3
f = 9; n = 3;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    Penn3EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    Penn3FA = u_DSItimeplot(spiketimes, sig, tim);

figure(1); clf; subplot(2,2,1); hold on;
plot([Penn3EV.dels], [Penn3EV.dsi.spikes], 'b', 'LineWidth', 3);
plot([Penn3FA.dels], [Penn3FA.dsi.spikes], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 9, neuron 3')

%% Fish 9, neuron 4
f = 9; n = 4;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    Penn4EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    Penn4FA = u_DSItimeplot(spiketimes, sig, tim);

figure(1); subplot(2,2,2); hold on;
plot([Penn4EV.dels], [Penn4EV.dsi.spikes], 'b', 'LineWidth', 3);
plot([Penn4FA.dels], [Penn4FA.dsi.spikes], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 9, neuron 4')

%% Fish 3, neuron 1
f = 3; n = 1;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f3n1EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f3n1EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f3n1FA = u_DSItimeplot(spiketimes, sig, tim);

figure(2); clf; subplot(2,2,1); hold on;
plot([f3n1EV.dels], [f3n1EV.dsi.spikes], 'b', 'LineWidth', 3);
plot([f3n1EA.dels], [f3n1EA.dsi.spikes], 'c', 'LineWidth', 2);
plot([f3n1FA.dels], [f3n1FA.dsi.spikes], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 3, neuron 1')

%% Fish 3, neuron 2
f = 3; n = 2;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f3n2EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f3n2FA = u_DSItimeplot(spiketimes, sig, tim);

figure(1); subplot(2,2,3); hold on;
plot([f3n2EV.dels], [f3n2EV.dsi.spikes], 'b', 'LineWidth', 3);
plot([f3n2FA.dels], [f3n2FA.dsi.spikes], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 3, neuron 2')

%% Fish 3, neuron 3
f = 3; n = 3;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f3n3EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f3n3EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f3n3FA = u_DSItimeplot(spiketimes, sig, tim);

figure(2); subplot(2,2,2); hold on;
plot([f3n3EV.dels], [f3n3EV.dsi.spikes], 'b', 'LineWidth', 3);
plot([f3n3EA.dels], [f3n3EA.dsi.spikes], 'c', 'LineWidth', 2);
plot([f3n3FA.dels], [f3n3FA.dsi.spikes], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 3, neuron 3')

%% Fish 4, neuron 6
f = 4; n = 6;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f4n6EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f4n6FA = u_DSItimeplot(spiketimes, sig, tim);

figure(1); subplot(2,2,4); hold on;
plot([f4n6EV.dels], [f4n6EV.dsi.spikes], 'b', 'LineWidth', 3);
plot([f4n6FA.dels], [f4n6FA.dsi.spikes], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 4, neuron 6')

%% Fish 7, neuron 1
f = 7; n = 1;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f7n1EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f7n1EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f7n1FA = u_DSItimeplot(spiketimes, sig, tim);

figure(2); subplot(2,2,3); hold on;
plot([f7n1EV.dels], [f7n1EV.dsi.spikes], 'b', 'LineWidth', 3);
plot([f7n1EA.dels], [f7n1EA.dsi.spikes], 'c', 'LineWidth', 2);
plot([f7n1FA.dels], [f7n1FA.dsi.spikes], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 7, neuron 1')






%% Fish 3, neuron 4
f = 3; n = 4;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f3n4EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f3n4EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f3n4FA = u_DSItimeplot(spiketimes, sig, tim);

figure(3); subplot(2,2,1); hold on;
plot([f3n4EV.dels], [f3n4EV.dsi.spikes], 'b', 'LineWidth', 3);
plot([f3n4EA.dels], [f3n4EA.dsi.spikes], 'c', 'LineWidth', 2);
plot([f3n4FA.dels], [f3n4FA.dsi.spikes], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 3, neuron 4')


%% Fish 3, neuron 5
f = 3; n = 5;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f3n5EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f3n5EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f3n5FA = u_DSItimeplot(spiketimes, sig, tim);

figure(3); subplot(2,2,2); hold on;
plot([f3n5EV.dels], [f3n5EV.dsi.spikes], 'b', 'LineWidth', 3);
plot([f3n5EA.dels], [f3n5EA.dsi.spikes], 'c', 'LineWidth', 2);
plot([f3n5FA.dels], [f3n5FA.dsi.spikes], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 3, neuron 5')

%% Fish 3, neuron 6
f = 3; n = 6;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f3n6EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f3n6EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f3n6FA = u_DSItimeplot(spiketimes, sig, tim);

figure(3); subplot(2,2,3); hold on;
plot([f3n6EV.dels], [f3n6EV.dsi.spikes], 'b', 'LineWidth', 3);
plot([f3n6EA.dels], [f3n6EA.dsi.spikes], 'c', 'LineWidth', 2);
plot([f3n6FA.dels], [f3n6FA.dsi.spikes], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 3, neuron 6')

