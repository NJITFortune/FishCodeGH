function [dsi, cnts] = trackDSI(spikes, signal, tim, delt)
% Usage: [dsi, cnts] = u_trackDSI(spikes, signal, tim, delt)
% This script returns DSI values for whatever you send it (Vel or Acc)
% This also returns the time-adjusted spike times and adjusted stimulus
% values. 

% Compute occupancy: number of signal samples above and below zero.
% This corrects for any bias in how much time the signal spends on each side.
occ_pos = sum(signal > 0);
occ_neg = sum(signal < 0);

% Get the kinematic data at the shifted spike times
newspikesData = interp1(tim, signal,  spikes + delt, 'linear', 'extrap');

randspikes = u_randspikegen(spikes);
randspikesData = interp1(tim, signal,  randspikes, 'linear', 'extrap');

% Calculate occupancy-corrected DSI values.
% Spike counts are divided by the time (in samples) the signal spent on each
% side of zero, yielding rates. DSI is then computed from those rates so that
% a neuron with no preference returns 0 regardless of signal asymmetry.

n_pos = sum(newspikesData > 0);
n_neg = sum(newspikesData < 0);

rate_pos = n_pos / occ_pos;
rate_neg = n_neg / occ_neg;

dsi.spikes = (rate_pos - rate_neg) / (rate_pos + rate_neg);

rn_pos = sum(randspikesData > 0);
rn_neg = sum(randspikesData < 0);

randrate_pos = rn_pos / occ_pos;
randrate_neg = rn_neg / occ_neg;
dsi.randspikes = (randrate_pos - randrate_neg) / (randrate_pos + randrate_neg);

cnts.newsig  = newspikesData;
cnts.randsig = randspikesData;
cnts.delt    = delt;
cnts.occ_pos = occ_pos;
cnts.occ_neg = occ_neg;
