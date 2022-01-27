Fs = 40000; %sample rate
freqs = [250 650]; %freq range of typical eigen EOD
% Band pass filter in frequency range of fish
    [h,g] = butter(5, [freqs(1)/(Fs/2) freqs(2)/(Fs/2)]);

%katie cal
%plot
figure(1); clf; hold on;
    load('/Volumes/My Book/Gallman/Calibration-Jan2022/ElectrodeCalibration-Jan-26-2022-B/Eigen24LDA-01-26-2022_14-56-51.mat');
    load('/Volumes/My Book/Gallman/Calibration-Jan2022/ElectrodeCalibration-Jan-26-2022-B/Eigen24LDA-01-26-2022_14-41-12.mat');
        data1 = filtfilt(h,g, data(:,1)); % Band pass filter   
        data2 = filtfilt(h,g, data(:,2)); % Band pass filter  
   kcalch1data = data1;
   kcalch1tim = tim;
        xa(1) = subplot(411); plot(tim, data1);
        xa(2) = subplot(412); plot(tim, data2);
   load('/Volumes/My Book/Gallman/Calibration-Jan2022/ElectrodeCalibration-Jan-26-2022-B/Eigen24LDA-01-26-2022_14-58-08.mat');
   load('/Volumes/My Book/Gallman/Calibration-Jan2022/ElectrodeCalibration-Jan-26-2022-B/Eigen24LDA-01-26-2022_14-58-08.mat');
        data1 = filtfilt(h,g, data(:,1)); % Band pass filter   
        data2 = filtfilt(h,g, data(:,2)); % Band pass filter  
   kcalch2data = data2;
   kcalch2tim = tim;
        xa(3) = subplot(413); plot(tim, data1);
        xa(4) = subplot(414); plot(tim, data2);

linkaxes(xa, 'x');


fprintf('Two clicks on top to get the range for analysis.\n')
[xx, ~] = ginput(2); xx = sort(xx);
tt1 = find(kcalch1tim > xx(1) & kcalch1tim < xx(2));
dur = xx(2) - xx(1);

[pks1, ~] = findpeaks(abs(kcalch1data(tt1) - mean(kcalch1data(tt1))));

    meanamp1 = mean(pks1);
    stdamp1 = std(pks1);

fprintf('One clicks on bottom to get start of the range for analysis.\n')
[xx, ~] = ginput(1); 
tt2 = find(kcalch2tim > xx & kcalch2tim < xx+dur);

[pks2, ~] = findpeaks(abs(kcalch2data(tt2) - mean(kcalch2data(tt2))));

    meanamp2 = mean(pks2);
    stdamp2 = std(pks2);


fprintf('Amp1 is %2.4f and Amp2 = %2.4f and ratio is %2.4f \n', meanamp1, meanamp2, meanamp1/meanamp2)

% figure(2); clf; hold on;
%     ax(1) = subplot(211); hold on;
%         plot(kcalch1data);
%       % findpeaks(abs(kcalch1data),'MinPeakProminence',2,'Annotate','extents')
%          [pks1, locs1] = findpeaks(kcalch1data);
%          [npks1, nloc1] = findpeaks(-kcalch1data);
%         plot(nloc1,-npks1, 'g.-');
%         plot(locs1, pks1, 'r.-');
%     ax(2) = subplot(212); 
%         plot(locs1, -npks1(2:end) + pks1);  
%  
%     
% figure(3); clf; hold on;
%     ax(1) = subplot(211); hold on;
%         plot(kcalch2data);
%        % findpeaks(abs(kcalch1data),'MinPeakProminence',2,'Annotate','extents')
%          [pks2, locs2] = findpeaks(kcalch2data);
%          [npks2, nloc2] = findpeaks(-kcalch2data);
%         plot(nloc2,-npks2, 'g.-');
%         plot(locs2, pks2, 'r.-');
%     ax(2) = subplot(212); 
%     
%          plot(locs2, -npks2 + pks2);  
%     
%     % plot(kcalch2data);
%            % [pks2, locs2] = findpeaks(kcalch2data);
%         %plot(locs2, pks2);
% 
%     
%      