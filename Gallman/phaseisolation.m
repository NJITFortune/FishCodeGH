
in = kg(64);
channel = 1; 
ReFs = 10;
light = 3;

[xx, fftyy, lighttimes] =  k_fftsubspliner(in, channel, ReFs, light);




twidx1 = find(xx >= lighttimes(3) & xx <= (lighttimes(3) + 48));
twlightidx = find(lighttimes >= lighttimes(3) & lighttimes <= (lighttimes(3) + 48));
    


figure(23); clf; hold on;
plot(xx(twidx1), fftyy(twidx1));
lesslight = lighttimes(twlightidx);
for k = 1:length(lesslight)
    plot([lesslight(k), lesslight(k)], ylim, 'k-');
    
end