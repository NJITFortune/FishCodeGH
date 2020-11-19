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

    foo.medianCh1obwAmp(ttk) = median([out(tt).Ch1obwAmp]); 
    foo.medianCh2obwAmp(ttk) = median([out(tt).Ch2obwAmp]);
    
    foo.medianCh1sAmp(ttk) = median([out(tt).Ch1sAmp]); 
    foo.medianCh2sAmp(ttk) = median([out(tt).Ch2sAmp]);
    
    foo.mediantims(ttk) = startim+(((ttk)*timstep*60) + ((timwin*60)/2)); % Middle of start and end times

end

figure(1); clf;

ax(1) = subplot(411); hold on;
    plot([out.timcont]/(60*60), [out.Ch1zAmp], 'b.');
    plot([out.timcont]/(60*60), [out.Ch2zAmp], 'r.');

    plot(foo.mediantims/(60*60), foo.medianCh1zAmp, 'c.', 'LineWidth', 3)
    plot(foo.mediantims/(60*60), foo.medianCh2zAmp, 'm.', 'LineWidth', 3)

ax(2) = subplot(412); hold on;
    plot([out.timcont]/(60*60), [out.Ch1sumAmp], 'b.');
    plot([out.timcont]/(60*60), [out.Ch2sumAmp], 'r.');
    plot(foo.mediantims/(60*60), foo.medianCh1sumAmp, 'c.', 'LineWidth', 3)
    plot(foo.mediantims/(60*60), foo.medianCh2sumAmp, 'm.', 'LineWidth', 3)

ax(3) = subplot(413); hold on;
    plot([out.timcont]/(60*60), [out.Ch1obwAmp], 'b.');
    plot([out.timcont]/(60*60), [out.Ch2obwAmp], 'r.');
    plot(foo.mediantims/(60*60), foo.medianCh1obwAmp, 'c.', 'LineWidth', 3)
    plot(foo.mediantims/(60*60), foo.medianCh2obwAmp, 'm.', 'LineWidth', 3)
    
ax(4) = subplot(414); hold on;
    plot([out.timcont]/(60*60), [out.Ch1sAmp], 'b.');
    plot([out.timcont]/(60*60), [out.Ch2sAmp], 'r.');
    plot(foo.mediantims/(60*60), foo.medianCh1sAmp, 'c.', 'LineWidth', 3)
    plot(foo.mediantims/(60*60), foo.medianCh2sAmp, 'm.', 'LineWidth', 3)
    ylim([0 400]);


linkaxes(ax, 'x');



end


