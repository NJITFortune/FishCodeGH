function [dsiSP, dsiAS, cnts] = iu_trackingDSI(spikes, signal, tracking, tim, delt)
% Usage: [dsiSP, dsiAS, cnts] = iu_trackingDSI(spikes, signal, tracking, tim, delt)
% This script returns DSI values for SP and AS for whatever you send it (Vel or Acc)
% This also returns the time-adjusted spike times and adjusted stimulus
% values. Meant to be used with i_2DHist, iu_getAllstas.

AStrax = [];
SPtrax = [];
astims = [];
sptims = [];

% Sample rate (in seconds) of the stimulus (1/Fs) 
    Sf = tim(2) - tim(1); 

% Adjust the timing of the spiketimes relative to the time base and trim the ends
Dspiketimes = spikes + delt; % delt is our time shift
    Dspiketimes = Dspiketimes(Dspiketimes > 0);
    Dspiketimes = Dspiketimes(Dspiketimes < tim(end));

% For every spike    
for k=1:length(Dspiketimes)
    curidx = find(tim < Dspiketimes(k), 1, "last");
    % Active sensing
    if tracking(curidx) == 0 || tracking(curidx) == 2
        extratimpercent = (Dspiketimes(k) - tim(curidx)) / Sf;
        AStrax(end+1) = signal(curidx) + ((signal(curidx+1) - signal(curidx)) * extratimpercent);
        astims(end+1) = Dspiketimes(k);
    end
    % Smooth Pursuit
    if tracking(curidx) == 1 || tracking(curidx) == 3
        extratimpercent = (Dspiketimes(k) - tim(curidx)) / Sf;
        SPtrax(end+1) = signal(curidx) + ((signal(curidx+1) - signal(curidx)) * extratimpercent);
        sptims(end+1) = Dspiketimes(k);
    end

end

% Calculate raw DSI values

dsiAS = (length(find(AStrax > 0)) - length(find(AStrax < 0))) / ...
    (length(find(AStrax > 0)) + length(find(AStrax < 0)));

dsiSP = (length(find(SPtrax > 0)) - length(find(SPtrax < 0))) / ...
    (length(find(SPtrax > 0)) + length(find(SPtrax < 0)));

cnts.AStrax = AStrax;
cnts.SPtrax = SPtrax;
cnts.astims = astims - delt;
cnts.sptims = sptims - delt;
cnts.delt = delt;
