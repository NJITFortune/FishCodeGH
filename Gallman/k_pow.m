function o = k_pow(in, ReFs, p)
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
    if ~isempty('in.idx')
        tto{1} = in.idx(1).obwidx; tto{2} = in.idx(2).obwidx; % tto is indices for obwAmp
        ttz{1} = in.idx(1).zidx; ttz{2} = in.idx(2).zidx; % ttz is indices for zAmp
        ttsf{1} = in.idx(1).sumfftidx; ttsf{2} = in.idx(2).sumfftidx; % ttsf is indices for sumfftAmp
    end

    tim = [in.e(1).s.timcont]/(60*60);
   
    if ~isempty('in.info.poweridx')
        tt = find(tim > in.info.poweridx(1) & tim < in.info.poweridx(2));
    else
        tt = 1:length(tim);
    end
        
    in.info.poweridx(1)
    in.info.poweridx(2)
    
    %hard coded because fuck thinking
    obwdata1 = [in.e(1).s(tto{1}(tt)).obwAmp]; 
    obwtim1 = tim(tto{1}(tt));
    
            spliney = csaps(obwtim1, obwdata1, p);
            o.obw(1).x = obwtim1(1):1/ReFs:obwtim1(end);
            o.obw(1).y = fnval(o.obw(1).x, spliney);
            
   % obwdata2 = [in.e(2).s(tto{2}(tt)).obwAmp]; 
    obwtim2 = tim(tto{2}(tt));
%             spliney = csaps(obwtim2, obwdata2, p);
%             o.obw(2).x = obwtim2(1):1/ReFs:obwtim2(end);
%             o.obw(2).y = fnval(o.obw(2).x, spliney);
        
    zdata1 = [in.e(1).s(ttz{1}(tt)).zAmp]; 
    ztim1 = tim(ttz{1}(tt));
            spliney = csaps(ztim1, zdata1, p);
            o.z(1).x = ztim1(1):1/ReFs:ztim1(end);
            o.z(1).y = fnval(o.z(1).x, spliney);
            
    zdata2 = [in.e(2).s(ttz{2}(tt)).zAmp]; 
    ztim2 = tim(ttz{2}(tt));
            spliney = csaps(ztim2, zdata2, p);
            o.z(2).x = ztim2(1):1/ReFs:ztim2(end);
            o.z(2).y = fnval(o.z(2).x, spliney);

            
    sfftdata1 = [in.e(1).s(ttsf{1}(tt)).sumfftAmp]; 
    sffttim1 = tim(ttsf{1}(tt));
            spliney = csaps(sffttim1, sfftdata1, p);
            o.sfft(1).x = sffttim1(1):1/ReFs:sffttim1(end);
            o.sfft(1).y = fnval(o.sfft(1).x, spliney);
            
    sfftdata2 = [in.e(2).s(ttsf{2}(tt)).sumfftAmp]; 
    sffttim2 = tim(ttsf{2}(tt));
            spliney = csaps(sffttim2, sfftdata2, p);
            o.sfft(2).x = sffttim2(2):1/ReFs:sffttim2(end);
            o.sfft(2).y = fnval(o.sfft(2).x, spliney);
            
            
%% Plot raw data range
figure(27); clf;
    %set(gcf, 'Position', [200 100 2*560 2*420]);

ax(1) = subplot(411); hold on; title('sumfftAmp');
    yyaxis right; plot(sffttim2, [in.e(2).s(ttsf{2}(tt)).sumfftAmp], '.');
    yyaxis left; plot(sffttim1, [in.e(1).s(ttsf{1}(tt)).sumfftAmp], '.');

ax(2) = subplot(412); hold on; title('zAmp');
    yyaxis right; plot(ztim2, [in.e(2).s(ttz{2}(tt)).zAmp], '.');
    yyaxis left; plot(ztim1, [in.e(1).s(ttz{1}(tt)).zAmp], '.');

ax(3) = subplot(413); hold on; title('obwAmp');
    yyaxis right; plot(obwtim2, [in.e(2).s(tto{2}(tt)).obwAmp], '.');
    yyaxis left; plot(obwtim1, [in.e(1).s(tto{1}(tt)).obwAmp], '.');
    
ax(4) = subplot(414); hold on; title('light transitions');
    plot(obwtim1, [in.e(1).s(tto{1}(tt)).light], '.', 'Markersize', 8);
    ylim([-1, 6]);
    xlabel('Continuous');
    
linkaxes(ax, 'x'); 

%% Plot to check fit

