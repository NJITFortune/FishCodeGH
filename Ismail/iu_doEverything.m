%% This is a script to process everything
load ~/Downloads/finalIsmaildata2024.mat


%% Plot everything for the fish as a start
fishno = 3;

out = iu_sta(curfish(fishno).spikes.times, [], curfish(fishno).error_vel, curfish(fishno).fs, 2);

%% Pick neuron

neuronNum = 2;

