%function out = KseparationNoxious(userfilespec)
%% Prep
    Fs = 40000; %sample rate
    freqs = [275 550]; %freq range of typical eigen EOD
    userfilespec = 'Eigen*'; %file names
    numstart = 23; %1st position in file name of time stamp
    
    %day count starts at 0
    daycount = 0;
    
    %Initialize nonelectrode data channels
    tempchan = 3; 
    lightchan = 4; 

% Get the list of files to be analyzed  
    iFiles = dir(userfilespec);

% Band pass filter in frequency range of fish
    [h,g] = butter(5, [freqs(1)/(Fs/2) freqs(2)/(Fs/2)]);

%% Load data
      
% Load the first file
    load(iFiles(1).name, 'data', 'tim');

%% Filter  (Not necessary under this new mthod)      
          
% Filter data  
     
        data1 = filtfilt(h,g, data(:,1)); % Band pass filter   
        data2 = filtfilt(h,g, data(:,2)); % Band pass filter  

%% Separation is the key

%what is the initial frequency of both fish?
figure(1); clf; 
    subplot(121); tmp = fftmachine(data1, Fs); plot(tmp.fftfreq, tmp.fftdata); xlim([freqs(1) freqs(2)]);
    subplot(122); tmp = fftmachine(data2, Fs); plot(tmp.fftfreq, tmp.fftdata); xlim([freqs(1) freqs(2)]);

figure(2); clf;
    subplot(211); specgram(data1,1024*16, Fs, [], ceil(1024*16*0.95)); ylim([freqs(1) freqs(2)]); caxis([15 50])
    subplot(212); specgram(data2,1024*16, Fs, [], ceil(1024*16*0.95)); ylim([freqs(1) freqs(2)]); caxis([15 50])
    colormap('HOT');     

%click between the two frequency peaks
figure(3); clf; hold on;
    tmp = fftmachine([data1 data2], Fs);
    plot(tmp.fftfreq, tmp.fftdata); xlim([freqs(1) freqs(2)]);
    drawnow; pause(1);
    [xfreq, ~] = ginput(1);
    
%calculate each peak and plot to check
    %lower freq peak
        lowfreqidx = find(tmp.fftfreq > freqs(1) & tmp.fftfreq < xfreq);
            [~, maxidx] = max(tmp.fftdata(lowfreqidx));
            currlofreq = tmp.fftfreq(lowfreqidx(maxidx));
            plot(currlofreq, tmp.fftdata(lowfreqidx(maxidx)), 'c.', 'MarkerSize', 10);

    %higher freq peak
        hifreqidx = find(tmp.fftfreq > xfreq & tmp.fftfreq < freqs(2));
            [~, maxidx] = max(tmp.fftdata(hifreqidx));
            currhifreq = tmp.fftfreq(hifreqidx(maxidx));        
            plot(currhifreq, tmp.fftdata(hifreqidx(maxidx)), 'm.', 'MarkerSize', 10);


out(1).hifreq = currhifreq;     
out(1).lofreq = currlofreq;    

%midpoint is a check. lo freq can't equal hi freq
midpoint = currlofreq + ((currhifreq - currlofreq)/2);
rango = abs(currhifreq - currlofreq)+5; % Freq range in Hz for change in fish freq 

% Electrode 1
    tmp = fftmachine(data1, Fs);
        [out(1).e1hiamp, ~] = max(tmp.fftdata(tmp.fftfreq > currhifreq-rango & tmp.fftfreq < currhifreq+rango));
        [out(1).e1loamp, ~] = max(tmp.fftdata(tmp.fftfreq > currlofreq-rango & tmp.fftfreq < currlofreq+rango));
% Electrode 2
    tmp = fftmachine(data2, Fs);
        [out(1).e2hiamp, ~] = max(tmp.fftdata(tmp.fftfreq > currhifreq-rango & tmp.fftfreq < currhifreq+rango));
        [out(1).e2loamp, ~] = max(tmp.fftdata(tmp.fftfreq > currlofreq-rango & tmp.fftfreq < currlofreq+rango));
        
        
%define time for j = 1
 % Add time stamps (in seconds) relative to computer midnight (COMES FROM THE FILENAME)
    hour = str2double(iFiles(1).name(numstart:numstart+1)); %numstart based on time stamp text location
    minute = str2double(iFiles(1).name(numstart+3:numstart+4));
    second = str2double(iFiles(1).name(numstart+6:numstart+7));
    
