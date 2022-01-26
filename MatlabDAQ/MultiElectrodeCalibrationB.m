
%katie cal
%plot
figure(1); clf; hold on;
    load('Eigen24LDA-01-26-2022_15-04-26.mat');
    kcalch1data = data(:,1);
        xa(1) = subplot(411); plot(data(:,1));
        xa(2) = subplot(412); plot(data(:,2));
   load('Eigen24LDA-01-26-2022_15-05-59.mat');
   kcalch2data = data(:,2);
        xa(3) = subplot(413); plot(data(:,1));
        xa(4) = subplot(414); plot(data(:,2));

figure(2); clf; hold on;
    ax(1) = subplot(211); 
        plot(kcalch1data);
            [pks1, locs1] = findpeaks(kcalch1data);
        plot(locs1, pks1);
    ax(2) = subplot(212); 
        plot(kcalch2data);
            [pks2, locs2] = findpeaks(kcalch2data);
        plot(locs2, pks2);

    
     