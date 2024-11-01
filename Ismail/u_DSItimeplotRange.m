function foo = u_DSItimeplotRange(spiketimes, sig, sig2, tim, rango)

foo.dels = -1.00:0.020:1.00; % Original
% foo.dels = -3.00:0.025:3.00;

% rango limit for error_vel somehwere between 150 and 200 (175) 
% rango limit for fish_acc somewhere between 650 and 800 (725)

parfor j=1:length(foo.dels)
    [dsi(j), ~] = u_trackDSIrange(spiketimes, sig, sig2, tim, foo.dels(j), rango); 
end


for j=length(dsi):-1:1

    foo.dsi(j) = dsi(j).spikes;
    foo.dsi2(j) = dsi(j).spikes2;
    foo.rdsi(j) = dsi(j).randspikes;

end
