function [dsi, cnts] = trackSpeedDSI(spikes, signal, tim, delt, speedRange)
% Usage: [dsi, cnts] = trackSpeedDSI(spikes, signal, tim, delt, speedRange)
% This script returns DSI values for whatever you send it (Vel or Acc)
% speedRange: two positive numbers [minSpeed maxSpeed] — only signal samples
%   whose absolute value falls within this range are used in the analysis.

% Build a logical mask for samples within the speed range
speedMask = abs(signal) >= speedRange(1) & abs(signal) <= speedRange(2);

% Compute occupancy restricted to the speed range: number of signal samples
% above and below zero within the speed range.
occ_pos = sum(signal(speedMask) > 0);
occ_neg = sum(signal(speedMask) < 0);

% Get the kinematic data at the shifted spike times
newspikesData = interp1(tim, signal, spikes + delt, 'linear', 'extrap');

randspikes = u_randspikegen(spikes);
randspikesData = interp1(tim, signal, randspikes, 'linear', 'extrap');

% Restrict spikes to those occurring within the speed range
spikeSpeedMask     = abs(newspikesData)  >= speedRange(1) & abs(newspikesData)  <= speedRange(2);
randSpikeSpeedMask = abs(randspikesData) >= speedRange(1) & abs(randspikesData) <= speedRange(2);

% Calculate occupancy-corrected DSI values.
n_pos = sum(newspikesData(spikeSpeedMask) > 0);
n_neg = sum(newspikesData(spikeSpeedMask) < 0);

rate_pos = n_pos / occ_pos;
rate_neg = n_neg / occ_neg;

dsi.spikes = (rate_pos - rate_neg) / (rate_pos + rate_neg);

rn_pos = sum(randspikesData(randSpikeSpeedMask) > 0);
rn_neg = sum(randspikesData(randSpikeSpeedMask) < 0);

randrate_pos = rn_pos / occ_pos;
randrate_neg = rn_neg / occ_neg;
dsi.randspikes = (randrate_pos - randrate_neg) / (randrate_pos + randrate_neg);

cnts.newsig       = newspikesData;
cnts.randsig      = randspikesData;
cnts.delt         = delt;
cnts.occ_pos      = occ_pos;
cnts.occ_neg      = occ_neg;
cnts.speedRange   = speedRange;
