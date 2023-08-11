function outdat = i_tim2stim(spiketimes, indat, intim, offset)
% outdat = i_tim2stim(curfish.spikes.times(curfish.spikes.codes == 3), curfish.error_vel, curfish.time, 0.1)

spiketimes = spiketimes + offset;
spiketimes = spiketimes(spiketimes > intim(1) & spiketimes < intim(end-1));
Sf = intim(2) - intim(1); 

for j = length(spiketimes):-1:1
 
    curidx = find(intim < spiketimes(j), 1, "last");
    extratimpercent = (spiketimes(j) - intim(curidx)) / Sf;

    outdat.ev(j) = indat(curidx) + ((indat(curidx+1) - indat(curidx)) * extratimpercent); 

end


