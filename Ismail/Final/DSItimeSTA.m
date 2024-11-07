function out = DSItimeSTA(spiketimes, sig, tim)
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
    [dsi(j), ~] = DSIcalculator(spiketimes, sig, tim, dels(j)); 
end

% Put the data into our output structure
for j = length(dsi):-1:1
    out.dsi(j) = dsi(j).spikes;
    out.rdsi(j) = dsi(j).randspikes;
end

end

function [dsi, cnts] = DSIcalculator(spikes, signal, tim, delt)
% Usage: [dsi, cnts] = DSIcalculator(spikes, signal, tim, delt)
% This script returns DSI values for whatever signal that you send it 
% (typically Vel or Acc).
% This also returns the time-adjusted spike times and adjusted stimulus
% values. 

% Get adusted and random spikes

newsig = u_tim2stim(spikes, signal, tim, delt);

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

end