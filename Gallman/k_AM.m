function out = k_AM(datums, timmy, Fs)

%find peaks
[peaky, idx] = findpeaks(datums); 
%resample peak idxs to get evenly spaced time indx for fft
qq = interp1(timmy(idx), peaky, 1/Fs:1/Fs:1);

out = fftmachine(fillmissing(qq-nanmean(qq), 'spline'), Fs);