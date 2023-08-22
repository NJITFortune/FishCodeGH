% load /Users/eric/Downloads/NeuroPhys2023/finaldata/Fin_2019_04_14_spikeID_34.mat

%% Pick your poison
neuron = 4;
delay = 0.1;

%%

spiketimes = curfish.allspikes.times(curfish.allspikes.codes == neuron);

[evAmp, evCat] = i_tim2stim(spiketimes, curfish.fish_vel, curfish.time, curfish.tracking, delay);
[eaAmp, eaCat] = i_tim2stim(spiketimes, curfish.fish_acc, curfish.time, curfish.tracking, delay);

figure; set(gcf, 'renderer', 'painters', 'Position', [100 480 1024 768]);

subplot(221); % SMOOTH
    vsout = i_vsOnly(evAmp(evCat == 3), eaAmp(eaCat == 3), curfish.fish_vel(curfish.tracking == 3), curfish.fish_acc(curfish.tracking == 3));
    title([num2str(neuron) ' Smooth Pursuit ' num2str(delay)])
    subplot(222); % ACTIVE
    vsout = i_vsOnly(evAmp(evCat == 2), eaAmp(eaCat == 2), curfish.fish_vel(curfish.tracking == 2), curfish.fish_acc(curfish.tracking == 2));
    title('Active Sensing')
subplot(223); % POOR? Tracking
    vsout = i_vsOnly(evAmp(evCat == 1), eaAmp(eaCat == 1), curfish.fish_vel(curfish.tracking == 1), curfish.fish_acc(curfish.tracking == 1));
    title('¿Poor Tracking?')
subplot(224); % NON? Tracking
    vsout = i_vsOnly(evAmp(evCat == 0), eaAmp(eaCat == 0), curfish.fish_vel(curfish.tracking == 0), curfish.fish_acc(curfish.tracking == 0));
    title('¿Non-Tracking?')

