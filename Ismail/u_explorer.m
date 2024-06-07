figure(28); clf; 

neuron = 1;
cellunit = 1;

sensorimotor = 's';
% sensorimotor = 'm';

%% 
if sensorimotor == 'm'
% Motor
vsout = u_PolarPlot(curfish(neuron).spikes.times(curfish(neuron).spikes.codes == cellunit), curfish(neuron).fish_vel, curfish(neuron).fish_acc, curfish(neuron).time, 0.1, [], 'Name');
end

if sensorimotor == 's'
% Sensory
vsout = u_PolarPlot(curfish(neuron).spikes.times(curfish(neuron).spikes.codes == cellunit), curfish(neuron).error_vel, curfish(neuron).error_acc, curfish(neuron).time, 0.1, [], 'Name');
end


%% 

vv = [];
% vv = [150 250 0 5000];

if sensorimotor == 'm'
[dsi, cnts] = u_trackDSIrango(curfish(neuron).spikes.times(curfish(neuron).spikes.codes == cellunit), curfish(neuron).fish_vel, curfish(neuron).fish_acc, curfish(neuron).time, -0.1, [])
end

if sensorimotor == 's'
[dsi, cnts] = u_trackDSIrango(curfish(neuron).spikes.times(curfish(neuron).spikes.codes == cellunit), curfish(neuron).error_vel, curfish(neuron).error_acc, curfish(neuron).time, -0.1, [])
end


