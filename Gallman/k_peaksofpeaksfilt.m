function [regtim, datadata] = k_peaksofpeaksfilt(timcont, obw, ReFs)

%% process data

%Take top of dataset
    %find peaks
    [PKS,LOCS] = findpeaks(obw);
    %find peaks of the peaks
    [obwpeaks,cLOCS] = findpeaks(obw(LOCS));
    peaktim = timcont(LOCS(cLOCS));
    
%     % plot checking peaks
%     figure(45); clf; hold on;   
%         plot(peaktim, obwpeaks);
%         plot(timcont, obw);
%         plot([lighttimes' lighttimes'], ylim, 'k-');
    
%Regularize
    %regularize data to ReFs interval
    [regtim, regobwminusmean, regobwpeaks] = k_regularmetamucil(peaktim, obwpeaks, timcont, obw, ReFs);
    
    %filter data
        %cut off frequency
        highWn = 0.005/(ReFs/2);
        lowWn = 0.1/(ReFs/2);

        %high pass removes feeding trend
        [bb,aa] = butter(5, highWn, 'high');
        filtdata = filtfilt(bb,aa, double(regobwminusmean)); %double vs single matrix?

        %low pass removes spikey-ness
        [dd,cc] = butter(5, lowWn, 'low');
        datadata = filtfilt(dd,cc, filtdata);
