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

        for k = 1:length([in(j).s.obwAmp])
            if in(j).s(k).fftFreq > cutofffreqL && in(j).s(k).fftFreq < cutofffreqH
                out(j).s(k).obwAmp = in(j).s(k).obwAmp;
                out(j).s(k).timcont = in(j).s(k).timcont;
                out(j).s(k).fftFreq = in(j).s(k).fftFreq;
                out(j).s(k).temp = in(j).s(k).temp;
                out(j).s(k).light = in(j).s(k).light;
                out(j).s(k).peakfftAmp = in(j).s(k).peakfftAmp;
                 out(j).s(k).sumfftAmp = in(j).s(k).sumfftAmp;
            end
        end

     end
        pause(1);
    

close(1);
    end
