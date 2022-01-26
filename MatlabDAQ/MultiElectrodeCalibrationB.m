Fs = 40000; %sample rate
freqs = [250 650]; %freq range of typical eigen EOD
% Band pass filter in frequency range of fish
    [h,g] = butter(5, [freqs(1)/(Fs/2) freqs(2)/(Fs/2)]);

%katie cal
%plot
figure(1); clf; hold on;
    load('Eigen24LDA-01-26-2022_15-04-26.mat');
        data1 = filtfilt(h,g, data(:,1)); % Band pass filter   
        data2 = filtfilt(h,g, data(:,2)); % Band pass filter  
    kcalch1data = data1;
        xa(1) = subplot(411); plot(data1);
        xa(2) = subplot(412); plot(data2);
   load('Eigen24LDA-01-26-2022_15-05-59.mat');
        data1 = filtfilt(h,g, data(:,1)); % Band pass filter   
        data2 = filtfilt(h,g, data(:,2)); % Band pass filter  
   kcalch2data = data2;
        xa(3) = subplot(413); plot(data1);
        xa(4) = subplot(414); plot(data2);

figure(2); clf; hold on;
    ax(1) = subplot(211); 
        plot(kcalch1data);
       % findpeaks(abs(kcalch1data),'MinPeakProminence',2,'Annotate','extents')
          [pks1, locs1] = findpeaks(abs(kcalch1data));
        plot(locs1, pks1, 'r.-');
    ax(2) = subplot(212); 
        plot(kcalch2data);
           % [pks2, locs2] = findpeaks(kcalch2data);
        %plot(locs2, pks2);

    
     