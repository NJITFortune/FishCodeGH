% Make plots for each fish

% 9,3 9,4 3,2 4,6
% 3,1 3,3 7,1
% 3,4 3,5 3,6

maxY = 0.4;


%% Fish 9, neuron 3

f = 9; n = 3;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    Penn3EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    Penn3EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    Penn3FA = u_DSItimeplot(spiketimes, sig, tim);

figure(1); clf; subplot(2,2,1); hold on;
plot([Penn3EV.dels], [Penn3EV.dsi.spikes], 'b', 'LineWidth', 3);
plot([Penn3EA.dels], [Penn3EA.dsi.spikes], 'g', 'LineWidth', 3);
plot([Penn3FA.dels], [Penn3FA.dsi.spikes], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 9, neuron 3')


%% Fish 9, neuron 4

f = 9; n = 4;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    Penn4EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    Penn4EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    Penn4FA = u_DSItimeplot(spiketimes, sig, tim);

figure(1); subplot(2,2,2); hold on;
plot([Penn4EV.dels], [Penn4EV.dsi.spikes], 'b', 'LineWidth', 3);
plot([Penn4EA.dels], [Penn4EA.dsi.spikes], 'g', 'LineWidth', 3);
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
plot([f3n1EA.dels], [f3n1EA.dsi.spikes], 'g', 'LineWidth', 2);
plot([f3n1FA.dels], [f3n1FA.dsi.spikes], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 3, neuron 1')


%% Fish 3, neuron 2
f = 3; n = 2;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f3n2EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f3n2EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f3n2FA = u_DSItimeplot(spiketimes, sig, tim);

figure(1); subplot(2,2,3); hold on;
plot([f3n2EV.dels], [f3n2EV.dsi.spikes], 'b', 'LineWidth', 3);
plot([f3n2EA.dels], [f3n2EA.dsi.spikes], 'g', 'LineWidth', 3);
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
plot([f3n3EA.dels], [f3n3EA.dsi.spikes], 'g', 'LineWidth', 2);
plot([f3n3FA.dels], [f3n3FA.dsi.spikes], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 3, neuron 3')

%% Fish 4, neuron 6
f = 4; n = 6;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f4n6EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f4n6EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f4n6FA = u_DSItimeplot(spiketimes, sig, tim);

figure(1); subplot(2,2,4); hold on;
plot([f4n6EV.dels], [f4n6EV.dsi.spikes], 'b', 'LineWidth', 3);
plot([f4n6EA.dels], [f4n6EA.dsi.spikes], 'g', 'LineWidth', 3);
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
plot([f7n1EA.dels], [f7n1EA.dsi.spikes], 'g', 'LineWidth', 2);
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
plot([f3n4EA.dels], [f3n4EA.dsi.spikes], 'g', 'LineWidth', 2);
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
plot([f3n5EA.dels], [f3n5EA.dsi.spikes], 'g', 'LineWidth', 2);
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
plot([f3n6EA.dels], [f3n6EA.dsi.spikes], 'g', 'LineWidth', 2);
plot([f3n6FA.dels], [f3n6FA.dsi.spikes], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 3, neuron 6')

%% Take the mean for our 4 velocity cases

% Error velocity
mDSIev = [Penn4EV.dsi.spikes];
mDSIev = mDSIev + [Penn3EV.dsi.spikes];
mDSIev = mDSIev + [f3n2EV.dsi.spikes];
mDSIev = mDSIev + [f4n6EV.dsi.spikes];
mDSIev = mDSIev ./ 4;

% randomized EV
mrDSIev = [Penn4EV.dsi.randspikes];
mrDSIev = mrDSIev + [Penn3EV.dsi.randspikes];
mrDSIev = mrDSIev + [f3n2EV.dsi.randspikes];
mrDSIev = mrDSIev + [f4n6EV.dsi.randspikes];
mrDSIev = mrDSIev ./ 4;

% Error acceleration
mDSIea = [Penn4EA.dsi.spikes];
mDSIea = mDSIea + [Penn3EA.dsi.spikes];
mDSIea = mDSIea + [f3n2EA.dsi.spikes];
mDSIea = mDSIea + [f4n6EA.dsi.spikes];
mDSIea = mDSIea ./ 4;

% randomized EV
mrDSIea = [Penn4EV.dsi.randspikes];
mrDSIea = mrDSIea + [Penn3EA.dsi.randspikes];
mrDSIea = mrDSIea + [f3n2EA.dsi.randspikes];
mrDSIea = mrDSIea + [f4n6EA.dsi.randspikes];
mrDSIea = mrDSIea ./ 4;

figure(101); clf; hold on;
    plot(f3n2EV.dels(f3n2EV.dels >= 0), mDSIev(f3n2EV.dels >= 0), 'b-.', 'LineWidth', 3);
    plot(f3n2EV.dels(f3n2EV.dels <= 0), mDSIev(f3n2EV.dels <= 0), 'b-', 'LineWidth', 4);
    plot(f3n2EV.dels, mrDSIev, 'c', 'LineWidth', 1);

    plot(f3n2EA.dels(f3n2EA.dels >= 0), mDSIea(f3n2EA.dels >= 0), 'g-.', 'LineWidth', 3);
    plot(f3n2EA.dels(f3n2EA.dels <= 0), mDSIea(f3n2EA.dels <= 0), 'g-', 'LineWidth', 4);
    plot(f3n2EA.dels, mrDSIea, 'g', 'LineWidth', 1);
    
    xlabel('delay, seconds'); ylabel('selectivity index');
    text(0.15, -0.2, 'N = 4','FontSize', 18);
    title('error velocity, acceleration and fish acceleration')

mDSIfa = [Penn4FA.dsi.spikes];
mDSIfa = mDSIfa + [Penn3FA.dsi.spikes];
mDSIfa = mDSIfa + [f3n2FA.dsi.spikes];
mDSIfa = mDSIfa + [f4n6FA.dsi.spikes];
mDSIfa = mDSIfa ./ 4;

mrDSIfa = [Penn4EV.dsi.randspikes];
mrDSIfa = mrDSIfa + [Penn3FA.dsi.randspikes];
mrDSIfa = mrDSIfa + [f3n2FA.dsi.randspikes];
mrDSIfa = mrDSIfa + [f4n6FA.dsi.randspikes];
mrDSIfa = mrDSIfa ./ 4;

figure(101); 
    plot(f3n2FA.dels(f3n2EV.dels <= 0), mDSIfa(f3n2EV.dels <= 0), 'r-.', 'LineWidth', 3);
    plot(f3n2FA.dels(f3n2EV.dels >= 0), mDSIfa(f3n2EV.dels >= 0), 'r-', 'LineWidth', 4);
    plot(f3n2FA.dels, mrDSIfa, 'm', 'LineWidth', 1);

xline(0); yline(0);
ylim([-0.25 0.25])


%% Take the mean for our 6 acceleration cases

mDSIev = [f3n1EV.dsi.spikes];
mDSIev = mDSIev + [f3n1EV.dsi.spikes];
mDSIev = mDSIev + [f3n3EV.dsi.spikes];
mDSIev = mDSIev + [f7n1EV.dsi.spikes];
mDSIev = mDSIev - [f3n4EV.dsi.spikes];
mDSIev = mDSIev - [f3n5EV.dsi.spikes];
mDSIev = mDSIev - [f3n6EV.dsi.spikes];
mDSIev = mDSIev ./ 6;

mrDSIev = [f3n1EV.dsi.randspikes];
mrDSIev = mrDSIev + [f3n1EV.dsi.randspikes];
mrDSIev = mrDSIev + [f3n3EV.dsi.randspikes];
mrDSIev = mrDSIev + [f7n1EV.dsi.randspikes];
mrDSIev = mrDSIev - [f3n4EV.dsi.randspikes];
mrDSIev = mrDSIev - [f3n5EV.dsi.randspikes];
mrDSIev = mrDSIev - [f3n6EV.dsi.randspikes];
mrDSIev = mrDSIev ./ 6;

% Error acceleration
mDSIea = [f3n1EA.dsi.spikes];
mDSIea = mDSIea + [f3n1EA.dsi.spikes];
mDSIea = mDSIea + [f3n3EA.dsi.spikes];
mDSIea = mDSIea + [f7n1EA.dsi.spikes];
mDSIea = mDSIea - [f3n4EA.dsi.spikes];
mDSIea = mDSIea - [f3n5EA.dsi.spikes];
mDSIea = mDSIea - [f3n6EA.dsi.spikes];
mDSIea = mDSIea ./ 6;

% random EA
mrDSIea = [f3n1EA.dsi.randspikes];
mrDSIea = mrDSIea + [f3n1EA.dsi.randspikes];
mrDSIea = mrDSIea + [f3n3EA.dsi.randspikes];
mrDSIea = mrDSIea + [f7n1EA.dsi.randspikes];
mrDSIea = mrDSIea - [f3n4EA.dsi.randspikes];
mrDSIea = mrDSIea - [f3n5EA.dsi.randspikes];
mrDSIea = mrDSIea - [f3n6EA.dsi.randspikes];
mrDSIea = mrDSIea ./ 6;

figure(102); clf; hold on;
    plot(f3n1EV.dels(f3n1EV.dels <= 0), mDSIev(f3n1EV.dels <= 0), 'b', 'LineWidth', 4);
    plot(f3n1EV.dels(f3n1EV.dels >= 0), mDSIev(f3n1EV.dels >= 0), 'b-.', 'LineWidth', 3);
    plot(f3n1EA.dels(f3n1EA.dels <= 0), mDSIea(f3n1EA.dels <= 0), 'g', 'LineWidth', 4);
    plot(f3n1EA.dels(f3n1EA.dels >= 0), mDSIea(f3n1EA.dels >= 0), 'g-.', 'LineWidth', 3);

    plot(f3n1EV.dels, mrDSIev, 'c', 'LineWidth', 1);
    plot(f3n1EA.dels, mrDSIea, 'g', 'LineWidth', 1);
    xlabel('delay, seconds'); ylabel('selectivity index');
    text(0.15, -0.2, 'N = 6','FontSize', 18);
    title('error acceleration and fish acceleration')

mDSIfa = [f3n1EA.dsi.spikes];
mDSIfa = mDSIfa + [f3n1FA.dsi.spikes];
mDSIfa = mDSIfa + [f3n3FA.dsi.spikes];
mDSIfa = mDSIfa + [f7n1FA.dsi.spikes];
mDSIfa = mDSIfa - [f3n4FA.dsi.spikes];
mDSIfa = mDSIfa - [f3n5FA.dsi.spikes];
mDSIfa = mDSIfa - [f3n6FA.dsi.spikes];
mDSIfa = mDSIfa ./ 6;

mrDSIfa = [f3n1EA.dsi.randspikes];
mrDSIfa = mrDSIfa + [f3n1FA.dsi.randspikes];
mrDSIfa = mrDSIfa + [f3n3FA.dsi.randspikes];
mrDSIfa = mrDSIfa + [f7n1FA.dsi.randspikes];
mrDSIfa = mrDSIfa - [f3n4FA.dsi.randspikes];
mrDSIfa = mrDSIfa - [f3n5FA.dsi.randspikes];
mrDSIfa = mrDSIfa - [f3n6FA.dsi.randspikes];
mrDSIfa = mrDSIfa ./ 6;

figure(102); 
    plot(f3n1FA.dels(f3n1EA.dels >= 0), mDSIfa(f3n1EA.dels >= 0), 'r-', 'LineWidth', 4);
    plot(f3n1FA.dels(f3n1EA.dels <= 0), mDSIfa(f3n1EA.dels <= 0), 'r-.', 'LineWidth', 3);
    plot(f3n1FA.dels, mrDSIfa, 'm', 'LineWidth', 1);

xline(0); yline(0);
ylim([-0.25 0.25])



%% STA stuff

% 9,3 9,4 3,2 4,6
% 3,1 3,3 7,1
% 3,4 3,5 3,6

fn = [9,3; 9,4; 3,2; 4,6; 3,1; 3,3; 7,1; 3,4; 3,5; 3,6];

wid = 1;
Fs = curfish(9).fs;

for j = length(fn):-1:1
    outEV(j) = u_sta(curfish(fn(j,1)).spikes.times(curfish(fn(j,1)).spikes.codes == fn(j,2)), [], curfish(fn(j,1)).error_vel, Fs, wid);
    outEA(j) = u_sta(curfish(fn(j,1)).spikes.times(curfish(fn(j,1)).spikes.codes == fn(j,2)), [], curfish(fn(j,1)).error_acc, Fs, wid);
    outFA(j) = u_sta(curfish(fn(j,1)).spikes.times(curfish(fn(j,1)).spikes.codes == fn(j,2)), [], curfish(fn(j,1)).fish_acc, Fs, wid);
end

for j=1:length(out)

    figure(j+10); clf; 
        subplot(211); hold on; 
        plot(outEV(j).time, outEV(j).MEAN / max(abs(outEV(j).MEAN)), 'b');
        plot(outEA(j).time, outEA(j).MEAN / max(abs(outEA(j).MEAN)), 'g');
        plot(outFA(j).time, outFA(j).MEAN / max(abs(outFA(j).MEAN)), 'r');

        subplot(212); hold on; 
        semilogy(outEV(j).time, outEV(j).Pval, 'b');
        semilogy(outEA(j).time, outEA(j).Pval, 'g');
        semilogy(outFA(j).time, outFA(j).Pval, 'r');
        ylim([0 0.01])
end