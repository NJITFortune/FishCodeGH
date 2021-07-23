function out = KseparationAnxiety(userfilespec)

Fs = 40000;
% userfilespec = 'Eigen*';
% Get the list of files to be analyzed  
        iFiles = dir(userfilespec);
    % numstart = 23;
    % daycount = 0;


% Set up filters
        % High pass filter cutoff frequency
            highp = 300;
            [b,a] = butter(5, highp/(Fs/2), 'high'); % Filter to eliminate 60Hz contamination
        % Low pass filter cutoff frequency
             lowp = 600;    
             [f,e] = butter(5, lowp/(Fs/2), 'low'); % Filter to eliminate high frequency contamination

        [h,g] = butter(5, [highp/(Fs/2) lowp/(Fs/2)]);
             


% CLICK THE FIRST FILE
    load(iFiles(1).name, 'data');

   % filter the data

%      tube1 = filtfilt(b,a,data(:,1));
%      tube2 = filtfilt(b,a,data(:,2));
%      tube1 = filtfilt(f,e,tube1);
%      tube2 = filtfilt(f,e,tube2);

    tube1 = filtfilt(h,g,data(:,1));
    tube2 = filtfilt(h,g,data(:,2));
         

   % extract the fish frequencies
     t1 = fftmachine(tube1, Fs);
     t2 = fftmachine(tube2, Fs);
     
   % click between the two frequency peaks
    figure(1); clf; 
 
    semilogy(t1.fftfreq, t1.fftdata);
    hold on;
    semilogy(t2.fftfreq, t2.fftdata);
    xlim([200 600]);

    [sepfreq, ~] = ginput(2);

    [tube1f, tube1a, tube2f, tube2a] = getfreqs(t1, t2, sort(sepfreq));
    

ff = waitbar(0, 'Cycling through files.');

for k = 2:length(iFiles)
       
     waitbar(k/length(iFiles), ff, 'Assembling', 'modal');

    
       % LOAD THE DATA FILE
        load(iFiles(k).name, 'data');
        
       %filter the data
        
%          tube1 = filtfilt(b,a,data(:,1));
%          tube2 = filtfilt(b,a,data(:,2));
%          tube1 = filtfilt(f,e,tube1);
%          tube2 = filtfilt(f,e,tube2);
    tube1 = filtfilt(h,g,data(:,1));
    tube2 = filtfilt(h,g,data(:,2));
         
       % extract the fish frequencies
         t1 = fftmachine(tube1, Fs);
         t2 = fftmachine(tube2, Fs);
         
         ttmp(:,1) = sort(tube1f(k-1,:));
         ttmp(:,2) = sort(tube2f(k-1,:));
         sepfreq = mean(ttmp);
         
         [tube1f(k,:), tube1a(k,:), tube2f(k,:), tube2a(k,:)] = getfreqs(t1, t2, sepfreq);
         
         sepfreq = ((abs(tube1f(k,1) - tube2f(k,1)))/2) + min([tube1f(k,1), tube2f(k,1)]);
         
 
             
end

out.tube1f = tube1f;
out.tube1a = tube1a;
out.tube2f = tube2f;
out.tube2a = tube2a; 

%% Plot the frequencies over time

figure(1); clf; 

    ax(1) = subplot(211); plot(out.tube1f(:,1), '.'); hold on; plot(out.tube2f(:,1), '.');
    ax(2) = subplot(212); plot(out.tube1a(:,1), '.'); hold on; plot(out.tube2a(:,1), '.');

    linkaxes(ax, 'x');

    
close(ff); % get rid of the counter thingy

end

    
    
    function [t1f,t1a,t2f,t2a] = getfreqs(t1, t2, previousfreaky)       
        %Assign frequencies to tubles 

        wid = 20; % +/- this number of Hz for peak
        
        % Get low frequency in both channels
        
        
       % Tube 1
        lfreqs = find(t1.fftfreq > previousfreaky(1)-wid & t1.fftfreq < previousfreaky(1)+wid);
            [pwrA1l, idx] = max(t1.fftdata(lfreqs));
            pwrF1l = t1.fftfreq(lfreqs(idx));

        hfreqs = find(t1.fftfreq > previousfreaky(2)-wid & t1.fftfreq < previousfreaky(2)+wid);
            [pwrA1h, idx] = max(t1.fftdata(hfreqs));
            pwrF1h = t1.fftfreq(hfreqs(idx));

       % Which amplitude is higher and what is the ratio of power?
        if pwrA1h > pwrA1l
            pwr1A = [pwrA1h pwrA1l]; pwr1F = [pwrF1h pwrF1l];
            ratio1 = pwrA1h / pwrA1l;
        else
            pwr1A = [pwrA1l pwrA1h]; pwr1F = [pwrF1l pwrF1h];
            ratio1 = pwrA1l / pwrA1h;
        end

        % Tube 2
        lfreqs = find(t2.fftfreq < previousfreaky(1)-wid & t2.fftfreq < previousfreaky(1)+wid);
            [pwrA2l, idx] = max(t2.fftdata(lfreqs));
            pwrF2l = t2.fftfreq(lfreqs(idx));

        hfreqs = find(t2.fftfreq > previousfreaky(2)-wid & t2.fftfreq < previousfreaky(2)+wid);
            [pwrA2h, idx] = max(t2.fftdata(hfreqs));
            pwrF2h = t2.fftfreq(hfreqs(idx));

       % Which amplitude is higher and what is the ratio of power?
        if pwrA2h > pwrA2l
            pwr2A = [pwrA2h pwrA2l]; pwr2F = [pwrF2h pwrF2l];
            ratio2 = pwrA2h / pwrA2l;
        else
            pwr2A = [pwrA2l pwrA2h]; pwr2F = [pwrF2l pwrF2h];
            ratio2 = pwrA2l / pwrA2h;
        end

        if pwr2F(1) == pwr1F(1)
            fprintf('Like what the fuck?\n');
         
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

        end
        
        t1f = pwr1F; t1a = pwr1A;
        t2f = pwr2F; t2a = pwr2A;
        
        
    end
    
