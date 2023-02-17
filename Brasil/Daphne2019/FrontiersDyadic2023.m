%% Load data

load SurfaceDataRev2018a.mat
load CaveDataRev2018a.mat

%% Make Pairwise Cave

[caveDD, ~] = dFanalysis(cave);

%% Analyze and/or plot

CurrRec = 7; 
CurrOut = length(CurrRec);

numPairs = length(caveDD(CurrOut).pair);  

for j=1:numPairs

    figure(j); clf;

    ax(1,j) = subplot(211); 
    plot(cave(CurrRec).fish(caveDD(CurrOut).pair(j).fishnums(1)).freq(:,1), cave(CurrRec).fish(caveDD(CurrOut).pair(j).fishnums(1)).freq(:,2));
           hold on; 
    plot(cave(CurrRec).fish(caveDD(CurrOut).pair(j).fishnums(2)).freq(:,1), cave(CurrRec).fish(caveDD(CurrOut).pair(j).fishnums(2)).freq(:,2));

    ax(2,j) = subplot(212); yyaxis("left"); plot(caveDD(CurrOut).pair(j).sharedtims, caveDD(CurrOut).pair(j).dF, 'Color', 'Blue');
    hold on; yyaxis("right"); plot(caveDD(CurrOut).pair(j).sharedtims, caveDD(CurrOut).pair(j).descartes, 'Color', 'Magenta');
    text(10,10, num2str(caveDD(CurrOut).pair(j).fishnums));
    linkaxes(ax(:,j),'x');

end