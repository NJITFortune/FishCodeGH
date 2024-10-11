
fishNum = 4; unitNum = 6;

spiketimes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == unitNum);
tim = curfish(fishNum).time;

sig = curfish(fishNum).error_vel;
sig2 = curfish(fishNum).fish_acc;

evthresh = 175; fathresh = 725;
EVrangeSlow = [0 evthresh]; % Default 175
EVrangeFast = [evthresh 10000];
FArangeSlow = [0 fathresh]; % Default 725
FArangeFast = [fathresh 100000];


EVslow = u_DSItimeplotRange(spiketimes, sig, sig2, tim, EVrangeSlow);
    [~, evslowMaxIDX] = max(abs(EVslow.dsi(EVslow.dels < 0)));
EVfast = u_DSItimeplotRange(spiketimes, sig, sig2, tim, EVrangeFast);
    [~, evfastMaxIDX] = max(abs(EVfast.dsi(EVfast.dels < 0)));

FAslow = u_DSItimeplotRange(spiketimes, sig2, sig, tim, FArangeSlow);
    [~, faslowMaxIDX] = max(abs(FAslow.dsi(FAslow.dels > 0)));
    faslowMaxIDX = faslowMaxIDX + length(find(FAslow.dels <= 0));
FAfast = u_DSItimeplotRange(spiketimes, sig2, sig, tim, FArangeFast);
    [~, fafastMaxIDX] = max(abs(FAfast.dsi(FAfast.dels > 0)));
    fafastMaxIDX = fafastMaxIDX + length(find(FAfast.dels <= 0));

figure(1); clf;

subplot(121); hold on;
    plot(EVslow.dels, EVslow.dsi, 'b-') 
    plot(EVfast.dels, EVfast.dsi, 'm-');
    plot(EVslow.dels(evslowMaxIDX), EVslow.dsi(evslowMaxIDX), 'b.', 'MarkerSize',16);
    plot(EVfast.dels(evfastMaxIDX), EVfast.dsi(evfastMaxIDX), 'm.', 'MarkerSize',16);
    plot(EVslow.dels, EVslow.dsi2, 'c-'); 
    plot(EVfast.dels, EVfast.dsi2, 'r-');
    xline(0)


subplot(122); hold on;
    plot(FAslow.dels, FAslow.dsi, 'b-');
    plot(FAfast.dels, FAfast.dsi, 'm-');
    plot(FAslow.dels(faslowMaxIDX), FAslow.dsi(faslowMaxIDX), 'b.', 'MarkerSize',16);
    plot(FAfast.dels(fafastMaxIDX), FAfast.dsi(fafastMaxIDX), 'm.', 'MarkerSize',16);
    plot(FAslow.dels, FAslow.dsi2, 'c-');
    plot(FAfast.dels, FAfast.dsi2, 'r-');
    xline(0)
