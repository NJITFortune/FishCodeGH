function out = gallmanCompleat(data)

resampFs = 0.00167; % May need to change this
cutfreq =  0.000005787 / 2; % Low pass filter for detrend - need to adjust re resampFs

hashfreq = 0.00027778/2; % Low pass filter

% Fs values
    % 1 minute =  0.0167 Hz
    % 1 hour =    0.00027778 Hz
    % 6 hours =   0.000046296 Hz
    % 12 hours =  0.000023148 Hz
    % 24 hours =  0.000011574 Hz
    % 48 hours =  0.000005787 Hz

% Make the data into sequences instead of structure entries.

    % The data
    timSec = [data.timcont];
    dat1 = [data.Ch1obwAmp];
    dat2 = [data.Ch2obwAmp];
    
    % The lights
    ld = [data.light];
    ldOnOff = diff(ld);    
    OnIDXs = find(ldOnOff > 1); % lights turned on
    OffIDXs = find(ldOnOff < -1); % lights turned on

% Resample the data so that we can use spectral analyses
    
    [dat1r, newtim] = resample(dat1, timSec, resampFs);
    [dat2r, ~] = resample(dat2, timSec, resampFs);
    [ldr, ~] = resample(ld, timSec, resampFs);

   % Filter the data

    [h,g] = butter(5,cutfreq/(resampFs/2),'low');
    [j,i] = butter(5,hashfreq/(resampFs/2),'low');
    
    dat1rlf = filtfilt(h,g,dat1r);
    dat2rlf = filtfilt(h,g,dat2r);

    % Remove the low frequency information
    datrend1 = dat1r-dat1rlf;
    datrend2 = dat2r-dat2rlf;

    % low-pass filter
    datrend1 = filtfilt(j,i,datrend1);
    datrend2 = filtfilt(j,i,datrend2);
    
    
    newtimMin = newtim/60;
    newtimHour = newtimMin/60;
    newtimDay = newtimHour/24;

    
 figure(1); clf;
 
    ax(1) = subplot(511); plot(newtimDay, datrend1, '.-');
    ax(2) = subplot(512); 
        plot(newtimDay, dat1rlf, '.'); 
        hold on; 
        plot(newtimDay, dat1r, '.');
    ax(3) = subplot(513); plot(newtimDay, datrend2, '.-');
    ax(4) = subplot(514); 
        plot(newtimDay, dat2rlf, '.'); 
        hold on; 
        plot(newtimDay, dat2r, '.');
    ax(5) = subplot(515); plot(newtimDay, ldr, '.');
    linkaxes(ax, 'x');
    
    
    
    Ch1 = fftmachine(datrend1*100, resampFs);
    Ch2 = fftmachine(datrend2*100, resampFs);
    ldf = fftmachine(ldr, resampFs);
    
figure(2); clf; 

    xa(1) = subplot(311); plot(Ch1.fftfreq, Ch1.fftdata, '.-');
        hold on; plot([0.000011574 0.000011574], [0 max(Ch1.fftdata)], '-');
    xa(2) = subplot(312); plot(Ch2.fftfreq, Ch2.fftdata, '.-');
        hold on; plot([0.000011574 0.000011574], [0 max(Ch2.fftdata)], '-');
    xa(3) = subplot(313); plot(ldf.fftfreq, ldf.fftdata, '.-');
        hold on; plot([0.000011574 0.000011574], [0 max(ldf.fftdata)], '-');

    linkaxes(xa, 'x');
    xlim([0 0.000046296]);
    
    out = 0;
    
    
    