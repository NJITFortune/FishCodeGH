
velrange = -250:10:250; velbins = -245:10:245;
accrange = -2500:100:2500; accbins = -2450:100:2450;

fishNum = 9;
spikeCode = 4;

spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == spikeCode);
EVsignal = curfish(fishNum).error_vel;
FAsignal = curfish(fishNum).fish_acc;
tracking = curfish(fishNum).tracking;
tim = curfish(fishNum).time;

delt = -0.150;
[dsiSPev, dsiASev, EVcnts] = iu_trackingDSI(spikes, EVsignal, tracking, tim, delt);
delt = -0.150;
[dsiSPfa, dsiASfa, FAcnts] = iu_trackingDSI(spikes, FAsignal, tracking, tim, delt);

% spikeVdat = sort([EVcnts.AStrax EVcnts.SPtrax]);
% spikeAdat = sort([FAcnts.AStrax FAcnts.SPtrax]);
spVdat = [];
spAdat = [];
asVdat = [];
asAdat = [];

for j=1:length(spikes)
    if find(EVcnts.sptims == spikes(j)) 
        if find(FAcnts.sptims == spikes(j))
            spVdat(end+1) = EVcnts.SPtrax(EVcnts.sptims == spikes(j));
            spAdat(end+1) = FAcnts.SPtrax(FAcnts.sptims == spikes(j));
        end
    end

    if find(EVcnts.astims == spikes(j)) 
        if find(FAcnts.astims == spikes(j))
        asVdat(end+1) = EVcnts.AStrax(EVcnts.astims == spikes(j));
        asAdat(end+1) = FAcnts.AStrax(FAcnts.astims == spikes(j));
        end
    end
end

for j=length(velrange):-1:2
    for k=length(accrange):-1:2

    respbinSP(j-1, k-1) = length(find(spVdat > velrange(j-1) & spVdat < velrange(j) & ...
        spAdat > accrange(k-1) & spAdat < accrange(k)) );

    respbinAS(j-1, k-1) = length(find(asVdat > velrange(j-1) & asVdat < velrange(j) & ...
        asAdat > accrange(k-1) & asAdat < accrange(k)) );

    stimbin(j-1, k-1) = length(find(EVsignal > velrange(j-1) & EVsignal < velrange(j) & ...
        FAsignal > accrange(k-1) & FAsignal < accrange(k)) );

    end
end
figure(56); clf;
subplot(131); surf(velbins, accbins, respbinSP); view([0,90]);
subplot(132); surf(velbins, accbins, respbinAS); view([0,90]);
subplot(133); surf(velbins, accbins, stimbin); view([0,90]);