% figure(1); clf; title('Channel 1')
% 
%     subplot(311); hold on; title('sfft')
%         plot(sffttim1, sfftdata1);
%         plot(o.sfft(1).x, o.sfft(1).y, 'k', 'LineWidth', 2); 
% 
%     subplot(312); hold on; title('zAmp')
%         plot(ztim1, zdata1);
%         plot(o.z(1).x, o.z(1).y, 'k', 'LineWidth', 2); 
%     
%     subplot(313); hold on; title('obwAmp')
%         plot(obwtim1, obwdata1);
%         plot(o.obw(1).x, o.obw(1).y, 'k', 'LineWidth', 2); 
%     
%     
%  figure(2); clf; title('Channel 2')
% 
%     subplot(311); hold on; title('sfft')
%     plot(sffttim2, sfftdata2);
%     plot(o.sfft(2).x, o.sfft(2).y, 'k', 'LineWidth', 2); 
% 
%     subplot(312); hold on; title('zAmp')
%     plot(ztim2, zdata2);
%     plot(o.z(2).x, o.z(2).y, 'k', 'LineWidth', 2); 
%     
%     subplot(313); hold on; title('obwAmp')
%     plot(obwtim2, obwdata2);
%     plot(o.obw(2).x, o.obw(2).y, 'k', 'LineWidth', 2); 
%     
%  figure(3); clf; title('Spline Comparo MF'); hold on;
%    
%     plot(o.sfft(1).x, o.sfft(1).y / max(o.sfft(1).y), 'b', 'LineWidth', 2); 
%     plot(o.sfft(2).x, o.sfft(2).y / max(o.sfft(2).y), 'c', 'LineWidth', 2); 
%     
%     plot(o.z(1).x, o.z(1).y / max(o.z(1).y), 'r', 'LineWidth', 2); 
%     plot(o.z(2).x, o.z(2).y / max(o.z(2).y), 'm', 'LineWidth', 2); 
%     
%     plot(o.obw(1).x, o.obw(1).y / max(o.obw(1).y), 'LineWidth', 2); 
%     plot(o.obw(2).x, o.obw(2).y / max(o.obw(2).y), 'LineWidth', 2); 
    
%% Fft power analysis of obw
%1/x = hours
%comparisons tell us that ReFs and p do not have much affect at the lower
%frequencies

% % Analysis OBW
% % fftmachine
% f = fftmachine(o.obw(1).y - mean(o.obw(1).y), ReFs, 3); 
% %pwelch
% L = length(o.obw(1).y); 
% NFFT = 2^nextpow2(L)/2;
% %NFFT = 8192;
% FreqRange = 0.002:0.0001:0.2;
% [pxx,pf] = pwelch(o.obw(1).y - mean(o.obw(1).y), NFFT, floor(NFFT*0.99), FreqRange, ReFs);   



%Analysis zAMp
%fftmachine
f = fftmachine(o.z(1).y - mean(o.z(1).y), ReFs, 3); 
%pwelch
L = length(o.z(1).y); 
NFFT = 2^nextpow2(L)/2;
%NFFT = 8192;
FreqRange = 0.002:0.0001:0.2;
[pxx,pf] = pwelch(o.z(1).y - mean(o.z(1).y), NFFT, floor(NFFT*0.99), FreqRange, ReFs);  


%colors for plots
rosey = [.8588 0.4980 0.4980];
aqua = [0.4784 0.9020 0.7882];

%size of figure window
L = 2*200;
W = 2*700; %changed from 2*420

figure(1); clf; hold on; 
%set(figure(1),'Units','normalized','Position',[0 0 .5 .5]); 
 set(gcf, 'Position', [0 0 W L]);

    %get ylim variables
    %maxY
    if max(pxx) > max(f.fftdata)
        maxY = max(pxx);
    else
        maxY = max(f.fftdata);
    end  
    
    %minY
    if min(pxx) < max(f.fftdata)
        minY = min(pxx);
    else
        minY = min(f.fftdata);
    end  

    %Draw lines for light cycles
    hrs = [96, 48, 26, 24, 20, 16, 12, 10, 8]; % Double hours

    %plot data on log scale
    %fftmachine
    figure(1); plot(f.fftfreq(f.fftfreq < 0.2), f.fftdata(f.fftfreq < 0.2), '-o', 'Color', aqua, 'LineWidth', 2); 
    %pwelch
    figure(1); plot(pf,pxx, '-o','Color', rosey, 'LineWidth', 2, 'MarkerSize', 3); ylim([minY, maxY + 0.01]);
    
    figure(1);    
        for j=1:length(hrs)

            plot([1/hrs(j), 1/hrs(j)], [minY, maxY], 'k-', 'LineWidth', 1);
            label = num2str(hrs(j)/2);
            str = " " + label + ":" + label;
            if mod(j, 2) == 0 % j is even
                pos(j) = maxY*0.9;
            else % j is odd
                pos(j) = maxY*0.5;
            end
            
            text(1/hrs(j), pos(j), str, 'FontSize', 14, 'FontWeight', 'bold');

        end
    
        set(gca, 'yscale', 'log');

    
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