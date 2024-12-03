% Figure 5

posposIDX = [15 16 17 26 48 51 52];
negnegIDX = [18 19 20 45 46];
allotherIDX = [1 2 3 5 7 8 10 11 12 14 21 22 23 24 25 26 27 28 31 32 33 34 35 37 39 43 44 47 48 49 50 54 56 57 60 66 69 70 71 72 73];



%% Calculate the DSIs

posposData = DSIfastslow(posposIDX, neuronsAll, curfish);
negnegData = DSIfastslow(negnegIDX, neuronsAll, curfish);
otherData = DSIfastslow(allotherIDX, neuronsAll, curfish);

% Combine pospos and negneg, and take the absolute value because what we
% care about is how direction selective it is, not which direction

% EV data
EVmeanPreferredFast = mean(abs([posposData.EVmasterEV(:,6)' negnegData.EVmasterEV(:,6)']));
EVmeanOtherFast = mean(abs(otherData.EVmasterEV(:,6)));
EVmeanPreferredSlow = mean(abs([posposData.EVmasterEV(:,4)' negnegData.EVmasterEV(:,4)']));
EVmeanOtherSlow = mean(abs(otherData.EVmasterEV(:,4)));

% FA data
FAmeanPreferredFast = mean(abs([posposData.EVmasterFA(:,6)' negnegData.EVmasterFA(:,6)']));
FAmeanOtherFast = mean(abs(otherData.EVmasterFA(:,6)));
FAmeanPreferredSlow = mean(abs([posposData.EVmasterFA(:,4)' negnegData.EVmasterFA(:,4)']));
FAmeanOtherSlow = mean(abs(otherData.EVmasterFA(:,4)));

% EVdata
EVstdPreferredFast = std(abs([posposData.EVmasterEV(:,6)' negnegData.EVmasterEV(:,6)']));
EVstdOtherFast = std(abs(otherData.EVmasterEV(:,6)));
EVstdPreferredSlow = std(abs([posposData.EVmasterEV(:,4)' negnegData.EVmasterEV(:,4)']));
EVstdOtherSlow = std(abs(otherData.EVmasterEV(:,4)));

% FAdata
FAstdPreferredFast = std(abs([posposData.EVmasterFA(:,6)' negnegData.EVmasterFA(:,6)']));
FAstdOtherFast = std(abs(otherData.EVmasterFA(:,6)));
FAstdPreferredSlow = std(abs([posposData.EVmasterFA(:,4)' negnegData.EVmasterFA(:,4)']));
FAstdOtherSlow = std(abs(otherData.EVmasterFA(:,4)));

%% Calculate our examples

f = 9; n = 4; evcutoff = 85;
EVslowDSI94 = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time, [0 evcutoff]);
EVfastDSI94 = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time, [evcutoff 1000000]);
EVallDSI94 = u_DSItimeplot(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).time);
FAallDSI94 = u_DSItimeplot(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).fish_acc, curfish(f).time);

f = 9; n = 3; evcutoff = 85;
EVslowDSI93 = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time, [0 evcutoff]);
EVfastDSI93 = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time, [evcutoff 1000000]);
EVallDSI93 = u_DSItimeplot(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).time);
FAallDSI93 = u_DSItimeplot(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).fish_acc, curfish(f).time);

f = 3; n = 1; evcutoff = 100;
EVslowDSI31 = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time, [0 evcutoff]);
EVfastDSI31 = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time, [evcutoff 1000000]);
EVallDSI31 = u_DSItimeplot(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).time);
FAallDSI31 = u_DSItimeplot(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).fish_acc, curfish(f).time);

f = 3; n = 2; evcutoff = 100;
EVslowDSI32 = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time, [0 evcutoff]);
EVfastDSI32 = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time, [evcutoff 1000000]);
EVallDSI32 = u_DSItimeplot(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).time);
FAallDSI32 = u_DSItimeplot(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).fish_acc, curfish(f).time);

f = 3; n = 3; evcutoff = 100;
EVslowDSI33 = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time, [0 evcutoff]);
EVfastDSI33 = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time, [evcutoff 1000000]);
EVallDSI33 = u_DSItimeplot(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).time);
FAallDSI33 = u_DSItimeplot(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).fish_acc, curfish(f).time);

