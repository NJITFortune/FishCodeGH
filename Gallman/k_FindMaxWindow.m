function [startim, startidx] = k_FindMaxWindow(in, tim, SampleWindowDur)
% This picks the window for data analysis

    stepsize = 100; % How many samples between windows Should be calculated with respect to Fs
    
    numsamps = length(find(tim < SampleWindowDur)); % Number of samples in the time

%% Loop for every window in the sample    
    for k = length(in)-numsamps:-stepsize:1
    
        rmsamp(k) = rms(in(k:k+numsamps));
        
    end

%% Output the data

    [~, startidx] = max(rmsamp);
    startim = tim(startidx);
