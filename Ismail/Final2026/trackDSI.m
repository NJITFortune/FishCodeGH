function [dsi, cnts] = u_trackDSI(spikes, signal, tim, delt)
% Usage: [dsi, cnts] = u_trackDSI(spikes, signal, tim, delt)
% This script returns DSI values for whatever you send it (Vel or Acc)
% This also returns the time-adjusted spike times and adjusted stimulus
% values. 

% Compute occupancy: number of signal samples above and below zero.
% This corrects for any bias in how much time the signal spends on each side.
occ_pos = sum(signal > 0);
occ_neg = sum(signal < 0);

% Get adjusted and random spikes
newsig = u_tim2stim(spikes, signal, tim, delt);

% figure(101); clf; histogram(newsig);

randspikes = u_randspikegen(spikes);
randsig = u_tim2stim(randspikes, signal, tim, 0);

% Calculate occupancy-corrected DSI values.
% Spike counts are divided by the time (in samples) the signal spent on each
% side of zero, yielding rates. DSI is then computed from those rates so that
% a neuron with no preference returns 0 regardless of signal asymmetry.
n_pos = sum(newsig > 0);
n_neg = sum(newsig < 0);
r_pos = n_pos / occ_pos;
r_neg = n_neg / occ_neg;
dsi.spikes = (r_pos - r_neg) / (r_pos + r_neg);

rn_pos = sum(randsig > 0);
rn_neg = sum(randsig < 0);
rr_pos = rn_pos / occ_pos;
rr_neg = rn_neg / occ_neg;
dsi.randspikes = (rr_pos - rr_neg) / (rr_pos + rr_neg);

cnts.newsig  = newsig;
cnts.randsig = randsig;
cnts.delt    = delt;
cnts.occ_pos = occ_pos;
cnts.occ_neg = occ_neg;
