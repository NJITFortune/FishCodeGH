function out = iu_3DhistA(spiketimes, randspiketimes, pos, vel, acc, Fs)
% Function out = iu_hist(spikes, randspikes, sig, Fs, wid)
% spikes are the spike times
% randspikes are shuffled spike times
% sig is the signal (e.g. error_vel) of interest. Behavior...
% Fs is the sample rate (usually 25 for these data, fs = 25
% wid is the width of the spike triggered average in seconds (1 or 2 seconds is good)%% Histogram of All Spikes as Isolated Spikes

        numOfBins = 8;
        std_coeff   = 3;

% Get the sample rate for position
pFs = in(ent).s(1).pFs;

% Get the entries for the size selected by the user
idx = find([in(ent).s.sizeDX] == sz);

% Preparations
tim = 0; % Starting time for the next sample as we concatonate
spikes = []; % List of spike times
stimPOS = []; % Position over time

%% Concatonate data
if ~isempty(idx) % just make sure that the user isn't an idiot 

    for j = 1:length(idx) % cycle to concatonate all of the correct entries

        stimPOS = [stimPOS in(ent).s(idx(j)).pos']; % Concatonate position
        currtim = 1/pFs:1/pFs:length(in(ent).s(idx(j)).pos)/pFs; % A time base for the currently added position

        spikes = [spikes (in(ent).s(idx(j)).st + tim(end))']; % Concatonate spike times, adding the time from the end of previous
        
        tim = [tim (currtim + tim(end))]; % Update the time base 
        
    end
        
    tim = tim(2:end); % When we are all done, we remove the initial zero
    
end

% Derive the velocity and acceleration from position

    [b,a] = butter(3, 30/pFs, 'low'); % Filter for velocity
    [d,c] = butter(5, 20/pFs, 'low'); % Filter for acceleration

    vel = filtfilt(b,a,diff(stimPOS)); % VELOCITY
    acc = filtfilt(d,c,diff(vel)); % ACCELERATION
        
        
        
       
%% Get the signal values at spike times

    spikePOS = interp1(tim, pos, spiketimes);
    spikeVEL = interp1(tim, vel, spiketimes);
    spikeACC = interp1(tim, acc, spiketimes);

    RspikePOS = interp1(tim, pos, randspiketimes);
    RspikeVEL = interp1(tim, vel, randspiketimes);
    RspikeACC = interp1(tim, acc, randspiketimes);
        
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
    histBound = std_coeff * std(acc);    
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
for ss = length(spikesPOS):-1:1
    
    posVvel(ss,:) = [spikesPOS(ss) spikesVEL(ss)];
    accVvel(ss,:) = [spikesACC(ss) spikesVEL(ss)];
    RposVvel(ss,:) = [RspikesPOS(ss) RspikesVEL(ss)];
    RaccVvel(ss,:) = [RspikesACC(ss) RspikesVEL(ss)];    
    
end
    out.posvel = hist3(posVvel,[out.Pedges, out.Vedges]);
    out.accvel = hist3(accVvel,[out.Pedges, out.Vedges]);

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

figure; clf;

% subplot(311); title('Position'); hold on;
%     histogram('BinEdges', out.Prand.edges, 'BinCounts', out.Prand.OccHist, 'FaceColor', 'r');
%     histogram('BinEdges', out.Presponse.edges, 'BinCounts', out.Presponse.OccHist, 'FaceColor', 'b');
% subplot(312); title('Velocity'); hold on;
%     histogram('BinEdges', out.Vrand.edges, 'BinCounts', out.Vrand.OccHist, 'FaceColor', 'r');
%     histogram('BinEdges', out.Vresponse.edges, 'BinCounts', out.Aresponse.OccHist, 'FaceColor', 'b');
% subplot(313); title('Acceleration'); hold on;
%     histogram('BinEdges', out.Arand.edges, 'BinCounts', out.Arand.OccHist, 'FaceColor', 'r');
%     histogram('BinEdges', out.Aresponse.edges, 'BinCounts', out.Aresponse.OccHist, 'FaceColor', 'b');

    

      