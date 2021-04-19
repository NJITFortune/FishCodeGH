function o = k_cspliner(in, ReFs, p)
% GENERATE CUBIC SPLINE FUNCTION FOR DATA
% Usage: [xx, yy] = k_cspliner(x, y, p)
% f(x) = csaps(x,y,p); p = 0.9

%% Preparations

%ReFs = 60;  %resample once every minute


if nargin < 3
    p = 0.9; %smoothing factor
end

% Prepare the data

    tto{1} = 1:length([in.e(1).s.timcont]); % tto is indices for obwAmp
    tto{2} = tto{1};

    ttz{1} = tto{1}; % ttz is indices for zAmp
    ttz{2} = tto{1};

    ttsf{1} = tto{1}; % ttsf is indices for sumfftAmp
    ttsf{2} = tto{1};
    
% If we have removed outliers via KatieRemover, get the indices...    
    if isfield(in, 'idx')
        tto{1} = in.idx(1).obwidx; tto{2} = in.idx(2).obwidx; % tto is indices for obwAmp
        ttz{1} = in.idx(1).zidx; ttz{2} = in.idx(2).zidx; % ttz is indices for zAmp
        ttsf{1} = in.idx(1).sumfftidx; ttsf{2} = in.idx(2).sumfftidx; % ttsf is indices for sumfftAmp
    end

    tim = [in.e(1).s.timcont]/(60*60);

    %hard coded because fuck thinking
    obwdata1 = [in.e(1).s(tto{1}).obwAmp]; 
    obwtim1 = tim(tto{1});
    
            spliney = csaps(obwtim1, obwdata1, p);
            o.obw(1).x = obwtim1(1):1/ReFs:obwtim1(end);
            o.obw(1).y = fnval(o.obw(1).x, spliney);
            
    obwdata2 = [in.e(2).s(tto{2}).obwAmp]; 
    obwtim2 = tim(tto{2});
            spliney = csaps(obwtim2, obwdata2, p);
            o.obw(2).x = obwtim2(1):1/ReFs:obwtim2(end);
            o.obw(2).y = fnval(o.obw(2).x, spliney);
        
    zdata1 = [in.e(1).s(ttz{1}).zAmp]; 
    ztim1 = tim(ttz{1});
            spliney = csaps(ztim1, zdata1, p);
            o.z(1).x = ztim1(1):1/ReFs:ztim1(end);
            o.z(1).y = fnval(o.z(1).x, spliney);
            
    zdata2 = [in.e(2).s(ttz{2}).zAmp]; 
    ztim2 = tim(ttz{2});
            spliney = csaps(ztim2, zdata2, p);
            o.z(2).x = ztim2(1):1/ReFs:ztim2(end);
            o.z(2).y = fnval(o.z(2).x, spliney);

            
    sfftdata1 = [in.e(1).s(ttsf{1}).sumfftAmp]; 
    sffttim1 = tim(ttsf{1});
            spliney = csaps(sffttim1, sfftdata1, p);
            o.sfft(1).x = sffttim1(1):1/ReFs:sffttim1(end);
            o.sfft(1).y = fnval(o.sfft(1).x, spliney);
            
    sfftdata2 = [in.e(2).s(ttsf{2}).sumfftAmp]; 
    sffttim2 = tim(ttsf{2});
            spliney = csaps(sffttim2, sfftdata2, p);
            o.sfft(2).x = sffttim2(2):1/ReFs:sffttim2(end);
            o.sfft(2).y = fnval(o.sfft(2).x, spliney);

%% Plot to check fit

