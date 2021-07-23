%function out = KseparationAnxiety(userfilespec)
%% Load data
Fs = 40000;
% userfilespec = 'Eigen*';
% Get the list of files to be analyzed  
    iFiles = dir(userfilespec);
      
% load the first file
    load(iFiles(1).name, 'data', 'tim');

%% Filter        
% Set up filter
  
    % Band pass filter in frequency range of fish
        [h,g] = butter(5, [300/(Fs/2) 600/(Fs/2)]);


        
% Filter data  
     
        filtdata1 = filtfilt(h,g, data(:,1)); % Band pass filter   
        filtdata2 = filtfilt(h,g, data(:,2)); % Band pass filter  

% Find the normalized peaks of the FFT of each tube in freq range
    %FFT
    onefft = fftmachine(filtdata1, Fs);
    twofft = fftmachine(filtdata2, Fs);
    
    nonefft = onefft.fftdata/ max(onefft.fftdata);
    ntwofft = twofft.fftdata/ max(twofft.fftdata);
    
    %plot to check
    clf; plot(onefft.fftfreq, nonefft); hold on; plot(twofft.fftfreq, ntwofft); xlim([300 600]);    
    
% Calculate peak freqs
    pkfreq1 = onefft.fftfreq(nonefft == max(nonefft));
    pkfreq2 = twofft.fftfreq(ntwofft == max(ntwofft));

% are they the same or different?

if abs(pkfreq1 - pkfreq2) < 1
    fprintf('We need to do something about this because they are the same freq');
else
    dFraw = abs(pkfreq1 - pkfreq2);
end
    

%% AM analysis (Check to see if dF on both tubes is the same)
% take the freqeuncy of the AM (findpeaks)

    rFs = 400;
    resamptim = 1/rFs:1/rFs:1;

    oneAM = k_AM(filtdata1, tim, rFs);
    twoAM = k_AM(filtdata2, tim, rFs);
    
    % See if dF is same on both channels (dF being freq of AM)
    
    onePeakAMf = oneAM.fftfreq(oneAM.fftdata(oneAM.fftfreq > 2) == max(oneAM.fftdata(oneAM.fftfreq > 2)));
    twoPeakAMf = twoAM.fftfreq(twoAM.fftdata(twoAM.fftfreq > 2) == max(twoAM.fftdata(twoAM.fftfreq > 2)));
    
    figure(27); clf; hold on;
        plot(oneAM.fftfreq, oneAM.fftdata);
        plot(twoAM.fftfreq, twoAM.fftdata);
    xlim([0 100]);
    
    if abs(onePeakAMf - twoPeakAMf) < 1 % The AMs are within 1 Hz
        fprintf('Woohoo for tubes!\n');
        dFam = mean([onePeakAMf, twoPeakAMf]);
    else
        fprintf('onePeakAMf is %2.2f and twoPeakAMf is %2.2f.\n', onePeakAMf, twoPeakAMf);
        dFam = 100000;
    end
    
    % Difference in peaks between tubes should equal the dF. 
    if pkfreq1 == pkfreq2
        fprintf('Poo on you fish two\n');
    else 
        dFreq = abs(pkfreq1 - pkfreq2);
    end
    
    % Test if dFraw and dFam are the same
    
    if abs(dFraw - dFam) < 1
        fprintf('This data and analysis is probably fabulous.\n');
    else
        fprintf('dFraw is %2.2f and dFam is %2.2f.\n', dFraw, dFam);
    end
    
    
%     if dFreq == oneAM.fftfreq
%         fprintf('Yay we did not fuck up!\n');
%     end
        
    
    
% AND perhaps we can find the frequency of the weaker fish using dF
        
    % If both same freq, take maximum amplitude.
    % If different freqs and dF matches, the take both amplitudes.