f = 4; n = 6; evcutoff = 75;
EVslowDSI46 = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time, [0 evcutoff]);
EVfastDSI46 = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time, [evcutoff 1000000]);
EVallDSI46 = u_DSItimeplot(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).time);
FAallDSI46 = u_DSItimeplot(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).fish_acc, curfish(f).time);

f = 8; n = 6; evcutoff = 55;
EVslowDSI86 = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time, [0 evcutoff]);
EVfastDSI86 = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time, [evcutoff 1000000]);
EVallDSI86 = u_DSItimeplot(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).time);
FAallDSI86 = u_DSItimeplot(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).fish_acc, curfish(f).time);

%% Plot our examples

figure(31); clf; hold on;
    plot(EVslowDSI93.dels, EVslowDSI93.dsi, 'Color', 'm');
    plot(EVfastDSI94.dels, EVfastDSI94.dsi, 'Color', 'r');
    plot(EVslowDSI93.dels, EVslowDSI93.dsi2, 'Color', 'c');
    plot(EVfastDSI94.dels, EVfastDSI94.dsi2, 'Color', 'b');
figure(32); clf; hold on;
    plot(EVslowDSI94.dels, EVslowDSI94.dsi, 'Color', 'm');
    plot(EVfastDSI94.dels, EVfastDSI94.dsi, 'Color', 'r');
    plot(EVslowDSI94.dels, EVslowDSI94.dsi2, 'Color', 'c');
    plot(EVfastDSI94.dels, EVfastDSI94.dsi2, 'Color', 'b');
figure(33); clf; hold on;
    plot(EVslowDSI31.dels, EVslowDSI31.dsi, 'Color', 'm');
    plot(EVfastDSI31.dels, EVfastDSI31.dsi, 'Color', 'r');
    plot(EVslowDSI31.dels, EVslowDSI31.dsi2, 'Color', 'c');
    plot(EVfastDSI31.dels, EVfastDSI31.dsi2, 'Color', 'b');
figure(34); clf; hold on;
    plot(EVslowDSI32.dels, EVslowDSI32.dsi, 'Color', 'm');
    plot(EVfastDSI32.dels, EVfastDSI32.dsi, 'Color', 'r');
    plot(EVslowDSI32.dels, EVslowDSI32.dsi2, 'Color', 'c');
    plot(EVfastDSI32.dels, EVfastDSI32.dsi2, 'Color', 'b');
figure(35); clf; hold on;
    plot(EVslowDSI33.dels, EVslowDSI33.dsi, 'Color', 'm');
    plot(EVfastDSI33.dels, EVfastDSI33.dsi, 'Color', 'r');
    plot(EVslowDSI33.dels, EVslowDSI33.dsi2, 'Color', 'c');
    plot(EVfastDSI33.dels, EVfastDSI33.dsi2, 'Color', 'b');
figure(36); clf; hold on;
    plot(EVslowDSI46.dels, EVslowDSI46.dsi, 'Color', 'm');
    plot(EVfastDSI46.dels, EVfastDSI46.dsi, 'Color', 'r');
    plot(EVslowDSI46.dels, EVslowDSI46.dsi2, 'Color', 'c');
    plot(EVfastDSI46.dels, EVfastDSI46.dsi2, 'Color', 'b');
figure(37); clf; hold on;
    plot(EVslowDSI86.dels, EVslowDSI86.dsi, 'Color', 'm');
    plot(EVfastDSI86.dels, EVfastDSI86.dsi, 'Color', 'r');
    plot(EVslowDSI86.dels, EVslowDSI86.dsi2, 'Color', 'c');
    plot(EVfastDSI86.dels, EVfastDSI86.dsi2, 'Color', 'b');

