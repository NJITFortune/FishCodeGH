function out = KatieMultiRemover(in)

% OBW        
figure(1); clf;

    histogram([in.Hiobw], 100); hold on;
    
    %Lower lim
    %fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
    [cutofffreqL, ~]  = ginput(1);
    plot([cutofffreqL, cutofffreqL], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
    drawnow; 
    
    %Upper lim
    %fprintf('Click cutoff for eliminating erroneously high amplitude measurements.\n');
    [cutofffreqH, ~]  = ginput(1);
    plot([cutofffreqH, cutofffreqH], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
    drawnow; 
    
    out(k).Hiobwidx = find([in.intubeHi] > cutofffreqL & [in.intubeHi] < cutofffreqH);
    pause(1);
    
    
figure(1); clf;

    histogram([in.Loobw], 100); hold on;
    
    %Lower lim
    %fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
    [cutofffreqL, ~]  = ginput(1);
    plot([cutofffreqL, cutofffreqL], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
    drawnow; 
    
    %Upper lim
    %fprintf('Click cutoff for eliminating erroneously high amplitude measurements.\n');
    [cutofffreqH, ~]  = ginput(1);
    plot([cutofffreqH, cutofffreqH], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
    drawnow; 
    
    out(k).Loobwidx = find([in.intubeLo] > cutofffreqL & [in.intubeLo] < cutofffreqH);
    pause(1);
    
end