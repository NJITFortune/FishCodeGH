Fs = 20000; % Sample rate

stimnum = 10; 

envfreqs = [0.0625, 0.125, 0.25, 0.5, 1];

% single AM "Drive bys"

AMfreqs = [20, 120];


for k = 1:length(envfreqs)

    numsamps = (stimnum * Fs) / envfreqs(k);
    tim = 1/Fs:1/Fs:numsamps/Fs;

    for j=1:length(AMfreqs)
        
        AMsig = sin(2*pi* tim * AMfreqs(j)); % AM modulated base signal
        ENVsig = sin(2*pi*tim * envfreqs(k)); 
        ENVsig = (ENVsig/10) + 0.9;

        EnvSigFinal(j).sig(k).sig = AMsig .* ENVsig; 

        %figure; plot(tim, EnvSigFinal(j).sig(k).sig)

    end
end

audiowrite('SinEnv_20HzEnv1.wav', EnvSigFinal(1).sig(5).sig, Fs)

%% Noisy Envelopes 

[b,a] = butter(5, 120/(Fs/2), 'low');

for k = 1:length(envfreqs)

    numsamps = (stimnum * Fs) / envfreqs(k);
    tim = 1/Fs:1/Fs:numsamps/Fs;

    noisig = rand(1,numsamps*3);
    noisig = filtfilt(b,a, noisig);

        noisig = noisig(numsamps+1:numsamps*2);
        noisig = noisig - mean(noisig);

        ENVsig = sin(2*pi*tim * envfreqs(k)); 
        ENVsig = (ENVsig/10) + 0.9;
        NoisEnvSigFinal(k).sig = noisig .* ENVsig;

        %figure; plot(tim, NoisEnvSigFinal(k).sig)

end

audiowrite('NoisyEnv_.5Hz.wav', NoisEnvSigFinal(4).sig, Fs)

%% Noise in three freq ranges (AM only < 20 Hz, AM and Env 60-80 Hz, AM 0-120 Hz)

noisedur = 20;
basenoise = rand(1,numsamps*3);


    [b,a] = butter(5, 20/(Fs/2), 'low');
        lownoise = filtfilt(b,a,basenoise);
        lownoise = lownoise(numsamps+1: numsamps*2);
        lownoise = lownoise - mean(lownoise);

    [b,a] = butter(3, [60/(Fs/2) 80/(Fs/2)], 'bandpass');
        highnoise = filtfilt(b,a,basenoise);
        highnoise = highnoise(numsamps+1: numsamps*2);
        highnoise = highnoise - mean(highnoise);

    [b,a] = butter(5, 120/(Fs/2), 'low');
        broadnoise = filtfilt(b,a,basenoise);
        broadnoise = broadnoise(numsamps+1: numsamps*2);
        broadnoise = broadnoise - mean(broadnoise);



figure(333); 
subplot(311); plot(lownoise); 
subplot(312); plot(highnoise);
subplot(313); plot(broadnoise);