meanfastDSIev = (EVfastDSI93.dsi - mean(EVfastDSI93.rdsi)) + (EVfastDSI94.dsi - mean(EVfastDSI94.rdsi)) + (EVfastDSI31.dsi - mean(EVfastDSI31.rdsi)) + (EVfastDSI32.dsi - mean(EVfastDSI32.rdsi)) + (EVfastDSI33.dsi - mean(EVfastDSI33.rdsi)) + (EVfastDSI46.dsi - mean(EVfastDSI46.rdsi)) + (EVfastDSI86.dsi - mean(EVfastDSI86.rdsi));
meanfastDSIev = meanfastDSIev / 7;
meanslowDSIev = (EVslowDSI93.dsi - mean(EVslowDSI93.rdsi)) + (EVslowDSI94.dsi - mean(EVslowDSI94.rdsi)) + (EVslowDSI31.dsi - mean(EVslowDSI31.rdsi)) + (EVslowDSI32.dsi - mean(EVslowDSI32.rdsi)) + (EVslowDSI33.dsi - mean(EVslowDSI33.rdsi)) + (EVslowDSI46.dsi - mean(EVslowDSI46.rdsi)) + (EVslowDSI86.dsi - mean(EVslowDSI86.rdsi));
meanslowDSIev = meanslowDSIev / 7;
figure(7); clf; hold on; 
    plot(EVslowDSI93.dels, meanslowDSIev, 'Color', 'm');
    plot(EVfastDSI94.dels, meanfastDSIev, 'Color', 'b');
    plot(EVslowDSI93.dels(EVslowDSI93.dels >= 0), meanfastDSIev(EVslowDSI93.dels >= 0), 'b-.', 'LineWidth', 3);
    plot(EVslowDSI93.dels(EVslowDSI93.dels <= 0), meanfastDSIev(EVslowDSI93.dels <= 0), 'b-', 'LineWidth', 4);
    plot(EVslowDSI93.dels(EVslowDSI93.dels >= 0), meanslowDSIev(EVslowDSI93.dels >= 0), 'r-.', 'LineWidth', 3);
    plot(EVslowDSI93.dels(EVslowDSI93.dels <= 0), meanslowDSIev(EVslowDSI93.dels <= 0), 'r-', 'LineWidth', 4);
    set(gcf, 'renderer', 'painters')

    xline(0); ylim([-0.1 0.3])

meanfastDSIfa = (EVfastDSI93.dsi2 - mean(EVfastDSI93.rdsi2)) + (EVfastDSI94.dsi2 - mean(EVfastDSI94.rdsi2)) + (EVfastDSI31.dsi2 - mean(EVfastDSI31.rdsi2)) + (EVfastDSI32.dsi2 - mean(EVfastDSI32.rdsi2)) + (EVfastDSI33.dsi2 - mean(EVfastDSI33.rdsi2)) + (EVfastDSI46.dsi2 - mean(EVfastDSI46.rdsi2)) + (EVfastDSI86.dsi2 - mean(EVfastDSI86.rdsi2));
meanfastDSIfa = meanfastDSIfa / 7;
meanslowDSIfa = (EVslowDSI93.dsi2 - mean(EVslowDSI93.rdsi2)) + (EVslowDSI94.dsi2 - mean(EVslowDSI94.rdsi2)) + (EVslowDSI31.dsi2 - mean(EVslowDSI31.rdsi2)) + (EVslowDSI32.dsi2 - mean(EVslowDSI32.rdsi2)) + (EVslowDSI33.dsi2 - mean(EVslowDSI33.rdsi2)) + (EVslowDSI46.dsi2 - mean(EVslowDSI46.rdsi2)) + (EVslowDSI86.dsi2 - mean(EVslowDSI86.rdsi2));
meanslowDSIfa = meanslowDSIfa / 7;
figure(8); clf; hold on; 
    %plot(EVslowDSI93.dels, meanslowDSIfa, 'Color', 'm');
    %plot(EVfastDSI94.dels, meanfastDSIfa, 'Color', 'b');

    plot(EVslowDSI93.dels(EVslowDSI93.dels <= 0), meanfastDSIfa(EVslowDSI93.dels <= 0), 'b-.', 'LineWidth', 3);
    plot(EVslowDSI93.dels(EVslowDSI93.dels >= 0), meanfastDSIfa(EVslowDSI93.dels >= 0), 'b-', 'LineWidth', 4);
    plot(EVslowDSI93.dels(EVslowDSI93.dels <= 0), meanslowDSIfa(EVslowDSI93.dels <= 0), 'r-.', 'LineWidth', 3);
    plot(EVslowDSI93.dels(EVslowDSI93.dels >= 0), meanslowDSIfa(EVslowDSI93.dels >= 0), 'r-', 'LineWidth', 4);
    xline(0); ylim([-0.1 0.3])
    set(gcf, 'renderer', 'painters')
