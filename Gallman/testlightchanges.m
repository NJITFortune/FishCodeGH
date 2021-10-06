out = kg2(1).s;

figure(58); clf; hold on;

plot([out.timcont]/3600, [out.light]);
            ylim([-1, 6]);
            
            
ipt = findchangepts([out.light], 'MinThreshold', 2.5);

plot([[out(ipt).light], [out(ipt).light]], [-1, 6], 'k-');

