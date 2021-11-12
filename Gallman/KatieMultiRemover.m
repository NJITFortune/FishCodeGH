function out = KatieMultiRemover(in)

% OBW        
figure(1); clf;

    histogram([in.his.HiAmp], 100); hold on;
    
    %Lower lim
    fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
    [cutofffreqL, ~]  = ginput(1);
    plot([cutofffreqL, cutofffreqL], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
    drawnow; 
    
    %Upper lim
    fprintf('Click cutoff for eliminating erroneously high amplitude measurements.\n');
    [cutofffreqH, ~]  = ginput(1);
    plot([cutofffreqH, cutofffreqH], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
    drawnow; 
    
    for j=1:length(in.his)
         if in(j).his.HiAmp > cutofffreqL && in(j).his.HiAmp < cutofffreqH
             out(j).Hiidx = j;
         end
    end

    pause(1);
    
    
figure(1); clf;

    histogram([in.los.LoAmp], 100); hold on;
    
    %Lower lim
    fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
    [cutofffreqL, ~]  = ginput(1);
    plot([cutofffreqL, cutofffreqL], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
    drawnow; 
    
    %Upper lim
    fprintf('Click cutoff for eliminating erroneously high amplitude measurements.\n');
    [cutofffreqH, ~]  = ginput(1);
    plot([cutofffreqH, cutofffreqH], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
    drawnow; 
    for j=1:length(in.los)
         if in(j).los.LoAmp > cutofffreqL && in(j).los.LoAmp < cutofffreqH
             out(j).Loidx = j;
         end
    end
    pause(1);
end
    

