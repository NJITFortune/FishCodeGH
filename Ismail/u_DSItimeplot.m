function foo = u_DSItimeplot(spiketimes, sig, tim)

foo.dels = -1.00:0.020:1.00; % Original
% foo.dels = -3.00:0.025:3.00;

parfor j=1:length(foo.dels)
    dels = -1.00:0.020:1.00;
    [dsi(j), ~] = u_trackDSI(spiketimes, sig, tim, dels(j)); 
end


for j=length(dsi):-1:1

    foo.dsi(j) = dsi(j).spikes;
    foo.rdsi(j) = dsi(j).randspikes;

end
