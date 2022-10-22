function out = Katiehkg2Remover(in)

% OBW        
figure(1); clf;

    histogram([in.obwAmp], 100); hold on;
    
    %Lower lim
    fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
    [cutoffampL, ~]  = ginput(1);
    plot([cutoffampL, cutoffampL], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
    drawnow; 
    
    %Upper lim
    fprintf('Click cutoff for eliminating erroneously high amplitude measurements.\n');
    [cutoffampH, ~]  = ginput(1);
    plot([cutoffampH, cutoffampH], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
    drawnow; 
    
    out.obwidx = find([in.obwAmp] > cutoffampL & [in.obwAmp] < cutoffampH);

    pause(1);
    
    

    close(1);

    

