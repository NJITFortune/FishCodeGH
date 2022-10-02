%function out = k_dataprepper(in, channel, ReFs)
%% prep

lighttimes = k_lighttimes(in, light);

%% regularize data across time in ReFs second intervals

    %raw data
%     timcont = [in.e(channel).s(ttsf{channel}).timcont];
%     sumfft = [in.e(channel).s(ttsf{channel}).sumfftAmp];

    timcont = [in.e(channel).s(tto{channel}).timcont];
    obw = [in.e(channel).s(tto{channel}).obwAmp]/max([in.e(channel).s(tto{channel}).obwAmp]);
    

    timidx = timcont >= lighttimes(1) & timcont <= lighttimes(end);
    timcont = timcont(timidx);
    obw = obw(timidx);  

    %data above spline
    %[subffttim, subfft, ~, lighttimes] =  k_fftabovespline(in, timcont, obw, ReFs, light); %squiggle is the spline for plotting

    %regularize data to ReFs interval
    [xx, out.regobw, ~] = k_regularmetamucil(timcont, obw, ReFs);


    out.xx = xx/3600;
    out.lighttimes = lighttimes/3600;