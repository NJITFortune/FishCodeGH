function out = iu_hist(struct)
% Function out = iu_hist(spikes, randspikes, sig, Fs, wid)
% spikes are the spike times
% randspikes are shuffled spike times
% sig is the signal (e.g. error_vel) of interest. Behavior...
% Fs is the sample rate (usually 25 for these data, fs = 25
% wid is the width of the spike triggered average in seconds (1 or 2 seconds is good)%% Histogram of All Spikes as Isolated Spikes

% tim = struct.time; % Time stamps for the duration of the signal.

% Get the signal values at spike times

    for j=1:length(struct.spikes.
    out.fishPOS = OccHist(struct.fish_pos, struct.spikes.fish_pos);
    out.fishPOSrand = OccHist(struct.fish_pos, struct.spikes_rand.fish_pos);
    
    out.fishVEL = OccHist(struct.fish_vel, struct.spikes.fish_vel);
    out.fishVELrand = OccHist(struct.fish_vel, struct.spikes_rand.fish_vel);
    
    out.fishACC = OccHist(struct.fish_acc, struct.spikes.fish_acc);
    out.fishACCrand = OccHist(struct.fish_acc, struct.spikes_rand.fish_acc);

    out.fishJRK = OccHist(struct.fish_jerk, struct.spikes.fish_jerk);
    out.fishJRKrand = OccHist(struct.fish_jerk, struct.spikes_rand.fish_jerk);

    
    out.errorPOS = OccHist(struct.error_pos, struct.spikes.error_pos);
    out.errorPOSrand = OccHist(struct.error_pos, struct.spikes_rand.error_pos);
    
    out.errorVEL = OccHist(struct.error_vel, struct.spikes.error_vel);
    out.errorVELrand = OccHist(struct.error_vel, struct.spikes_rand.error_vel);
    
    out.errorACC = OccHist(struct.error_acc, struct.spikes.error_acc);
    out.errorACCrand = OccHist(struct.error_acc, struct.spikes_rand.error_acc);

    out.errorJRK = OccHist(struct.error_jerk, struct.spikes.error_jerk);
    out.errorJRKrand = OccHist(struct.error_jerk, struct.spikes_rand.error_jerk);
    
% figure(27); clf;
% 
% subplot(311); title('Position'); hold on;
% 
%     histogram('BinEdges', out.Presponse.edges, 'BinCounts', out.Presponse.stimulusHist, 'FaceColor', 'y', 'EdgeColor', 'y');
%     histogram('BinEdges', out.Presponse.edges, 'BinCounts', out.Presponse.responseHist, 'FaceColor', 'b', 'EdgeColor', 'b');
% %    histogram('BinEdges', out.Prand.edges, 'BinCounts', out.Prand.responseHist, 'FaceColor', 'r', 'EdgeColor', 'r');
% 
% subplot(312); title('Velocity'); hold on;
%     histogram('BinEdges', out.Vresponse.edges, 'BinCounts', out.Vresponse.stimulusHist, 'FaceColor', 'y', 'EdgeColor', 'y');
%     histogram('BinEdges', out.Vresponse.edges, 'BinCounts', out.Vresponse.responseHist, 'FaceColor', 'b', 'EdgeColor', 'b');
% %    histogram('BinEdges', out.Vrand.edges, 'BinCounts', out.Vrand.responseHist, 'FaceColor', 'r', 'EdgeColor', 'r');
% 
% subplot(313); title('Acceleration'); hold on;
%     histogram('BinEdges', out.Aresponse.edges, 'BinCounts', out.Aresponse.stimulusHist, 'FaceColor', 'y', 'EdgeColor', 'y');
%     histogram('BinEdges', out.Aresponse.edges, 'BinCounts', out.Aresponse.responseHist, 'FaceColor', 'b', 'EdgeColor', 'b');
% %    histogram('BinEdges', out.Arand.edges, 'BinCounts', out.Arand.responseHist, 'FaceColor', 'r', 'EdgeColor', 'r');

    
    function foo = OccHist(sig, spks)
        
        numOfBins = 8;
        std_coeff   = 3;
    % Determine edge boundaries
    
    histBound = std_coeff * std(sig);    
    edgs = linspace(-histBound, histBound, numOfBins+1);
    
    foo.stimulusHist = histcounts(sig, edgs);
        foo.stimulusHist(~isfinite(foo.stimulusHist)) = 0;
    
    foo.responseHist = histcounts(spks, edgs);
        foo.responseHist(~isfinite(foo.responseHist)) = 0;
        
    foo.OccCorrHist = (foo.responseHist / max(foo.responseHist)) ./ (foo.stimulusHist / max(foo.stimulusHist)); 
        foo.OccCorrHist(~isfinite(foo.OccCorrHist)) = 0;
    
    foo.edges = edgs;
        distX = abs((edgs(2) - edgs(1))/2);
    foo.Xs = edgs(1:end-1)+distX;
            
    end


end
