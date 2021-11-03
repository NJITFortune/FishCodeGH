
%tests for spline fitting subtraction
%plot like the detrending?

in = kg(4);
channel = 1;
ReFs = 10;
p = 0.5;


% ReFs = 10;
%% Take spline estimate of raw data

ld = in.info.ld; % Whatever - ld is shorter than in.info.ld

[xx, obwyy, obwtimOG, obwAmpOG, lighttimes] =  k_testobwspliner(in, channel, ReFs, p);

%% Plot spline vs raw data

figure(222); clf; title('spline estimate vs raw data'); hold on;

    plot(obwtimOG, obwAmpOG, 'MarkerSize', 3);
    plot(xx, obwyy, 'LineWidth', 3);
    plot([ld ld], ylim, 'k-', 'LineWidth', 1);