% There are 86400 seconds in a day.
    out(1).timcont = (hour*60*60) + (minute*60) + second + (daycount*86400);
    out(1).tim24 = (hour*60*60) + (minute*60) + second;
    
%light and temp for j = 1
    out(1).temp = mean(data(1,tempchan));
    out(1).light = mean(data(1,lightchan));
%% Loop through the rest of the datums

for j=2:length(iFiles)
    
    % Load current file
    load(iFiles(j).name, 'data', 'tim');
    % Filter current data
    data1 = filtfilt(h,g, data(:,1)); % Band pass filter   
    data2 = filtfilt(h,g, data(:,2)); % Band pass filter  
    
    % Add time stamps (in seconds) relative to computer midnight (COMES FROM THE FILENAME)
    hour = str2double(iFiles(j).name(numstart:numstart+1)); %numstart based on time stamp text location
    minute = str2double(iFiles(j).name(numstart+3:numstart+4));
    second = str2double(iFiles(j).name(numstart+6:numstart+7));
                
        if j > 2 && ((hour*60*60) + (minute*60) + second) < out(j-1).tim24
               daycount = daycount + 1;
        end
    

    %if the latest midpoint is somewhere weird, it is wrong and don't use it
    oldmidpoint = midpoint;
    midpoint = currlofreq + ((currhifreq - currlofreq)/2);
    if abs(oldmidpoint - midpoint) > 10
        midpoint = oldmidpoint;
    end
    
% Electrode 1
    tmp1 = fftmachine(data1, Fs);
        tmpidx1h = find(tmp1.fftfreq > midpoint & tmp1.fftfreq < midpoint+rango);
        [out(j).e1hiamp, hifreq1idx] = max(tmp1.fftdata(tmpidx1h));
        tmpidx1l = find(tmp1.fftfreq > midpoint-rango & tmp1.fftfreq < midpoint);
        [out(j).e1loamp, lofreq1idx] = max(tmp1.fftdata(tmpidx1l));
        
        tmphifreq1 = tmp1.fftfreq(tmpidx1h(hifreq1idx));
        tmplofreq1 = tmp1.fftfreq(tmpidx1l(lofreq1idx));
        
% Electrode 2
    tmp2 = fftmachine(data2, Fs);
        tmpidx2h = find(tmp2.fftfreq > midpoint & tmp2.fftfreq < midpoint+rango);
        [out(j).e2hiamp, hifreq2idx] = max(tmp2.fftdata(tmpidx2h));
        tmpidx2l = find(tmp2.fftfreq > midpoint-rango & tmp2.fftfreq < midpoint);
        [out(j).e2loamp, lofreq2idx] = max(tmp2.fftdata(tmpidx2l));
    
        tmphifreq2 = tmp2.fftfreq(tmpidx2h(hifreq2idx));
        tmplofreq2 = tmp2.fftfreq(tmpidx2l(lofreq2idx));

% Set current frequencies

        currhifreq = mean([tmphifreq1 tmphifreq2]);        
        currlofreq = mean([tmplofreq1 tmplofreq2]);        
        
         figure(101); clf;
            subplot(121); hold on; plot(tmp1.fftfreq, tmp1.fftdata); xlim(freqs); ylim([0 1]);
                plot(currhifreq, out(j).e1hiamp, 'or'); plot(currlofreq, out(j).e1loamp, 'om'); 
            subplot(122); hold on; plot(tmp2.fftfreq, tmp2.fftdata); xlim(freqs); ylim([0 1]);
                plot(currhifreq, out(j).e2hiamp, 'or'); plot(currlofreq, out(j).e2loamp, 'om'); 
         
        
   %save frequencies  
    out(j).hifreq = currhifreq;     
    out(j).lofreq = currlofreq;    
    
   %save time 
    % There are 86400 seconds in a day.
    out(j).timcont = (hour*60*60) + (minute*60) + second + (daycount*86400);
    out(j).tim24 = (hour*60*60) + (minute*60) + second;
    
   %save light and temp
   out(j).light = mean(data(:,lightchan));
   out(j).temp = mean(data(:,tempchan));
       
end
        

%frequency
figure(4);clf;hold on; 
        plot([out.hifreq]); plot([out.lofreq]);

