function k_regularplotter(in)

%outliers
    % Prepare the data with outliers
            ttsf{1} = 1:length([in.e(1).s.timcont]); % ttsf is indices for sumfftAmp
            ttsf{2} = 1:length([in.e(2).s.timcont]);
    % Prepare the data without outliers

            % If we have removed outliers via KatieRemover, get the indices...    
            if ~isempty(in.idx) 
                ttsf{1} = in.idx(1).sumfftidx; ttsf{2} = in.idx(2).sumfftidx; % ttsf is indices for sumfftAmp
            end


figure(543); clf; hold on;

for k = 1:2
    ax(1) = subplot(411); hold on; title('sumfftAmp'); ylim([0,4]);
        plot(in.ch(k).timcontxx(ttsf{k})/(60*60), in.ch(k).sumfftAmpyy(ttsf{k}), '.');
       % plot(in.ch(k).timcontxx/(60*60), in.ch(k).sumfftAmpyy, '.');
       
    ax(2) = subplot(412); hold on; title('frequency (black) and temperature (red)');   
        plot([in.e(k).s.timcont]/(60*60), [in.e(k).s.fftFreq], '.k', 'Markersize', 8);
         
    ax(3) = subplot(413); hold on; title('temperature');
        plot([in.e(k).s.timcont]/(60*60), [in.ch(k).tempcelcius], '-r', 'Markersize', 8);
        
    ax(4) = subplot(414); hold on; title('light transitions');  
        plot([in.e(1).s.timcont]/(60*60), [in.e(1).s.light], '.', 'Markersize', 8);
        ylim([-1, 6]);
        xlabel('Continuous');

        % Add light transitions times to check luz if we have programmed it
        if isfield(in.info, 'luz')
            if  ~isempty(in.info.luz)
                
                %luz by transition type
                    %separate by transition type
                    lighton = in.info.luz(in.info.luz > 0);
                    darkon = in.info.luz(in.info.luz < 0);
                    
                    %plot
                    ax(4) = subplot(414); hold on;
                    plot([lighton' lighton']', [0 6], 'y-', 'LineWidth', 2, 'MarkerSize', 10);
                    plot([abs(darkon)' abs(darkon)']', [0 6], 'k-', 'LineWidth', 2, 'MarkerSize', 10);
            end    
        end

linkaxes(ax, 'x'); 


end
