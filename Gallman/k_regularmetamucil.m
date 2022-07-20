function [newtim, normsubfft, newampFilled] = k_regularmetamucil(oldtim, oldamp, rawtim, rawamp, regularinterval)
% Usage: [newtim, newampmeansubtracted, newampFilled] = metamucil(oldtim, oldamp)
%
% oldtim and oldamp are the recording times in seconds and data from kg
% e.g. [kg(1).e(1).s.timcont] and [kg(1).e(1).s.sumfftAmp]
% BUT better to input the data with outliers already removed.
%
% newtim is the regularized sample times (based on the regularinterval)
% newampNaN has NaNs for missing data
% newampFilled has missing data filled using 'linear' interpolation
%
% The old data has a minimum interval of 60 seconds. 

%% Oldtim starts with first peak, not first light change
%finding peaks of peaks creates oldtim, need rawtim to start the day 

if oldtim(1) > timcont(1)
    gapidx = find(timcont < oldtim(1) - timcont(1));
    oldtim = [timcont(gapidx) oldtim];
    oldamp = [rawamp(gapidx) oldamp];
end
%% Regularize the data at precisely 60 second intervals

b = mod(oldtim, regularinterval); % How far is each time point away from ReFs second intervals
    oldtim(b < regularinterval/2) = oldtim(b < regularinterval/2) - b(b < regularinterval/2); % for data that is less than ReFs seconds away, round down.
    oldtim(b >= regularinterval/2) = oldtim(b >= regularinterval/2) + (regularinterval - b(b >= regularinterval/2)); % for data this is ReFs-2*ReFs seconds away, round up.

%% Now we need to fill in the gaps, both in time and insert NaNs for amplitude    

% find the interval between oldtim samples, divide by regular interval. 
d = (diff(oldtim)/regularinterval) - 1;  % Diff tells us the gaps, and the -1 is so that 0 is no gap 
                            % and otherwise the number we need to insert.
                          
dd = find(d > 0); % We only need to fill gaps (0 is not a gap!)

% This is painful for the weird case that the first data has a gap after it

if dd(1) == 1 % There is a gap after the first data point
    newtim = oldtim(1):regularinterval: oldtim(2) - regularinterval/3; % This is weird, but don't worry
    newampNaN = [oldamp(1) NaN(1, d(1))];

else % Copy the first batch of data into the new data and add first missing values
    newtim = oldtim(1:dd(1));
    newampNaN = oldamp(1:dd(1));

    insertims = (((1:d(dd(1))) * regularinterval) + newtim(end)); 
    insertamps = NaN(1, d(dd(1)));

    newtim = [newtim insertims];
    newampNaN = [newampNaN insertamps];

end

for j = 2:length(dd) % The rest of the data

    % Append the good old data to the new data
    newtim = [newtim oldtim(dd(j-1) + 1:dd(j))];
    newampNaN = [newampNaN oldamp(dd(j-1) + 1:dd(j))];

    % Insert the missing times and NaNs at the end
    insertims = (((1:d(dd(j))) * regularinterval) + newtim(end)); 
    insertamps = NaN(1, d(dd(j)));

    newtim = [newtim insertims];
    newampNaN = [newampNaN insertamps];

end

% Make a filled version
    newampFilled = fillmissing(newampNaN, 'linear');

% Normalization methods
   %mean subtraction
   normsubfft = newampFilled - mean(newampFilled);


   %detrend ydata
%    dtsubfftyy = detrend(newampFilled,0,'SamplePoints', newtim); %changed from polynomial detrend to mean subtraction 
%    normsubfftyytrend = 1./(newampFilled - dtsubfftyy);
%    tnormsubfftyy = newampFilled .* normsubfftyytrend;

% %Plot old and new data
% figure; clf;
%     ax(1) = subplot(211); hold on; plot(oldtim, oldamp, '*-'); hold on; plot(newtim, newampNaN, 'o');
%     ax(2) = subplot(212); hold on; plot(oldtim, oldamp, '*-'); hold on; plot(newtim, newampFilled, 'o');
%     linkaxes(ax, 'x');
%     pea = imread('/Applications/MATLAB_R2021b.app/toolbox/images/imdata/peacock.jpg');
%     figure; imshow(pea, 'InitialMagnification',1000); pause(1); close(gcf);
%A lasting impression