figure(1); clf; title('Channel 1')

    subplot(311); hold on; title('sfft')
        plot(sffttim1, sfftdata1);
        plot(o.sfft(1).x, o.sfft(1).y, 'k', 'LineWidth', 2); 

    subplot(312); hold on; title('zAmp')
        plot(ztim1, zdata1);
        plot(o.z(1).x, o.z(1).y, 'k', 'LineWidth', 2); 
    
    subplot(313); hold on; title('obwAmp')
        plot(obwtim1, obwdata1);
        plot(o.obw(1).x, o.obw(1).y, 'k', 'LineWidth', 2); 
    
    
 figure(2); clf; title('Channel 2')

    subplot(311); hold on; title('sfft')
    plot(sffttim2, sfftdata2);
    plot(o.sfft(2).x, o.sfft(2).y, 'k', 'LineWidth', 2); 

    subplot(312); hold on; title('zAmp')
    plot(ztim2, zdata2);
    plot(o.z(2).x, o.z(2).y, 'k', 'LineWidth', 2); 
    
    subplot(313); hold on; title('obwAmp')
    plot(obwtim2, obwdata2);
    plot(o.obw(2).x, o.obw(2).y, 'k', 'LineWidth', 2); 
    
 figure(3); clf; title('Spline Comparo MF'); hold on;
   
    plot(o.sfft(1).x, o.sfft(1).y / max(o.sfft(1).y), 'b', 'LineWidth', 2); 
    plot(o.sfft(2).x, o.sfft(2).y / max(o.sfft(2).y), 'c', 'LineWidth', 2); 
    
    plot(o.z(1).x, o.z(1).y / max(o.z(1).y), 'r', 'LineWidth', 2); 
    plot(o.z(2).x, o.z(2).y / max(o.z(2).y), 'm', 'LineWidth', 2); 
    
    plot(o.obw(1).x, o.obw(1).y / max(o.obw(1).y), 'LineWidth', 2); 
    plot(o.obw(2).x, o.obw(2).y / max(o.obw(2).y), 'LineWidth', 2); 
    
%% Fft power analysis of obw
%1/x = hours
%comparisons tell us that ReFs and p do not have much affect at the lower
%frequencies

figure(4); hold on; 
figure(5); hold on; 

    f = fftmachine(o.obw(1).y - mean(o.obw(1).y), ReFs, 3); 
    figure(4); yyaxis left; plot(f.fftfreq, f.fftdata, 'm-o'); xlim([0 0.4]);
    figure(5); yyaxis left; plot(f.fftfreq, f.fftdata/(max(f.fftdata)), 'm-o'); xlim([0 0.4]);

    L = length(o.obw(1).y); 
    NFFT = 2^nextpow2(L)/2;
    FreqRange = 0.002:0.0001:0.2; % From XX days to 5 hours 
    %[pxx,pf] = pwelch(o.obw(1).y - mean(o.obw(1).y), NFFT, floor(ReFs*0.99), FreqRange, ReFs);    
    [pxx,pf] = pwelch(o.obw(1).y - mean(o.obw(1).y), NFFT, floor(NFFT*0.99), FreqRange, ReFs);    
    
    figure(4);     yyaxis right; plot(pf,pxx);
    figure(5);    yyaxis right; plot(pf,pxx/(max(pxx)));

    maxY = max(pxx);
    
    hrs = [96, 48, 24, 20, 16, 12, 10, 8]; % Double hours
figure(4);    
    for j=1:length(hrs)
        
        plot([1/hrs(j), 1/hrs(j)], [0, maxY], 'b-');
        text(1/hrs(j), maxY*0.9, num2str(hrs(j)/2));
        
    end
    
%% save peak values
%[o.Xfftpower, o.Yfftpower] = ginput(1);
%[o.X24power, o.Y24power] = ginput(1);

%% Resample - original for reference

% spliney = csaps(x, y, p);
% 
% % fx = fnval(x, spliney);
% 
% %%RESAMPLE DATA ALONG SPLINE FUNCTION
% %%Generate uniform (regular) time values
% 
% xx = x(1):1/ReFs:x(end);
% %xx = linspace(x(1), x(end), ((x(end)-x(1))*ReFs));
% 
% %%Resample at new time values along cubic spline
% yy = fnval(xx, spliney);


end