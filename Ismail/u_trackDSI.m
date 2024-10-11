function [dsi, cnts] = u_trackDSI(spikes, signal, tim, delt)
% Usage: [dsiSP, dsiAS, cnts] = u_trackDSI(spikes, signal, tim, delt)
% This script returns DSI values for whatever you send it (Vel or Acc)
% This also returns the time-adjusted spike times and adjusted stimulus
% values. 

% Get adusted and random spikes

newsig = u_tim2stim(spikes, signal, tim, delt);

% figure(101); clf; histogram(newsig);

randspikes = u_randspikegen(spikes);
randsig = u_tim2stim(randspikes, signal, tim, 0);


% Calculate raw DSI values

dsi.spikes = (length(find(newsig > 0)) - length(find(newsig < 0))) / ...
    (length(find(newsig > 0)) + length(find(newsig < 0)));
dsi.randspikes = (length(find(randsig > 0)) - length(find(randsig < 0))) / ...
    (length(find(randsig > 0)) + length(find(randsig < 0)));

cnts.newsig = newsig;
cnts.randsig = randsig;
cnts.delt = delt;
