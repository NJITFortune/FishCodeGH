%% Step through and track highest 10 amplitude signals
% Expects fndmnt, harm1, harm2 as [samples x channels] matrices (e.g. from filterall.m)
% Outputs amps*/freqs* as [numtracks x numsteps x nchans]

numtracks = 10;
windoWidth = 3; % in seconds
stepsize = 0.5; % in seconds
nchans = 16; % Channels 1:nchans are analyzed

siglen = size(fndmnt,1);

% Cycle through the entire time of the signal at steps stepsize

startims = 0:stepsize:siglen/Fs-windoWidth;
nsteps = length(startims);

% Sample indices for each window, matching tim > start & tim < start+windoWidth
% where tim = (1:siglen)/Fs
startidx = round(startims*Fs) + 1;
endidx = round((startims+windoWidth)*Fs) - 1;

ampsF = zeros(numtracks,nsteps,nchans);
freqsF = ampsF;
ampsH1 = ampsF;
freqsH1 = ampsF;
ampsH2 = ampsF;
freqsH2 = ampsF;

parfor k = 1:nchans

    sigF = fndmnt(:,k);
    sigH1 = harm1(:,k);
    sigH2 = harm2(:,k);

    aF = zeros(numtracks,nsteps); fF = aF;
    aH1 = aF; fH1 = aF;
    aH2 = aF; fH2 = aF;

    for x = 1:nsteps

        tt = startidx(x):endidx(x);

        j = fftmachine(sigF(tt), Fs, 9);
            [z,idxz] = findpeaks(j.fftdata);
            [sz, sidxz] = sort (z);
                for m = 0:numtracks-1
                    aF(m+1,x) = sz(end-m);
                    fF(m+1,x) = j.fftfreq(idxz(sidxz(end-m)));
                end

        jj = fftmachine(sigH1(tt), Fs, 9);
            [zz, idxzz] = findpeaks(jj.fftdata);
            [szz, sidxzz] = sort(zz);
                for m = 0:numtracks-1
                    aH1(m+1,x) = szz(end-m);
                    fH1(m+1,x) = jj.fftfreq(idxzz(sidxzz(end-m)));
                end

        jj2 = fftmachine(sigH2(tt), Fs, 9);
            [zz2, idxzz2] = findpeaks(jj2.fftdata);
            [szz2, sidxzz2] = sort(zz2);
                for m = 0:numtracks-1
                    aH2(m+1,x) = szz2(end-m);
                    fH2(m+1,x) = jj2.fftfreq(idxzz2(sidxzz2(end-m)));
                end

    end

    ampsF(:,:,k) = aF;
    freqsF(:,:,k) = fF;
    ampsH1(:,:,k) = aH1;
    freqsH1(:,:,k) = fH1;
    ampsH2(:,:,k) = aH2;
    freqsH2(:,:,k) = fH2;

end
