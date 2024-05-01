function out = iu_DSItims(curfish, unitNumber)

%% Get DSIs

spiketimes = curfish.spikes.times(curfish.spikes.codes == unitNumber);

delts = -0.50:0.05:0.50; 

parfor z = 1:length(delts)
    [EVSP(z), EVAS(z), ~] = iu_trackingDSI(spiketimes, curfish.error_vel, curfish.tracking, curfish.time, delts(z));
    [EASP(z), EAAS(z), ~] = iu_trackingDSI(spiketimes, curfish.error_acc, curfish.tracking, curfish.time, delts(z));
    [FASP(z), FAAS(z), ~] = iu_trackingDSI(spiketimes, curfish.fish_acc, curfish.tracking, curfish.time, delts(z));
end

figure(27); clf; 
    axx(1) = subplot(121); plot(delts, EVAS, '.-'); hold on; plot(delts, EAAS, '.-'); plot(delts, FAAS, '.-'); xline(0); yline(0);
        title('Active Sensing DSI')
    axx(2) = subplot(122); plot(delts, EVSP, '.-'); hold on; plot(delts, EASP, '.-'); plot(delts, FASP, '.-'); xline(0); yline(0);
        title('Smooth Pursuit DSI')

    linkaxes(axx, 'xy'); ylim([-0.5 0.5])
    
out = 1;

