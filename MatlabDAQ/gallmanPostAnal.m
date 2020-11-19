function [foo] = gallmanPostAnal(out)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

timstep = 5; % Step size of integration window in minutes
timwin = 30; % Time of integration window in minutes

%% Calculate our time window

startim = out(1).timcont;
endtim = out(end).timcont;

totaltim = endtim - startim;


% Trend line 
for ttk = 1:floor(totaltim/(timstep*60))   % Every timwin minutes
    
    tt = find([out.timcont] > startim+((ttk-1)*timstep*60) & [out.timcont] < startim+(((ttk-1)*timstep*60) + (timwin*60)) );
    
    foo.medianCh1sumAmp(ttk) = median([out(tt).Ch1sumAmp]); 
    foo.medianCh2sumAmp(ttk) = median([out(tt).Ch2sumAmp]);
    
    foo.medianCh1zAmp(ttk) = median([out(tt).Ch1zAmp]);
    foo.medianCh2zAmp(ttk) = median([out(tt).Ch2zAmp]);
    
    foo.mediantims(ttk) = startim+(((ttk)*timstep*60) + ((timwin*60)/2)); % Middle of start and end times

end

figure(1); clf;

subplot(211); hold on;
    plot([out.timcont]/(60*60), [out.Ch1zAmp], 'b.');
    plot([out.timcont]/(60*60), [out.Ch2zAmp], 'r.');

    plot(foo.mediantims/(60*60), foo.medianCh1zAmp, 'c-', 'LineWidth', 3)
    plot(foo.mediantims/(60*60), foo.medianCh2zAmp, 'm-', 'LineWidth', 3)

subplot(212); hold on;
    plot([out.timcont]/(60*60), [out.Ch1sumAmp], 'b.');
    plot([out.timcont]/(60*60), [out.Ch2sumAmp], 'r.');
    plot(foo.mediantims/(60*60), foo.medianCh1sumAmp, 'c-', 'LineWidth', 3)
    plot(foo.mediantims/(60*60), foo.medianCh2sumAmp, 'm-', 'LineWidth', 3)

end


