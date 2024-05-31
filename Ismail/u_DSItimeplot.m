function out = u_DSItimeplot(spiketimes, sig, tim)

out.dels = -0.750:0.025:0.750;

for j=length(out.dels):-1:1
    [out.dsi(j), ~] = u_trackDSI(spiketimes, sig, tim, out.dels(j)); 
end
