function [foo] = gallmanPostAnal(out)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Calculate our time window

timezero = 

% Smoothed trend line (20 minute duration window with 10 minute overlap)
for ttk = 1:143   % Every ten minutes
    tt = find([out.tim24] > ((ttk-1)*10*60) & [out.tim24] < (((ttk-1)*10*60) + (20*60)) );
    medianCh1sumAmp(ttk) = median([out(tt).Ch1obwAmp]); %huh? %is this just a quick way to replace one with the other?
    medianCh2sumAmp(ttk) = median([out(tt).Ch2obwAmp]);
    medianCh1zAmp(ttk) = median([out(tt).Ch1zAmp]);
    medianCh2zAmp(ttk) = median([out(tt).Ch2zAmp]);
    mediantims(ttk) = (((ttk-1)*10*60) + (10*60));
end




end



