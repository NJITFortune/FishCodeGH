function out = iu_hist(spiketimes, randspiketimes, pos, vel, acc, Fs)
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

    out.Presponse = OccHist(pos, spikePOS);
    out.Prand = OccHist(pos, RspikePOS);
    
    out.Vresponse = OccHist(vel, spikeVEL);
    out.Vrand = OccHist(vel, RspikeVEL);
    
    out.Aresponse = OccHist(acc, spikeACC);
    out.Arand = OccHist(acc, RspikeACC);
    
figure(27); clf;

subplot(311); title('Position'); hold on;

    histogram(out.Prand.stimulusHist, out.Prand.edges);
    histogram(out.Presponse.stimulusHist, out.Presponse.edges);
    %plot(out.Presponse.edges, out.Presponse.stimulusHist, 'b-*');

subplot(312); title('Velocity'); hold on;
%     plot(out.Vrand.edges, out.Vrand.stimulusHist, 'r-*');
%     plot(out.Vresponse.edges, out.Vresponse.stimulusHist, 'b-*');

subplot(313); title('Acceleration'); hold on;
%     plot(out.Arand.edges, out.Arand.stimulusHist, 'r-*');
%     plot(out.Aresponse.edges, out.Aresponse.stimulusHist, 'b-*');

    
    function foo = OccHist(sig, spks)
        
        numOfBins = 10;
        std_coeff   = 3;
    % Determine edge boundaries
    
    histBound = std_coeff * std(sig);    
    edgs = linspace(mean(sig)-histBound, mean(sig)+histBound, numOfBins+1);
    
    foo.stimulusHist      = histcounts(sig, edgs);
    % hc      = hc / 25;
    
    foo.responseHist      = histcounts(spks, edgs);
    foo.randHist      = histcounts(spks, edgs);

        foo.stimulusHist(~isfinite(foo.stimulusHist)) = 0;
        foo.responseHist(~isfinite(foo.responseHist)) = 0;
        foo.OccHist = foo.responseHist ./ foo.stimulusHist; 
            foo.OccHist(~isfinite(foo.OccHist)) = 0;
    
        foo.edges = edgs;
            
    end


end
