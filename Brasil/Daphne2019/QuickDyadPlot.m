function QuickDyadPlot(in, idx, freqs, tims)
% Usage: QuickDyadPlot(in, idx, freqs, tims)
% Generates F1 with frequency traces and F2 with grid positions
% freqs and tims are optional. 
% Freqs in Hz, tims in seconds.

if exist('idx','var') == 0; idx = []; end
if exist('freqs','var') == 0; freqs = []; end
if exist('tims','var') == 0; tims = []; end

%% Setup

if isempty(idx)
    idx = 1:length(in.fish); % Default is show all fish
end    
if isempty(freqs)
    freqs = [250 500]; % Default frequency range for EODs
end    

    freqs = sort(freqs);

    figure(1); clf; hold on; % Frequency plot
    figure(2); clf; hold on; % Grid position plot
    % Make the Grid position plot square
        wp=get(gcf,'Position');
        set(gcf, 'Position', [wp(1),wp(2),560,560])


%% For each fish in the sample, plot frequency and xy plots

   tt1 = find(~isnan(in.fish(idx(1)).freq(:,2))); % all valid data
   tt2 = find(~isnan(in.fish(idx(1)).freq(:,2))); % all valid data
        
        if ~isempty(tims) % use only data in the range specified by the user
            tims = sort(tims);
            uu1 = find(in.fish(idx(1)).freq(:,1) > tims(1) & in.fish(idx(1)).freq(:,1) < tims(2));
            tt1 = intersect(tt1, uu1);
            uu2 = find(in.fish(idx(2)).freq(:,1) > tims(1) & in.fish(idx(2)).freq(:,1) < tims(2));
            tt2 = intersect(tt2, uu2);
        end
   
    denom1 = length(tt1)/16;
    sze1 = 1/denom1:1/denom1:16; z1=zeros(size(tt1'));
    denom2 = length(tt2)/16;
    sze2 = 1/denom2:1/denom2:16; z2=zeros(size(tt2'));

figure(1); set(gcf, 'Renderer', 'painters')
surface([in.fish(idx(1)).freq(tt1,1)';in.fish(idx(1)).freq(tt1,1)'], [in.fish(idx(1)).freq(tt1,2)';in.fish(idx(1)).freq(tt1,2)'], [z1;z1], [in.fish(idx(1)).freq(tt1,1)';in.fish(idx(1)).freq(tt1,1)'], "FaceColor", "none", "EdgeColor", "interp", "LineWidth", 8); 
    plot(in.fish(idx(1)).freq(tt1,1), in.fish(idx(1)).freq(tt1,2), 'g.', 'MarkerSize', 6); 
surface([in.fish(idx(2)).freq(tt2,1)';in.fish(idx(2)).freq(tt2,1)'], [in.fish(idx(2)).freq(tt2,2)';in.fish(idx(2)).freq(tt2,2)'], [z2;z2], [in.fish(idx(2)).freq(tt2,1)';in.fish(idx(2)).freq(tt2,1)'], "FaceColor", "none", "EdgeColor", "interp", "LineWidth", 4); 
    plot(in.fish(idx(2)).freq(tt2,1), in.fish(idx(2)).freq(tt2,2), 'm.', 'MarkerSize', 6); ylim(freqs);
figure(2); set(gcf, 'Renderer', 'painters')
surface([in.fish(idx(1)).x(tt1)';in.fish(idx(1)).x(tt1)'], [in.fish(idx(1)).y(tt1)';in.fish(idx(1)).y(tt1)'], [z1;z1], [in.fish(idx(1)).freq(tt1,1)';in.fish(idx(1)).freq(tt1,1)'], "FaceColor", "none", "EdgeColor", "interp", "LineWidth", 6); 
    plot(in.fish(idx(1)).x(tt1), in.fish(idx(1)).y(tt1), 'g.', 'MarkerSize', 12); 
surface([in.fish(idx(2)).x(tt2)';in.fish(idx(2)).x(tt2)'], [in.fish(idx(2)).y(tt2)';in.fish(idx(2)).y(tt2)'], [z2;z2], [in.fish(idx(2)).freq(tt2,1)';in.fish(idx(2)).freq(tt2,1)'], "FaceColor", "none", "EdgeColor", "interp", "LineWidth", 4); 
    plot(in.fish(idx(2)).x(tt2), in.fish(idx(2)).y(tt2), 'm.', 'MarkerSize', 12); 

        %axis([-200, 250, -200, 250]); % May need adjustment
    
