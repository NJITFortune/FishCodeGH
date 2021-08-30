%function out = KseparationNoxious(userfilespec)
%% Prep
    Fs = 40000; %sample rate
    freqs = [350 550]; %freq range of typical eigen EOD
    userfilespec = 'Eigen12LDB-07-30*'; %file names
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
            subplot(122); hold on; plot(tmp2.fftfreq, tmp2.fftdata); xlim(freqs); ylim([0 1]);
         
        
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
        
figure(25); clf; %by tube - color is always the same fish
    axs(1) = subplot(211); title('Tube 1'); hold on; %fish one - higher freq
        plot([out.e1hiamp], 'b'); plot([out.e1loamp], 'r');
    axs(2)= subplot(212); title('Tube 2'); hold on; %fish two - lower freq
        plot([out.e2hiamp], 'b'); plot([out.e2loamp], 'r');   
        
        
        legend('High frequency fish', 'Low frequency fish');
  
linkaxes(axs, 'x');      

%% set boundaries

%get boundaries by clicking on graph?
xlines = ginput(100); %clicking enter ends after the number of clicks you want

 %plot boundaries to check
 
figure(25); hold on;
    axs(1) = subplot(211); hold on;
        plot(xlines, [0, max([out.e1loamp])], 'k-'); 
    





 %% extract amplitude data for each tube
% 
% %amplitude by frequency
%     %loamp is lowfreq fish, name not releated to amp
% 
% %by tube
% %electrode 1
%     e1hi = [out([out.e1hiamp] > [out.e1loamp]).e1hiamp];
%     e1lo = [out([out.e1loamp] > [out.e1hiamp]).e1loamp];
%     
%     length(e1hi)
%     length(e1lo)
%     
%     if length(e1hi) > length(e1lo)
%         e1tubeamp = e1hi;
%     else
%         e1tubeamp = e1lo;
%     end
% 
% %%
%     
% %amplitude by frequency
%     %loamp is lowfreq fish, name not releated to amp
% 
% %by tube
% %electrode 2
%     e2hi = [out([out.e2hiamp] > [out.e2loamp]).e2hiamp];
%     e2lo = [out([out.e2loamp] > [out.e2hiamp]).e2loamp];
%     
%     length(e2hi)
%     length(e2lo)
%     
%     if length(e2hi) > length(e2lo)
%         e2tubeamp = e2hi;
%     else
%         e2tubeamp = e2lo;
%     end    
%     
% %%    
%         
% %High freq fish
%     hifish1 = [out.e1hiamp] > [out.e2hiamp];
%     hifish1 = [out(hifish1).e1hiamp];
%     hifish2 = [out.e2hiamp] > [out.e1hiamp];
%     hifish2 = [out(hifish2).e2hiamp];
%     
%     length(hifish1)
%     length(hifish2)
%     
%     if length(hifish1) > length(hifish2)
%         e1fishamp = hifish1;
%     else
%         e2fishamp = hifish2;
%     end
%     
% %Low freq fish
%     lofish1 = [out.e1loamp] > [out.e2loamp];
%     lofish1 = [out(lofish1).e1loamp];
%     lofish2 = [out.e2loamp] > [out.e1loamp];
%     lofish2 = [out(lofish2).e2loamp];
%    
%     length(lofish1)
%     length(lofish2)
%     
%     if length(lofish1) > length(lofish2)
%         e1fishamp = lofish1;
%     else
%         e2fishamp = lofish2;
%     end
%  
%     
% %%    
%     
%     
%     
%     
%    e1tim = [out(e1amp).timcont];
%    e2tim = [out(e2amp).timcont];
%     
% %Make sure its not wonky
% figure(7); clf; title('High freq fish')
%     subplot(411); hold on; %fish one - higher freq
%         plot([out.timcont],[out.e1hiamp], 'b.'); plot([out.timcont],[out.e2hiamp], 'r.');
%         %plot([out.timcont], movmean([out.e1hiamp], 5), 'b-');
%     subplot(412); hold on;
%         plot(e1tim, e1amp); 
%     subplot(413); hold on; %fish two - lower freq
%         plot([out.timcont],[out.e1loamp], 'b.'); plot([out.timcont],[out.e2loamp], 'r.');  
%     subplot(414); hold on;
%         plot(e2tim, e2amp); 
%         
%     
%         
% 
%         
