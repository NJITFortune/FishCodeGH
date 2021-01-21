function out = iu_histA(struct)
% Function out = iu_hist(spikes, randspikes, sig, Fs, wid)
% spikes are the spike times
% randspikes are shuffled spike times
% sig is the signal (e.g. error_vel) of interest. Behavior...
% Fs is the sample rate (usually 25 for these data, fs = 25
% wid is the width of the spike triggered average in seconds (1 or 2 seconds is good)%% Histogram of All Spikes as Isolated Spikes

tim = 1/Fs:1/Fs:; % Time stamps for the duration of the signal.

% Get the signal values at spike times

    for j=length(spikes):-1:1
        
        PreTim = 1; % Position integration time before spike
        tt = find(struct.time > spikes(j)-PreTim & struct.time < spikes(j));
        fishSpikePos(j) = mean(struct.fish_pos(tt));
        errSpikePos(j) = mean(struct.error_pos(tt));
        
        PreTim = PreTim / 2;
        tt = find(struct.time > spikes(j)-PreTim & struct.time < spikes(j));
        fishSpikeVel(j) = mean(struct.fish_vel(tt));
        errSpikeVel(j) = mean(struct.error_vel(tt));
        
        PreTim = PreTim / 2;
        tt = find(struct.time > spikes(j)-PreTim & struct.time < spikes(j));
        fishSpikeAcc(j) = mean(struct.fish_acc(tt));
        errSpikeAcc(j) = mean(struct.error_acc(tt));
        
        PreTim = PreTim / 2;
        tt = find(struct.time > spikes(j)-PreTim & struct.time < spikes(j));
        fishSpikeJrk(j) = mean(struct.fish_jerk(tt));    
        errSpikeJrk(j) = mean(struct.error_jerk(tt));        
    end
    
    % out.fishPOS = OccHist(struct.fish_pos, struct.spikes.fish_pos);
    out.fishPOS = OccHist(struct.fish_pos, fishSpikePos);
    out.fishPOSrand = OccHist(struct.fish_pos, struct.spikes_rand.fish_pos);
    
%    out.fishVEL = OccHist(struct.fish_vel, struct.spikes.fish_vel);
    out.fishVEL = OccHist(struct.fish_vel, fishSpikeVel);
    out.fishVELrand = OccHist(struct.fish_vel, struct.spikes_rand.fish_vel);
    
%    out.fishACC = OccHist(struct.fish_acc, struct.spikes.fish_acc);
    out.fishACC = OccHist(struct.fish_acc, fishSpikeAcc);
    out.fishACCrand = OccHist(struct.fish_acc, struct.spikes_rand.fish_acc);

%    out.fishJRK = OccHist(struct.fish_jerk, struct.spikes.fish_jerk);
    out.fishJRK = OccHist(struct.fish_jerk, fishSpikeJrk);
    out.fishJRKrand = OccHist(struct.fish_jerk, struct.spikes_rand.fish_jerk);

    
%    out.errorPOS = OccHist(struct.error_pos, struct.spikes.error_pos);
    out.errorPOS = OccHist(struct.error_pos, errSpikePos);
    out.errorPOSrand = OccHist(struct.error_pos, struct.spikes_rand.error_pos);
    
%    out.errorVEL = OccHist(struct.error_vel, struct.spikes.error_vel);
    out.errorVEL = OccHist(struct.error_vel, errSpikeVel);
    out.errorVELrand = OccHist(struct.error_vel, struct.spikes_rand.error_vel);
    
%    out.errorACC = OccHist(struct.error_acc, struct.spikes.error_acc);
    out.errorACC = OccHist(struct.error_acc, errSpikeAcc);
    out.errorACCrand = OccHist(struct.error_acc, struct.spikes_rand.error_acc);

%    out.errorJRK = OccHist(struct.error_jerk, struct.spikes.error_jerk);
    out.errorJRK = OccHist(struct.error_jerk, errSpikeJrk);
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
