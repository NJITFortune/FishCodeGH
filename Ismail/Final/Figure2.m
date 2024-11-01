% Figure 1 • Example STA plots for error velocity and fish acceleration

% This is our best neuron.
spikes = curfish(9).spikes.times(curfish(9).spikes.codes == 4);

% The kinematic data is saved in pixels. This converts it to cm.
Esig = u_signalprep(curfish(9).error_pos);
Fsig = u_signalprep(curfish(9).fish_pos);

    sigEV = Esig.vel;
    sigFA = Fsig.acc;

% Our video sampling rate was 25 Hz.
Fs = 25;

% The window for the STA is (+/-) 2 seconds.
wid = 2;

% Run our STA code (uses a parfor loop for speed)
outEV = u_sta(spikes, [], sigEV, Fs, wid);
outFA = u_sta(spikes, [], sigFA, Fs, wid);

% Plots for Figure 1, edited in Illustrator
figure(1); clf; set(gcf, 'renderer', 'painters'); hold on;
    plot(outEV.time, outEV.MEAN, 'Color', 'Magenta');
    plot(outEV.time, outEV.randMEAN, 'Color', '#333333')
    xline(0); ylim([-0.5 1]);

figure(2); clf; set(gcf, 'renderer', 'painters'); hold on;
    plot(outFA.time, outFA.MEAN, 'Color', 'Blue');
    plot(outFA.time, outFA.randMEAN, 'Color', '#333333')
    xline(0); ylim([-2.5 5])
