%% Load data

load SurfaceDataRev2018a.mat
load CaveDataRev2018a.mat

%% Make Pairwise Cave

[caveDD, ~] = dFanalysis(cave);

%% Analyze and/or plot

CurrRec = 3; 
CurrOut = length(CurrRec);

numPairs = length(out(CurrOut).pair);  

for j=1:numPairs

    figure(j); clf;
    out(CurrOut).pair(j).fishnums
    subplot(211); 
    plot(cave(CurrRec).fish(out(CurrOut).pair(j).fishnums(1)).freq(:,1), cave(CurrRec).fish(out(CurrOut).pair(j).fishnums(1)).freq(:,2));
           hold on; 
    plot(cave(CurrRec).fish(out(CurrOut).pair(j).fishnums(2)).freq(:,1), cave(CurrRec).fish(out(CurrOut).pair(j).fishnums(2)).freq(:,2));

    subplot(212); yyaxis("left"); plot(out(CurrOut).pair(j).sharedtims, out(CurrOut).pair(j).dF, 'Color', 'Blue');
    hold on; yyaxis("right"); plot(out(CurrOut).pair(j).sharedtims, out(CurrOut).pair(j).descartes, 'Color', 'Magenta');
    text(10,10, num2str(out(CurrOut).pair(j).fishnums));

end