% ff = waitbar(0, 'Starting the painful process...');
% pause(2);
% 
% for k = 1:length(iFiles)
%        
%      waitbar(k/length(iFiles), ff, 'Assembling', 'modal');
% 
%     
%        % LOAD THE DATA FILE
%         load(iFiles(k).name, 'data');
%                       
%         [tube1f(k,:), tube1a(k,:), tube2f(k,:), tube2a(k,:)] = getfreqs(data(:,1)-mean(data(:,1)), data(:,2)-mean(data(:,2)), sepfreq);
%          
%          % sepfreq = ((abs(tube1f(k,1) - tube2f(k,1)))/2) + min([tube1f(k,1), tube2f(k,1)]);
%          
%  
%              
% end
% 
% out.tube1f = tube1f;
% out.tube1a = tube1a;
% out.tube2f = tube2f;
% out.tube2a = tube2a; 
% 
% %% Plot the frequencies over time
% 
% figure(2); clf; 
% 
%     ax(1) = subplot(211); plot(out.tube1f(:,1), '.'); hold on; plot(out.tube1f(:,2), '.');
%     ax(2) = subplot(212); plot(out.tube2f(:,1), '.'); hold on; plot(out.tube2f(:,2), '.');
% 
%     linkaxes(ax, 'x');
% 
% %%    
% close(ff); % get rid of the counter thingy
% 
% end
% 
%     
%     
%     function [t1f,t1a,t2f,t2a] = getfreqs(t1data, t2data, previousfreaky)       
%         %Assign frequencies to tubles 
% 
%         wid = 40; % +/- this number of Hz for filter
%         Fs = 40000;
%         
%         [b,a] = butter(3, [(previousfreaky(1)-wid)/(Fs/2) (previousfreaky(1)+wid)/(Fs/2)], 'bandpass');
%         [d,c] = butter(3, [(previousfreaky(2)-wid)/(Fs/2) (previousfreaky(2)+wid)/(Fs/2)], 'bandpass');
%         
%         
%         
%        % Tube 1
%        
%         t1fl = filtfilt(b,a,t1data);       
%         t1 = fftmachine(t1fl, 40000, 9);
%         
%         lfreqs = find(t1.fftfreq > previousfreaky(1)-wid & t1.fftfreq < previousfreaky(1)+wid);
%             [pwrA1l, idx] = max(t1.fftdata(lfreqs));
%             pwrF1l = t1.fftfreq(lfreqs(idx));
% 
%         t1fh = filtfilt(d,c,t1data);
%         t1 = fftmachine(t1fh, 40000, 9);
%         
%         hfreqs = find(t1.fftfreq > previousfreaky(2)-wid & t1.fftfreq < previousfreaky(2)+wid);
%             [pwrA1h, idx] = max(t1.fftdata(hfreqs));
%             pwrF1h = t1.fftfreq(hfreqs(idx));
% 
%        % Which amplitude is higher and what is the ratio of power?
%         if pwrA1h > pwrA1l
%             pwr1A = [pwrA1h pwrA1l]; pwr1F = [pwrF1h pwrF1l];
%             ratio1 = pwrA1h / pwrA1l;
%         else
%             pwr1A = [pwrA1l pwrA1h]; pwr1F = [pwrF1l pwrF1h];
%             ratio1 = pwrA1l / pwrA1h;
%         end
% 
%         % Tube 2
%         t2fl = filtfilt(b,a,t2data);       
%         t2 = fftmachine(t2fl, 40000, 9);
%         
%         lfreqs = find(t2.fftfreq < previousfreaky(1)-wid & t2.fftfreq < previousfreaky(1)+wid);
%             [pwrA2l, idx] = max(t2.fftdata(lfreqs));
%             pwrF2l = t2.fftfreq(lfreqs(idx));
% 
%         t2hl = filtfilt(d,c,t2data);       
%         t2 = fftmachine(t2hl, 40000, 9);
%         
%         hfreqs = find(t2.fftfreq > previousfreaky(2)-wid & t2.fftfreq < previousfreaky(2)+wid);
%             [pwrA2h, idx] = max(t2.fftdata(hfreqs));
%             pwrF2h = t2.fftfreq(hfreqs(idx));
% 
%        % Which amplitude is higher and what is the ratio of power?
%         if pwrA2h > pwrA2l
%             pwr2A = [pwrA2h pwrA2l]; pwr2F = [pwrF2h pwrF2l];
%             ratio2 = pwrA2h / pwrA2l;
%         else
%             pwr2A = [pwrA2l pwrA2h]; pwr2F = [pwrF2l pwrF2h];
%             ratio2 = pwrA2l / pwrA2h;
%         end
% 
%         if pwr2F(1) == pwr1F(1)
%          
%             if ratio1 > ratio2
%                 
%                 pwr2A = [pwr2A(2) pwr2A(1)];
%                 pwr2F = [pwr2F(2) pwr2F(1)];
%                 
%             end
%             
%             if ratio2 > ratio1
%                 
%                 pwr1A = [pwr1A(2) pwr1A(1)];
%                 pwr1F = [pwr1F(2) pwr1F(1)];
%                 
%             end
% 
%         end
%         
%         t1f = pwr1F; t1a = pwr1A;
%         t2f = pwr2F; t2a = pwr2A;
%         
%         
%     end
%     
