%% single fish test case
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

%% multiple fish
light = 3;
channel = 1;
ReFs = 10;

%% kg data index
 exp1idx = [64 65 66 67];
 
 %get the spline estimates for each sample
    for k = 1:length(exp1idx)

   
    %[one(k).xx, one(k).fftyy, one(k).lighttimes] =  k_fftsubspliner(kg(onefish124idx(k)), channel, ReFs, light);
    [one(k).xx, one(k).fftyy, one(k).lighttimes] =  k_fftsubspliner(kg(exp1idx(k)), channel, ReFs, light);

    %first transistion idx
    twidx1 = find(one(k).xx >= one(k).lighttimes(3) & one(k).xx <= (one(k).lighttimes(3) + 48));
    twlightidx = find(one(k).lighttimes >= one(k).lighttimes(3) & one(k).lighttimes <= (one(k).lighttimes(3) + 48));
    

    one(k).lighttimes1 = one(k).lighttimes(twlightidx);
    one(k).xx1 = one(k).xx(twidx1);
    one(k).fftyy1 = one(k).fftyy(twidx1);

    %raw data for plotting/spline check
    one(k).timcont = [kg(exp1idx(k)).e(1).s(twidx1).timcont]/3600;
    one(k).fft = [kg(exp1idx(k)).e(1).s(twidx1).sumfftAmp];


    end

%% plots

%spline tranistion summary plot
figure(24); clf; hold on;

%plot all splines on top of eachother
    for k = 1:length(one)
    plot(one(k).xx1, one(k).fftyy1);
    end
%plot light transitions
    for j = 1:length(one(1).lighttimes1)
        plot([one(1).lighttimes1(j), one(1).lighttimes1(j)], ylim, 'k-');
      
    end

%individual splines plus raw data    
figure(25); clf; hold on;




   
