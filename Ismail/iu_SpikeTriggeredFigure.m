
% load /Users/eric/NotCloudy/UyanikFinalPutsch/uyanik_neurophys/finaldata/Fin_2019_04_14_spikeID_34.mat 
    % 4 EXCEL 3 OK EV/FA <<<<<<<<<<<<<<<<<<<<
% load /Users/eric/NotCloudy/UyanikFinalPutsch/uyanik_neurophys/finaldata/Andre_2019_04_10_spikeID_12356M.mat
    % 1,2,3,5,6 NR - Andre bad
% load /Users/eric/NotCloudy/UyanikFinalPutsch/uyanik_neurophys/finaldata/Ankara_2019_01_31_spikeID_35_p1.mat
    % 3,5, NR - Ankara p1 bad
load /Users/eric/NotCloudy/UyanikFinalPutsch/uyanik_neurophys/finaldata/BammBamm_2019_04_12_spikeID_123M.mat
    % 1,2,3 acc/motor lots of spikes   <<<<<<<<<<<<
% load /Users/eric/NotCloudy/UyanikFinalPutsch/uyanik_neurophys/finaldata/Bent_2019_02_26_spikeID_2346.mat
    % 2 EV/FA messy good?, 3 active not smooth, 4 responsive, EV/FA medium number  
% load /Users/eric/NotCloudy/UyanikFinalPutsch/uyanik_neurophys/finaldata/Brown_2018_09_25_spikeID_235.mat
    % 2 messy, 3 NR, 5 NR  <<<<<
% load /Users/eric/NotCloudy/UyanikFinalPutsch/uyanik_neurophys/finaldata/Brownie_2019_01_26_spikeID_13_p2.mat
    % 1 and 3 NR, 3 is specially bad
% load /Users/eric/NotCloudy/UyanikFinalPutsch/uyanik_neurophys/finaldata/Brownie_2019_01_26_spikeID_13_p2_OLD.mat
    % 1 and 3 NR, 3 is specially bad
% load /Users/eric/NotCloudy/UyanikFinalPutsch/uyanik_neurophys/finaldata/Brownie_2019_01_26_spikeID_348_p1.mat
    % All 3,4,8 NR
% load /Users/eric/NotCloudy/UyanikFinalPutsch/uyanik_neurophys/finaldata/Bumpy_2019_04_03_spikeID_17.mat
    % 1 and 7 weak something sensory <<
% load /Users/eric/NotCloudy/UyanikFinalPutsch/uyanik_neurophys/finaldata/Copy_of_Andre_2019_04_10_spikeID_12356M.mat
    % 1,2,3,5,6 NR - Andre bad
% load /Users/eric/NotCloudy/UyanikFinalPutsch/uyanik_neurophys/finaldata/Goldy_2019_03_28_spikeID_1689.mat
    % 1 6 8 9 weak not enough spikes
% load /Users/eric/NotCloudy/UyanikFinalPutsch/uyanik_neurophys/finaldata/Hobo_2019_04_01_spikeID_123.mat
    % 1 sensory not enough spikes, 2 intermediate, 3 NR
% load /Users/eric/NotCloudy/UyanikFinalPutsch/uyanik_neurophys/finaldata/Penn_2019_04_13_spikeID_123.mat
    % 1 weak sensory, 2 and 3 not sufficient spikes
% load /Users/eric/NotCloudy/UyanikFinalPutsch/uyanik_neurophys/finaldata/Tolstoy_2019_01_29_spikeID_134.mat
    % 1 too few spikes NR, 3 OK EV/FA, 4 OK EV/FA <<<<<<<<<<<<
% load /Users/eric/NotCloudy/UyanikFinalPutsch/uyanik_neurophys/finaldata/virtual_fish.mat
% 

%%
clear spiketimes spikeTracking staEV staFA ax

unitNumber = 3;
winDur = 1.5;

figNum = [1, 2];
trackType{1} = [0, 2]; % active sensing and non-tracking
trackType{2} = [1, 3]; % smooth and poor tracking


spiketimes = curfish.spikes.times(curfish.spikes.codes == unitNumber);

