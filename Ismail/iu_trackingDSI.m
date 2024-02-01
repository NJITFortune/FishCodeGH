function [dsiSP, dsiAS] = iu_trackingDSI(spikes, signal, tracking, tim, delt)

AStrax = [];
SPtrax = [];

% Adjust the timing of the spiketimes relative to the time base and trim the ends
Dspiketimes = spikes + delt; % delt is our time shift
    Dspiketimes = Dspiketimes(Dspiketimes > 0);
    Dspiketimes = Dspiketimes(Dspiketimes < tim(end));

% For every spike    
for k=1:length(Dspiketimes)
    curidx = find(tim < Dspiketimes(k), 1, "last");
    % Active sensing
    if tracking(curidx) == 0 || tracking(curidx) == 2
        AStrax(end+1) = signal(curidx);
    end
    % Smooth Pursuit
    if tracking(curidx) == 1 || tracking(curidx) == 3
        SPtrax(end+1) = signal(curidx);
    end

end

% Calculate DSI values

dsiAS = (length(find(AStrax > 0)) - length(find(AStrax < 0))) / ...
    (length(find(AStrax > 0)) + length(find(AStrax < 0)));

dsiSP = (length(find(SPtrax > 0)) - length(find(SPtrax < 0))) / ...
    (length(find(SPtrax > 0)) + length(find(SPtrax < 0)));
