function vsout = i_vs(spikesig1, spikesig2, sig1, sig2)


% Get lengths for vector for spikes
    vsout.spikemag = sqrt(spikesig1.^2 + spikesig2.^2);

% Get angles for vector for spikes
    vsout.spikeang = atand(spikesig2 ./ spikesig1);

for j=1:length(vsout.spikeang)
    if spikesig1(j) < 0
        vsout.spikeang(j) =  180 + vsout.spikeang(j);
    end
    if spikesig1(j) > 0 && spikesig2(j) < 0
        vsout.spikeang(j) = 360 + vsout.spikeang(j);
    end
end

% Get lengths for vector for signal
    vsout.sigmag = sqrt(sig1.^2 + sig2.^2);

% Get angles for vector for spikes
    vsout.sigang = atand(sig2 ./ sig1);

for j=1:length(vsout.sigang)
    if sig1(j) < 0
        vsout.sigang(j) =  180 + vsout.sigang(j);
    end
    if sig1(j) > 0 && sig2(j) < 0
        vsout.sigang(j) = 360 + vsout.sigang(j);
    end
end

fprintf('Spikes mag ang is %4.2f %4.2f \n', mean(vsout.spikemag), mean(vsout.spikeang));
fprintf('Signal mag ang is %4.2f %4.2f \n', mean(vsout.sigmag), mean(vsout.sigang));



figure(27); clf;
    polarplot(vsout.sigang, log(vsout.sigmag), '.');
    hold on;
    polarplot(vsout.spikeang, log(vsout.spikemag), '.')


