function out = k_dataprepper(in, channel, ReFs)
%% prep

% define length of trial
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld



            
%% crop data to lighttimes 

    ld = in.info.ld;
lighttimeslong = abs(in.info.luz);
if in.info.luz(1) < 0

    %fit light vector to power idx
        %poweridx = good data
    if isempty(in.info.poweridx) %if there are no values in poweridx []
        if light < 4
        lighttimes = lighttimeslong;
        else
        lighttimes = lighttimeslong(2:end);
        end
    else %take data from within power idx range

        if light < 4 %we start with dark
            lighttimesidx = lighttimeslong > in.info.poweridx(1) & lighttimeslong < in.info.poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        else %we start with light
            %poweridx normally starts with dark, so we need to add ld to start with light
            poweridx1 = in.info.poweridx(1) + ld;
            lighttimesidx = lighttimeslong > poweridx1(1) & lighttimeslong < in.info.poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        end
    end

else 
    lighttimeslong = lighttimeslong(2:end);
    if isempty(in.info.poweridx) %if there are no values in poweridx []
        if light < 4
        lighttimes = lighttimeslong;
        else
        lighttimes = lighttimeslong(2:end);
        end
    else %take data from within power idx range

        if light < 4 %we start with dark
            lighttimesidx = lighttimeslong > in.info.poweridx(1) & lighttimeslong < in.info.poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        else %we start with light
            %poweridx normally starts with dark, so we need to add ld to start with light
            poweridx1 = in.info.poweridx(1) + ld;
            lighttimesidx = lighttimeslong > poweridx1(1) & lighttimeslong < in.info.poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        end
    end
end
%make lighttimes an integer
    %convert to seconds because xx is in seconds
    lighttimes = floor(lighttimes*3600);

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