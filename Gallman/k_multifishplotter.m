function k_multifishplotter(out)
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

figure(67); clf; title('By fish'); hold on;

    axs(1) = subplot(511); hold on; title('High frequency fish');
     %   plot([out.hifish(ttkhi).timcont]/3600, [out.hifish(ttkhi).pkAmp], 'Color', teal);
        plot([out.hifish(ttohi).timcont]/3600, [out.hifish(ttohi).obwAmp],'.', 'Color', teal); 

    axs(2) = subplot(512); hold on; title('Low frequency fish');
    %    plot([out.lofish(ttklo).timcont]/3600, [out.lofish(ttklo).pkAmp], 'Color', orange);
        plot([out.lofish(ttolo).timcont]/3600, [out.lofish(ttolo).obwAmp],'.', 'Color', orange); 


    axs(3) = subplot(513); hold on; title('Frequency ');
        plot([out.hifish(ttohi).timcont]/3600, [out.hifish(ttohi).freq],'.', 'Color', teal); 
        plot([out.lofish(ttolo).timcont]/3600, [out.lofish(ttolo).freq],'.', 'Color', orange); 

    axs(4) = subplot(514); hold on; title('Temperature');
            plot([out.s.timcont]/3600, [out.s.temp], 'r.');

    axs(5) = subplot(515); hold on;
        plot([out.s.timcont]/3600, [out.s.light]);
        ylim([-1, 6]);

        
    %additional plot elements - depend on whether user has input info

        % Add temptimes, if we have them... 
        if isfield(out.info, 'temptims')
            if ~isempty([out.info.temptims])
               axs(4) = subplot(514); 
               for j = 1:length([out.info.temptims])
                    plot([out.info.temptims(j), out.info.temptims(j)], ylim, 'b-');
               end         
            end
        end  

        % Add light transitions times to check luz if we have programmed it
        if isfield(out.info, 'luz')
            if  ~isempty(out.info.luz)
                
                %luz by transition type
                    %separate by transition type
                    lighton = out.info.luz(out.info.luz > 0);
                    darkon = out.info.luz(out.info.luz < 0);
                    
                    %plot
                    axs(5) = subplot(515); hold on;
                    plot([lighton' lighton']', [0 6], 'y-', 'LineWidth', 2, 'MarkerSize', 10);
                    plot([abs(darkon)' abs(darkon)']', [0 6], 'k-', 'LineWidth', 2, 'MarkerSize', 10);
            end    
        end


            
linkaxes(axs, 'x');


