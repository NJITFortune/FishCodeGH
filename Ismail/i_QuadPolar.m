% load /Users/eric/Downloads/NeuroPhys2023/finaldata/Fin_2019_04_14_spikeID_34.mat
figure; set(gcf, 'renderer', 'painters', 'Position', [100 480 1024 768]);

%% Pick your poison
neuron = 4;
delay = 0.1;

spiketimes = curfish.allspikes.times(curfish.allspikes.codes == neuron);


[evAmp, evCat] = i_tim2stim(spiketimes, curfish.fish_vel, curfish.time, curfish.tracking, delay);
[eaAmp, eaCat] = i_tim2stim(spiketimes, curfish.fish_acc, curfish.time, curfish.tracking, delay);


subplot(221); % SMOOTH
    vsout = i_vsOnly(evAmp(evCat == 3), eaAmp(eaCat == 3), curfish.fish_vel(curfish.tracking == 3), curfish.fish_acc(curfish.tracking == 3));
    title([num2str(neuron) ' Smooth Pursuit ' num2str(delay)])
    hold on; 
    text(0.2*pi, -0.7*pi, ['N=', num2str(vsout.numspikes), ' VSI=', num2str(round(100*vsout.normVSI)), ' ASI=', num2str(round(100*vsout.normASI))], 'FontSize', 10, 'Color', 'b');

subplot(222); % ACTIVE
    vsout = i_vsOnly(evAmp(evCat == 2), eaAmp(eaCat == 2), curfish.fish_vel(curfish.tracking == 2), curfish.fish_acc(curfish.tracking == 2));
    title('Active Sensing')
    hold on; 
    text(0.2*pi, -0.7*pi, ['N=', num2str(vsout.numspikes), ' VSI=', num2str(round(100*vsout.normVSI)), ' ASI=', num2str(round(100*vsout.normASI))], 'FontSize', 10, 'Color', 'b');
subplot(223); % Poor Tracking
    vsout = i_vsOnly(evAmp(evCat == 1), eaAmp(eaCat == 1), curfish.fish_vel(curfish.tracking == 1), curfish.fish_acc(curfish.tracking == 1));
    title('Poor Tracking')
    hold on; 
    text(0.2*pi, -0.7*pi, ['N=', num2str(vsout.numspikes), ' VSI=', num2str(round(100*vsout.normVSI)), ' ASI=', num2str(round(100*vsout.normASI))], 'FontSize', 10, 'Color', 'b');
subplot(224); % NON-Tracking
    vsout = i_vsOnly(evAmp(evCat == 0), eaAmp(eaCat == 0), curfish.fish_vel(curfish.tracking == 0), curfish.fish_acc(curfish.tracking == 0));
    title('Non-Tracking')
    hold on; 
    text(0.2*pi, -0.7*pi, ['N=', num2str(vsout.numspikes), ' VSI=', num2str(round(100*vsout.normVSI)), ' ASI=', num2str(round(100*vsout.normASI))], 'FontSize', 10, 'Color', 'b');


delay = -0.1;

[evAmp, evCat] = i_tim2stim(spiketimes, curfish.error_vel, curfish.time, curfish.tracking, delay);
[eaAmp, eaCat] = i_tim2stim(spiketimes, curfish.error_acc, curfish.time, curfish.tracking, delay);


subplot(221); % SMOOTH
    vsout = i_vsOnly(evAmp(evCat == 3), eaAmp(eaCat == 3), curfish.error_vel(curfish.tracking == 3), curfish.error_acc(curfish.tracking == 3));
    text(0.3*pi, -0.8*pi, ['N=', num2str(vsout.numspikes), ' VSI=', num2str(round(100*vsout.normVSI)), ' ASI=', num2str(round(100*vsout.normASI))], 'FontSize', 10, 'Color', 'r');

subplot(222); % ACTIVE
    vsout = i_vsOnly(evAmp(evCat == 2), eaAmp(eaCat == 2), curfish.error_vel(curfish.tracking == 2), curfish.error_acc(curfish.tracking == 2));
    text(0.3*pi, -0.8*pi, ['N=', num2str(vsout.numspikes), ' VSI=', num2str(round(100*vsout.normVSI)), ' ASI=', num2str(round(100*vsout.normASI))], 'FontSize', 10, 'Color', 'r');

subplot(223); % Poor Tracking
    vsout = i_vsOnly(evAmp(evCat == 1), eaAmp(eaCat == 1), curfish.error_vel(curfish.tracking == 1), curfish.error_acc(curfish.tracking == 1));
    text(0.3*pi, -0.8*pi, ['N=', num2str(vsout.numspikes), ' VSI=', num2str(round(100*vsout.normVSI)), ' ASI=', num2str(round(100*vsout.normASI))], 'FontSize', 10, 'Color', 'r');

subplot(224); % NON-Tracking
    vsout = i_vsOnly(evAmp(evCat == 0), eaAmp(eaCat == 0), curfish.error_vel(curfish.tracking == 0), curfish.error_acc(curfish.tracking == 0));
    text(0.3*pi, -0.8*pi, ['N=', num2str(vsout.numspikes), ' VSI=', num2str(round(100*vsout.normVSI)), ' ASI=', num2str(round(100*vsout.normASI))], 'FontSize', 10, 'Color', 'r');
