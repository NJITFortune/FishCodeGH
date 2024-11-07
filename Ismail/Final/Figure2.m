% Figure 1 • Example STA plots for error velocity and fish acceleration

%% This is our best positive neuron.
f = 9; n = 4;

spikes = curfish(f).spikes.times(curfish(f).spikes.codes == n);

% The kinematic data is saved in pixels. This converts it to cm.
Esig = u_signalprep(curfish(9).error_pos);
Fsig = u_signalprep(curfish(9).fish_pos);

    sigEP = Esig.pos;
    sigEV = Esig.vel;
    sigEA = Esig.acc;

    sigFP = Fsig.pos;
    sigFV = Fsig.vel;
    sigFA = Fsig.acc;

% Our video sampling rate was 25 Hz.
Fs = 25;

% The window for the STA is (+/-) 2 seconds.
wid = 2;

% Run our STA code (uses a parfor loop for speed)
outEP = u_sta(spikes, [], sigEP, Fs, wid);
outEV = u_sta(spikes, [], sigEV, Fs, wid);
outEA = u_sta(spikes, [], sigEA, Fs, wid);

outFP = u_sta(spikes, [], sigFP, Fs, wid);
outFV = u_sta(spikes, [], sigFV, Fs, wid);
outFA = u_sta(spikes, [], sigFA, Fs, wid);

%% Plots for Figure 1, edited in Illustrator
figure(1); clf; set(gcf, 'renderer', 'painters'); hold on;
    plot(outEV.time, outEV.MEAN, 'Color', 'Magenta');
    plot(outEV.time, outEV.randMEAN, 'Color', '#333333')
    xline(0); ylim([-0.5 1]);

figure(2); clf; set(gcf, 'renderer', 'painters'); hold on;
    plot(outFA.time, outFA.MEAN, 'Color', 'Blue');
    plot(outFA.time, outFA.randMEAN, 'Color', '#333333')
    xline(0); ylim([-2.5 5])

figure(3); clf; 
subplot(2,2,1); hold on;
    plot(outEP.time, outEP.MEAN, 'Color', 'Magenta');
    plot(outEP.time, outEP.randMEAN, 'Color', '#333333')
    xline(0); 
subplot(2,2,2); hold on;
    plot(outEA.time, outEA.MEAN, 'Color', 'Magenta');
    plot(outEA.time, outEA.randMEAN, 'Color', '#333333')
    xline(0); ylim([-5 2.5])
subplot(2,2,3); hold on;
    plot(outFP.time, outFP.MEAN, 'Color', 'Magenta');
    plot(outFP.time, outFP.randMEAN, 'Color', '#333333')
    xline(0); 
subplot(2,2,4); hold on;
    plot(outFV.time, outFV.MEAN, 'Color', 'Magenta');
    plot(outFV.time, outFV.randMEAN, 'Color', '#333333')
    xline(0); ylim([-1 0.5])



set(gcf, 'renderer', 'painters'); hold on;
