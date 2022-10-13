function k_bodecodeplotter(inSignal, outSignal, ReFs)
%(inSignal, outSignal, Fs)
%in = hkg2(k).e(1) or hkg2(k)
    %replace hkg with xxkg for temp changes


    % Estimate transfer function from data
        [txy, f] = tfestimate(inSignal, outSignal, 1024, 1000, [], ReFs);
    % Plot Bode plot
%  figure(1); clf;
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
       