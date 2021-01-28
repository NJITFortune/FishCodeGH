function out = iu_3DhistA(spiketimes, randspiketimes, pos, vel, acc, Fs)
% Function out = iu_hist(spikes, randspikes, sig, Fs, wid)
% spikes are the spike times
% randspikes are shuffled spike times
% sig is the signal (e.g. error_vel) of interest. Behavior...
% Fs is the sample rate (usually 25 for these data, fs = 25
% wid is the width of the spike triggered average in seconds (1 or 2 seconds is good)%% Histogram of All Spikes as Isolated Spikes

tim = 1/Fs:1/Fs:length(pos)/Fs; % Time stamps for the duration of the signal.

% Get the signal values at spike times

    spikePOS = interp1(tim, pos, spiketimes);
    spikeVEL = interp1(tim, vel, spiketimes);
    spikeACC = interp1(tim, acc, spiketimes);

    RspikePOS = interp1(tim, pos, randspiketimes);
    RspikeVEL = interp1(tim, vel, randspiketimes);
    RspikeACC = interp1(tim, acc, randspiketimes);

    actually = OccHist(pos, vel, acc, spikePOS, spikeVEL, spikeACC);
    randomly = OccHist(pos, vel, acc, RspikePOS, RspikeVEL, RspikeACC);
        
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

subplot(311); title('Position'); hold on;
    histogram('BinEdges', out.Prand.edges, 'BinCounts', out.Prand.OccHist, 'FaceColor', 'r');
    histogram('BinEdges', out.Presponse.edges, 'BinCounts', out.Presponse.OccHist, 'FaceColor', 'b');
subplot(312); title('Velocity'); hold on;
    histogram('BinEdges', out.Vrand.edges, 'BinCounts', out.Vrand.OccHist, 'FaceColor', 'r');
    histogram('BinEdges', out.Vresponse.edges, 'BinCounts', out.Aresponse.OccHist, 'FaceColor', 'b');
subplot(313); title('Acceleration'); hold on;
    histogram('BinEdges', out.Arand.edges, 'BinCounts', out.Arand.OccHist, 'FaceColor', 'r');
    histogram('BinEdges', out.Aresponse.edges, 'BinCounts', out.Aresponse.OccHist, 'FaceColor', 'b');

    
  function foo = OccHist(psig, vsig, asig, pspks, vspks, aspks)
%     actually = OccHist(pos, vel, acc, spikePOS, spikeVEL, spikeACC);
        
        numOfBins = 8;
        std_coeff   = 3;
    % Position-only histogram
    histBound = std_coeff * std(psig);    
    edgs = linspace(mean(psig)-histBound, mean(psig)+histBound, numOfBins+1);
    foo.PstimulusHist = histcounts(psig, edgs);
        foo.PstimulusHist(~isfinite(foo.PstimulusHist)) = 0;    
    foo.PresponseHist = histcounts(pspks, edgs);
        foo.PresponseHist(~isfinite(foo.PresponseHist)) = 0;
    foo.POccHist = (foo.PresponseHist / max(foo.PresponseHist)) ./ (foo.PstimulusHist / max(foo.PstimulusHist)); 
        foo.POccHist(~isfinite(foo.POccHist)) = 0;    
        foo.Pedges = edgs;
        
    % Velocity-only histogram
    histBound = std_coeff * std(vsig);    
    edgs = linspace(mean(vsig)-histBound, mean(vsig)+histBound, numOfBins+1);
    foo.VstimulusHist = histcounts(vsig, edgs);
        foo.VstimulusHist(~isfinite(foo.VstimulusHist)) = 0;    
    foo.VresponseHist = histcounts(vspks, edgs);
        foo.VresponseHist(~isfinite(foo.VresponseHist)) = 0;
    foo.VOccHist = (foo.VresponseHist / max(foo.VresponseHist)) ./ (foo.VstimulusHist / max(foo.VstimulusHist)); 
        foo.VOccHist(~isfinite(foo.VOccHist)) = 0;    
        foo.Vedges = edgs;

    % Acceleration-only histogram
    histBound = std_coeff * std(asig);    
    edgs = linspace(mean(asig)-histBound, mean(asig)+histBound, numOfBins+1);
    foo.AstimulusHist = histcounts(asig, edgs);
        foo.AstimulusHist(~isfinite(foo.AstimulusHist)) = 0;    
    foo.AresponseHist = histcounts(aspks, edgs);
        foo.AresponseHist(~isfinite(foo.AresponseHist)) = 0;
    foo.AOccHist = (foo.AresponseHist / max(foo.AresponseHist)) ./ (foo.AstimulusHist / max(foo.AstimulusHist)); 
        foo.AOccHist(~isfinite(foo.AOccHist)) = 0;    
        foo.Aedges = edgs;
        
  end


end