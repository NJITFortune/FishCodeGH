% iu_DSIcompleat

%% Get fast and slow spike data
thresh = 30;

spikes = curfish(9).spikes.times(curfish(9).spikes.codes == 3);
signal = curfish(9).error_vel;
tracking = curfish(9).tracking;
tim = curfish(9).time;
delt = -0.150;


[dsiSP, dsiAS, cnts] = iu_trackingDSI(spikes, signal, tracking, tim, delt);

slowASspikes = cnts.AStrax(abs(cnts.AStrax) < thresh); 
fastASspikes = cnts.AStrax(abs(cnts.AStrax) > thresh); 
slowSPspikes = cnts.SPtrax(abs(cnts.SPtrax) < thresh); 
fastSPspikes = cnts.SPtrax(abs(cnts.SPtrax) > thresh); 

%% Distribution

fastbinedges = -300:10:300;
fastbincenters = -295:10:295;
slowbinedges = -30:2:30;
slowbincenters = -29:2:29;

normFast = histcounts(signal, fastbinedges, 'Normalization', 'count');
normSlow = histcounts(signal, slowbinedges, 'Normalization', 'count');
ASfastbins = histcounts(fastASspikes, fastbinedges, 'Normalization', 'count');
ASslowbins = histcounts(slowASspikes, slowbinedges, 'Normalization', 'count');
figure(49); clf; 
    subplot(121); plot(fastbincenters, normFast ./ sum(normFast)); hold on; plot(fastbincenters, ASfastbins ./ sum(ASfastbins));
    ylim([0 0.1])
    subplot(122); plot(slowbincenters, normSlow ./ sum(normSlow)); hold on; plot(slowbincenters, ASslowbins ./ sum(ASslowbins));
    ylim([0 0.1]);

SPfastbins = histcounts(fastSPspikes, fastbinedges, 'Normalization', 'count');
SPslowbins = histcounts(slowSPspikes, slowbinedges, 'Normalization', 'count');
figure(48); clf; 
    subplot(121); plot(fastbincenters, normFast ./ sum(normFast)); hold on; plot(fastbincenters, SPfastbins ./ sum(SPfastbins));
    ylim([0 0.1])
    subplot(122); plot(slowbincenters, normSlow ./ sum(normSlow)); hold on; plot(slowbincenters, SPslowbins ./ sum(SPslowbins));
    ylim([0 0.1]);
%% Calculate occupancy-corrected DSI values

asError = curfish.error_vel(curfish.tracking == 1 | curfish.tracking == 3);
    occupASev = (length(find(asError > 0)) - length(find(asError < 0))) / length(asError);
spError = curfish.error_vel(curfish.tracking == 0 | curfish.tracking == 2);
    occupSPev = (length(find(spError > 0)) - length(find(spError < 0))) / length(spError);
asFish = curfish.fish_acc(curfish.tracking == 1 | curfish.tracking == 3);
    occupASfa = (length(find(asFish > 0)) - length(find(asFish < 0))) / length(asFish);
spFish = curfish.fish_acc(curfish.tracking == 0 | curfish.tracking == 2);
    occupSPfa = (length(find(spFish > 0)) - length(find(spFish < 0))) / length(spFish);



fprintf('Active DSI EV signal: %1.4f \n', occupASev);
fprintf('Smooth DSI EV signal: %1.4f \n', occupSPev);

fprintf('Active DSI FA signal: %1.4f \n', occupASfa);
fprintf('Smooth DSI FA signal: %1.4f \n', occupSPfa);