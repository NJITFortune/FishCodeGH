% Make plots for each fish
% There is no need to use u_signalprep because these are DSIs for all spikes.
% DSIs are just + or -, which doesn't change with the scaling.

% 9,3 9,4 3,2 4,6
% 3,1 3,3 7,1
% 3,4 3,5 3,6

maxY = 0.4; % Selectivity Index

%% Fish 9, neuron 3 • Iconic positive EV to postive FA

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
plot([Penn3EV.dels], [Penn3EV.dsi], 'b', 'LineWidth', 3);
plot([Penn3EA.dels], [Penn3EA.dsi], 'g', 'LineWidth', 3);
plot([Penn3FA.dels], [Penn3FA.dsi], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 9, neuron 3')


%% Fish 9, neuron 4 • Iconic positive EV to postive FA

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
plot([Penn4EV.dels], [Penn4EV.dsi], 'b', 'LineWidth', 3);
plot([Penn4EA.dels], [Penn4EA.dsi], 'g', 'LineWidth', 3);
plot([Penn4FA.dels], [Penn4FA.dsi], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 9, neuron 4')


%% Fish 3, neuron 1 • Centered positive EV to postive FA - delayed relative to iconics

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
plot([f3n1EV.dels], [f3n1EV.dsi], 'b', 'LineWidth', 3);
plot([f3n1EA.dels], [f3n1EA.dsi], 'g', 'LineWidth', 2);
plot([f3n1FA.dels], [f3n1FA.dsi], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 3, neuron 1')


%% Fish 3, neuron 2 • Centered positive EV to postive FA - delayed relative to iconics
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
plot([f3n2EV.dels], [f3n2EV.dsi], 'b', 'LineWidth', 3);
plot([f3n2EA.dels], [f3n2EA.dsi], 'g', 'LineWidth', 3);
plot([f3n2FA.dels], [f3n2FA.dsi], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 3, neuron 2')

%% Fish 3, neuron 3 • Centered positive EV to postive FA - delayed relative to iconics
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
plot([f3n3EV.dels], [f3n3EV.dsi], 'b', 'LineWidth', 3);
plot([f3n3EA.dels], [f3n3EA.dsi], 'g', 'LineWidth', 2);
plot([f3n3FA.dels], [f3n3FA.dsi], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 3, neuron 3')

%% Fish 4, neuron 6 • Positive EV is convincing, but nothing else?
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
plot([f4n6EV.dels], [f4n6EV.dsi], 'b', 'LineWidth', 3);
plot([f4n6EA.dels], [f4n6EA.dsi], 'g', 'LineWidth', 3);
plot([f4n6FA.dels], [f4n6FA.dsi], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 4, neuron 6')

%% Fish 7, neuron 1 • WEAK Centered positive EV to postive FA - delayed relative to iconics - but normal level motor
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
plot([f7n1EV.dels], [f7n1EV.dsi], 'b', 'LineWidth', 3);
plot([f7n1EA.dels], [f7n1EA.dsi], 'g', 'LineWidth', 2);
plot([f7n1FA.dels], [f7n1FA.dsi], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 7, neuron 1')

%% Fish 3, neuron 4 • Iconic negative EV to negative FA
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
plot([f3n4EV.dels], [f3n4EV.dsi], 'b', 'LineWidth', 3);
plot([f3n4EA.dels], [f3n4EA.dsi], 'g', 'LineWidth', 2);
plot([f3n4FA.dels], [f3n4FA.dsi], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 3, neuron 4')


%% Fish 3, neuron 5 • Iconic negative EV to negative FA
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
plot([f3n5EV.dels], [f3n5EV.dsi], 'b', 'LineWidth', 3);
plot([f3n5EA.dels], [f3n5EA.dsi], 'g', 'LineWidth', 2);
plot([f3n5FA.dels], [f3n5FA.dsi], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 3, neuron 5')

%% Fish 3, neuron 6 • Centered negative EV to negative FA - delayed relative to iconics - or maybe ICONIC
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
plot([f3n6EV.dels], [f3n6EV.dsi], 'b', 'LineWidth', 3);
plot([f3n6EA.dels], [f3n6EA.dsi], 'g', 'LineWidth', 2);
plot([f3n6FA.dels], [f3n6FA.dsi], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 3, neuron 6')

%% Fish 8, neuron 3 • Centered negative EV to negative FA - delayed relative to iconics - or maybe ICONIC
f = 8; n = 3;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f8n3EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f8n3EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f8n3FA = u_DSItimeplot(spiketimes, sig, tim);

figure(3); subplot(2,2,3); hold on;
plot([f8n3EV.dels], [f8n3EV.dsi], 'b', 'LineWidth', 3);
plot([f8n3EA.dels], [f8n3EA.dsi], 'g', 'LineWidth', 2);
plot([f8n3FA.dels], [f8n3FA.dsi], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 8, neuron 3')

%% Fish 8, neuron 4 • Centered negative EV to negative FA - delayed relative to iconics - or maybe ICONIC
f = 8; n = 4;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f8n4EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f8n4EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f8n4FA = u_DSItimeplot(spiketimes, sig, tim);

figure(3); subplot(2,2,3); hold on;
plot([f8n4EV.dels], [f8n4EV.dsi], 'b', 'LineWidth', 3);
plot([f8n4EA.dels], [f8n4EA.dsi], 'g', 'LineWidth', 2);
plot([f8n4FA.dels], [f8n4FA.dsi], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 8, neuron 4')


%% Fish 8, neuron 7 • Centered negative EV to negative FA - delayed relative to iconics - or maybe ICONIC
f = 8; n = 7;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f8n7EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f8n7EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f8n7FA = u_DSItimeplot(spiketimes, sig, tim);

figure(3); clf; hold on;
plot([f8n7EV.dels], [f8n7EV.dsi], 'b', 'LineWidth', 3);
plot([f8n7EA.dels], [f8n7EA.dsi], 'g', 'LineWidth', 2);
plot([f8n7FA.dels], [f8n7FA.dsi], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 8, neuron 7')


%% Fish 10, neuron 8 • Pos sensory only
f = 10; n = 8;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f10n8EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f10n8EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f10n8FA = u_DSItimeplot(spiketimes, sig, tim);

figure(3); hold on;
plot([f10n8EV.dels], [f10n8EV.dsi], 'b', 'LineWidth', 3);
plot([f10n8EA.dels], [f10n8EA.dsi], 'g', 'LineWidth', 2);
plot([f10n8FA.dels], [f10n8FA.dsi], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 10, neuron 8')


%% Fish 11, neuron 2 • Pos sensory only
f = 11; n = 2;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f11n2EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f11n2EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f11n2FA = u_DSItimeplot(spiketimes, sig, tim);

figure(3); clf; hold on;
plot([f11n2EV.dels], [f11n2EV.dsi], 'b', 'LineWidth', 3);
plot([f11n2EA.dels], [f11n2EA.dsi], 'g', 'LineWidth', 2);
plot([f11n2FA.dels], [f11n2FA.dsi], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 11, neuron 2')


%% Fish 6, neuron 1 • Pos sensory only
f = 6; n = 1;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f6n1EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f6n1EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f6n1FA = u_DSItimeplot(spiketimes, sig, tim);

figure(3); clf; hold on;
plot([f6n1EV.dels], [f6n1EV.dsi], 'b', 'LineWidth', 3);
plot([f6n1EA.dels], [f6n1EA.dsi], 'g', 'LineWidth', 2);
plot([f6n1FA.dels], [f6n1FA.dsi], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 6, neuron 1')


%% Fish 6, neuron 5 • Pos sensory only
f = 6; n = 5;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    f6n5EV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    f6n5EA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    f6n5FA = u_DSItimeplot(spiketimes, sig, tim);

figure(3); clf; hold on;
plot([f6n5EV.dels], [f6n5EV.dsi], 'b', 'LineWidth', 3);
plot([f6n5EA.dels], [f6n5EA.dsi], 'g', 'LineWidth', 2);
plot([f6n5FA.dels], [f6n5FA.dsi], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
title('Fish 6, neuron 5')



%% Testing
f = 4; n = 6;
spiketimes = curfish(f).spikes.times(curfish(f).spikes.codes == n);
tim = curfish(f).time;    
    sig = curfish(f).error_vel; 
    tmpEV = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).error_acc; 
    tmpEA = u_DSItimeplot(spiketimes, sig, tim);
    sig = curfish(f).fish_acc; 
    tmpFA = u_DSItimeplot(spiketimes, sig, tim);

figure(10); clf; hold on;
plot([tmpEV.dels], [tmpEV.dsi], 'b', 'LineWidth', 3);
plot([tmpEA.dels], [tmpEA.dsi], 'g', 'LineWidth', 3);
plot([tmpFA.dels], [tmpFA.dsi], 'm', 'LineWidth', 3);
xline(0); yline(0); ylim([-maxY, maxY]);
tit = ['Fish ', num2str(f), ' neuron ' num2str(n)];
title(tit)




%% Take the mean for our 6 Pos EV - Pos FA cases

baseDSIf9ev = (length(find(curfish(9).error_vel > 0)) - length(find(curfish(9).error_vel < 0))) / length(curfish(9).error_vel);
baseDSIf3ev = (length(find(curfish(3).error_vel > 0)) - length(find(curfish(3).error_vel < 0))) / length(curfish(3).error_vel);
baseDSIf7ev = (length(find(curfish(7).error_vel > 0)) - length(find(curfish(7).error_vel < 0))) / length(curfish(7).error_vel);


% Error velocity
mDSIev = [Penn4EV.dsi] - baseDSIf9ev;
mDSIev = mDSIev + [Penn3EV.dsi] - baseDSIf9ev;
mDSIev = mDSIev + [f3n2EV.dsi] - baseDSIf3ev;
mDSIev = mDSIev + [f3n1EV.dsi] - baseDSIf3ev;
mDSIev = mDSIev + [f3n3EV.dsi] - baseDSIf3ev;
mDSIev = mDSIev + [f7n1EV.dsi] - baseDSIf7ev;
mDSIev = mDSIev ./ 6;

% randomized EV
mrDSIev = [Penn4EV.rdsi] - baseDSIf9ev;
mrDSIev = mrDSIev + [Penn3EV.rdsi] - baseDSIf9ev;
mrDSIev = mrDSIev + [f3n2EV.rdsi] - baseDSIf3ev;
mrDSIev = mrDSIev + [f3n1EV.rdsi] - baseDSIf3ev;
mrDSIev = mrDSIev + [f3n3EV.rdsi] - baseDSIf3ev;
mrDSIev = mrDSIev + [f7n1EV.rdsi] - baseDSIf7ev;
mrDSIev = mrDSIev ./ 6;

% Error acceleration
mDSIea = [Penn4EA.dsi];
mDSIea = mDSIea + [Penn3EA.dsi];
mDSIea = mDSIea + [f3n2EA.dsi];
mDSIea = mDSIea + [f4n6EA.dsi];
mDSIea = mDSIea ./ 4;

% randomized EA
mrDSIea = [Penn4EA.rdsi];
mrDSIea = mrDSIea + [Penn3EA.rdsi];
mrDSIea = mrDSIea + [f3n2EA.rdsi];
mrDSIea = mrDSIea + [f4n6EA.rdsi];
mrDSIea = mrDSIea ./ 4;

figure(101); clf; hold on;
    plot(f3n2EV.dels(f3n2EV.dels >= 0), mDSIev(f3n2EV.dels >= 0), 'b-.', 'LineWidth', 3);
    plot(f3n2EV.dels(f3n2EV.dels <= 0), mDSIev(f3n2EV.dels <= 0), 'b-', 'LineWidth', 4);
    plot(f3n2EV.dels, mrDSIev, 'c', 'LineWidth', 1);

    %plot(f3n2EA.dels(f3n2EA.dels >= 0), mDSIea(f3n2EA.dels >= 0), 'g-.', 'LineWidth', 3);
    %plot(f3n2EA.dels(f3n2EA.dels <= 0), mDSIea(f3n2EA.dels <= 0), 'g-', 'LineWidth', 4);
    %plot(f3n2EA.dels, mrDSIea, 'g', 'LineWidth', 1);
    
    xlabel('delay, seconds'); ylabel('selectivity index');
    text(0.15, -0.2, 'N = 6','FontSize', 18);
    title('error velocity and fish acceleration: pos -> pos')

baseDSIf9fa = (length(find(curfish(9).fish_acc > 0)) - length(find(curfish(9).fish_acc < 0))) / length(curfish(9).fish_acc);
baseDSIf3fa = (length(find(curfish(3).fish_acc > 0)) - length(find(curfish(3).fish_acc < 0))) / length(curfish(3).fish_acc);
baseDSIf7fa = (length(find(curfish(7).fish_acc > 0)) - length(find(curfish(7).fish_acc < 0))) / length(curfish(7).fish_acc);

mDSIfa = [Penn4FA.dsi] - baseDSIf9fa;
mDSIfa = mDSIfa + [Penn3FA.dsi] - baseDSIf9fa;
mDSIfa = mDSIfa + [f3n2FA.dsi] - baseDSIf3fa;
mDSIfa = mDSIfa + [f3n1FA.dsi] - baseDSIf3fa;
mDSIfa = mDSIfa + [f3n3FA.dsi] - baseDSIf3fa;
mDSIfa = mDSIfa + [f7n1FA.dsi] - baseDSIf7fa;
mDSIfa = mDSIfa ./ 6;

mrDSIfa = [Penn4FA.rdsi] - baseDSIf9fa;
mrDSIfa = mrDSIfa + [Penn3FA.rdsi] - baseDSIf9fa;
mrDSIfa = mrDSIfa + [f3n2FA.rdsi] - baseDSIf3fa;
mrDSIfa = mrDSIfa + [f3n1FA.rdsi] - baseDSIf3fa;
mrDSIfa = mrDSIfa + [f3n3FA.rdsi] - baseDSIf3fa;
mrDSIfa = mrDSIfa + [f7n1FA.rdsi] - baseDSIf7fa;
mrDSIfa = mrDSIfa ./ 6;

figure(101); 
    plot(f3n2FA.dels(f3n2EV.dels <= 0), mDSIfa(f3n2EV.dels <= 0), 'r-.', 'LineWidth', 3);
    plot(f3n2FA.dels(f3n2EV.dels >= 0), mDSIfa(f3n2EV.dels >= 0), 'r-', 'LineWidth', 4);
    plot(f3n2FA.dels, mrDSIfa, 'm', 'LineWidth', 1);

xline(0); yline(0);
ylim([-0.25 0.25])
set(gcf, 'renderer', 'painters')

%% Take the mean for our 5 Neg EV - Neg FA cases

baseDSIf3ev = (length(find(curfish(3).error_vel > 0)) - length(find(curfish(3).error_vel < 0))) / length(curfish(3).error_vel);
baseDSIf8ev = (length(find(curfish(8).error_vel > 0)) - length(find(curfish(8).error_vel < 0))) / length(curfish(8).error_vel);

% Error velocity
mDSIev = [f3n4EV.dsi] - baseDSIf3ev;
mDSIev = mDSIev + [f3n5EV.dsi] - baseDSIf3ev;
mDSIev = mDSIev + [f3n6EV.dsi] - baseDSIf3ev;
mDSIev = mDSIev + [f8n3EV.dsi] - baseDSIf8ev;
mDSIev = mDSIev + [f8n4EV.dsi] - baseDSIf8ev;
mDSIev = mDSIev ./ 5;

% randomized EV
mrDSIev = [f3n4EV.rdsi] - baseDSIf3ev;
mrDSIev = mrDSIev + [f3n5EV.rdsi] - baseDSIf3ev;
mrDSIev = mrDSIev + [f3n6EV.rdsi] - baseDSIf3ev;
mrDSIev = mrDSIev + [f8n3EV.rdsi] - baseDSIf8ev;
mrDSIev = mrDSIev + [f8n4EV.rdsi] - baseDSIf8ev;
mrDSIev = mrDSIev ./ 5;

% Error acceleration
% mDSIea = [Penn4EA.dsi];
% mDSIea = mDSIea + [Penn3EA.dsi];
% mDSIea = mDSIea + [f3n2EA.dsi];
% mDSIea = mDSIea + [f4n6EA.dsi];
% mDSIea = mDSIea ./ 4;
% 
% % randomized EA
% mrDSIea = [Penn4EA.rdsi];
% mrDSIea = mrDSIea + [Penn3EA.rdsi];
% mrDSIea = mrDSIea + [f3n2EA.rdsi];
% mrDSIea = mrDSIea + [f4n6EA.rdsi];
% mrDSIea = mrDSIea ./ 4;

figure(102); clf; hold on;
    plot(f3n2EV.dels(f3n2EV.dels >= 0), mDSIev(f3n2EV.dels >= 0), 'b-.', 'LineWidth', 3);
    plot(f3n2EV.dels(f3n2EV.dels <= 0), mDSIev(f3n2EV.dels <= 0), 'b-', 'LineWidth', 4);
    plot(f3n2EV.dels, mrDSIev, 'c', 'LineWidth', 1);

    %plot(f3n2EA.dels(f3n2EA.dels >= 0), mDSIea(f3n2EA.dels >= 0), 'g-.', 'LineWidth', 3);
    %plot(f3n2EA.dels(f3n2EA.dels <= 0), mDSIea(f3n2EA.dels <= 0), 'g-', 'LineWidth', 4);
    %plot(f3n2EA.dels, mrDSIea, 'g', 'LineWidth', 1);
    
    xlabel('delay, seconds'); ylabel('selectivity index');
    text(0.15, -0.2, 'N = 5','FontSize', 18);
    title('error velocity and fish acceleration: neg -> neg')

baseDSIf3fa = (length(find(curfish(3).fish_acc > 0)) - length(find(curfish(3).fish_acc < 0))) / length(curfish(3).fish_acc);
baseDSIf8fa = (length(find(curfish(8).fish_acc > 0)) - length(find(curfish(8).fish_acc < 0))) / length(curfish(8).fish_acc);

mDSIfa = [f3n4FA.dsi] - baseDSIf3fa;
mDSIfa = mDSIfa + [f3n5FA.dsi] - baseDSIf3fa;
mDSIfa = mDSIfa + [f3n6FA.dsi] - baseDSIf3fa;
mDSIfa = mDSIfa + [f8n3FA.dsi] - baseDSIf8fa;
mDSIfa = mDSIfa + [f8n4FA.dsi] - baseDSIf8fa;
mDSIfa = mDSIfa ./ 5;

mrDSIfa = [f3n4FA.rdsi] - baseDSIf3fa;
mrDSIfa = mrDSIfa + [f3n5FA.rdsi] - baseDSIf3fa;
mrDSIfa = mrDSIfa + [f3n6FA.rdsi] - baseDSIf3fa;
mrDSIfa = mrDSIfa + [f8n3FA.rdsi] - baseDSIf8fa;
mrDSIfa = mrDSIfa + [f8n4FA.rdsi] - baseDSIf8fa;
mrDSIfa = mrDSIfa ./ 5;

figure(102); 
    plot(f3n2FA.dels(f3n2EV.dels <= 0), mDSIfa(f3n2EV.dels <= 0), 'r-.', 'LineWidth', 3);
    plot(f3n2FA.dels(f3n2EV.dels >= 0), mDSIfa(f3n2EV.dels >= 0), 'r-', 'LineWidth', 4);
    plot(f3n2FA.dels, mrDSIfa, 'm', 'LineWidth', 1);

xline(0); yline(0);
ylim([-0.25 0.25])
set(gcf, 'renderer', 'painters')


%% Take the mean for our 3 Pos EV only cases

baseDSIf10ev = (length(find(curfish(10).error_vel > 0)) - length(find(curfish(10).error_vel < 0))) / length(curfish(10).error_vel);
baseDSIf8ev = (length(find(curfish(8).error_vel > 0)) - length(find(curfish(8).error_vel < 0))) / length(curfish(8).error_vel);
baseDSIf4ev = (length(find(curfish(4).error_vel > 0)) - length(find(curfish(4).error_vel < 0))) / length(curfish(4).error_vel);

% Error velocity
mDSIev = [f10n8EV.dsi] - baseDSIf10ev;
mDSIev = mDSIev + [f8n7EV.dsi] - baseDSIf8ev;
mDSIev = mDSIev + [f4n6EV.dsi] - baseDSIf4ev;
mDSIev = mDSIev ./ 3;

% randomized EV
mrDSIev = [f10n8EV.rdsi] - baseDSIf10ev;
mrDSIev = mrDSIev + [f8n7EV.rdsi] - baseDSIf8ev;
mrDSIev = mrDSIev + [f4n6EV.rdsi] - baseDSIf4ev;
mrDSIev = mrDSIev ./ 3;

% Error acceleration
% mDSIea = [Penn4EA.dsi];
% mDSIea = mDSIea + [Penn3EA.dsi];
% mDSIea = mDSIea + [f3n2EA.dsi];
% mDSIea = mDSIea + [f4n6EA.dsi];
% mDSIea = mDSIea ./ 4;
% 
% % randomized EA
% mrDSIea = [Penn4EA.rdsi];
% mrDSIea = mrDSIea + [Penn3EA.rdsi];
% mrDSIea = mrDSIea + [f3n2EA.rdsi];
% mrDSIea = mrDSIea + [f4n6EA.rdsi];
% mrDSIea = mrDSIea ./ 4;

figure(103); clf; hold on;
    plot(f3n2EV.dels(f3n2EV.dels >= 0), mDSIev(f3n2EV.dels >= 0), 'b-.', 'LineWidth', 3);
    plot(f3n2EV.dels(f3n2EV.dels <= 0), mDSIev(f3n2EV.dels <= 0), 'b-', 'LineWidth', 4);
    plot(f3n2EV.dels, mrDSIev, 'c', 'LineWidth', 1);

    %plot(f3n2EA.dels(f3n2EA.dels >= 0), mDSIea(f3n2EA.dels >= 0), 'g-.', 'LineWidth', 3);
    %plot(f3n2EA.dels(f3n2EA.dels <= 0), mDSIea(f3n2EA.dels <= 0), 'g-', 'LineWidth', 4);
    %plot(f3n2EA.dels, mrDSIea, 'g', 'LineWidth', 1);
    
    xlabel('delay, seconds'); ylabel('selectivity index');
    text(0.15, -0.2, 'N = 3','FontSize', 18);
    title('error velocity and fish acceleration: neg -> neg')

baseDSIf10fa = (length(find(curfish(10).fish_acc > 0)) - length(find(curfish(10).fish_acc < 0))) / length(curfish(10).fish_acc);
baseDSIf8fa = (length(find(curfish(8).fish_acc > 0)) - length(find(curfish(8).fish_acc < 0))) / length(curfish(8).fish_acc);
baseDSIf4fa = (length(find(curfish(4).fish_acc > 0)) - length(find(curfish(4).fish_acc < 0))) / length(curfish(4).fish_acc);

mDSIfa = [f10n8FA.dsi] - baseDSIf10fa;
mDSIfa = mDSIfa + [f8n7FA.dsi] - baseDSIf8fa;
mDSIfa = mDSIfa + [f4n6FA.dsi] - baseDSIf4fa;
mDSIfa = mDSIfa ./ 3;

figure(103); 
    plot(f3n2FA.dels(f3n2EV.dels <= 0), mDSIfa(f3n2EV.dels <= 0), 'r-.', 'LineWidth', 3);
    plot(f3n2FA.dels(f3n2EV.dels >= 0), mDSIfa(f3n2EV.dels >= 0), 'r-', 'LineWidth', 4);
    plot(f3n2FA.dels, mrDSIfa, 'm', 'LineWidth', 1);

xline(0); yline(0);
ylim([-0.25 0.25])
set(gcf, 'renderer', 'painters')



%% Take the mean for our 3 Neg EV only cases

baseDSIf11ev = (length(find(curfish(11).error_vel > 0)) - length(find(curfish(11).error_vel < 0))) / length(curfish(11).error_vel);
baseDSIf6ev = (length(find(curfish(6).error_vel > 0)) - length(find(curfish(6).error_vel < 0))) / length(curfish(6).error_vel);

% Error velocity
mDSIev = [f11n2EV.dsi] - baseDSIf11ev;
mDSIev = mDSIev + [f6n1EV.dsi] - baseDSIf6ev;
mDSIev = mDSIev + [f6n5EV.dsi] - baseDSIf6ev;
mDSIev = mDSIev ./ 3;

% randomized EV
mrDSIev = [f11n2EV.rdsi] - baseDSIf11ev;
mrDSIev = mrDSIev + [f6n1EV.rdsi] - baseDSIf6ev;
mrDSIev = mrDSIev + [f6n5EV.rdsi] - baseDSIf6ev;
mrDSIev = mrDSIev ./ 3;

% Error acceleration
% mDSIea = [Penn4EA.dsi];
% mDSIea = mDSIea + [Penn3EA.dsi];
% mDSIea = mDSIea + [f3n2EA.dsi];
% mDSIea = mDSIea + [f4n6EA.dsi];
% mDSIea = mDSIea ./ 4;
% 
% % randomized EA
% mrDSIea = [Penn4EA.rdsi];
% mrDSIea = mrDSIea + [Penn3EA.rdsi];
% mrDSIea = mrDSIea + [f3n2EA.rdsi];
% mrDSIea = mrDSIea + [f4n6EA.rdsi];
% mrDSIea = mrDSIea ./ 4;

figure(104); clf; hold on;
    plot(f3n2EV.dels(f3n2EV.dels >= 0), mDSIev(f3n2EV.dels >= 0), 'b-.', 'LineWidth', 3);
    plot(f3n2EV.dels(f3n2EV.dels <= 0), mDSIev(f3n2EV.dels <= 0), 'b-', 'LineWidth', 4);
    plot(f3n2EV.dels, mrDSIev, 'c', 'LineWidth', 1);

    %plot(f3n2EA.dels(f3n2EA.dels >= 0), mDSIea(f3n2EA.dels >= 0), 'g-.', 'LineWidth', 3);
    %plot(f3n2EA.dels(f3n2EA.dels <= 0), mDSIea(f3n2EA.dels <= 0), 'g-', 'LineWidth', 4);
    %plot(f3n2EA.dels, mrDSIea, 'g', 'LineWidth', 1);
    
    xlabel('delay, seconds'); ylabel('selectivity index');
    text(0.15, -0.2, 'N = 3','FontSize', 18);
    title('error velocity and fish acceleration: neg -> neg')

baseDSIf11fa = (length(find(curfish(11).fish_acc > 0)) - length(find(curfish(11).fish_acc < 0))) / length(curfish(11).fish_acc);
baseDSIf6fa = (length(find(curfish(6).fish_acc > 0)) - length(find(curfish(6).fish_acc < 0))) / length(curfish(6).fish_acc);

mDSIfa = [f11n2FA.dsi] - baseDSIf11fa;
mDSIfa = mDSIfa + [f6n1FA.dsi] - baseDSIf6fa;
mDSIfa = mDSIfa + [f6n5FA.dsi] - baseDSIf6fa;
mDSIfa = mDSIfa ./ 3;

figure(104); 
    plot(f3n2FA.dels(f3n2EV.dels <= 0), mDSIfa(f3n2EV.dels <= 0), 'r-.', 'LineWidth', 3);
    plot(f3n2FA.dels(f3n2EV.dels >= 0), mDSIfa(f3n2EV.dels >= 0), 'r-', 'LineWidth', 4);
    plot(f3n2FA.dels, mrDSIfa, 'm', 'LineWidth', 1);

xline(0); yline(0);
ylim([-0.25 0.25])
set(gcf, 'renderer', 'painters')



%% Take the mean for our 6 acceleration cases

mDSIev = [f3n1EV.dsi];
mDSIev = mDSIev + [f3n1EV.dsi];
mDSIev = mDSIev + [f3n3EV.dsi];
mDSIev = mDSIev + [f7n1EV.dsi];
mDSIev = mDSIev - [f3n4EV.dsi];
mDSIev = mDSIev - [f3n5EV.dsi];
mDSIev = mDSIev - [f3n6EV.dsi];
mDSIev = mDSIev ./ 6;

mrDSIev = [f3n1EV.rdsi];
mrDSIev = mrDSIev + [f3n1EV.rdsi];
mrDSIev = mrDSIev + [f3n3EV.rdsi];
mrDSIev = mrDSIev + [f7n1EV.rdsi];
mrDSIev = mrDSIev - [f3n4EV.rdsi];
mrDSIev = mrDSIev - [f3n5EV.rdsi];
mrDSIev = mrDSIev - [f3n6EV.rdsi];
mrDSIev = mrDSIev ./ 6;

% Error acceleration
mDSIea = [f3n1EA.dsi];
mDSIea = mDSIea + [f3n1EA.dsi];
mDSIea = mDSIea + [f3n3EA.dsi];
mDSIea = mDSIea + [f7n1EA.dsi];
mDSIea = mDSIea - [f3n4EA.dsi];
mDSIea = mDSIea - [f3n5EA.dsi];
mDSIea = mDSIea - [f3n6EA.dsi];
mDSIea = mDSIea ./ 6;

% random EA
mrDSIea = [f3n1EA.rdsi];
mrDSIea = mrDSIea + [f3n1EA.rdsi];
mrDSIea = mrDSIea + [f3n3EA.rdsi];
mrDSIea = mrDSIea + [f7n1EA.rdsi];
mrDSIea = mrDSIea - [f3n4EA.rdsi];
mrDSIea = mrDSIea - [f3n5EA.rdsi];
mrDSIea = mrDSIea - [f3n6EA.rdsi];
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

mDSIfa = [f3n1EA.dsi];
mDSIfa = mDSIfa + [f3n1FA.dsi];
mDSIfa = mDSIfa + [f3n3FA.dsi];
mDSIfa = mDSIfa + [f7n1FA.dsi];
mDSIfa = mDSIfa - [f3n4FA.dsi];
mDSIfa = mDSIfa - [f3n5FA.dsi];
mDSIfa = mDSIfa - [f3n6FA.dsi];
mDSIfa = mDSIfa ./ 6;

mrDSIfa = [f3n1EA.rdsi];
mrDSIfa = mrDSIfa + [f3n1FA.rdsi];
mrDSIfa = mrDSIfa + [f3n3FA.rdsi];
mrDSIfa = mrDSIfa + [f7n1FA.rdsi];
mrDSIfa = mrDSIfa - [f3n4FA.rdsi];
mrDSIfa = mrDSIfa - [f3n5FA.rdsi];
mrDSIfa = mrDSIfa - [f3n6FA.rdsi];
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