function out = KatiesingleMultiRemover(in)

% OBW        
figure(1); clf;

    histogram([in.obwAmp], 100); hold on;
    
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
    
   
            out.obwidx = find([in.obwAmp] > cutofffreqL & [in.obwAmp] < cutofffreqH);
     

    pause(1);
 
  %peak amp  
    
figure(1); clf;

    histogram([in.pkAmp], 100); hold on;
    plot([thresh.upper, thresh.upper], ylim, 'k-');
    plot([thresh.lower, thresh.lower], ylim, 'k-');
    
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
 
         
             out.pkidx = find([in.pkAmp] > cutofffreqL & [in.pkAmp] < cutofffreqH);
       
    pause(1);
    close(1);

