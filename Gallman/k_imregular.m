function [xx, filledsumfftAmpyy, lighttimes] =  k_imregular(in, channel, ReFs, light)
%function out = imregular(in)
%% to lazy to function
% clearvars -except kg kg2
% %out = in;
% in = kg(1);
% channel = 1;
% ReFs = 60;
% light = 3;


k = channel;
%% prep
%outlier removal indicies
    ttsf{1} = 1:length([in.e(1).s.timcont]); % ttsf is indices for sumfftAmp
    ttsf{2} = 1:length([in.e(2).s.timcont]);

    % If we have removed outliers via KatieRemover, get the indices...    
            if ~isempty(in.idx) 
                ttsf{1} = in.idx(1).sumfftidx; ttsf{2} = in.idx(2).sumfftidx; % ttsf is indices for sumfftAmp
            end
      
%lighttimes
    lighttimeslong = abs(in.info.luz);
    ld = in.info.ld;

  %fit light vector to power idx
        %poweridx = good data

    %no poweridx
    if isempty(in.info.poweridx) %if there are no values in poweridx []

        lighttimes = lighttimeslong;

    %poweridx
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

xx = in.e(1).s(1).timcont:ReFs:in.e(1).s(end).timcont;
xidx = find(xx>= lighttimes(1)*3600 & xx <= lighttimes(end)*3600);

%xx = lighttimes(1)*3600:ReFs:lighttimes(end)*3600;

for j = length(xx):-1:1

    %find values a half step in either direction ReFs
    tt = find([in.e(k).s.timcont] > (xx(j)-ReFs/2) & [in.e(k).s.timcont] < (xx(j)+ReFs/2));

    %if there are values, assign the y to xx
    if ~isempty(tt) 
        sumfftAmpyy(j) = in.e(k).s(tt).sumfftAmp;

    %if there are no values assign nan
    else
        sumfftAmpyy(j) = nan;
    end

end

out.meanamp = movmean(sumfftAmpyy, 3, 'omitnan');
filledsumfftAmpyy = fillmissing(sumfftAmpyy, 'linear');
%xx = xx/3600;
figure(4); clf; hold on;
    plot([in.e(k).s.timcont], [in.e(k).s.sumfftAmp], '.-');
    plot(xx, sumfftAmpyy, '.-'); 
    plot(xx, filledsumfftAmpyy, 'o-');

