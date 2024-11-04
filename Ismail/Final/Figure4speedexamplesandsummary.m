% Figure 5

posposIDX = [15 16 17 51 52];
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

%% Calculate our example

f = 9; n = 4; evcutoff = 85;
exampleEVslowDSI = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time, [0 evcutoff]);
exampleEVfastDSI = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time, [evcutoff 1000000]);
exampleEVallDSI = u_DSItimeplot(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).time);
exampleFAallDSI = u_DSItimeplot(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).fish_acc, curfish(f).time);


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

