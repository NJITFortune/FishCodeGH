function out = u_DSItimeplot(spiketimes, sig, tim)

out.dels = -0.250:0.050:0.250;

for j=length(out.dels):-1:1
    [out.dsi(j), ~] = u_trackDSI(spiketimes, sig, tim, out.dels(j)); 
end
