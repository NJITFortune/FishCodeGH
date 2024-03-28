%% This is a script to process everything
%load('~/Downloads/finalIsmaildata2024.mat', 'curfish');
load('~/Documents/uyanik_neurophys/finalIsmaildata2024.mat', 'curfish');

%% Plot everything for the fish as a start
fishno = 1;

[evOUT, faOUT] = iu_getAllstas(curfish, fishno); 

%% Pick neuron

neuronNum = 1;
spiketimes = curfish(fishno).spikes.times(curfish(fishno).spikes.codes == neuronNum);
spikeCategory = [];
for j=length(spiketimes):-1:1
    curidx = find(curfish(fishno).time < spiketimes(j), 1, "last"); 
    spikeCategory(j) = curfish(fishno).tracking(curidx); 
end

asidx = find(spikeCategory == 0 | spikeCategory == 2);
spidx = find(spikeCategory == 1 | spikeCategory == 3);

evSP = iu_sta(spiketimes(spidx), [], curfish(fishno).error_acc, curfish(fishno).fs, 2);
faSP = iu_sta(spiketimes(spidx), [], curfish(fishno).fish_acc, curfish(fishno).fs, 2);
evAS = iu_sta(spiketimes(asidx), [], curfish(fishno).error_acc, curfish(fishno).fs, 2);
faAS = iu_sta(spiketimes(asidx), [], curfish(fishno).fish_acc, curfish(fishno).fs, 2);

figure(3); clf;
ax(1)=subplot(121); hold on;
    yyaxis left; plot(evSP.time, evSP.MEAN);
    yyaxis right; plot(faSP.time, faSP.MEAN);
    xline(0);
    title('Smooth Pursuit')
ax(2)=subplot(122); hold on;
    yyaxis left; plot(evAS.time, evAS.MEAN);
    yyaxis right; plot(faAS.time, faAS.MEAN);
    xline(0);
    title('Active Sensing')
linkaxes(ax,'x')

%% 
sensoryOffset = -0.200;
motorOffset = 0.200;

[evAmp, evCat] = i_tim2stim(spiketimes, curfish(fishno).error_vel, curfish(fishno).time, curfish(fishno).tracking, sensoryOffset);
[eaAmp, eaCat] = i_tim2stim(spiketimes, curfish(fishno).error_vel, curfish(fishno).time, curfish(fishno).tracking, sensoryOffset);


% STA

% Divide by type of tracking (2 categories)


% Divide by velocity (3 categories)







% [evAmp, evCat] = i_tim2stim(spiketimes, curfish.error_vel, curfish.time, curfish.tracking, -0.1);
% [eaAmp, eaCat] = i_tim2stim(spiketimes, curfish.error_acc, curfish.time, curfish.tracking, -0.1);

[evAmp, evCat] = i_tim2stim(spiketimes, curfish(fishno).error_vel, curfish(fishno).time, curfish(fishno).tracking, sensoryOffset);
[eaAmp, eaCat] = i_tim2stim(spiketimes, curfish(fishno).error_vel, curfish(fishno).time, curfish(fishno).tracking, sensoryOffset);

vsout = i_vsOnly(spikesig1, spikesig2, sig1, sig2);




