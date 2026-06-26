function [mi, cnts] = trackMI(spikes, signal, tim, delt, nbins)
% [mi, cnts] = trackMI(spikes, signal, tim, delt, nbins)
% Mutual information between spike train and a continuous signal,
% using the Skaggs et al. (1993) rate-map information formula.
%
% Inputs:
%   spikes  - spike times (seconds)
%   signal  - continuous kinematic signal sampled at tim
%   tim     - time vector (seconds)
%   delt    - spike time shift (seconds); same convention as trackDSI
%   nbins   - number of bins for signal (default 20)
%
% Outputs:
%   mi.bps        - information rate (bits / second)
%   mi.bpspk      - information per spike (bits / spike)
%   mi.rand_bps   - bits/s for randomized spikes (bias baseline)
%   mi.rand_bpspk - bits/spike for randomized spikes
%   cnts          - diagnostic struct (occupancy, rate map, bin edges)
%
% Formula (Skaggs et al. 1993):
%   I (bits/s)    = sum_i  p_i * lambda_i * log2(lambda_i / lambda_bar)
%   I (bits/spk)  = I_bps / lambda_bar
% where p_i is the occupancy probability of bin i, lambda_i is the
% firing rate in bin i, and lambda_bar is the overall mean firing rate.

if nargin < 5 || isempty(nbins)
    nbins = 20;
end

dT = median(diff(tim));

% Restrict to 1-99th percentile (matches heatmap analysis range)
sigRange = prctile(signal, [1 99]);
edges    = linspace(sigRange(1), sigRange(2), nbins + 1);

% Occupancy: time the signal spends in each bin (seconds)
occ = histcounts(signal, edges) * dT;

% Signal values at (temporally shifted) spike times
spkSig = interp1(tim, signal, spikes + delt, 'linear', 'extrap');
spkCnt = histcounts(spkSig, edges);

[mi.bps, mi.bpspk] = skaggsInfo(spkCnt, occ);

% Random-spike baseline (same function as trackDSI uses)
randspikes = u_randspikegen(spikes);
randSig    = interp1(tim, signal, randspikes, 'linear', 'extrap');
randCnt    = histcounts(randSig, edges);

[mi.rand_bps, mi.rand_bpspk] = skaggsInfo(randCnt, occ);

% Diagnostics
cnts.occ      = occ;
cnts.edges    = edges;
cnts.spkCnt   = spkCnt;
cnts.lambda   = spkCnt ./ max(occ, eps);   % rate map (spikes/s per bin)
cnts.sigRange = sigRange;
cnts.delt     = delt;
end


%% -----------------------------------------------------------------------
function [bps, bpspk] = skaggsInfo(spkCnt, occ)
% Skaggs et al. (1993) formula.

validBins = occ > 0;

lambda = zeros(size(occ));
lambda(validBins) = spkCnt(validBins) ./ occ(validBins);

totalTime   = sum(occ(validBins));
totalSpikes = sum(spkCnt(validBins));

if totalTime == 0 || totalSpikes == 0
    bps = 0;  bpspk = 0;  return;
end

lambda_bar = totalSpikes / totalTime;
p          = occ / totalTime;

active = validBins & lambda > 0;
bps   = sum(p(active) .* lambda(active) .* log2(lambda(active) / lambda_bar));
bpspk = bps / lambda_bar;
end
