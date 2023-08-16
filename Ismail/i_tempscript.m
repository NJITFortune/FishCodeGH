% load /Users/eric/Downloads/NeuroPhys2023/finaldata/Fin_2019_04_14_spikeID_34.mat

clf(28);
%%
neuron = 3;
delay = 0.09;
%trackType = "All";
%trackType = "Smooth";
trackType = "Active";
%trackType = "Others";

titletitle = strcat('Fin_', num2str(neuron), '_', trackType, '_', num2str(delay));


spiketimes = curfish.allspikes.times(curfish.allspikes.codes == neuron);

[evAmp, evCat] = i_tim2stim(spiketimes, curfish.error_vel, curfish.time, curfish.tracking, delay);
[eaAmp, eaCat] = i_tim2stim(spiketimes, curfish.error_acc, curfish.time, curfish.tracking, delay);

if trackType == "All"
    vsout = i_vs(evAmp, eaAmp, curfish.error_vel, curfish.error_acc);
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



