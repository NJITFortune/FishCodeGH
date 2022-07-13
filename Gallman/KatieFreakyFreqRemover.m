function out = KatieFreakyFreqRemover(in)
% This eliminates bad data
% Usage: kg(#).idx = KatieRemover(kg(#).e);
    for j=1:2
    
       
    figure(1); clf;
    
        histogram([in(j).s.fftFreq], 100); hold on;
        
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
        
        %freqidx = find([in(j).s.fftFreq] > cutofffreqL & [in(j).s.fftFreq] < cutofffreqH);


        tt = find([in(j).s.fftFreq] > cutofffreqL & [in(j).s.fftFreq] < cutofffreqH);
    
            out(j).s = in(j).s(tt);

        
    end

        pause(1);
    

close(1);
    end
