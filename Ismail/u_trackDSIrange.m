function [dsi, cnts] = u_trackDSIrange(spikes, signal, sig2, tim, delt, rango)
% Usage: [dsi, cnts] = u_trackDSIrange(spikes, signal, sig2, tim, delt, rango)
% This script returns DSI values for whatever you send it (Vel or Acc)
% and for a second 'slave' signal.  The difference between u_trackDSI and
% u_trackDSIrange is the signal range selection function - e.g. velocity
% range.
% This also returns the time-adjusted spike times and adjusted stimulus
% values. 

% Get adusted spikes

newsig = u_tim2stim(spikes, signal, tim, delt);

    shiftspikes = spikes + delt;
    shiftspikes = shiftspikes(shiftspikes > tim(1) & shiftspikes < tim(end-1));

    if length(newsig) ~= length(shiftspikes)
        fprintf('That did not work properly!\n')
    end

% Filter spikes for the range

idx = find(abs(newsig) > rango(1) & abs(newsig) < rango(2));
newsig = newsig(idx);

% fprintf('Filter Spikes count = %i \n', length(idx))

% Generate the random spikes

randspikes = u_randspikegen(shiftspikes(idx));
randsig = u_tim2stim(randspikes, signal, tim, 0);

% Generate second signal

newsig2 = u_tim2stim(shiftspikes(idx), sig2, tim, 0);

% Calculate raw DSI values

dsi.spikes = (length(find(newsig > 0)) - length(find(newsig < 0))) / ...
    (length(find(newsig > 0)) + length(find(newsig < 0)));
dsi.randspikes = (length(find(randsig > 0)) - length(find(randsig < 0))) / ...
    (length(find(randsig > 0)) + length(find(randsig < 0)));
dsi.spikes2 = (length(find(newsig2 > 0)) - length(find(newsig2 < 0))) / ...
    (length(find(newsig2 > 0)) + length(find(newsig2 < 0)));

cnts.newsig = newsig;
cnts.newsig2 = newsig2;
cnts.randsig = randsig;
cnts.delt = delt;
