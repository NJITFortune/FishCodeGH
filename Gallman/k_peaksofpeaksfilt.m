function [regtim,  regobwpeaks] = k_peaksofpeaksfilt(timcont, obw, ReFs)

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
    [regtim, ~, regobwpeaks] = k_regularmetamucil(peaktim, obwpeaks, timcont, timcont, obw, ReFs);
    


%         %high pass removes feeding trend
%         [bb,aa] = butter(5, highWn, 'high');
%         filtdata = filtfilt(bb,aa, double(regobwpeaks)); %double vs single matrix?
% 
%         %low pass removes spikey-ness
%         [dd,cc] = butter(5, lowWn, 'low');
%         datadata = filtfilt(dd,cc, filtdata);
