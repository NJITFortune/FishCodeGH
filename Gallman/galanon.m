%% Setup once per Matlab start

    addpath('~/SparkleShare/github.com/FishCodeGH/General')
    addpath('~/SparkleShare/github.com/FishCodeGH')
    % Relies on fftmachine.m, which lives in 

    % cd into the directory where the original files live
    
%% Setup 

iFiles = dir('GallmanImage*.mat');
eFiles = dir('GallmanElectro*.mat');

Fs = 20000; % Sample rate for EOD in Hz
samlen = 10; % Duration of the sample (60 seconds total)

[b,a] = butter(3, 160 / (Fs/2), 'high'); % Highpass filter to remove 60Hz.

if (length(iFiles) / 6) ~= length(eFiles)
    fprintf('Fuck off motherfucker\n');
end

%% Cycle through the files and build the structure "out"

iidx = 0;
eidx = 1;

while eidx <= length(eFiles)

    figure(1); clf; figure(2); clf;
    eval(['load ' eFiles(eidx).name]); % Load the EOD data
    tmpsigA = filtfilt(b,a,EODonly(:,1)); % Filter both channels
    tmpsigB = filtfilt(b,a,EODonly(:,2));
    
    fprintf('Entry %i. \n', eidx); % Tell the user where we are    
    
    for j=1:6 % For each 10 second epoch in the 60 second sample
        figure(1); 
        eval(['load ' iFiles(iidx+j).name]); % Load the image
        subplot(3,2,j); imshow(vData); % Plot the EODonly
        text(100,100, num2str(j), 'Color', 'g', 'FontSize', 24); % Add the label
        figure(2); 
        subplot(3,2,j); hold on;
        tt = find(tim > (j-1)*samlen &  tim <= j*samlen);
        plot(tim(tt(1:4:end)), tmpsigA(tt(1:4:end))+0.5); 
        plot(tim(tt(1:4:end)), tmpsigB(tt(1:4:end))-0.5);
        text(0.5+((j-1)*10), 0, num2str(j), 'Color', 'm', 'FontSize', 24); % Add the label
        ylim([-1.5 1.5]);
    end
   
    drawnow;
    framNo = input('Best Frame? ');
    
    if isempty(framNo)
        
        out(eidx).Ch1 = zeros(1, Fs*10);
        out(eidx).Ch2 = zeros(1, Fs*10);
        
    end
    
    if ~isempty(framNo) % The fish is in the correct position in these frames
                           
        out(eidx).Ch1 = tmpsigA(tim > samlen*(framNo-1) & tim <= samlen*framNo);
        out(eidx).Ch2 = tmpsigB(tim > samlen*(framNo-1) & tim <= samlen*framNo);
            
    end
    
% Light, temp, and time data    
    out(eidx).light = mean(mean(vData(700:800, 500:600)));
    out(eidx).temp = temp;
    out(eidx).time = eFiles(eidx).name;
    
% Advance our counters
    iidx = iidx+6;
    eidx = eidx+1;
    
end

%% Analysis

for j=length(out):-1:1
    
    if sum(out(j).Ch1) ~= 0
        
        sondatCh1 = fftmachine(out(j).Ch1, Fs);
            [famp, fidx] = max(smooth(sondatCh1.fftdata,100));
        fftCh1(j,:) = [famp, sondatCh1.fftfreq(fidx)];
        rmsCh1(j) = rms(out(j).Ch1);
        
        sondatCh2 = fftmachine(out(j).Ch2, Fs);
            [famp, fidx] = max(smooth(sondatCh2.fftdata,100));
        fftCh2(j,:) = [famp, sondatCh2.fftfreq(fidx)];
        rmsCh2(j) = rms(out(j).Ch2);

        lightlevels(j) = out(j).light;
        temps(j) = out(j).temp;
        
        dataidxs(j) = j;
        
    end    
    
    if sum(out(j).Ch1) == 0
        dataidxs(j) = [];
        temps(j) = [];
        lightlevels(j) = [];
        rmsCh1(j) = [];
        rmsCh2(j) = [];
        fftCh1(j,:) = [];
        fftCh2(j,:) = [];
    end
        
end

figure(2); clf; 
    ax(1) = subplot(411); 
        plot(dataidxs, fftCh1(:,1), '.-', 'MarkerSize', 8); title('FFT amplitude');
        hold on; plot(dataidxs, fftCh2(:,1), '.-', 'MarkerSize', 8); 
    ax(2) = subplot(412); 
        plot(dataidxs, rmsCh1, '.-', 'MarkerSize', 8);
        hold on; plot(dataidxs, rmsCh2, '.-', 'MarkerSize', 8); title('RMS amplitude');
    ax(3) = subplot(413); 
        plot(squeeze(dataidxs), squeeze(fftCh1(:,2)), '.-', 'MarkerSize', 8); ylim([200 700]); title('EOD Frequency');
        hold on; plot(dataidxs, fftCh2(:,2), '.-', 'MarkerSize', 8); ylim([300 600]);
    ax(4) = subplot(414); 
        yyaxis left; plot(dataidxs, lightlevels, '.-', 'MarkerSize', 8); ylim([190 250]);
        title('Light level & Temperature');
        yyaxis right; plot(dataidxs, temps, '.-', 'MarkerSize', 8); ylim([0.7 0.9]);
        
    linkaxes(ax, 'x');
    
% figure(2); clf; 
%     ax(1) = subplot(411); plot(lightims, fftamp(:,1), '.-', 'MarkerSize', 8);
%     ax(2) = subplot(412); plot(lightims, rmsamp, '.-', 'MarkerSize', 8)
%     ax(3) = subplot(413); plot(lightims, fftamp(:,2), '.-', 'MarkerSize', 8);
%     ax(4) = subplot(414); plot(lightims, lightlevel, '.-', 'MarkerSize', 8)
%     linkaxes(ax, 'x');

%% Other stuff to do

% freeampEODonly = ampEODonly; freeampEODonly(freeampEODonly > 10) = 0;
% % % hdat = real(hilbert(freeampEODonly));
% hdat = envelope(freeampEODonly, 200, 'peak');
% figure(28); clf; plot(timtim(1:3:end), freeampEODonly(1:3:end), timtim(1:3:end), hdat(1:3:end)); ylim([-0.5 0.5]);
% % tt = find(timtim > 920 & timtim < 930);
% % asdf = fftmachine(hdat(tt(1:10:end)), Fs/10);
% % figure(29); hold on; semilogy(asdf.fftfreq, asdf.fftdata); xlim([0 100]);


%% When you are done...

% save filname.mat