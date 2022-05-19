QuickPlotGrid(cave(5))

listofish = 1: length(cave (5). fish);
figure(1);

[x, y] = ginput(1);
clk = find(cave (5) .fish(1). freq(:,1) > x, 1, 'first');

for j=listofish
    dF(j) = abs(y - nanmean (cave (5). fish(j).freq(clk-20: clk+20,2)));
end

    [~, curfish] = min(dF);
    ofish = listofish(listofish ~= curfish);
%Clk = 1400;

for j=1:length(ofish)
    a(j) = pdist2([cave(5).fish(curfish).x(clk), cave(5).fish(curfish).y(clk)], [cave(5).fish(ofish(j)).x(clk), cave(5).fish(ofish(j)).y(clk)]);
end

    [~, idx] = min(a);
    idx=ofish(idx);

    len = 200;

figure(1); clf;
subplot (121); hold on;

    plot(cave(5).fish(curfish).x(clk-len:clk+len), cave(5).fish(curfish).y(clk-len:clk+len), 'b.');
    plot(cave(5).fish(idx).x(clk-len:clk+len),cave(5).fish(idx).y(clk-len:clk+len), 'm.');
        axis([-200 200 -200 200])
        text (0,150, ['curfish = ' num2str(curfish)], 'Color', 'b')
        text (0,100, ['otherfish = ' num2str(idx)], 'Color', 'm')

subplot(122); hold on;

    plot(cave(5).fish(curfish).freq(clk-len:clk+len,1), cave(5).fish(curfish).freq(clk-len:clk+len,2), 'b.');
    plot(cave(5).fish(idx).freq(clk-len:clk+len, 1), cave(5).fish(idx).freq(clk-len:clk+len,2), 'm.');
ylim ( [200 500]) ;

% cave(5)
% 1 interacting with 5 during chirps and 6 during scallops