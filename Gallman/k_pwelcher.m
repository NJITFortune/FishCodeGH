function [freq, pwr] = k_pwelcher(in, ReFs, p, hourperiod, channel)
% GENERATE CUBIC SPLINE FUNCTION FOR DATA
% Usage: channel = 1 or 2

%[xx, yy] = k_cspliner(x, y, p)
% f(x) = csaps(x,y,p); p = 0.9

%% Preparations

%ReFs = 60;  %resample once every minute

% Define variables

    if nargin < 3
        p = 0.9; %smoothing factor
    end

%Accounting for outlier exclusion
   
    % Prepare the data with outliers

        tto{1} = 1:length([in.e(1).s.timcont]); % tto is indices for obwAmp
        tto{2} = tto{1};

        ttz{1} = tto{1}; % ttz is indices for zAmp
        ttz{2} = tto{1};

        ttsf{1} = tto{1}; % ttsf is indices for sumfftAmp
        ttsf{2} = tto{1};


    % Prepare the data without outliers
    
        % If we have removed outliers via KatieRemover, get the indices...    
        if ~isempty(in.idx) 
            tto{1} = in.idx(1).obwidx; tto{2} = in.idx(2).obwidx; % tto is indices for obwAmp
            ttz{1} = in.idx(1).zidx; ttz{2} = in.idx(2).zidx; % ttz is indices for zAmp
            ttsf{1} = in.idx(1).sumfftidx; ttsf{2} = in.idx(2).sumfftidx; % ttsf is indices for sumfftAmp
        end

  
    
    
    %hard coded because fuck thinking
    %OBW
    
    
    %Channel 1
   
    
    %Sample dataset by poweridx 
        %poweridx-window of good data to analyze [start end]  
    
        if isempty(in.info.poweridx) %if there are no values in poweridx []
           obtt = 1:length([in.e(1).s(tto{1}).timcont]/(60*60)); %use the entire data set to perform the analysis
        else %if there are values in poweridx [X1 X2]
            %perform the analysis between the poweridx values
            obtt = find([in.e(1).s(tto{1}).timcont]/(60*60) > in.info.poweridx(1) & [in.e(1).s(tto{1}).timcont]/(60*60) < in.info.poweridx(2));
        end
    
    %create data variables of poweridx 
    obwdata1 = [in.e(1).s(tto{1}(obtt)).obwAmp]; 
    obwtim1 = [in.e(1).s(tto{1}(obtt)).timcont]/(60*60);
    
        %summarize data
            %ppform of cubic smoothing spline
            spliney = csaps(obwtim1, obwdata1, p);
            %fortune doesn't like linspace... I think he does it to confuse me
            o.obw(1).x = obwtim1(1):1/ReFs:obwtim1(end);
            %evaluate the csplined values of y for the new equally spaced values of x
            o.obw(1).y = fnval(o.obw(1).x, spliney);
            o.obw(1).y = o.obw(1).yr - mean(o.obw(1).yr);
            
    %Channel 2
   
    if ~isempty(in.info.poweridx) 
        obt2 = find([in.e(1).s(tto{2}).timcont]/(60*60) > in.info.poweridx(1) & [in.e(1).s(tto{2}).timcont]/(60*60) < in.info.poweridx(2));
    else
        obt2 = 1:length([in.e(1).s(tto{2}).timcont]/(60*60));
    end
            
    obwdata2 = [in.e(2).s(tto{2}(obt2)).obwAmp]; 
    obwtim2 = [in.e(1).s(tto{2}(obt2)).timcont]/(60*60);
            spliney = csaps(obwtim2, obwdata2, p);
            o.obw(2).x = obwtim2(1):1/ReFs:obwtim2(end);
            o.obw(2).y = fnval(o.obw(2).x, spliney);
            
    %ZAMP
    %Channel 1
    
    if ~isempty(in.info.poweridx)
        tz1 = find([in.e(1).s(ttz{1}).timcont]/(60*60) > in.info.poweridx(1) & [in.e(1).s(ttz{1}).timcont]/(60*60) < in.info.poweridx(2));
    else
        tz1 = 1:length([in.e(1).s(ttz{1}).timcont]/(60*60));
    end
        
    zdata1 = [in.e(1).s(ttz{1}(tz1)).zAmp]; 
    ztim1 = [in.e(1).s(ttz{1}(tz1)).timcont]/(60*60);
            spliney = csaps(ztim1, zdata1, p);
            o.z(1).x = ztim1(1):1/ReFs:ztim1(end);
            o.z(1).yr = fnval(o.z(1).x, spliney);
            o.z(1).y = o.z(1).yr - mean(o.z(1).yr);
            
    %Channel 2
    
    if ~isempty(in.info.poweridx) 
        tz2 = find([in.e(1).s(ttz{2}).timcont]/(60*60) > in.info.poweridx(1) & [in.e(1).s(ttz{2}).timcont]/(60*60) < in.info.poweridx(2));
    else
        tz2 = 1:length([in.e(1).s(ttz{2}).timcont]/(60*60));
    end
    
    zdata2 = [in.e(2).s(ttz{2}(tz2)).zAmp]; 
    ztim2 = [in.e(1).s(ttz{2}(tz2)).timcont]/(60*60);
            spliney = csaps(ztim2, zdata2, p);
            o.z(2).x = ztim2(1):1/ReFs:ztim2(end);
            o.z(2).y = fnval(o.z(2).x, spliney);
            o.z(2).y = o.z(2).yr - mean(o.z(2).yr);

    %SUMAMP - FFT
    %Channel 1
    
    if ~isempty(in.info.poweridx) 
        st1 = find([in.e(1).s(ttsf{1}).timcont]/(60*60) > in.info.poweridx(1) & [in.e(1).s(ttsf{1}).timcont]/(60*60) < in.info.poweridx(2));
    else
        st1 = 1:length([in.e(1).s(ttsf{1}).timcont]/(60*60));
    end
            
    sfftdata1 = [in.e(1).s(ttsf{1}(st1)).sumfftAmp]; 
    sffttim1 = [in.e(1).s(ttsf{1}(st1)).timcont]/(60*60);
            spliney = csaps(sffttim1, sfftdata1, p);
            o.sfft(1).x = sffttim1(1):1/ReFs:sffttim1(end);
            o.sfft(1).y = fnval(o.sfft(1).x, spliney);
            o.sfft(1).y = o.sfft(1).yr - mean(o.sfft(1).yr);
            
    if ~isempty(in.info.poweridx)
        st2 = find([in.e(1).s(ttsf{2}).timcont]/(60*60) > in.info.poweridx(1) & [in.e(1).s(ttsf{2}).timcont]/(60*60) < in.info.poweridx(2));
    else
        st2 = 1:length([in.e(1).s(ttsf{2}).timcont]/(60*60));
    end
            
    sfftdata2 = [in.e(2).s(ttsf{2}(st2)).sumfftAmp]; 
    sffttim2 = [in.e(1).s(ttsf{2}(st2)).timcont]/(60*60);
            spliney = csaps(sffttim2, sfftdata2, p);
            o.sfft(2).x = sffttim2(2):1/ReFs:sffttim2(end);
            o.sfft(2).y = fnval(o.sfft(2).x, spliney);
            o.sfft(2).y = o.sfft(2).yr - mean(o.sfft(2).yr);
            
