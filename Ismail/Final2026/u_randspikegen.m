function shuffledspikes = u_randspikegen(spikes)
% Usage shuffledspikes = u_randspikegen(spikes)
% This shuffles the ISIs of a spike train. Same number of spikes, same
% duration, different sequence.

% The only spike that is assured to be the same between the input sequence
% and the output is the last spike. We simply copy the last spiketime as a
% starting point.
shuffledspikes(length(spikes)) = spikes(end); 

% Get the InterSpike Intervals using diff
    ISIs = diff(spikes);

% Shuffle them using randperm
    ISIs = ISIs(randperm(length(ISIs)));

% Build our new shuffled spiketrain from the end backwards in time.    
for k = length(ISIs):-1:1
    shuffledspikes(k) = shuffledspikes(k+1) - ISIs(k);
end
