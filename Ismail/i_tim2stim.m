function [outamplitude, outcategory] = i_tim2stim(spiketimes, indat, intim, intype, offset)
% This prepares the data for use with the suite of i_ analysis tools.  RUN THIS FIRST!
%
% Usage: [signalValue, trackingCategory] = i_tim2stim(spiketimes, signal, time, tracking type, time offset)
% [outdat outcat] = i_tim2stim(curfish.spikes.times(curfish.spikes.codes == 3), curfish.error_vel, curfish.time, currfish.tracking, -0.1)

% Sample rate (in seconds) of the stimulus (1/Fs) 
    Sf = intim(2) - intim(1); 

% Add the offset to the spikes
    spiketimes = spiketimes + offset;

% Because we are adding/subtracting time, we need to make sure that 
% the spiketimes are within the range of times of the stimulus. 
    spiketimes = spiketimes(spiketimes > intim(1) & spiketimes < intim(end-1));
    
% Loop through every spike to get the stimulus value at that time
for j = length(spiketimes):-1:1
 
    % Get the index of the time of the spike
    curidx = find(intim < spiketimes(j), 1, "last"); 

    % To improve accuracy, we interpolate the stimulus value between stimulus samples.
    extratimpercent = (spiketimes(j) - intim(curidx)) / Sf; % Get the remainder of time between stimulus samples
    outamplitude(j) = indat(curidx) + ((indat(curidx+1) - indat(curidx)) * extratimpercent); % Interpolate!

    % Get the category of the tracking (0-3, e.g. smooth or active)
    outcategory(j) = intype(curidx); 

end

% Report to the user how many spikes we have and the mean spike rate.
fprintf('Spike Count = %i, Duration = %i, Spike Rate = %2.2f \n', length(spiketimes), round(intim(end)), length(spiketimes) / intim(end));
