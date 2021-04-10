fftmachine <- function(data, Fs){
# Compute the FFT (Fast Fourier Transform)
# out = fftmachine(data, Fs, smoothwindow);
# Where out is a strucutre with fftfreq and fftdata
# The smoothwindow is for a medfilt1 low-pass filtering
# of the fft data itself. This should generally be low and
# odd, 9 or less.

L <- length(data) # How long is our sample?

NFFT <- 2^pracma::nextpow2(L) # Next power of 2 from length of the data

fftdata <- fft(data, NFFT)/L # Perform the FFT (fftw would be faster)

# We use only half of the data, hence fftdata(1:round(end/2));
# And we take the absolute value of the real component and filter
# that so that it is smooth

fftdata <- 2*abs(fftdata[1:(NFFT/2)+1])

# Now we need to generate the X values - which are the frequencies

fftfreq <- Fs/2*linspace(0,1,NFFT/2+1)

# Sometimes the rounding makes it so that the lengths of the
# data and the frequency values are off by one.  Let us correct that.

minlen <- min(length(fftfreq), length(fftdata))
fftfreq <- fftfreq[1:minlen]
fftdata <- fftdata[1:minlen]

# Finally, we can plot

plot(fftfreq, fftdata, type = 'l')

df <- data.frame(fftfreq, fftdata)
return(df)
}

