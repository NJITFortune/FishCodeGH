
in = kg(64);
channel = 1; 
ReFs = 10;
light = 3;

[xx, fftyy, lighttimes] =  k_fftsubspliner(in, channel, ReFs, light);



for j = 1:length(lighttimes/2)
    
    if lighttimes(j+1) - lighttimes(j) == 24 & lighttimes(j+3) - lighttimes(j+2) == 4
        twidx1 = find(xx >= lighttimes(j) & xx <= (lighttimes(j) + 48));
    end
        
    
end

figure(23); clf; hold on;
plot(xx(twidx1), fftyy(twidx1));
lesslight = lighttimes(twidx1);
for k = 1:length(lesslight)
    plot([lesslight(k), lesslight(k)], ylim, 'k-');
    
end