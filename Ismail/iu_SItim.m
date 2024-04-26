function out = iu_SItim(curfish, unitNumber)

%% Get DSIs

spiketimes = curfish.spikes.times(curfish.spikes.codes == unitNumber);

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
    
% Calculate occupancy-corrected DSI values

asError = curfish.error_vel(curfish.tracking == 1 | curfish.tracking == 3);
    occupASev = (length(find(asError > 0)) - length(find(asError < 0))) / length(asError);
spError = curfish.error_vel(curfish.tracking == 0 | curfish.tracking == 2);
    occupSPev = (length(find(spError > 0)) - length(find(spError < 0))) / length(spError);
asFish = curfish.fish_acc(curfish.tracking == 1 | curfish.tracking == 3);
    occupASfa = (length(find(asFish > 0)) - length(find(asFish < 0))) / length(asFish);
spFish = curfish.fish_acc(curfish.tracking == 0 | curfish.tracking == 2);
    occupSPfa = (length(find(spFish > 0)) - length(find(spFish < 0))) / length(spFish);



fprintf('Active DSI EV signal: %1.4f \n', occupASev);
fprintf('Smooth DSI EV signal: %1.4f \n', occupSPev);

fprintf('Active DSI FA signal: %1.4f \n', occupASfa);
fprintf('Smooth DSI FA signal: %1.4f \n', occupSPfa);

out = 1;

