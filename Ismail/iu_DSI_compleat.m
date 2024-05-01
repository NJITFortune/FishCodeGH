% iu_DSIcompleat

%% Get fast and slow spike data
vthresh = 30; % 30 for vel 
athresh = 250; % 250 for acc

fishNum = 3;
spikeCode = 1;
delt = -0.00;

spikes = curfish(fishNum).spikes.times(curfish(3).spikes.codes == spikeCode);
vsignal = curfish(fishNum).error_vel;
asignal = curfish(fishNum).fish_acc;
tracking = curfish(fishNum).tracking;
tim = curfish(fishNum).time;

[~, ~, vcnts] = iu_trackingDSI(spikes, vsignal, tracking, tim, delt);
[~, ~, acnts] = iu_trackingDSI(spikes, asignal, tracking, tim, delt);

slowASspikesV = vcnts.AStrax(abs(vcnts.AStrax) < vthresh); 
fastASspikesV = vcnts.AStrax(abs(vcnts.AStrax) > vthresh); 
slowSPspikesV = vcnts.SPtrax(abs(vcnts.SPtrax) < vthresh); 
fastSPspikesV = vcnts.SPtrax(abs(vcnts.SPtrax) > vthresh); 

slowASspikesA = acnts.AStrax(abs(acnts.AStrax) < athresh); 
fastASspikesA = acnts.AStrax(abs(acnts.AStrax) > athresh); 
slowSPspikesA = acnts.SPtrax(abs(acnts.SPtrax) < athresh); 
fastSPspikesA = acnts.SPtrax(abs(acnts.SPtrax) > athresh); 


%% Distribution

fastbinedgesV = -300:10:300;
fastbincentersV = -295:10:295;
slowbinedgesV = -30:2:30;
slowbincentersV = -29:2:29;

normFastV = histcounts(vsignal, fastbinedgesV, 'Normalization', 'count');
normSlowV = histcounts(vsignal, slowbinedgesV, 'Normalization', 'count');

ASfastbinsV = histcounts(fastASspikesV, fastbinedgesV, 'Normalization', 'count');
ASslowbinsV = histcounts(slowASspikesV, slowbinedgesV, 'Normalization', 'count');
figure(49); clf; 
    subplot(121); plot(fastbincentersV, normFastV ./ sum(normFastV)); hold on; plot(fastbincentersV, ASfastbinsV ./ sum(ASfastbinsV));
    ylim([0 0.1]); title('AS V Fast');
    subplot(122); plot(slowbincentersV, normSlowV ./ sum(normSlowV)); hold on; plot(slowbincentersV, ASslowbinsV ./ sum(ASslowbinsV));
    ylim([0 0.1]); title('AS V Slow');

SPfastbinsV = histcounts(fastSPspikesV, fastbinedges, 'Normalization', 'count');
SPslowbinsV = histcounts(slowSPspikesV, slowbinedges, 'Normalization', 'count');
figure(48); clf; 
    subplot(121); plot(fastbincentersV, normFastV ./ sum(normFastV)); hold on; plot(fastbincentersV, SPfastbinsV ./ sum(SPfastbinsV));
    ylim([0 0.1]); title('SP V Fast');
    subplot(122); plot(slowbincentersV, normSlowV ./ sum(normSlowV)); hold on; plot(slowbincentersV, SPslowbinsV ./ sum(SPslowbinsV));
    ylim([0 0.1]); title('SP V Slow');

fastbinedgesA = -3000:100:3000;
fastbincentersA = -2950:100:2950;
slowbinedgesA = -300:20:300;
slowbincentersA = -290:20:290;

normFastA = histcounts(asignal, fastbinedgesA, 'Normalization', 'count');
normSlowA = histcounts(asignal, slowbinedgesA, 'Normalization', 'count');

ASfastbinsA = histcounts(fastASspikesA, fastbinedgesA, 'Normalization', 'count');
ASslowbinsA = histcounts(slowASspikesA, slowbinedgesA, 'Normalization', 'count');
figure(39); clf; 
    subplot(121); plot(fastbincentersA, normFastA ./ sum(normFastA)); hold on; plot(fastbincentersA, ASfastbinsA ./ sum(ASfastbinsA));
    ylim([0 0.1]); title('AS A Fast');
    subplot(122); plot(slowbincentersA, normSlowA ./ sum(normSlowA)); hold on; plot(slowbincentersA, ASslowbinsA ./ sum(ASslowbinsA));
    ylim([0 0.1]); title('AS A Slow');

SPfastbinsA = histcounts(fastSPspikesA, fastbinedgesA, 'Normalization', 'count');
SPslowbinsA = histcounts(slowSPspikesA, slowbinedgesA, 'Normalization', 'count');
figure(38); clf; 
    subplot(121); plot(fastbincentersA, normFastA ./ sum(normFastA)); hold on; plot(fastbincentersA, SPfastbinsA ./ sum(SPfastbinsA));
    ylim([0 0.1]); title('SP A Fast');
    subplot(122); plot(slowbincentersA, normSlowA ./ sum(normSlowA)); hold on; plot(slowbincentersA, SPslowbinsA ./ sum(SPslowbinsA));
    ylim([0 0.1]); title('SP A Slow');


%% Calculate occupancy-corrected DSI values
% 
% asError = curfish.error_vel(curfish.tracking == 1 | curfish.tracking == 3);
%     occupASev = (length(find(asError > 0)) - length(find(asError < 0))) / length(asError);
% spError = curfish.error_vel(curfish.tracking == 0 | curfish.tracking == 2);
%     occupSPev = (length(find(spError > 0)) - length(find(spError < 0))) / length(spError);
% asFish = curfish.fish_acc(curfish.tracking == 1 | curfish.tracking == 3);
%     occupASfa = (length(find(asFish > 0)) - length(find(asFish < 0))) / length(asFish);
% spFish = curfish.fish_acc(curfish.tracking == 0 | curfish.tracking == 2);
%     occupSPfa = (length(find(spFish > 0)) - length(find(spFish < 0))) / length(spFish);
% 
% 
% 
% fprintf('Active DSI EV signal: %1.4f \n', occupASev);
% fprintf('Smooth DSI EV signal: %1.4f \n', occupSPev);
% 
% fprintf('Active DSI FA signal: %1.4f \n', occupASfa);
% fprintf('Smooth DSI FA signal: %1.4f \n', occupSPfa);