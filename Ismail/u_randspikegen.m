function randspikes = u_randspikegen(spikes)

randspikes(length(spikes)) = spikes(end); % Just a "random" first spike time to get things started.
    ISIs = diff(spikes);
    ISIs = ISIs(randperm(length(ISIs)));

for k = length(ISIs):-1:1
    randspikes(k) = randspikes(k+1) - ISIs(k);
end
