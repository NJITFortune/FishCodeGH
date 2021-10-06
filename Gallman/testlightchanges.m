out = kg2(1).s;

figure(58); clf;

plot([out.timcont]/3600, [out.light]);
            ylim([-1, 6]);