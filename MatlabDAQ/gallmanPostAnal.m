function [foo, neww] = gallmanPostAnal(out)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

timstep = 5; % Step size of integration window in minutes
timwin = 30; % Time of integration window in minutes

%% Calculate our time window

startim = out(1).timcont;
endtim = out(end).timcont;

totaltim = endtim - startim;


%% Get the Trend lines 
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

%% Take data above trend line

for j = length(out):-1:1
   
% For the data points before our first median value

k = find(foo.mediantims > out(j).timcont, 1, 'first');
        
        if out(j).Ch1sumAmp > foo.medianCh1sumAmp(k)
            newCh1sumAmp(j) = out(j).Ch1sumAmp;
        end
        if out(j).Ch1zAmp > foo.medianCh1zAmp(k)
            newCh1zAmp(j) = out(j).Ch1zAmp;
        end
        if out(j).Ch1sumAmp > foo.medianCh1obwAmp(k)
            newCh1obwAmp(j) = out(j).Ch1obwAmp;
        end
        if out(j).Ch1sAmp > foo.medianCh1sAmp(k)
            newCh1sAmp(j) = out(j).Ch1sAmp;
        end
        
        if out(j).Ch2sumAmp > foo.medianCh2sumAmp(k)
            newCh2sumAmp(j) = out(j).Ch2sumAmp;
        end
        if out(j).Ch2zAmp > foo.medianCh2zAmp(k)
            newCh2zAmp(j) = out(j).Ch2zAmp;
        end
        if out(j).Ch2obwAmp > foo.medianCh2obwAmp(k)
            newCh2obwAmp(j) = out(j).Ch2obwAmp;
        end
        if out(j).Ch2sAmp > foo.medianCh2sAmp(k)
            newCh2sAmp(j) = out(j).Ch2sAmp;
        end
            
end

     newCh1sumAmp(length(out)) = NaN; newCh2sumAmp(length(out)) = NaN;
     newCh1zAmp(length(out)) = NaN; newCh2zAmp(length(out)) = NaN;
     newCh1obwAmp(length(out)) = NaN; newCh2obwAmp(length(out)) = NaN;
     newCh1sAmp(length(out)) = NaN; newCh2sAmp(length(out)) = NaN;

     newCh1sumAmp(newCh1sumAmp == 0) = NaN;
     newCh1zAmp(newCh1zAmp == 0) = NaN;
     newCh1obwAmp(newCh1obwAmp == 0) = NaN;
     newCh1sAmp(newCh1sAmp == 0) = NaN;
     newCh2sumAmp(newCh2sumAmp == 0) = NaN;
     newCh2zAmp(newCh2zAmp == 0) = NaN;
     newCh2obwAmp(newCh2obwAmp == 0) = NaN;
     newCh2sAmp(newCh2sAmp == 0) = NaN;

%% Get the NEW Trend lines 

for ttk = 1:floor(totaltim/(timstep*60))   % Every timwin minutes
    
    tt = find([out.timcont] > startim+((ttk-1)*timstep*60) & [out.timcont] < startim+(((ttk-1)*timstep*60) + (timwin*60)) );
    
    neww.medianCh1sumAmp(ttk) = nanmedian(newCh1sumAmp(tt)); 
    neww.medianCh2sumAmp(ttk) = nanmedian(newCh2sumAmp(tt));
    
    neww.medianCh1zAmp(ttk) = nanmedian(newCh1zAmp(tt));
    neww.medianCh2zAmp(ttk) = nanmedian(newCh2zAmp(tt));

    neww.medianCh1obwAmp(ttk) = nanmedian(newCh1obwAmp(tt)); 
    neww.medianCh2obwAmp(ttk) = nanmedian(newCh2obwAmp(tt));
    
    neww.medianCh1sAmp(ttk) = nanmedian(newCh1sAmp(tt)); 
    neww.medianCh2sAmp(ttk) = nanmedian(newCh2sAmp(tt));
    
    neww.mediantims(ttk) = startim+(((ttk)*timstep*60) + ((timwin*60)/2)); % Middle of start and end times