%% Stats for only pos pos fast versus slow

posposIDX = [15 16 17 26 48 51 52];
posposData = DSIfastslow(posposIDX, neuronsAll, curfish);

%%

% Preferred fast versus slow
[pp,oo,ii,uu] = ttest2(posposData.EVmasterEV(:,6), posposData.EVmasterEV(:,4))
% PASSED P VALUE TEST

[pp,oo,ii,uu] = ttest2(posposData.EVmasterFA(:,6), posposData.EVmasterFA(:,4))
% FAILED P VALUE TEST

%% Statistical tests

% Preferred fast versus slow
[pp,oo,ii,uu] = ttest2(abs([posposData.EVmasterEV(:,6)' negnegData.EVmasterEV(:,6)']), abs([posposData.EVmasterEV(:,4)' negnegData.EVmasterEV(:,4)']))

% Other fast versus slow
[mm,nn,bb,vv] = ttest2(abs(otherData.EVmasterEV(:,6)), abs(otherData.EVmasterEV(:,4)))

% Preferred fast versus other fast
[ll,kk,jj,hh] = ttest2(abs([posposData.EVmasterEV(:,6)' negnegData.EVmasterEV(:,6)']), abs(otherData.EVmasterEV(:,6)))

% Preferred slow versus other slow
[yy,tt,rr,ee] = ttest2(abs([posposData.EVmasterEV(:,4)' negnegData.EVmasterEV(:,4)']), abs(otherData.EVmasterEV(:,4)))


%% Plots

figure(33); clf; hold on;
errorbar([0.9 1.9 2.9 3.9], [EVmeanPreferredFast EVmeanPreferredSlow EVmeanOtherFast EVmeanOtherSlow], [EVstdPreferredFast EVstdPreferredSlow EVstdOtherFast EVstdOtherSlow], 'm.', 'MarkerSize', 36)
errorbar([1.1 2.1 3.1 4.1], [FAmeanPreferredFast FAmeanPreferredSlow FAmeanOtherFast FAmeanOtherSlow], [FAstdPreferredFast FAstdPreferredSlow FAstdOtherFast FAstdOtherSlow], 'b.', 'MarkerSize', 36)
    xlim([0 5]);
    title('Fast ecn, Mean Slow ecn, Others Fast, Others slow')
    set(gcf, 'renderer', 'painters')

figure(32); clf; hold on;
    % Fast and slow
    plot(exampleEVslowDSI.dels, exampleEVslowDSI.dsi, 'Color', 'm');
    plot(exampleEVfastDSI.dels, exampleEVfastDSI.dsi, 'Color', 'b');
    % All spikes
    plot(exampleEVallDSI.dels, exampleEVallDSI.dsi, 'Color', "#333333");
    plot(exampleEVallDSI.dels, exampleEVallDSI.rdsi, 'g');

    xline(0); ylim([-0.2 0.4])
    title('EV Fast (blue) vs. Slow (magenta) vs. all')
    set(gcf, 'renderer', 'painters')

figure(31); clf; hold on;
    % Fast and slow
    plot(exampleEVslowDSI.dels, exampleEVslowDSI.dsi2, 'Color', 'm');
    plot(exampleEVfastDSI.dels, exampleEVfastDSI.dsi2, 'Color', 'b');
    % All spikes
    plot(exampleFAallDSI.dels, exampleFAallDSI.dsi, 'Color', "#333333");
    plot(exampleFAallDSI.dels, exampleFAallDSI.rdsi, 'g');

    xline(0); ylim([-0.2 0.4])
    title('FA Fast (blue) vs. Slow (magenta) vs. all')
    set(gcf, 'renderer', 'painters')

% Velocity threshold sample for figure

figure(2); clf; plot(curfish(3).time, curfish(3).error_vel, 'k'); hold on; plot(curfish(3).time(slowtt), curfish(3).error_vel(slowtt)); xlim([122 132])
set(gcf, 'renderer', 'painters')
