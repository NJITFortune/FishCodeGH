function outy = iu_RecFieldClick(in, ent, sz)
% Function out = iu_RecFieldClick(in, ent, sz)
% USAGE: rf(ent) = iu_RecFieldClick(in, ent, sz);
% "in" is AL
% "out is rf
% "ent" = is entry (e.g. AL(1) and rf(1))
% sz is 1-8 (1 being small close, and 8 large)

% For the histogram
    numOfBins = 24;
    std_coeff   = 3;

% Get the sample rate for position
    Fs = in(ent).s(1).pFs;

% Get the entries for the size selected by the user
    idx = find([in(ent).s.sizeDX] == sz);

% Preparations
    tim = 0; % Starting time for the next sample as we concatonate
    spikes = []; % List of spike times
    pos = []; % Position over time

%% Concatonate data
if ~isempty(idx) % just make sure that the user isn't an idiot 
    
    totalspikes = [];        

    for j = 1:length(idx) % cycle to concatonate all of the correct entries

        sizetmp = size(in(ent).s(idx(j)).pos);
            if sizetmp(1)/sizetmp(2) < 1; pos = [pos in(ent).s(idx(j)).pos]; end % Concatonate position
            if sizetmp(1)/sizetmp(2) > 1; pos = [pos in(ent).s(idx(j)).pos']; end % Concatonate position
            
        currtim = 1/Fs:1/Fs:length(in(ent).s(idx(j)).pos)/Fs; % A time base for the currently added position

        sizetmp = size(in(ent).s(idx(j)).st);
            if sizetmp(1)/sizetmp(2) < 1; spikes = [spikes (in(ent).s(idx(j)).st + tim(end))]; end % Concatonate position
            if sizetmp(1)/sizetmp(2) > 1; spikes = [spikes (in(ent).s(idx(j)).st + tim(end))']; end % Concatonate position
         % Concatonate spike times, adding the time from the end of previous
        
        tim = [tim (currtim + tim(end))]; % Update the time base 
        
    end
        
    tim = tim(2:end); % When we are all done, we remove the initial zero
    
end


%% Get the signal values at spike times

    spikePOS = interp1(tim, pos, spikes);
    
    % Inital Position-only histogram
    histBoundPOS = std_coeff * std(pos);    
    POSedgs = linspace(mean(pos)-histBoundPOS, mean(pos)+histBoundPOS, numOfBins+1);
        POSwidth = POSedgs(2) - POSedgs(1);
    out.PstimulusHist = histcounts(pos, POSedgs);
        out.PstimulusHist(~isfinite(out.PstimulusHist)) = 0;    
    out.PresponseHist = histcounts(spikePOS, POSedgs);
        out.PresponseHist(~isfinite(out.PresponseHist)) = 0;
    out.POccHist = (out.PresponseHist / max(out.PresponseHist)) ./ (out.PstimulusHist / max(out.PstimulusHist)); 
        out.POccHist(~isfinite(out.POccHist)) = 0;    
        out.Pedges = POSedgs;
        

figure(2); clf; hold on;        
    for j=1:length(idx) % For each stimulus entry
                    
        if in(ent).s(idx(j)).pFs ~= 0 % If there is data
            tim = 1/in(ent).s(idx(j)).pFs:1/in(ent).s(idx(j)).pFs:length(in(ent).s(idx(j)).pos) / in(ent).s(idx(j)).pFs;
            plot(tim, in(ent).s(idx(j)).pos + 10*j, 'k-');
        
             ySpikes = interp1(tim, in(ent).s(idx(j)).pos, in(ent).s(idx(j)).st);
             tmp = size(ySpikes); if tmp(1) ~= 1; ySpikes = ySpikes'; end
             plot(in(ent).s(idx(j)).st, 10*j + ySpikes + (rand(1,length(in(ent).s(idx(j)).st))-0.5),  'b.', 'MarkerSize', 8);    
             
             text(1, 10*j, in(ent).s(idx(j)).size);  
        
             totalspikes = [totalspikes ySpikes];
            
        end
    end 

figure(1); clf; 
        ax(1) = subplot(211); plot(POSedgs(2:end)-(POSwidth/2), out.POccHist, 'o-'); %xlim([0.5 numOfBins+0.5]);
            title('Raw Position');
        ax(2) = subplot(212); plot(POSedgs(2:end)-(POSwidth/2), out.PresponseHist', 'o-'); %xlim([0.5 numOfBins+0.5]);
            title('OccHist Position');
        linkaxes(ax, 'x');

        
a = input('Get clicks for receptive field? (Y=1 or N=2) \n');    

        
if a == 2
    outy.Pidx = 999;
    outy.Nidx = 999;
end
if a == 1
    
    figure(1); [xs, ~] = ginput(2); xs = sort(xs);

    for j = 1:length(idx) % cycle through each 
        outy.Pidx{idx(j)} = find(in(ent).s(idx(j)).pos > xs(1) & in(ent).s(idx(j)).pos < xs(2));
    end
    
end



      