function out = iu_3DhistA(in, ent, sz)
% Function out = iu_hist(spikes, randspikes, sig, Fs, wid)
% spikes are the spike times
% randspikes are shuffled spike times
% sig is the signal (e.g. error_vel) of interest. Behavior...
% Fs is the sample rate (usually 25 for these data, fs = 25
% wid is the width of the spike triggered average in seconds (1 or 2 seconds is good)%% Histogram of All Spikes as Isolated Spikes

        numOfBins = 16;
        std_coeff   = 2;

% Get the sample rate for position
Fs = in(ent).s(1).pFs;

% Get the entries for the size selected by the user
idx = find([in(ent).s.sizeDX] == sz);

% Preparations
tim = 0; % Starting time for the next sample as we concatonate
spikes = []; % List of spike times
pos = []; % Position over time

%% Concatonate data
if ~isempty(idx) % just make sure that the user isn't an idiot 

    for j = 1:length(idx) % cycle to concatonate all of the correct entries

        pos = [pos in(ent).s(idx(j)).pos']; % Concatonate position
        currtim = 1/Fs:1/Fs:length(in(ent).s(idx(j)).pos)/Fs; % A time base for the currently added position

        spikes = [spikes (in(ent).s(idx(j)).st + tim(end))']; % Concatonate spike times, adding the time from the end of previous
        
        tim = [tim (currtim + tim(end))]; % Update the time base 
        
    end
        
    tim = tim(2:end); % When we are all done, we remove the initial zero
    
end

% Derive the velocity and acceleration from position
% 
%     [b,a] = butter(3, 30/Fs, 'low'); % Filter for velocity
%     [d,c] = butter(5, 20/Fs, 'low'); % Filter for acceleration
% 
%     vel = filtfilt(b,a,diff(pos)); % VELOCITY
%         vel(end+1) = vel(end);
%     acc = filtfilt(d,c,diff(vel)); % ACCELERATION
%         acc(end+1) = acc(end);
    vel = smooth(diff(pos)); vel(end+1) = vel(end);
    acc = smooth(diff(vel)); acc(end+1) = acc(end);
    vel = vel'; acc = acc';
        
% Make random spike train    
    ISIs = diff(spikes);
    randspikes(1) = spikes(1);
    for k = randperm(length(ISIs))
        randspikes(end+1) = randspikes(end) + ISIs(k);
    end

        
       
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
    histBound = std_coeff * std(acc) / 10;    
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

% Histogram for stimulus
for ss = length(pos):-100:1
    STIMposVvel(ss,:) = [pos(ss) vel(ss)];
    STIMaccVvel(ss,:) = [acc(ss) vel(ss)];
end

    out.STIMposvel = hist3(STIMposVvel, 'Edges', {out.Pedges, out.Vedges});
    out.STIMaccvel = hist3(STIMaccVvel, 'Edges', {out.Aedges, out.Vedges});


figure(1); clf;
    subplot(121); surf(out.posvel'); view(0,90); 
    subplot(122); surf(out.accvel'); view(0,90);
colormap('HOT');

figure(2); clf;
    subplot(121); surf(out.STIMposvel'); view(0,90); 
    subplot(122); surf(out.STIMaccvel'); view(0,90);
colormap('HOT');

figure(3); clf;
    subplot(311); bar(out.POccHist);
    subplot(312); bar(out.VOccHist);
    subplot(313); bar(out.AOccHist);
    
    
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

    

      