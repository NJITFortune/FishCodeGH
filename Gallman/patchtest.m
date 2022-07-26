

figure(22); clf; title('freq-nonphase adjusted'); hold on

x = [out(1).s.timcont]/3600;
y1 = [out(1).s.flo];
y2 = [out(1).s.fhi];

plot([out(1).s.timcont]/3600, [out(1).s.flo]);
plot([out(1).s.timcont]/3600, [out(1).s.fhi]);
patch([x fliplr(x)], [y1 fliplr(y2)], 'r');

plot([out(1).s.timcont]/3600, [out(1).s.fftFreq], 'k-', 'LineWidth',3);