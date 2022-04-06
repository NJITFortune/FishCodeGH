function out =  KatieRegular(in, ReFs)
%function out = imregular(in)
%% to lazy to function
% clearvars -except kg kg2
% %out = in;
% in = kg(1);
% channel = 1;
% ReFs = 60;
% light = 3;


%k = channel;
lighttimes = abs(in.info.luz);


%% regular
%generate new vectors for each channel (electrode)

for k = 1:2

    %calculate starttim
%     if lighttimes(1) < in.e(k).s(1).timcont
%         starttim = lighttimes(1);
%     else 
        starttim = in.e(k).s(1).timcont;
    %end
    %generate new time vector with regular intervals of ReFs (60 seconds)
    out(k).timcontxx = starttim:ReFs:in.e(k).s(end).timcont;

    %assign amplitude values to new time vector
    for j = length(out(k).timcontxx):-1:1
    
        %find values a half step in either direction ReFs
        tt = find([in.e(k).s.timcont] > (out(k).timcontxx(j)-ReFs/2) & [in.e(k).s.timcont] < (out(k).timcontxx(j)+ReFs/2));
    
        %if there are values, assign the y to xx
        if ~isempty(tt) 
            temp(k).sumfftAmpyy(j) = in.e(k).s(tt).sumfftAmp;
    
        %if there are no values assign nan
        else
            temp(k).sumfftAmpyy(j) = nan;
        end
    
    end

    %fill missing - replaces nans with values?
    out(k).sumfftAmpyy = fillmissing(temp(k).sumfftAmpyy, 'linear');

    %save temperature vectors - because why not?
    out(k).tempcelcius = real(k_voltstodegC(in, k));


end 

%% plot to check

% %outliers
%     % Prepare the data with outliers
%             ttsf{1} = 1:length([in.e(1).s.timcont]); % ttsf is indices for sumfftAmp
%             ttsf{2} = 1:length([in.e(2).s.timcont]);
%     % Prepare the data without outliers
% 
%             % If we have removed outliers via KatieRemover, get the indices...    
%             if ~isempty(in.idx) 
%                 ttsf{1} = in.idx(1).sumfftidx; ttsf{2} = in.idx(2).sumfftidx; % ttsf is indices for sumfftAmp
%             end
% 

figure(543); clf; hold on;

for k = 1:2
    ax(1) = subplot(411); hold on; title('sumfftAmp');
        %plot(out(k).timcontxx(ttsf{k})/(60*60), out(k).sumfftAmpyy(ttsf{k}), '.');
        plot(out(k).timcontxx/(60*60), out(k).sumfftAmpyy, '.');
       
    ax(2) = subplot(412); hold on; title('frequency (black) and temperature (red)');   
        plot([in.e(k).s.timcont]/(60*60), [in.e(k).s.fftFreq], '.k', 'Markersize', 8);
         
    ax(3) = subplot(413); hold on; title('temperature');
        plot([in.e(k).s.timcont]/(60*60), [out(k).tempcelcius], '-r', 'Markersize', 8);
        
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