%amplitude by frequency
    %loamp is lowfreq fish, name not releated to amp
% figure(5); clf;%by fish
%     subplot(211); hold on; %fish one - higher freq
%         plot([out.e1hiamp], 'b'); plot([out.e2hiamp], 'r');
%     subplot(212); hold on; %fish two - lower freq
%         plot([out.e1loamp], 'b'); plot([out.e2loamp], 'r');
%% plot

figure(25); clf; %by tube - color is always the same fish
    axs(1) = subplot(411); title('Tube 1'); hold on; %fish one - higher freq
        plot([out.timcont], [out.e1hiamp], 'b.', 'MarkerSize', 10); plot([out.timcont], [out.e1loamp], 'r.', 'MarkerSize', 10);
    axs(2)= subplot(412); title('Tube 2'); hold on; %fish two - lower freq
        plot([out.timcont], [out.e2hiamp], 'b.', 'MarkerSize', 10); plot([out.timcont], [out.e2loamp], 'r.', 'MarkerSize', 10);   
    axs(3)= subplot(413); title('t2/t1'); hold on;
        plot([out.timcont], [out.e2loamp] ./ [out.e1loamp], 'mo')
        plot([out.timcont], [out.e2hiamp] ./ [out.e1hiamp], 'co')
        plot([out(1).timcont out(end).timcont], [2.5 2.5], 'k')
        
        intube2hi = find([out.e2hiamp] ./ [out.e1hiamp] > 2.5);
        intube2lo = find([out.e2loamp] ./ [out.e1loamp] > 2.5);
        plot([out(intube2hi).timcont], [out(intube2hi).e2hiamp] ./ [out(intube2hi).e1hiamp], 'b.');
        plot([out(intube2lo).timcont], [out(intube2lo).e2loamp] ./ [out(intube2lo).e1loamp], 'r.');

    axs(4)= subplot(414); title('t1/t2'); hold on;
        plot([out.timcont], [out.e1loamp] ./ [out.e2loamp], 'mo')
        plot([out.timcont], [out.e1hiamp] ./ [out.e2hiamp], 'co')
        plot([out(1).timcont out(end).timcont], [2.5 2.5], 'k')
        
        intube1hi = find([out.e1hiamp] ./ [out.e2hiamp] > 2.5);
        intube1lo = find([out.e1loamp] ./ [out.e2loamp] > 2.5);
        plot([out(intube1hi).timcont], [out(intube1hi).e1hiamp] ./ [out(intube1hi).e2hiamp], 'b.');
        plot([out(intube1lo).timcont], [out(intube1lo).e1loamp] ./ [out(intube1lo).e2loamp], 'r.');
    
        legend('High frequency fish', 'Low frequency fish');
  
linkaxes(axs, 'x');      

%% Amplitude ratio

% find "definitely in the tube" moments from the data



% % E1 threshold.
% fprintf("Click threshold in top panel (tube 1).\n");
%     [~, yy] = ginput(1);
% 
%     hh1IDX = find([out.e1hiamp] > yy);
%     hl1IDX = find([out.e1loamp] > yy);
%     
% fprintf("Found %i HI fish and %i LO fish above threshold in tube 1.\n", length(hh1IDX), length(hl1IDX));
% 
% % E2 threshold.
% fprintf("Click threshold in bottom panel (tube 2).\n");
%     [~, yy] = ginput(1);
% 
%     hh2IDX = find([out.e2hiamp] > yy);
%     hl2IDX = find([out.e2loamp] > yy);
%     
% fprintf("Found %i HI fish and %i LO fish above threshold in tube 2.\n", length(hh2IDX), length(hl2IDX));
% 
% %check to make sure data is from only one tube
% hhshared = intersect(hh1IDX, hh2IDX);
% hhshared
% hlshared = intersect(hl1IDX, hl2IDX);
% hlshared

   

