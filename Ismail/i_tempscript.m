%% SuperScript to run 'vector strength' code with more ease...

% If you haven't already loaded data (curfish), do so!
% load /Users/eric/Downloads/NeuroPhys2023/finaldata/Fin_2019_04_14_spikeID_34.mat

% Prepare figure
figure(28); clf(28);

%%
% Which of the neurons do you want to run?
neuron = 3;

% Pick your delay.  This is added to the spike times directly - so negative
% is spiking phase advance (motor-ish) whereas positive is phase delay (sensory-ish).
delay = -0.1;

% Pick one of these:
%trackType = "All";
%trackType = "Smooth";
trackType = "Active";
%trackType = "Others";

% Make a title for the figure
titletitle = strcat('Fin_', num2str(neuron), '_', trackType, '_', num2str(delay));

% Copy the data from the structure into our variable spiketimes
spiketimes = curfish.allspikes.times(curfish.allspikes.codes == neuron);

% Convert the data into the format we are using for analysis
[evAmp, evCat] = i_tim2stim(spiketimes, curfish.error_vel, curfish.time, curfish.tracking, delay);
[eaAmp, eaCat] = i_tim2stim(spiketimes, curfish.error_acc, curfish.time, curfish.tracking, delay);

% Run the VS code
if trackType == "All"
    vsout = i_vs(evAmp, eaAmp, curfish.error_vel, curfish.error_acc, titletitle);
end
if trackType == "Smooth"
    vsout = i_vs(evAmp(evCat == 3), eaAmp(eaCat == 3), curfish.error_vel(curfish.tracking == 3), curfish.error_acc(curfish.tracking == 3), titletitle);
end
if trackType == "Active"
    vsout = i_vs(evAmp(evCat == 2), eaAmp(eaCat == 2), curfish.error_vel(curfish.tracking == 2), curfish.error_acc(curfish.tracking == 2), titletitle);
end
if trackType == "Others"
    vsout = i_vs(evAmp(evCat < 2), eaAmp(eaCat < 2), curfish.error_vel(curfish.tracking < 2), curfish.error_acc(curfish.tracking < 2), titletitle);
end



