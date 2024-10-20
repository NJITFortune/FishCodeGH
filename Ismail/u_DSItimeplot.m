function foo = u_DSItimeplot(spiketimes, sig, tim)

foo.dels = -0.750:0.025:0.750; % Original
% foo.dels = -3.00:0.025:3.00;

parfor j=1:length(foo.dels)
    [dsi(j), ~] = u_trackDSI(spiketimes, sig, tim, foo.dels(j)); 
end


for j=length(dsi):-1:1

    foo.dsi(j) = dsi(j).spikes;
    foo.rdsi(j) = dsi(j).randspikes;

end
