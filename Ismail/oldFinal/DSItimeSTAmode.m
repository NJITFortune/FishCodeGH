function out = DSItimeSTAmode(spiketimes, modes, sig, tim)
% Usage out = DSItimeSTA(spiketimes, sig, tim)
% Example: 
% out = DSItimeSTA(curfish(9).spikes.times(curfish(9).times.codes == 4), curfish(9).error_vel, curfish(9).time);
% This calculates "Selectivity index" for an array of delays relative to spike times. Sort of like an STA. 
% This script relies on scripts u_randspikegen and u_tim2stim.
% u_randspikegen generates shuffled spike trains.
% u_tim2stim interpolates to find signal values for each spike time.

% The delays in seconds. Make sure they are the same as within the parfor loop below.
% Default is -1.00:0.010:1.00. Up to (+/-)3 seconds. Less than 1 second isn't useful for this dataset.
out.dels = -1.00:0.010:1.00; 

% Calculate the DSI for each delay. 
parfor j=1:length(out.dels)
    dels = -1.00:0.010:1.00; % Make sure these are the same as out.dels above. (Double copy is for the parfor loop)
    dsi(j) = DSIcalculator(spiketimes, modes, sig, tim, dels(j)); 
end

% Put the data into our output structure
for j = length(dsi):-1:1
    out.smoothdsi(j) = dsi(j).smoothSpikes;
    out.rsmoothdsi(j) = dsi(j).rSmoothSpikes;
    out.activedsi(j) = dsi(j).activeSpikes;
    out.ractivedsi(j) = dsi(j).rActiveSpikes;
end

end

function dsi = DSIcalculator(spikes, modelist, signal, tim, delt)
% Usage: [dsi, cnts] = DSIcalculator(spikes, signal, tim, delt)
% This script returns DSI values for whatever signal that you send it 
% (typically Vel or Acc).
    % Smooth tracking == 3
    % Active tracking == 2);
    % Poor tracking == 1);
    % Non tracking == 0);

% Get adusted and random spikes

[newsig, newmodes] = u_tim2stimMode(spikes, modelist, signal, tim, delt);

randspikes = u_randspikegen(spikes);
[randsig, randmodes] = u_tim2stimMode(randspikes, modelist, signal, tim, 0);

smoothIDX = sort([find(newmodes == 3), find(newmodes == 1)]);
% activeIDX = sort([find(newmodes == 2), find(newmodes == 0)]);
% smoothIDX = find(newmodes == 3);
activeIDX = find(newmodes == 2);

% smoothRIDX = sort([find(randmodes == 3), find(randmodes == 1)]);
% activeRIDX = sort([find(randmodes == 2), find(randmodes == 0)]);
smoothRIDX = find(randmodes == 3);
activeRIDX = find(randmodes == 2);

% Calculate raw DSI values

dsi.smoothSpikes = (length(find(newsig(smoothIDX) > 0)) - length(find(newsig(smoothIDX) < 0))) / ...
    (length(find(newsig(smoothIDX) > 0)) + length(find(newsig(smoothIDX) < 0)));
dsi.activeSpikes = (length(find(newsig(activeIDX) > 0)) - length(find(newsig(activeIDX) < 0))) / ...
    (length(find(newsig(activeIDX) > 0)) + length(find(newsig(activeIDX) < 0)));

dsi.rSmoothSpikes = (length(find(randsig(smoothRIDX) > 0)) - length(find(randsig(smoothRIDX) < 0))) / ...
    (length(find(randsig(smoothRIDX) > 0)) + length(find(randsig(smoothRIDX) < 0)));
dsi.rActiveSpikes = (length(find(randsig(activeRIDX) > 0)) - length(find(randsig(activeRIDX) < 0))) / ...
    (length(find(randsig(activeRIDX) > 0)) + length(find(randsig(activeRIDX) < 0)));

% cnts.newsig = newsig;
% cnts.randsig = randsig;
% cnts.delt = delt;

end