%% Run fft (pwelch)


%Analysis zAMp
% %fftmachine
% f = fftmachine(o.z(1).y - mean(o.z(1).y), ReFs, 3); 
%pwelch
L = length(o.z(1).y); 
NFFT = 2^nextpow2(L)/2;
%NFFT = 8192;
FreqRange = 0.002:0.0001:0.2;


% %generate fft by channel
%     


    if channel == 1
    %Channel 1
    %generate fft
    [pxx,pf] = pwelch(o.z(1).y - mean(o.z(1).y), NFFT, floor(NFFT*0.99), FreqRange, ReFs);  
    %populate values 
    zwelch = [pxx', pf'];
    colNames = {'pxx','pfreq'};
    pw(1).zAmp = array2table(zwelch,'VariableNames',colNames);
    
    %find peak at given frequency
    range = 0.002;
    xfreq(1) = 1/(2*hourperiod);
    hourpeak(1) = mean(pw(1).zAmp.pxx(pw(1).zAmp.pfreq > (1/(2*hourperiod) - range/2) & pw(1).zAmp.pfreq < ((1/(2*hourperiod) + range/2))));
        freq = xfreq(1);
        pwr = hourpeak(1);
    else    
    %Channel 2
    %generate fft
    [pxx,pf] = pwelch(o.z(2).y - mean(o.z(2).y), NFFT, floor(NFFT*0.99), FreqRange, ReFs);  
    %populate values 
    zwelch = [pxx', pf'];
    colNames = {'pxx','pfreq'};
    pw(2).zAmp = array2table(zwelch,'VariableNames',colNames);
    
    %find peak at given frequency
    range = 0.002;
    xfreq(2) = 1/(2*hourperiod);
    hourpeak(2) = mean(pw(2).zAmp.pxx(pw(2).zAmp.pfreq > (1/(2*hourperiod) - range/2) & pw(2).zAmp.pfreq < ((1/(2*hourperiod) + range/2))));
        freq = xfreq(2);
        pwr = hourpeak(2);
    end






end