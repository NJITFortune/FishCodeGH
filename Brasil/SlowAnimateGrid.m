% Make original plot
QuickPlotGrid(cave(5))

% Make a list of fish
    listofish = 1:length(cave(5).fish);

% User tells us the event to examine    
figure(1);
    [x, y] = ginput(1);
    clk = find(cave (5) .fish(1). freq(:,1) > x, 1, 'first');

% Find which fish is closest (frequency of EOD) to the click - this is the chosen one    
    for j=listofish
        dF(j) = abs(y - nanmean(cave(5).fish(j).freq(clk-20:clk+20,2)));
    end
    % curfish is the chosen fish
    [~, curfish] = min(dF);
        % ofish are the other individuals in the recording
        ofish = listofish(listofish ~= curfish);

% Get the distance (XY) from the chosen fish to each of the others        
    for j=1:length(ofish)
        a(j) = pdist2([cave(5).fish(curfish).x(clk), cave(5).fish(curfish).y(clk)], [cave(5).fish(ofish(j)).x(clk), cave(5).fish(ofish(j)).y(clk)]);
    end

    [~, idx] = min(a);
    closestfish=ofish(idx);

    len = 200; % How many steps is our window

    % We start one window before the click
    baseidx = clk - len;

    dotwidth = 1/(len*2):1/(len*2):2;

% Make a quick plot
figure(3, "Visible", "off"); clf;
subplot (121); hold on;

for j = 2:len*2
    plot(cave(5).fish(curfish).x(baseidx:baseidx+(len*3)), cave(5).fish(curfish).y(baseidx:baseidx+(len*3)), 'b.', 'MarkerSize', dotwidth(j));
    plot(cave(5).fish(closestfish).x(baseidx:baseidx+(len*3)),cave(5).fish(closestfish).y(baseidx:baseidx+(len*3)), 'm.', 'MarkerSize', dotwidth(j));
        axis([-200 200 -200 200])
        text (0,150, ['curfish = ' num2str(curfish)], 'Color', 'b')
        text (0,140, ['otherfish = ' num2str(closestfish)], 'Color', 'm')
end

subplot(122); hold on;

    plot(cave(5).fish(curfish).freq(baseidx:baseidx+(len*3),1), cave(5).fish(curfish).freq(baseidx:baseidx+(len*3),2), 'b.');
    plot(cave(5).fish(closestfish).freq(baseidx:baseidx+(len*3), 1), cave(5).fish(closestfish).freq(baseidx:baseidx+(len*3),2), 'm.');
ylim ( [200 500]) ;

drawnow;

% Make an animation
step = 5;

figure(3); clf;
subplot (121); hold on;

    plot(cave(5).fish(curfish).x(baseidx:baseidx+(len*3)), cave(5).fish(curfish).y(baseidx:baseidx+(len*3)), 'b.');
    plot(cave(5).fish(closestfish).x(baseidx:baseidx+(len*3)),cave(5).fish(closestfish).y(baseidx:baseidx+(len*3)), 'm.');
        axis([-200 200 -200 200])
        text (0,150, ['curfish = ' num2str(curfish)], 'Color', 'b')
        text (0,100, ['otherfish = ' num2str(closestfish)], 'Color', 'm')

subplot(122); hold on;

    plot(cave(5).fish(curfish).freq(baseidx:baseidx+(len*3),1), cave(5).fish(curfish).freq(baseidx:baseidx+(len*3),2), 'b.');
    plot(cave(5).fish(closestfish).freq(baseidx:baseidx+(len*3), 1), cave(5).fish(closestfish).freq(baseidx:baseidx+(len*3),2), 'm.');
ylim ( [200 500]) ;



% cave(5)
% 1 interacting with 5 during chirps and 6 during scallops