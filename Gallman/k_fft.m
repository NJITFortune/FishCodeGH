function [peakfreq, peakamp, sumamp] = k_fft(in, Fs)

rango = 10; % Range in Hz for summing amplitude.

tmpfft = fftmachine(in, Fs);

    [peakamp, peakIDX] = max(tmpfft.fftdata);
    
    peakfreq = tmpfft.fftfreq(peakIDX);
    sumamp = sum(tmpfft.fftdata(tmpfft.fftfreq > (peakFreq - rango) & tmpfft.fftfreq < (peakFreq + rango)));
    
    