for k=length(spiketimes):-1:1
    % The direction *COULD* have a profound effect - need to test this
    spikeTracking(k) = curfish.tracking(find(curfish.time < spiketimes(k), 1,"last"));
    % spikeTracking(k) = curfish.tracking(find(curfish.time > spiketimes(k), 1,"first"));
end

for j = 1:2

    % Smooth tracking == 3
    % Active tracking == 2);
    % Poor tracking == 1);
    % Non tracking == 0);

if length(trackType{j}) == 2
        evSpikes = sort([spiketimes(spikeTracking == trackType{j}(1))', spiketimes(spikeTracking == trackType{j}(2))']);
    staEV = iu_sta(evSpikes, [], curfish.error_vel, 25, winDur);
        faSpikes = sort([spiketimes(spikeTracking == trackType{j}(1))', spiketimes(spikeTracking == trackType{j}(2))']);
    staFA = iu_sta(faSpikes, [], curfish.fish_acc, 25, winDur);
elseif length(trackType{j}) == 1
        evSpikes = spiketimes(spikeTracking == trackType{j});
    staEV = iu_sta(evSpikes, [], curfish.error_vel, 25, winDur);
        faSpikes = spiketimes(spikeTracking == trackType{j});
    staFA = iu_sta(faSpikes, [], curfish.fish_acc, 25, winDur);
else
    fprintf('Something went wrong with trackType.\n');
end

%% Plot STAs

figure(figNum(j)); clf;
    ax(1) = subplot(121); plot(staEV.time, staEV.MEAN, staEV.time, staEV.randMEAN); 
        hold on; xline(0); xlim([-winDur, winDur])
        [evMax, evIdx] = max(staEV.MEAN); plot(staEV.time(evIdx), evMax, 'mo', "MarkerSize", 6)
    ax(2) = subplot(122); plot(staFA.time, staFA.MEAN, staFA.time, staFA.randMEAN)
        hold on; xline(0); xlim([-winDur, winDur])
        [faMax, faIdx] = max(staFA.MEAN); plot(staFA.time(faIdx), faMax, 'mo', "MarkerSize", 6)
    linkaxes(ax,'x');

if trackType{j}(1) == 0
    fprintf('Active sensing total spikes: %i \n', length(evSpikes) + length(faSpikes))
    fprintf('Active sensing EV peak STA: %1.4f \n', staEV.time(evIdx));
    fprintf('Active sensing FA peak STA: %1.4f \n', staFA.time(faIdx));
    AS_EV_staTime = staEV.time(evIdx);
    AS_FA_staTime = staFA.time(faIdx);
    figure(figNum(j)); subplot(122); title('Active Sensing - Fish Acc'); subplot(121); title('Active Sensing - Error Vel'); 
        hold on; xline(0); xlim([-winDur, winDur])
end
if trackType{j}(1) == 1
    fprintf('Smooth pursuit total spikes: %i \n', length(evSpikes) + length(faSpikes))
    fprintf('Smooth pursuit EV peak STA: %1.4f \n', staEV.time(evIdx));
    fprintf('Smooth pursuit FA peak STA: %1.4f \n', staFA.time(faIdx));
    SP_EV_staTime = staEV.time(evIdx);
    SP_FA_staTime = staFA.time(faIdx);
    figure(figNum(j)); subplot(122); title('Smooth Pursuit - Fish Acc'); subplot(121); title('Smooth Pursuit - Error Vel');
        hold on; xline(0); xlim([-winDur, winDur])
end


end

%% Get DSIs

delts = -0.50:0.05:0.50; 

parfor z = 1:length(delts)
    [EVSP(z), EVAS(z)] = iu_trackingDSI(spiketimes, curfish.error_vel, curfish.tracking, curfish.time, delts(z));
    [FASP(z), FAAS(z)] = iu_trackingDSI(spiketimes, curfish.fish_acc, curfish.tracking, curfish.time, delts(z));
end

figure(27); clf; 
    axx(1) = subplot(211); plot(delts, EVAS, '.-'); hold on; plot(delts, FAAS, '.-'); xline(0); yline(0);
        title('Active Sensing DSI')
    axx(2) = subplot(212); plot(delts, EVSP, '.-'); hold on; plot(delts, FASP, '.-'); xline(0); yline(0);
        title('Smooth Pursuit')

    linkaxes(axx, 'xy'); ylim([-0.5 0.5])
    