% fprintf("Click a region where one fish one fish.\n");
%     [xx, ~] = ginput(2);
% 
%     xxx = floor(xx(1)):ceil(xx(2));
%     
%     % Which tube is the high fish occupying
%         if mean([out(xxx).e2hiamp]) > mean([out(xxx).e1hiamp])
%            hifish = 2;
%            HIratio = mean([out(xxx).e1hiamp] ./ [out(xxx).e2hiamp]);
%         else
%            hifish = 1;
%            HIratio = mean([out(xxx).e2hiamp] ./ [out(xxx).e1hiamp]);
%         end
% 
%     % Which tube is the low fish occupying
%         if mean([out(xxx).e2loamp]) > mean([out(xxx).e1loamp])
%            lofish = 2;
%            LOratio = mean([out(xxx).e1loamp] ./ [out(xxx).e2loamp]);
%         else
%            lofish = 1;
%            LOratio = mean([out(xxx).e2loamp] ./ [out(xxx).e1loamp]);
%         end

        %thresholding
        
%% Assign amplitude data to fish

figure(987); clf; hold on;
    %Indicies when each fish was in each tube
        %when each fish was in tube 2
        intube2hi = find([out.e2hiamp] ./ [out.e1hiamp] > 2.5);
            plot([out(intube2hi).timcont], [out(intube2hi).e2hiamp], 'b.');
        intube2lo = find([out.e2loamp] ./ [out.e1loamp] > 2.5);
            plot([out(intube2lo).timcont], [out(intube2lo).e2loamp], 'm.');

        %when each fish was in tube 2
        intube1hi = find([out.e1hiamp] ./ [out.e2hiamp] > 2.5);
             plot([out(intube1hi).timcont], [out(intube1hi).e1hiamp], 'bo');
       intube1lo = find([out.e1loamp] ./ [out.e2loamp] > 2.5);
            plot([out(intube1lo).timcont], [out(intube1lo).e1loamp], 'mo');
        
    %Data over indicies for each fish
        %high freq fish amp
        [Hisortidx, ~] = sort([intube2hi intube1hi]);
        %intubeHi = [out(intube2hi).e2hiamp, out(intube1hi).e1hiamp];
         intubeHi = [out.e2hiamp, out.e1hiamp];
        
        for j = 1:length(Hisortidx)
            out(j).Hiobw(:) = intubeHi(Hisortidx(j));
            out(j).Hitimobw(:) = [out(Hisortidx(j)).timcont]/(60*60);
            out(j).HIfreq(:) = [out(Hisortidx(j)).hifreq];
        end
        
        %low freq fish amp
        [Losortidx, ~] = sort([intube2lo intube1lo]);
        intubeLo = [out(intube2lo).e2loamp, out(intube1lo).e1loamp];
        Loobw = intubeLo(Losortidx); 
        
        for j = 1:length(intubeLo)
            out(j).Loobw(:) = intubeLo(Losortidx(j));
            out(j).Lotimobw(:) = [out(Losortidx(j)).timcont]/(60*60);
            out(j).LOfreq(:) = [out(Losortidx(j)).lofreq];
        end
        
        
        
        
   
        %eric this doesn't work...
%         [out.HItimidx, Hisortidx] = sort([intube2hi intube1hi]);
%         intubeHi = [out(intube2hi).e2hiamp, out(intube1hi).e1hiamp];
%         
%         for j = 1:length(intubeHi)
%             out(Hisortidx(j)).Hiobw = intubeHi(j);
%             out(HItimidx(j)).HItimidx = 
%         end
%         
%         %low freq fish amp
%         [out.LOtimidx, Losortidx] = sort([intube2lo intube1lo]);
%         intubeLo = [out(intube2lo).e2loamp, out(intube1lo).e1loamp];
%        
%         for j = 1:length(intubeLo)
%             out(Losortidx(j)).Loobw = intubeLo(j);
%         end
    
        
    
        
%% Plot fish against light/temp


figure(1); clf; 

    
    assx(1) = subplot(411); hold on; 
        plot([out(Hisortidx).timcont]/(60*60), [out.Hiobw], '.');
        plot([out(Losortidx).timcont]/(60*60), [out.Loobw], '.');

        legend('High frequency fish', 'Low frequency fish');
        
    assx(2) = subplot(412); hold on;
        plot([out.Hitimobw], [out.HIfreq], '.'); 
        plot([out.Lotimobw], [out.LOfreq], '.');
        
    
    assx(3) = subplot(413); hold on; 
            plot([out.timcont]/(60*60), [out.temp], '.');
    
    assx(4) = subplot(414); hold on;
        plot([out.timcont]/(60*60), [out.light]);
        ylim([-1, 6]);
        
linkaxes(assx, 'x');

