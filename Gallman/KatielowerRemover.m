function out = KatielowerRemover(in)
% This eliminates bad data
% Usage: kg(#).idx = KatieRemover(kg(#).e);
for k=1:2

% OBW        
figure(1); clf;

    histogram([in(k).s.obwAmp], 100); hold on;
    
    fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
    [cutofffreq, ~]  = ginput(1);
    plot([cutofffreq, cutofffreq], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
    drawnow;    
    out(k).obwidx = find([in(k).s.obwAmp] > cutofffreq);
    pause(1);
    
% zAmp        
figure(1); clf;

    histogram([in(k).s.zAmp], 100); hold on;
    
    fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
    [cutofffreq, ~]  = ginput(1);
    plot([cutofffreq, cutofffreq], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
    drawnow;    
    out(k).zidx = find([in(k).s.zAmp] > cutofffreq);
    pause(1);

% peakfftAmp        
figure(1); clf;

    histogram([in(k).s.peakfftAmp], 100); hold on;
    
    fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
    [cutofffreq, ~]  = ginput(1);
    plot([cutofffreq, cutofffreq], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
    drawnow;    
    out(k).peakfftidx = find([in(k).s.peakfftAmp] > cutofffreq);
    pause(1);
    
% sumfftAmp        
figure(1); clf;

    histogram([in(k).s.sumfftAmp], 100); hold on;
    
    fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
    [cutofffreq, ~]  = ginput(1);
    plot([cutofffreq, cutofffreq], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
    drawnow;    
    out(k).sumfftidx = find([in(k).s.sumfftAmp] > cutofffreq);
    pause(1);

end