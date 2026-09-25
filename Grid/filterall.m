fnd = [350 600];

fndmnt = a;
harm1 = a;
harm2 = a;

[c,b] = butter(4, [fnd(1) / (Fs/2), fnd(2) / (Fs/2)], 'bandpass'); % Fundamental
[cc,bb] = butter(5, [2*fnd(1) / (Fs/2), 2*fnd(2) / (Fs/2)], 'bandpass'); % First Harmonic
[ccc,bbb] = butter(6, [3*fnd(1) / (Fs/2), 3*fnd(2) / (Fs/2)], 'bandpass'); % Second Harmonic

parfor j=1:length(a(1,:))

	fndmnt(:,j) = filtfilt(c,b, a(:,j));
	harm1(:,j) = filtfilt(cc,bb, a(:,j));
	harm2(:,j) = filtfilt(ccc,bbb, a(:,j));

end
