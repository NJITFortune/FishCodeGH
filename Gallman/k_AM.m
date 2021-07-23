function out = k_AM(datums)

%find peaks
[peaky, idx] = findpeaks(datums); 
%resample peak idxs to get evenly spaced time indx for fft
qq = interp1(tim(idx), peaky, tim);

out = fftmachine(fillmissing(qq-nanmean(qq), 'spline'),40000);