out = kg2(1).s;

figure(58); clf; hold on;

plot([out.timcont]/3600, [out.light]);
            ylim([-1, 6]);
            
            
lightchange = findchangepts([out.light]);

plot([out.timcont]/3600, lightchange);