function out = iu_3DhistA(in, ent, sz)
% Function out = iu_hist(spikes, randspikes, sig, Fs, wid)
% spikes are the spike times
% randspikes are shuffled spike times
% sig is the signal (e.g. error_vel) of interest. Behavior...
% Fs is the sample rate (usually 25 for these data, fs = 25
% wid is the width of the spike triggered average in seconds (1 or 2 seconds is good)%% Histogram of All Spikes as Isolated Spikes

        numOfBins = 16;
        std_coeff   = 3;

% Get the sample rate for position
Fs = in(ent).s(1).pFs;

% Get the entries for the size selected by the user
    idx = [];
    for omg = 1:length(dat(neuronidx).s)
        if dat(neuronidx).s(omg).sizeDX == sz 
            idx(end+1) = omg;
        end
    end

% Preparations
tim = 0; % Starting time for the next sample as we concatonate
spikes = []; % List of spike times
pos = []; % Position over time

%% Concatonate data
if ~isempty(idx) % just make sure that the user isn't an idiot 

    for j = 1:length(idx) % cycle to concatonate all of the correct entries

        sizetmp = size(in(ent).s(idx(j)).pos);
            if sizetmp(1)/sizetmp(2) < 1; pos = [pos in(ent).s(idx(j)).pos]; end % Concatonate position
            if sizetmp(1)/sizetmp(2) > 1; pos = [pos in(ent).s(idx(j)).pos']; end % Concatonate position
            
        currtim = 1/Fs:1/Fs:length(in(ent).s(idx(j)).pos)/Fs; % A time base for the currently added position

        sizetmp = size(in(ent).s(idx(j)).st);
            if sizetmp(1)/sizetmp(2) < 1; spikes = [spikes (in(ent).s(idx(j)).st + tim(end))]; end % Concatonate position
            if sizetmp(1)/sizetmp(2) > 1; spikes = [spikes (in(ent).s(idx(j)).st + tim(end))']; end % Concatonate position
         % Concatonate spike times, adding the time from the end of previous
        
        tim = [tim (currtim + tim(end))]; % Update the time base 
        
    end
        
    tim = tim(2:end); % When we are all done, we remove the initial zero
    
end

% Derive the velocity and acceleration from position
% 
    [b,a] = butter(3, 2/(Fs/2), 'low'); % Filter for velocity
    [d,c] = butter(3, 2/(Fs/2), 'low'); % Filter for acceleration

    vel = filtfilt(b,a,diff(pos)); % VELOCITY
        vel(end+1) = vel(end);
    acc = filtfilt(d,c,diff(vel)); % ACCELERATION
        acc(end+1) = acc(end);
%     vel = smooth(diff(pos)); vel(end+1) = vel(end);
%     acc = smooth(diff(vel)); acc(end+1) = acc(end);
    vel = vel'; acc = acc';
        
% Make random spike train    
    ISIs = diff(spikes);
    randspikes(1) = spikes(1);
    for k = randperm(length(ISIs))
        randspikes(end+1) = randspikes(end) + ISIs(k);
    end

%% Get the STAs

%     pSTA = iu_sta(spikes, randspikes, pos, Fs, 2);
%     vSTA = iu_sta(spikes, randspikes, vel, Fs, 2);
%     aSTA = iu_sta(spikes, randspikes, acc, Fs, 2);
%     
%     figure(1); clf; 
%         subplot(311); hold on; plot(pSTA.time, pSTA.MEAN, 'b-'); 
%             plot(pSTA.time, pSTA.randMEAN, 'r-');
%         subplot(312); hold on; plot(vSTA.time, vSTA.MEAN, 'b-'); 
%             plot(vSTA.time, vSTA.randMEAN, 'r-');
%         subplot(313); hold on; plot(aSTA.time, aSTA.MEAN, 'b-'); 
%             plot(aSTA.time, aSTA.randMEAN, 'r-');    
        
       
%% Get the signal values at spike times

    spikePOS = interp1(tim, pos, spikes);
    spikeVEL = interp1(tim, vel, spikes);
    spikeACC = interp1(tim, acc, spikes);

    RspikePOS = interp1(tim, pos, randspikes);
    RspikeVEL = interp1(tim, vel, randspikes);
    RspikeACC = interp1(tim, acc, randspikes);
        
    % Position-only histogram
    histBound = std_coeff * std(pos);    
    POSedgs = linspace(mean(pos)-histBound, mean(pos)+histBound, numOfBins+1);
    out.PstimulusHist = histcounts(pos, POSedgs);
        out.PstimulusHist(~isfinite(out.PstimulusHist)) = 0;    
    out.PresponseHist = histcounts(spikePOS, POSedgs);
        out.PresponseHist(~isfinite(out.PresponseHist)) = 0;
    out.POccHist = (out.PresponseHist / max(out.PresponseHist)) ./ (out.PstimulusHist / max(out.PstimulusHist)); 
        out.POccHist(~isfinite(out.POccHist)) = 0;    
        out.Pedges = POSedgs;
        
    % Velocity-only histogram
    histBound = std_coeff * std(vel);    
    VELedgs = linspace(mean(vel)-histBound, mean(vel)+histBound, numOfBins+1);
    out.VstimulusHist = histcounts(vel, VELedgs);
        out.VstimulusHist(~isfinite(out.VstimulusHist)) = 0;    
    out.VresponseHist = histcounts(spikeVEL, VELedgs);
        out.VresponseHist(~isfinite(out.VresponseHist)) = 0;
    out.VOccHist = (out.VresponseHist / max(out.VresponseHist)) ./ (out.VstimulusHist / max(out.VstimulusHist)); 
        out.VOccHist(~isfinite(out.VOccHist)) = 0;    
        out.Vedges = VELedgs;

    % Acceleration-only histogram
    histBound = std_coeff * std(acc) / 20;    
    ACCedgs = linspace(mean(acc)-histBound, mean(acc)+histBound, numOfBins+1);
    out.AstimulusHist = histcounts(acc, ACCedgs);
        out.AstimulusHist(~isfinite(out.AstimulusHist)) = 0;    
    out.AresponseHist = histcounts(spikeACC, ACCedgs);
        out.AresponseHist(~isfinite(out.AresponseHist)) = 0;
    out.AOccHist = (out.AresponseHist / max(out.AresponseHist)) ./ (out.AstimulusHist / max(out.AstimulusHist)); 
        out.AOccHist(~isfinite(out.AOccHist)) = 0;    
        out.Aedges = ACCedgs;

% 3D histograms

% Raw spikes
for ss = length(spikePOS):-1:1
    
    posVvel(ss,:) = [spikePOS(ss) spikeVEL(ss)];
    accVvel(ss,:) = [spikeACC(ss) spikeVEL(ss)];
    RposVvel(ss,:) = [RspikePOS(ss) RspikeVEL(ss)];
    RaccVvel(ss,:) = [RspikeACC(ss) RspikeVEL(ss)];    
    
end
    out.posvel = hist3(posVvel, 'Edges', {out.Pedges, out.Vedges});
    out.accvel = hist3(accVvel, 'Edges', {out.Aedges, out.Vedges});
    
    out.Rposvel = hist3(RposVvel, 'Edges', {out.Pedges, out.Vedges});
    out.Raccvel = hist3(RaccVvel, 'Edges', {out.Aedges, out.Vedges});

% Histogram for stimulus
for ss = length(pos):-1:1
    STIMposVvel(ss,:) = [pos(ss) vel(ss)];
    STIMaccVvel(ss,:) = [acc(ss) vel(ss)];
end
 
    out.STIMposvel = hist3(STIMposVvel, 'Edges', {out.Pedges, out.Vedges});
    out.STIMaccvel = hist3(STIMaccVvel, 'Edges', {out.Aedges, out.Vedges});


figure(2); clf; title('Position and Velocity');

    h(1) = subplot(2,2,1);
        h(1).Position = [0.1 0.35 0.2 0.6];
        barh(out.VOccHist); ylim([0.5 numOfBins+0.5]);
        ylabel('Velocity');
    h(2) = subplot(2,2,4);
        h(2).Position = [0.35 0.1 0.6 0.2];
        bar(out.POccHist); xlim([0.5 numOfBins+0.5]);
        xlabel('Position');
    h(3) = subplot(2,2,2);
        h(3).Position = [0.35 0.35 0.6 0.6];
        surf(out.posvel'); view(0,90); xlim([1 numOfBins+1]); ylim([1 numOfBins+1]);
        colormap('HOT');
        
figure(3); clf; title('Acceleration and Velocity');

    hh(1) = subplot(2,2,1);
        hh(1).Position = [0.1 0.35 0.2 0.6];
        barh(out.VOccHist); ylim([0.5 numOfBins+0.5]);
        ylabel('Velocity');
    hh(2) = subplot(2,2,4);
        hh(2).Position = [0.35 0.1 0.6 0.2];
        bar(out.AOccHist); xlim([0.5 numOfBins+0.5]);
        xlabel('Acceleration');
    hh(3) = subplot(2,2,2);
        hh(3).Position = [0.35 0.35 0.6 0.6];
        surf(out.accvel'); view(0,90); xlim([1 numOfBins+1]); ylim([1 numOfBins+1]);
        colormap('HOT');

% figure(2); clf;
%     subplot(121); surf(out.Rposvel'); view(0,90); xlim([1 numOfBins+1]); ylim([1 numOfBins+1]);
%     subplot(122); surf(out.Raccvel'); view(0,90); xlim([1 numOfBins+1]); ylim([1 numOfBins+1]);
% colormap('HOT');
% 
% figure(4); clf;
%     subplot(121); surf(out.STIMposvel'); view(0,90); xlim([1 numOfBins+1]); ylim([1 numOfBins+1]);
%     subplot(122); surf(out.STIMaccvel'); view(0,90); xlim([1 numOfBins+1]); ylim([1 numOfBins+1]);
% colormap('HOT');
% 
% figure(4); clf;
%     subplot(311); barh(out.POccHist);
%     subplot(312); bar(out.VOccHist);
%     subplot(313); bar(out.AOccHist);
%     
    
% Raw stimulus
        
% figure(27); clf;
% 
% subplot(311); title('Position'); hold on;
% 
%     histogram('BinEdges', out.Presponse.edges, 'BinCounts', out.Presponse.stimulusHist);
%     histogram('BinEdges', out.Presponse.edges, 'BinCounts', out.Presponse.responseHist);
%     histogram('BinEdges', out.Prand.edges, 'BinCounts', out.Prand.responseHist);
% 
% subplot(312); title('Velocity'); hold on;
%     histogram('BinEdges', out.Vresponse.edges, 'BinCounts', out.Vresponse.stimulusHist);
%     histogram('BinEdges', out.Vresponse.edges, 'BinCounts', out.Vresponse.responseHist);
%     histogram('BinEdges', out.Vrand.edges, 'BinCounts', out.Vrand.responseHist);
% 
% subplot(313); title('Acceleration'); hold on;
%     histogram('BinEdges', out.Aresponse.edges, 'BinCounts', out.Aresponse.stimulusHist);
%     histogram('BinEdges', out.Aresponse.edges, 'BinCounts', out.Aresponse.responseHist);
%     histogram('BinEdges', out.Arand.edges, 'BinCounts', out.Arand.responseHist);

% subplot(311); title('Position'); hold on;
%     histogram('BinEdges', out.Prand.edges, 'BinCounts', out.Prand.OccHist, 'FaceColor', 'r');
%     histogram('BinEdges', out.Presponse.edges, 'BinCounts', out.Presponse.OccHist, 'FaceColor', 'b');
% subplot(312); title('Velocity'); hold on;
%     histogram('BinEdges', out.Vrand.edges, 'BinCounts', out.Vrand.OccHist, 'FaceColor', 'r');
%     histogram('BinEdges', out.Vresponse.edges, 'BinCounts', out.Aresponse.OccHist, 'FaceColor', 'b');
% subplot(313); title('Acceleration'); hold on;
%     histogram('BinEdges', out.Arand.edges, 'BinCounts', out.Arand.OccHist, 'FaceColor', 'r');
%     histogram('BinEdges', out.Aresponse.edges, 'BinCounts', out.Aresponse.OccHist, 'FaceColor', 'b');

    

      