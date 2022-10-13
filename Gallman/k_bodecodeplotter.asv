function k_bodecodeplotter(inSignal, outSignal, Fs)



    % Estimate transfer function from data
        [txy, f] = tfestimate(inSignal, outSignal, 1024, 1000, [], Fs);
    % Plot Bode plot
    figure; clf;
        ax(1) = subplot(211); 
            loglog(f, mag2db(abs(txy))); 
            title('Gain')
            ylabel('dB gain')
        ax(2) = subplot(212); 
            semilogx(f, phase(txy));
            title('Phase')
            ylabel('Degrees')
            xlabel('Frequency')
            
    linkaxes(ax, 'x');
       