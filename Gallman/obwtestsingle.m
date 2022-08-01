%function out  = KatieAssembler(userfilespec, numstart)
% This function reads the original data collection files
% It filters the data and saves it into a single structure
% Performs these analyses: OBW, zAMP
% Relies on k_zAmp, k_FindMaxWindow, k_fft
%
% Usage: kg(#).e = KatieAssembler(userfilespec, Fs, numstart)
%
clearvars -except kg kg2 rkg out
userfilespec = 'Eigen*';
numstart = 23;
% This should not change, but if for some reason...
tempchan = 3; % Either 4 or 3
lightchan = 4; % Either 5 or 4

daycount = 0;


%% SET UP 
% Get the list of files to be analyzed  
        iFiles = dir(userfilespec);
        datasubset = 6638:8170;
        %iFiles = iFiles(datasubset);
            % Get sample frequency
            load(iFiles(1).name, 'tim');
            Fs = 1 / (tim(2) - tim(1));
            clear tim
               
% Set up filters
        % High pass filter cutoff frequency
            highp = 100; %200 %k = 9 800-1200
            [b,a] = butter(5, highp/(Fs/2), 'high'); % Filter to eliminate 60Hz contamination
        % Low pass filter cutoff frequency
            lowp = 1200;    %1500
            [f,e] = butter(5, lowp/(Fs/2), 'low'); % Filter to eliminate high frequency contamination
                    
% How much of the sample that we will use (each sample is 1 second)  
% This is important because the fish moves
        SampleWindw = 0.25; % 250 ms window
        %SampleWindw = 0.01;
% Fish limit frequencies for OBW calculation (unlikely to be changed)
        topFreqOBW = 700;%800
        botFreqOBW = 200;

tout(1).s(length(iFiles)).Fs = Fs;
tout(1).s(length(iFiles)).name = [];
        
    
%% CYCLE THROUGH EVERY FILE IN DIRECTORY

    ff = waitbar(0, 'Cycling through files.');
 
 datasubset = [6950 7100];   
 %figure(27); clf; hold on;
figure(25); clf ; hold on;
for kk = datasubset
 % figure(kk);clf; hold on;  
     waitbar(kk/length(iFiles), ff, 'Assembling', 'modal');

    
       % LOAD THE DATA FILE
        load(iFiles(kk).name, 'data', 'tim');
      
        
       % Filter data  
          
            data(:,1) = filtfilt(b,a, data(:,1)); % High pass filter
           % data(:,1) = filtfilt(f,e, data(:,1)); % Low pass filter   
            
            data(:,2) = filtfilt(b,a, data(:,2)); % High pass filter
          %  data(:,2) = filtfilt(f,e, data(:,2)); % Low pass filter   
% 
        % Add time stamps (in seconds) relative to computer midnight (COMES FROM THE FILENAME)
 
                hour = str2double(iFiles(kk).name(numstart:numstart+1));        %numstart based on time stamp text location
                minute = str2double(iFiles(kk).name(numstart+3:numstart+4));
                second = str2double(iFiles(kk).name(numstart+6:numstart+7));
%                 
%             if kk > datasubset(1) && ((hour*60*60) + (minute*60) + second) < out(1).s(kk-1).tim24
%                    daycount = daycount + 1;
%             end
            
       % PICK YOUR WINDOW - THIS IS A CRITICAL STEP THAT MAY NEED REVISION

        for j = 1%orm analyses on the two channels
        
            
            % [~, idx] = max(abs(data(:,j))); % FIND THE MAXIMUM
            [tout(j).s(kk).startim, ~] = k_FindMaxWindow(data(:,j), tim, SampleWindw);

           % if k == 465; out(j).s(k).startim = out(j).s(k).startim + 0.001; end

            data4analysis = (data(tim > tout(j).s(kk).startim & tim < tout(j).s(kk).startim+SampleWindw, j));     
            data4analysis = (data4analysis - mean(data4analysis)); 
           timidx = find(tim > tout(j).s(kk).startim & tim < tout(j).s(kk).startim+SampleWindw);
            nonphasetim = tim(timidx)-tim(timidx(1));  
            %find the first zero crossing
                    z = zeros(1,length(data4analysis)); %create vector length of data
                    z(data4analysis > 0) = 1; %fill with 1s for all filtered data greater than 0
                    z = diff(z); %subtract the X(2) - X(1) to find the positive zero crossings
                    posZs = find(z == 1); 
                    newidx = find(tim >= tim(posZs(1)) & tim <= tim(posZs(end)));

           phaseddata4analysis = data4analysis(newidx);
                    phasetim = tim(newidx)-tim(newidx(1));
%                
% figure(29); clf ;title('raw data'); hold on;
%             
%             ax(1) = subplot(211); title('nonphase'); hold on;
%                 plot( nonphasetim,data4analysis);%xlim([0,250]);
%          
%             ax(2) = subplot(212); title('phase'); hold on;
                 plot(phasetim, phaseddata4analysis/max(phaseddata4analysis)); 

           % data4analysis = (data4analysis - mean(data4analysis));
            % ANALYSES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
%             % OBW
            [tout(j).s(kk).bw,tout(j).s(kk).flo,tout(j).s(kk).fhi,tout(j).s(kk).obwAmp] = obw(data4analysis, Fs, [botFreqOBW topFreqOBW]);
            [tout(j).s(kk).pbw,tout(j).s(kk).pflo,tout(j).s(kk).pfhi,tout(j).s(kk).pobwAmp] = obw(phaseddata4analysis, Fs, [botFreqOBW topFreqOBW]);
%            
%            
%             figure(25); clf ;title('obw-nonphase');hold on;set(gcf,'renderer','Painters'); 
%                 obw(data4analysis, Fs, [botFreqOBW topFreqOBW]);xlim([0,1]);
% 
%             figure(24); clf; title('obw-phase');hold on;set(gcf,'renderer','Painters');
              %  obw(phaseddata4analysis, Fs, [botFreqOBW topFreqOBW]); xlim([0,1]);
% %     

            % zAmp
             tout(j).s(kk).zAmp = k_zAmp(phaseddata4analysis);
            % FFT Machine
            [tout(j).s(kk).fftFreq, tout(j).s(kk).peakfftAmp, tout(j).s(kk).sumfftAmp] = k_fft(data4analysis, Fs); 
             [tout(j).s(kk).pfftFreq, tout(j).s(kk).ppeakfftAmp, tout(j).s(kk).psumfftAmp] = k_fft(phaseddata4analysis, Fs); 
           % obw(data4analysis, Fs, [botFreqOBW topFreqOBW]);

%            if mod(k-1, 50) == 0 && j == 1
%                 %find the first zero crossing
%                     z = zeros(1,length(data4analysis)); %create vector length of data
%                     z(data4analysis > 0) = 1; %fill with 1s for all filtered data greater than 0
%                     z = diff(z); %subtract the X(2) - X(1) to find the positive zero crossings
%                     posZs = find(z == 1); 
%                     newidx = find(tim >= tim(posZs(1)) & tim < tim(posZs(1)) + .02); 
%             
%                 if out(j).s(k).fftFreq > 525
%                ax(1)=subplot(211); title('high freq');hold on;     
%                 plot(tim(newidx)-tim(newidx(1)), data4analysis(newidx));
%                 end
% 
%                 if out(j).s(k).fftFreq < 440
%                ax(2)=subplot(212);title('low freq'); hold on;     
%                 plot(tim(newidx)-tim(newidx(1)), data4analysis(newidx));
%                 end 
%             end
%       
            tout(j).s(kk).light = mean(data(:,lightchan));
            tout(j).s(kk).temp = mean(data(:,tempchan));
    
            
        % There are 86400 seconds in a day.
        tout(j).s(kk).timcont = (hour*60*60) + (minute*60) + second + (daycount*86400) ;
        tout(j).s(kk).tim24 = (hour*60*60) + (minute*60) + second;

        
        end
        
end
%linkaxes(ax, 'xy');
        pause(1); close(ff);
        

 
 %%
%  figure(28);clf; hold on;
%         
%         ax(1) = subplot(511); title('Mean square amplitude'); hold on;
%             plot([out(2).s.timcont]/3600, [out(1).s.pobwAmp], 'o');
%             plot([out(2).s.timcont]/3600, [out(1).s.obwAmp], '.');
%         ax(2) = subplot(512); title('99% occupied bandwidth'); hold on;
%             plot([out(1).s.timcont]/3600, [out(1).s.bw]);
%             plot([out(1).s.timcont]/3600, [out(1).s.pbw]);
%         ax(3) = subplot(513); title('Frequency-nonphase'); hold on;
%             plot([out(1).s.timcont]/3600, [out(1).s.fftFreq]);
%             plot([out(1).s.timcont]/3600, [out(1).s.flo], 'o-');
%             plot([out(1).s.timcont]/3600, [out(1).s.fhi], 'o-');
%          ax(4) = subplot(514); title('Frequency-phase'); hold on;
%             plot([out(1).s.timcont]/3600, [out(1).s.fftFreq]);
%             plot([out(1).s.timcont]/3600, [out(1).s.pflo], 'o-');
%             plot([out(1).s.timcont]/3600, [out(1).s.pfhi], 'o-');
%         ax(5) = subplot(515); title('light'); hold on;ylim([-1, 6]);
%             plot([out(1).s.timcont]/3600, [out(1).s.light]);
%             plot([out(2).s.timcont]/3600, [out(2).s.light]);
%     
%     linkaxes(ax, 'x')
%         
%         
%         
%         
        
         
    