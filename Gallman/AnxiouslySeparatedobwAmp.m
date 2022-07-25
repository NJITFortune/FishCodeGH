
clearvars -except kg kg2 rkg k
in = kg2(k);
%% prep

Fs = 40000;
freqs = [200 650]; %freq range of typical eigen EOD
iFiles = dir('Eigen*');

 % Band pass filter in frequency range of fish
 [h,g] = butter(5, [freqs(1)/(Fs/2) freqs(2)/(Fs/2)]);

%% obwAmp of anxiously separated data
ff = waitbar(0, 'Cycling through files.');
for j = 1:length(in.s)

     waitbar(j/length(iFiles), ff, 'Working on it...', 'modal');
    
  %load in raw data  
    load(iFiles(j).name, 'data');
  %filter data
    e1 = filtfilt(h,g,data(:,1));
    e2 = filtfilt(h,g,data(:,2));
  %fft to get frequency ranges
    f1 = fftmachine(filtfilt(h,g,data(:,1)), Fs);
    f2 = fftmachine(filtfilt(h,g,data(:,2)), Fs);

  %use frequencies of each fish to define new frequency ranges for obw
    midpoint = in.s(j).lofreq + ((in.s(j).hifreq - in.s(j).lofreq)/2);

  %perform obw on both fish
    %low frequency fish
    if in.s(j).lotube == 1
        lowfreqidx = find(f1.fftfreq > freqs(1) & f1.fftfreq < midpoint);
        [out(j).lobw, out(j).loflo, out(j).lofhi, out(j).loAmpobw] = obw(e1(lowfreqidx), Fs, [freqs(1) midpoint]);
    end

    if in.s(j).lotube == 2
        lowfreqidx = find(f2.fftfreq > freqs(1) & f2.fftfreq < midpoint);
        [out(j).lobw, out(j).loflo, out(j).lofhi, out(j).loAmpobw] = obw(e2(lowfreqidx), Fs, [freqs(1) midpoint]);
    end

    %high frequency fish
    if in.s(j).hitube == 1
        hifreqidx = find(f1.fftfreq > midpoint & f1.fftfreq < freqs(2));
        [out(j).hibw, out(j).hiflo, out(j).hifhi, out(j).hiAmpobw] = obw(e1(hifreqidx), Fs, [midpoint freqs(2)]);
    end

    if in.s(j).hitube == 2
        hifreqidx = find(f2.fftfreq > midpoint & f2.fftfreq < freqs(2));
        [out(j).hibw, out(j).hiflo, out(j).hifhi, out(j).hiAmpobw] = obw(e2(hifreqidx), Fs, [midpoint freqs(2)]);
    end

end
pause(1); close(ff);
%%
    figure(65); clf; hold on;
    
       ax(1)
        plot([in.s([in.s.lotube]==1).timcont]/3600, [out([in.s.lotube]==1).loAmpobw], 'b.');
        plot([in.s([in.s.lotube]==2).timcont]/3600, [out([in.s.lotube]==2).loAmpobw], 'c.');
        plot([in.s([in.s.hitube]==1).timcont]/3600, [out([in.s.hitube]==1).hiAmpobw], 'r.');
        plot([in.s([in.s.hitube]==2).timcont]/3600, [out([in.s.hitube]==2).hiAmpobw], 'm.');
    