out = kg2(1).s;

figure(58); clf; hold on;

plot([out.timcont]/3600, [out.light]);
            ylim([-1, 6]);
            
            
findchangepts([out.light], 'MaxNumChanges', );

%plot([out.timcont]/3600, lightchange);