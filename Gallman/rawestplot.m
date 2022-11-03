figure(342); clf; hold on;
set(gcf, 'renderer', 'painters');
    ax(1) = subplot(211); 
        plot(tim,data(:,1)); 
        ylabel('Amplitude');
    ax(2) = subplot(212); 
    plot(tim,data(:,2)); 
    xlabel('Time (seconds)');
    ylabel('Amplitude');
    
linkaxes(ax,'x');