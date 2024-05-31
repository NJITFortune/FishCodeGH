%% Do this

%velrange = -100:10:100; velbins = -95:10:95;
%accrange = -1000:100:1000; accbins = -950:100:950;
%velrange = -200:20:200; velbins = -190:20:190;
%accrange = -2000:200:2000; accbins = -1900:200:1900;
%velrange = -225:50:225; velbins = -200:50:200;
%accrange = -2250:500:2250; accbins = -2000:500:2000;
velrange = -250:100:250; velbins = -200:100:200;
accrange = -2500:1000:2500; accbins = -2000:1000:2000;

fishNum = 3;
spikeCode = 2;
delt = -0.200;

%% Generate shuffled spike trains for a baseline.

numrands = 20;

for j=numrands:-1:1
    randspikes = u_randspikegen(spiketimes);
    randEV{j} = u_tim2stim(randspikes, curfish(n).error_vel, curfish(n).time, 0);
    randEA{j} = u_tim2stim(randspikes, curfish(n).error_acc, curfish(n).time, 0);
end

%% Calcuate the baseline 2D histogram

respbinRAND = u_get2DHist(randEV{1}, randEA{1}, velrange, accrange);
    for j=2:numrands
        respbinRAND = respbinRAND + u_get2DHist(randEV{j}, randEA{j}, velrange, accrange);
    end
respbinRAND = respbinRAND / numrands;

%% Get the shifted values for the real data

    newEV = u_tim2stim(spiketimes, curfish(n).error_vel, curfish(n).time, delt);
    newEA = u_tim2stim(spiketimes, curfish(n).error_acc, curfish(n).time, delt);

% Calcuate the 2D histogram
    respbin = u_get2DHist(newEV, newEA, velrange, accrange);

mr = max(max(respbin));

figure(17); clf
subplot(131); surf(velbins, accbins, respbinRAND); colormap('HOT'); view([0, 90]); clim([3 mr]);
subplot(132); surf(velbins, accbins, respbin); colormap('HOT'); view([0, 90]); clim([3 mr]);
subplot(133); surf(velbins, accbins, respbin - respbinRAND); colormap('HOT'); view([0, 90]); clim([3 mr]);

%% Yee

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
