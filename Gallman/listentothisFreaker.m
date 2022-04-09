 function listentothisFreaker(~,evt)
% obj is the DataAcquisition object passed in. evt is not used.

    data = evt.Data;
    tim = evt.TimeStamps;
    
    
    %EOD channels
    EODonly(:,1) = data(:,1);
    EODonly(:,2) = data(:,2);
    EODonly(:,3) = data(:,3);
    %Temp channel
    temp = mean(data(:,4));
    
%% Get frequency of the recording
    [b,a] = butter(5, [250/(40000/2) 650/(40000/2)], 'bandpass');
    dd = filtfilt(b,a,data(:,1));
    ff = fftmachine(dd, 40000);
    
    diff = -5; % # Hz difference from fish's own frequency

    [~, idx] = max(ff.fftdata(ff.fftfreq > 250 & ff.fftfreq < 650));
    oFs = 20000; tim = 1/oFs:1/oFs:60;
    ss = sin(tim*2*pi* ff.fftfreq(idx) + diff);
    audiowrite('playbackwav.wav', ss, oFs);
    
    FileName = sprintf('TESTElectro_%s.mat', datestr(now, 'mm-dd-yyyy_HH-MM-SS'));
    save(FileName, 'EODonly', 'tim', 'temp');

    % plot(tim, data);

    
 end
 