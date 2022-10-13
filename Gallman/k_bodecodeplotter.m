function k_bodecodeplotter(in, ReFs)
%(inSignal, outSignal, Fs)
%in = hkg2(k).e(1) or hkg2(k)
    %replace hkg with xxkg for temp changes

%too lazy to function
clearvars -except rkg kg2 hkg hkg2 xxkg xxkg2     
in = hkg(k)

    % Estimate transfer function from data
        [txy, f] = tfestimate(inSignal, outSignal, 1024, 1000, [], ReFs);
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
       