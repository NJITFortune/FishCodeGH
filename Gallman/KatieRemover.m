function out = KatieRemover(in)
% This eliminates bad data

for k=2:1
    
figure(1); clf;
    histogram([in(k).sampl.obwAmp], 100); hold on;
    
    fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
    [cutofffreq, ~]  = ginput(1);
    plot([cutofffreq, cutofffreq], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
    drawnow;
    
    out(k).obwidx = find([in(k).sampl.obwAmp] > cutofffreq);

    pause(1);
    
end