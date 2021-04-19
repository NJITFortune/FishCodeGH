function [peakfreq, peakamp, sumamp] = k_fft(in, uFs)

rango = 10; % Range in Hz for summing amplitude.

tmpfft = fftmaker(in, uFs);

    [peakamp, peakIDX] = max(tmpfft.fftdata);
    
    peakfreq = tmpfft.fftfreq(peakIDX);
    sumamp = sum(tmpfft.fftdata(tmpfft.fftfreq > (peakfreq - rango) & tmpfft.fftfreq < (peakfreq + rango)));
    
    
function out = fftmaker(data, Fs)
    
    % Compute the FFT (Fast Fourier Transform)

        L = length(data);
        NFFT = 2^nextpow2(L); % Next power of 2 from length of the data
        % NFFT = 1024*2;

        fftdata = fft(data,NFFT)/L;

        % We use only half of the data, hence fftdata(1:round(end/2));
        % And we take the absolute value of the real component and filter
        % that so that it is smooth

        out.fftdata = 2*abs(fftdata(1:(NFFT/2)+1));
        % out.fftdata = abs(real(fftdata(1:round(end/2))));

        % Now we need to generate the X values - which are the frequencies

        out.fftfreq = Fs/2*linspace(0,1,NFFT/2+1);

        % Sometimes the rounding makes it so that the lengths of the
        % data and the frequency values are off by one.  Let us correct that.

        minlen = min([length(out.fftfreq) length(out.fftdata)]);
        out.fftfreq = out.fftfreq(1:minlen);
        out.fftdata = out.fftdata(1:minlen);
end

    
    
end