end



%% Plot
figure(1); clf;

ax(1) = subplot(411); hold on; title('zAmp');
    plot([out.timcont]/(60*60), [out.Ch1zAmp], 'b.');
    plot([out.timcont]/(60*60), [out.Ch2zAmp], 'r.');

    plot(foo.mediantims/(60*60), foo.medianCh1zAmp, 'c-', 'LineWidth', 3)
    plot(foo.mediantims/(60*60), foo.medianCh2zAmp, 'm-', 'LineWidth', 3)

ax(2) = subplot(412); hold on; title('sumAmpFFT');
    plot([out.timcont]/(60*60), [out.Ch1sumAmp], 'b.');
    plot([out.timcont]/(60*60), [out.Ch2sumAmp], 'r.');
    plot(foo.mediantims/(60*60), foo.medianCh1sumAmp, 'c-', 'LineWidth', 3)
    plot(foo.mediantims/(60*60), foo.medianCh2sumAmp, 'm-', 'LineWidth', 3)

ax(3) = subplot(413); hold on; title('obwAmp');
    plot([out.timcont]/(60*60), [out.Ch1obwAmp], 'b.');
    plot([out.timcont]/(60*60), [out.Ch2obwAmp], 'r.');
    plot(foo.mediantims/(60*60), foo.medianCh1obwAmp, 'c-', 'LineWidth', 3)
    plot(foo.mediantims/(60*60), foo.medianCh2obwAmp, 'm-', 'LineWidth', 3)
    
ax(4) = subplot(414); hold on; title('sAmp');
    plot([out.timcont]/(60*60), [out.Ch1sAmp], 'b.');
    plot([out.timcont]/(60*60), [out.Ch2sAmp], 'r.');
    plot(foo.mediantims/(60*60), foo.medianCh1sAmp, 'c-', 'LineWidth', 3)
    plot(foo.mediantims/(60*60), foo.medianCh2sAmp, 'm-', 'LineWidth', 3)
    ylim([0 400]);


linkaxes(ax, 'x');

figure(2); clf;

xax(1) = subplot(411); hold on; title('zAmp');
    plot([out.timcont]/(60*60), newCh1zAmp, 'b.');
    plot([out.timcont]/(60*60), newCh2zAmp, 'r.');

    plot(neww.mediantims/(60*60), neww.medianCh1zAmp, 'c-', 'LineWidth', 2)
    plot(neww.mediantims/(60*60), neww.medianCh2zAmp, 'm-', 'LineWidth', 2)

xax(2) = subplot(412); hold on; title('sumAmpFFT');
    plot([out.timcont]/(60*60), newCh1sumAmp, 'b.');
    plot([out.timcont]/(60*60), newCh2sumAmp, 'r.');
    plot(neww.mediantims/(60*60), neww.medianCh1sumAmp, 'c-', 'LineWidth', 2)
    plot(neww.mediantims/(60*60), neww.medianCh2sumAmp, 'm-', 'LineWidth', 2)

xax(3) = subplot(413); hold on; title('obwAmp');
    plot([out.timcont]/(60*60), newCh1obwAmp, 'b.');
    plot([out.timcont]/(60*60), newCh2obwAmp, 'r.');
    plot(neww.mediantims/(60*60), neww.medianCh1obwAmp, 'c-', 'LineWidth', 2)
    plot(neww.mediantims/(60*60), neww.medianCh2obwAmp, 'm-', 'LineWidth', 2)
    
xax(4) = subplot(414); hold on; title('sAmp');
    plot([out.timcont]/(60*60), newCh1sAmp, 'b.');
    plot([out.timcont]/(60*60), newCh2sAmp, 'r.');
    plot(neww.mediantims/(60*60), neww.medianCh1sAmp, 'c-', 'LineWidth', 2)
    plot(neww.mediantims/(60*60), neww.medianCh2sAmp, 'm-', 'LineWidth', 2)
    ylim([0 400]);


linkaxes(xax, 'x');

end


