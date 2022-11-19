function k_multifishlightbinplotter(out)
% out = kg2(k);
%plots final cleaned high and low frequency fish amplitudes
%% Preparations
%outlier removal indicies
% All the data (set because we may want to plot before running KatieRemover and/or KatieLabeler)
    ttohi = 1:length(out.hifish); % tthi is indices for HiAmp
    ttolo = 1:length(out.lofish); % ttlo is indices for LoAmp

%     ttkhi = 1:length(out.hifish);
%     ttklo = 1:length(out.lofish);


% If we have removed outliers via KatieRemover, get the indices... 
    %high frequency fish indicies
        if isfield(out, 'hiidx')
            if ~isempty(out.hiidx)
                ttohi = [out.hiidx.obwidx]; 
                %ttkhi = [out.hiidx.pkidx];
            end
        end

    %low frequency fish indicies
        if isfield(out, 'loidx')
            if ~isempty(out.loidx)
                ttolo = [out.loidx.obwidx]; 
               % ttklo = [out.loidx.pkidx];
            end
        end


  
% figure(1); clf; plot(tthi);
% colors
teal = [0.2 0.8 0.8];
%blue = [0 0.4470 0.7410];

orange = [0.8500 0.3250 0.0980];
%yellow = [0.9290 0.6940 0.1250];


%% plots
 timcont = [out.s.timcont]/3600;
 oldtim = [out.hifish(ttohi).timcont];
oldamp = [out.hifish(ttohi).obwAmp];
[regtim,  regobw] = k_amponlymetamucil(oldtim, oldamp, 20);

 lowWn = 0.025/(20/2);
[dd,cc] = butter(5, lowWn, 'low');
regobwpeaks= filtfilt(dd,cc, double(regobw));

figure(67); clf; title('By fish'); hold on;
set(gcf, 'renderer', 'painters');

    axs(1) = subplot(411); hold on; title('High frequency fish');

     %   plot([out.hifish(ttkhi).timcont]/3600, [out.hifish(ttkhi).pkAmp], 'Color', teal);
        plot([out.hifish(ttohi).timcont]/3600-timcont(1), [out.hifish(ttohi).obwAmp],'.', 'Color', teal); 
        plot(regtim/3600-timcont(1), regobwpeaks, 'k-', 'LineWidth', 2);

    axs(2) = subplot(412); hold on; title('Low frequency fish');
    %    plot([out.lofish(ttklo).timcont]/3600, [out.lofish(ttklo).pkAmp], 'Color', orange);
        plot([out.lofish(ttolo).timcont]/3600-timcont(1), [out.lofish(ttolo).obwAmp],'.', 'Color', orange); 


    axs(3) = subplot(413); hold on; title('Frequency ');
        plot([out.hifish(ttohi).timcont]/3600-timcont(1), [out.hifish(ttohi).freq],'.', 'Color', teal); 
        plot([out.lofish(ttolo).timcont]/3600-timcont(1), [out.lofish(ttolo).freq],'.', 'Color', orange); 

    axs(4) = subplot(414); hold on; title('lightbins');

   
    binwidth = 0.5;
             luz = [out.info.luz];
            for k = 2:length(luz)
            
                if luz(k-1) < 0
                  
                  d = histogram(timcont-timcont(1), 'BinWidth', binwidth,'BinLimits',[abs(luz(k-1))-timcont(1),abs(luz(k))-timcont(1)]);
                  d.Normalization = 'countdensity';
                  d.FaceColor = [0.9 0.9 0.9];
                else
                    
                   l = histogram(timcont-timcont(1),'BinWidth', binwidth, 'BinLimits',[abs(luz(k-1))-timcont(1),abs(luz(k))-timcont(1)]);
                   l.Normalization = 'countdensity';
                   l.FaceColor = 'y';
                end
            end
             xlim([0 timcont(end)-timcont(1)]);
  

            
linkaxes(axs, 'x');


