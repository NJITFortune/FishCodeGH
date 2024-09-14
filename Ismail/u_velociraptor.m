function out = u_velociraptor(spiketimes, signal, tim, delays, threshs)
% Usage: out = u_velociraptor(spiketimes, signal, tim, delays, threshs)
% Error Velocity threshs slow 50 and fast 200
% Fish Acceleration threshs slow 250 and fast 500
% 
% Internal DSI calculation

intvl = mean(diff(tim)); % This is 1/Fs

for k = 1:length(delays)

% Adjust the spiketimes relative to the delay
newspiketimes = spiketimes + delays(k);
    newspiketimes = newspiketimes(newspiketimes > tim(1));
    newspiketimes = newspiketimes(newspiketimes < max(tim));

% Get the value for each spike

for j = length(newspiketimes):-1:1
    idx = find(tim < newspiketimes(j), 1, "last");
    spikeval(j) = signal(idx) + ((signal(idx+1) - signal(idx)) * ((newspiketimes(j)-tim(idx)) / intvl));
end

out(k).delay = delays(k);

% Calculate Selectivity Indices

slowspikesIDX = find(abs(spikeval) < threshs(1));
medspikesIDX = find(abs(spikeval) > threshs(1) & abs(spikeval) < threshs(2));
fastspikesIDX = find(abs(spikeval) > threshs(2));


out(k).alldsi = dsiCalc(spikeval);
out(k).allspikes = spikeval;

out(k).fastdsi = dsiCalc(spikeval(fastspikesIDX));
out(k).fastspikes = spikeval(fastspikesIDX);
out(k).fastIDX = fastspikesIDX;

out(k).slowdsi = dsiCalc(spikeval(slowspikesIDX));
out(k).slowspikes = spikeval(slowspikesIDX);
out(k).slowIDX = slowspikesIDX;

out(k).meddsi = dsiCalc(spikeval(medspikesIDX));
out(k).medspikes = spikeval(medspikesIDX);
out(k).medIDX = medspikesIDX;

end

end % End of main function

function foo = dsiCalc(spikevalues)

foo = (length(find(spikevalues > 0)) - length(find(spikevalues < 0))) / (length(find(spikevalues > 0)) + length(find(spikevalues < 0)));

end
