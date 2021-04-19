function out = KatieRemover(in)
% This eliminates bad data
% Usage: kg(#).idx = KatieRemover(kg(#).e);
for k=1:2

% OBW        
figure(1); clf;

    histogram([in(k).s.obwAmp], 100); hold on;
    
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
    
    out(k).obwidx = [in(k).s.obwAmp] > cutofffreqL & [in(k).s.obwAmp] < cutofffreqH;
    pause(1);
    
% zAmp        
figure(1); clf;

    histogram([in(k).s.zAmp], 100); hold on;
    
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
    
    %Define indices by upper and lower lim
    out(k).zidx = [in(k).s.zAmp] > cutofffreqL & [in(k).s.zAmp] < cutofffreqH;
    pause(1);

% peakfftAmp        
figure(1); clf;

    histogram([in(k).s.peakfftAmp], 100); hold on;
    
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
    
   %Define indices by upper and lower lim
    out(k).peakfftidx = find([in(k).s.peakfftAmp] > cutofffreqL & [in(k).s.peakfftAmp] < cutofffreqH);
    pause(1);
    
% sumfftAmp        
figure(1); clf;

    histogram([in(k).s.sumfftAmp], 100); hold on;
    
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
    
    %Define indices by upper and lower lim
    out(k).sumfftidx = [in(k).s.sumfftAmp] > cutofffreqL & [in(k).s.sumfftAmp] < cutofffreqH;
    pause(1);

end