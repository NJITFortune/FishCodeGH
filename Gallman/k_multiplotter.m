function k_multiplotter(out)
%% Preparations

%outlier removal indicies
% All the data (set because we may want to plot before running KatieRemover and/or KatieLabeler)
    tthi = 1:length([out.s.HiTim]); % tthi is indices for HiAmp
    ttlo = 1:length([out.s.LoTim]); % ttlo is indices for LoAmp

    length(tthi)

% If we have removed outliers via KatieRemover, get the indices... 
    if isfield(out, 'idx')
        if ~isempty(out.idx)
            tthi = out.idx.Hiidx; % tthi is indices for HiAmp
            ttlo = out.idx.Loidx; % ttlo is indices for LoAmp
        end
    end

    length(tthi)
%colors
teal = [0.2 0.8 0.8];
%blue = [0 0.4470 0.7410];

orange = [0.8500 0.3250 0.0980];
%yellow = [0.9290 0.6940 0.1250];


%% plots

figure(66); clf; title('By fish'); hold on;

    axs(1) = subplot(511); hold on; title('High frequency fish');
        plot([out.s(tthi).HiTim], [out.s(tthi).HiAmp], '.', 'Color', teal);
        

    axs(2) = subplot(512); hold on; title('Low frequency fish');
        plot([out.s(ttlo).LoTim], [out.s(ttlo).LoAmp], '.','Color', orange);
   

    axs(3) = subplot(513); hold on; title('Frequency ');
        plot([out.s(tthi).HiTim], [out.s(tthi).HIfreq], '.','Color', teal); 
        plot([out.s(ttlo).LoTim], [out.s(ttlo).LOfreq], '.','Color', orange); 
        
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


