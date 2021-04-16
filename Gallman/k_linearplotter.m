function k_linearplotter(out)
% plot the data for fun
% Usage: k_initialplotter(kg(#));
close all;
%% Preparations

% All the data (set because we may want to plot before running KatieRemover and/or KatieLabeler)
    tto{1} = 1:length([out.e(1).s.timcont]); % tto is indices for obwAmp
    tto{2} = tto{1};

    ttz{1} = tto{1}; % ttz is indices for zAmp
    ttz{2} = tto{1};

    ttsf{1} = tto{1}; % ttsf is indices for sumfftAmp
    ttsf{2} = tto{1};
    
% If we have removed outliers via KatieRemover, get the indices...    
    if ~isempty(out.idx)
        tto{1} = out.idx(1).obwidx; tto{2} = out.idx(2).obwidx; % tto is indices for obwAmp
        ttz{1} = out.idx(1).zidx; ttz{2} = out.idx(2).zidx; % ttz is indices for zAmp
        ttsf{1} = out.idx(1).sumfftidx; ttsf{2} = out.idx(2).sumfftidx; % ttsf is indices for sumfftAmp
    end
    



%% amplitude vs temperature

figure(1); clf; title('Amplitude vs temperature');
    set(gcf, 'Position', [200 100 2*560 2*420]);
    

ax(1) = subplot(511); hold on; title('sumfftAmp');
    
    nffttemp1 = normalize([out.e(1).s(ttsf{1}).temp], 'range'); 
    nfftAmp1 = normalize([out.e(1).s(ttsf{1}).sumfftAmp], 'range');

    [Rsqsf,yCalcsf] = KatieRegress(nffttemp1, nfftAmp1);
    scatter(nffttemp1, nfftAmp1);
    hold on
    plot(nffttemp1', yCalcsf, '--', 'LineWidth', 2);
    
    NE = [max(xlim) max(ylim)]-[diff(xlim) diff(ylim)]*0.2;
    str = "Rsquared = " + num2str(Rsqsf);
    text(NE(1), NE(2), str, 'FontSize', 14);
    

ax(2) = subplot(512); hold on; title('zAmp');
    
    nztemp1 = normalize([out.e(1).s(ttz{1}).temp], 'range');
    nzAmp1 = normalize([out.e(1).s(ttz{1}).zAmp], 'range');

    [Rsqz,yCalz] = KatieRegress(nztemp1, nzAmp1);
    scatter(nztemp1, nzAmp1);
    hold on
    plot(nztemp1', yCalz, '--','LineWidth', 2);
    
    NE = [max(xlim) max(ylim)]-[diff(xlim) diff(ylim)]*0.2;
    str = "Rsquared = " + num2str(Rsqz);
    text(NE(1), NE(2), str, 'FontSize', 14);


ax(3) = subplot(513); hold on; title('obwAmp');

    nobwtemp1 = normalize([out.e(1).s(tto{1}).temp], 'range');
    nobwAmp1 = normalize([out.e(1).s(tto{1}).obwAmp], 'range');

    [Rsqobw, yCalobw] = KatieRegress(nobwtemp1, nobwAmp1);
    scatter(nobwtemp1, nobwAmp1);
    hold on
    plot(nobwtemp1', yCalobw, '--' ,'LineWidth', 2);
    
    NE = [max(xlim) max(ylim)]-[diff(xlim) diff(ylim)]*0.2;
    str = "Rsquared = " + num2str(Rsqobw);
    text(NE(1), NE(2), str, 'FontSize', 14);

ax(4) = subplot(514); hold on; title('frequency');  

    ntemp = normalize([out.e(1).s.temp], 'range');
    nfreq = normalize([out.e(1).s.fftFreq], 'range');
    nfreqr = nfreq(nfreq < (mean(nfreq) + std(nfreq)) & nfreq > (mean(nfreq) - std(nfreq)));
    ntempr = ntemp(nfreq < (mean(nfreq) + std(nfreq)) & nfreq > (mean(nfreq) - std(nfreq)));
    

    [Rsqfreq,yCalfreq] = KatieRegress(ntempr, nfreqr);
    scatter(ntempr, nfreqr);
    hold on
    plot(ntempr', yCalfreq, '--','LineWidth', 2);
%     ylim([mean([out.e(1).s.fftFreq])-100, mean([out.e(1).s.fftFreq])+100]);

    NE = [max(xlim) max(ylim)]-[diff(xlim) diff(ylim)]*0.2;
    str = "Rsquared = " + num2str(Rsqfreq);
    text(NE(1), NE(2), str, 'FontSize', 14);

       
    
linkaxes(ax, 'x'); 

%% Multiple linear regression

% figure(2); clf; title('Amplitude vs temperature vs light');
%     set(gcf, 'Position', [200 100 2*560 2*420]);
% 
%     
%     subplot(211); hold on; title('sumfftAmp');
%     
%     
%     [bfft, ~, ~, ~, fftstats] = KatiemultiRegress([out.e(1).s(ttsf{1}).sumfftAmp], [out.e(1).s(ttsf{1}).light], [out.e(1).s(ttsf{1}).temp]);
%     
%     scatter3([out.e(1).s(ttsf{1}).light], [out.e(1).s(ttsf{1}).temp],[out.e(1).s(ttsf{1}).sumfftAmp],'filled')
%     hold on
%     x1fit = min([out.e(1).s(ttsf{1}).light]):1:max([out.e(1).s(ttsf{1}).light]);
%     x2fit = min([out.e(1).s(ttsf{1}).temp]):0.01:max([out.e(1).s(ttsf{1}).temp]);
%     [X1FIT,X2FIT] = meshgrid(x1fit,x2fit);
%     YFIT = bfft(1) + bfft(2)*X1FIT + bfft(3)*X2FIT + bfft(4)*X1FIT.*X2FIT;
%     mesh(X1FIT,X2FIT,YFIT)
%     xlabel('Light')
%     ylabel('fftAmp')
%     zlabel('Temperature')
%     view(50,10)
%     hold off
%     
%     fftstats
%     
%     subplot(212); hold on; title('normalized sumfftAmp')
%     
%     nfftlight1 = normalize([out.e(1).s(ttsf{1}).light], 'range');
%    
%     
%     [nbfft, ~, ~, ~, nfftstats] = KatiemultiRegress(nfftAmp1, nfftlight1, nffttemp1);
%     
%     scatter3(nfftlight1, nffttemp1 ,nfftAmp1,'filled')
%     hold on
%     x1fit = min(nfftlight1):0.5:max(nfftlight1);
%     x2fit = min(nffttemp1 ):0.1:max(nffttemp1);
%     [X1FIT,X2FIT] = meshgrid(x1fit,x2fit);
%     YFIT = nbfft(1) + nbfft(2)*X1FIT + nbfft(3)*X2FIT + nbfft(4)*X1FIT.*X2FIT;
%     mesh(X1FIT,X2FIT,YFIT)
%     xlabel('Light')
%     ylabel('fftAmp')
%     zlabel('Temperature')
%     view(50,10)
%     hold off
%     
%     nfftstats

    
    lightfft1 = [out.e(1).s(ttsf{1}).light];
    
    for j = 1:length(lightfft1)
        if lightfft1(j) > 2
            lightfft1(j) = 5;
        else
            lightfft1(j) = 1;
        end
    end
    
    
    
    figure(2); clf; title('Amplitude vs temperature vs light');
    set(gcf, 'Position', [200 100 2*560 2*420]);

    sumfft1 = [out.e(1).s(ttsf{1}).sumfftAmp];
    tempfft1 = [out.e(1).s(ttsf{1}).temp];
    lightfft1 = [out.e(1).s(ttsf{1}).light];
%     
    gscatter(tempfft1, sumfft1, lightfft1, 'bgr', 'x.o');
%     line(w,feval(fit,w,'70'),'Color','b','LineWidth',2)
%     line(w,feval(fit,w,'76'),'Color','g','LineWidth',2)
%     line(w,feval(fit,w,'82'),'Color','r','LineWidth',2)
    
%     fftreg1 = table(sumfft1, tempfft1, categorical(lightfft1));
%     fftfit = fitlm(fftreg1, 'sumfft1~tempfft1*lightfft');
%   
    
    
    
    

%linkaxes(ax, 'x'); 

%% Continuous data plot

% figure(1); clf; 
%     set(gcf, 'Position', [200 100 2*560 2*420]);
% 
% ax(1) = subplot(511); hold on; title('sumfftAmp');
%     yyaxis right; plot([out.e(2).s(ttsf{2}).timcont]/(60*60), [out.e(2).s(ttsf{2}).sumfftAmp], '.');
%     yyaxis left; plot([out.e(1).s(ttsf{1}).timcont]/(60*60), [out.e(1).s(ttsf{1}).sumfftAmp], '.');
% 
% ax(2) = subplot(512); hold on; title('zAmp');
%     yyaxis right; plot([out.e(2).s(ttz{2}).timcont]/(60*60), [out.e(2).s(ttz{2}).zAmp], '.');
%     yyaxis left; plot([out.e(1).s(ttz{1}).timcont]/(60*60), [out.e(1).s(ttz{1}).zAmp], '.');
% 
% ax(1) = subplot(513); hold on; title('obwAmp');
%     yyaxis right; plot([out.e(2).s(tto{2}).timcont]/(60*60*24), [out.e(2).s(tto{2}).obwAmp], '.');
%     yyaxis left; plot([out.e(1).s(tto{1}).timcont]/(60*60*24), [out.e(1).s(tto{1}).obwAmp], '.');
% 
% ax(3) = subplot(514); hold on; title('frequency (black) and temperature (red)');   
%         yyaxis right; plot([out.e(2).s.timcont]/(60*60), [out.e(2).s.fftFreq], '.k', 'Markersize', 8);
%         yyaxis right; plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.fftFreq], '.k', 'Markersize', 8);
%         yyaxis left; plot([out.e(2).s.timcont]/(60*60), [out.e(2).s.temp], '.r', 'Markersize', 8);
%         yyaxis left; plot([out.e(1).s.timcont]/(60*60), [out.e(1).s.temp], '.r', 'Markersize', 8);
%     
% ax(4) = subplot(515); hold on; title('light transitions');
%     plot([out.e(2).s.timcont]/(60*60), [out.e(1).s.light], '.', 'Markersize', 8);
%     ylim([-1, 6]);
%     xlabel('Continuous');
        
% Add feedingtimes, if we have them...    
%      if ~isempty(out.info)
%         subplot(511); plot([out.info.feedingtimes' out.info.feedingtimes']', [0 max([out.e(1).s.sumfftAmp])], 'm-', 'LineWidth', 2, 'MarkerSize', 10);
%         subplot(512); plot([out.info.feedingtimes' out.info.feedingtimes']', [0 max([out.e(1).s.zAmp])], 'm-', 'LineWidth', 2, 'MarkerSize', 10);
%         % subplot(515); plot([abs(out.info.luz)' abs(out.info.luz)'], [0 6], 'm-', 'LineWidth', 2, 'MarkerSize', 10);
%                     drawnow;
%         
%      end
%      
% linkaxes(ax, 'x'); 