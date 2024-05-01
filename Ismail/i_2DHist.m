
velrange = -250:10:250; velbins = -245:10:245;
accrange = -2500:100:2500; accbins = -2450:100:2450;

fishNum = 3;
spikeCode = 1;

spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == spikeCode);
EVsignal = curfish(fishNum).error_vel;
FAsignal = curfish(fishNum).error_acc;
tracking = curfish(fishNum).tracking;
tim = curfish(fishNum).time;

delt = -0.150;
[dsiSPev, dsiASev, EVcnts] = iu_trackingDSI(spikes, EVsignal, tracking, tim, delt);
[dsiSPfa, dsiASfa, FAcnts] = iu_trackingDSI(spikes, FAsignal, tracking, tim, delt);

% spikeVdat = sort([EVcnts.AStrax EVcnts.SPtrax]);
% spikeAdat = sort([FAcnts.AStrax FAcnts.SPtrax]);
spikeVdat = [];
spikeAdat = [];
for j=1:length(spikes)
    if find(EVcnts.sptimes == spikes(j)) 
        if find(FAcnts.sptimes == spikes(j))
        spikeVdat(end+1) = EVcnts.AStrax(EVcnts.sptimes == spikes(j));
        spikeAdat(end+1) = FAcnts.AStrax(FAcnts.sptimes == spikes(j));
        end
    end
end

for j=length(velrange):-1:2
    for k=length(accrange):-1:2

    respbin(j-1, k-1) = length(find(spikeVdat > velrange(j-1) & spikeVdat < velrange(j) & ...
        spikeAdat > accrange(k-1) & spikeAdat < accrange(k)) );

    stimbin(j-1, k-1) = length(find(EVsignal > velrange(j-1) & EVsignal < velrange(j) & ...
        FAsignal > accrange(k-1) & FAsignal < accrange(k)) );

    end
end

subplot(121); surf(velbins, accbins, respbin); view([0,90]);subplot(122); surf(velbins, accbins, stimbin); view([0,90]);
