function foo = DSItimeplotEVFA(spiketimes, EVsig, FAsig, tim)

foo.dels = -1.00:0.020:1.00; % Original
% foo.dels = -3.00:0.025:3.00;
% foo.dels = -0.500:0.010:0.500;


parfor j=1:length(foo.dels)
    dels = -1.00:0.020:1.00;
    [dsiEV(j), ~] = trackDSI(spiketimes, EVsig, tim, dels(j)); 
    [dsiFA(j), ~] = trackDSI(spiketimes, FAsig, tim, dels(j)); 
end


for j=length(dsiEV):-1:1

    foo.evDSI(j) = dsiEV(j).spikes;
    foo.rEVdsi(j) = dsiEV(j).randspikes;
    foo.faDSI(j) = dsiFA(j).spikes;
    foo.rFAdsi(j) = dsiFA(j).randspikes;

end

% figure(27); clf; 
% plot(foo.dels, [foo.evDSI', foo.faDSI']); hold on; plot([0, 0], [-0.5, 0.5], 'k-');