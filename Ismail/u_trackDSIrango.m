function [dsi, cnts] = u_trackDSIrango(spikes, sig1, sig2, tim, delt, rango)
% Usage: [dsiSP, dsiAS, cnts] = u_trackDSI(spikes, signal, tim, delt)
% This script returns DSI values for whatever you send it (Vel or Acc)
% This also returns the time-adjusted spike times and adjusted stimulus
% values. 

% Get adusted and random spikes

newsig1 = u_tim2stim(spikes, sig1, tim, delt);
newsig2 = u_tim2stim(spikes, sig2, tim, delt);

newsig1only = newsig1(abs(newsig1) > rango(1) & abs(newsig1) < rango(2));
newsig2only = newsig2(abs(newsig2) > rango(3) & abs(newsig2) < rango(4));

newsig1comb = newsig1(abs(newsig1) > rango(1) & abs(newsig1) < rango(2) & ...
    abs(newsig2) > rango(3) & abs(newsig2) < rango(4));
newsig2comb = newsig2(abs(newsig1) > rango(1) & abs(newsig1) < rango(2) & ...
    abs(newsig2) > rango(3) & abs(newsig2) < rango(4));

% figure(101); clf; histogram(newsig);

randspikes = u_randspikegen(spikes);
randsig1 = u_tim2stim(randspikes, sig1, tim, 0);
    randsig1only = randsig1(abs(randsig1) > rango(1) & abs(randsig1) < rango(2));
randsig2 = u_tim2stim(randspikes, sig2, tim, 0);
    randsig2only = randsig2(abs(randsig2) > rango(3) & abs(randsig2) < rango(4));

newRsig1comb = randsig1(abs(randsig1) > rango(1) & abs(randsig1) < rango(2) & ...
    abs(randsig2) > rango(3) & abs(randsig2) < rango(4));
newRsig2comb = randsig2(abs(randsig1) > rango(1) & abs(randsig1) < rango(2) & ...
    abs(randsig2) > rango(3) & abs(randsig2) < rango(4));
    

% Calculate raw DSI values

dsi.sig1 = (length(find(newsig1only > 0)) - length(find(newsig1only < 0))) / ...
    (length(find(newsig1only > 0)) + length(find(newsig1only < 0)));
dsi.sig1combo = (length(find(newsig1comb > 0)) - length(find(newsig1comb < 0))) / ...
    (length(find(newsig1comb > 0)) + length(find(newsig1comb < 0)));
dsi.sig2 = (length(find(newsig2only > 0)) - length(find(newsig2only < 0))) / ...
    (length(find(newsig2only > 0)) + length(find(newsig2only < 0)));
dsi.sig2combo = (length(find(newsig2comb > 0)) - length(find(newsig2comb < 0))) / ...
    (length(find(newsig2comb > 0)) + length(find(newsig2comb < 0)));

dsi.randspikes1 = (length(find(randsig1only > 0)) - length(find(randsig1only < 0))) / ...
    (length(find(randsig1only > 0)) + length(find(randsig1only < 0)));
dsi.randspikes1combo = (length(find(newRsig1comb > 0)) - length(find(newRsig1comb < 0))) / ...
    (length(find(newRsig1comb > 0)) + length(find(newRsig1comb < 0)));
dsi.randspikes2 = (length(find(randsig2only > 0)) - length(find(randsig2only < 0))) / ...
    (length(find(randsig2only > 0)) + length(find(randsig2only < 0)));
dsi.randspikes2combo = (length(find(newRsig2comb > 0)) - length(find(newRsig2comb < 0))) / ...
    (length(find(newRsig2comb > 0)) + length(find(newRsig2comb < 0)));


cnts.sig1 = newsig1only;
cnts.sig1combo = newsig1comb;
cnts.randsig1 = newsig1comb;
cnts.randsig1combo = newRsig1comb;

cnts.sig2 = newsig2only;
cnts.sig2combo = newsig2comb;
cnts.randsig2 = randsig2only;
cnts.randsig2combo = newRsig2comb;
cnts.delt = delt;
