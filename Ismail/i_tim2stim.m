function [outamplitude, outcategory] = i_tim2stim(spiketimes, indat, intim, intype, offset)
% outdat = i_tim2stim(curfish.spikes.times(curfish.spikes.codes == 3), curfish.error_vel, curfish.time, 0.1)

spiketimes = spiketimes + offset;
spiketimes = spiketimes(spiketimes > intim(1) & spiketimes < intim(end-1));
Sf = intim(2) - intim(1); 

for j = length(spiketimes):-1:1
 
    curidx = find(intim < spiketimes(j), 1, "last");
    extratimpercent = (spiketimes(j) - intim(curidx)) / Sf;

    outamplitude(j) = indat(curidx) + ((indat(curidx+1) - indat(curidx)) * extratimpercent); 
    outcategory(j) = intype(curidx);

end

fprintf('Spike Count = %i, Duration = %i, Spike Rate = %2.2f \n', length(spiketimes), round(intim(end)), length(spiketimes) / intim(end));
