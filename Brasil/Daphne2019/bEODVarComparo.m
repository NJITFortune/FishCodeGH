%% Immobilized (in tubes) Surface Fish in the grid

SurfImmobileSTDs = []; SurfImmobileSEMs = [];

nSurfSolo = 13;

StepSize = 300;

% Surface recording #1
for fishidx = [7 9 11] 
    for j = 1:2 % 0 to 600
        tt = srf(1).fish(fishidx).freq(:,1) > StepSize*(j-1) & srf(1).fish(fishidx).freq(:,1) < StepSize*j;
        SurfImmobileSTDs(end+1) = nanstd(srf(1).fish(fishidx).freq(tt,2));
    end
%        SurfImmobileSTDs(end+1) = nanstd(srf(1).fish(fishidx).freq(:,2));

end

% Surface recording #2
for fishidx = [11 18 19] 
    for j = 1:3 % 0 to 900
        tt = srf(2).fish(fishidx).freq(:,1) > StepSize*(j-1) & srf(2).fish(fishidx).freq(:,1) < StepSize*j;
        SurfImmobileSTDs(end+1) = nanstd(srf(2).fish(fishidx).freq(tt,2));
    end
%        SurfImmobileSTDs(end+1) = nanstd(srf(2).fish(fishidx).freq(:,2));
end

% Surface recording #3
for fishidx = [22 28] 
    for j = 1:2 % 0 to 600
        tt = srf(3).fish(fishidx).freq(:,1) > StepSize*(j-1) & srf(3).fish(fishidx).freq(:,1) < StepSize*j;
        SurfImmobileSTDs(end+1) = nanstd(srf(3).fish(fishidx).freq(tt,2));
    end
%        SurfImmobileSTDs(end+1) = nanstd(srf(3).fish(fishidx).freq(:,2));
end

% Surface recording #4
for fishidx = [11 16 20] 
    for j = 1:2 % 0 to 600
        tt = srf(4).fish(fishidx).freq(:,1) > StepSize*(j-1) & srf(4).fish(fishidx).freq(:,1) < StepSize*j;
        SurfImmobileSTDs(end+1) = nanstd(srf(4).fish(fishidx).freq(tt,2));
    end
%         SurfImmobileSTDs(end+1) = nanstd(srf(4).fish(fishidx).freq(:,2));
end

% Surface recording #5
for fishidx = [3 23] 
    for j = 1:3 % 0 to 900
        tt = srf(5).fish(fishidx).freq(:,1) > StepSize*(j-1) & srf(5).fish(fishidx).freq(:,1) < StepSize*j;
        SurfImmobileSTDs(end+1) = nanstd(srf(5).fish(fishidx).freq(tt,2));
    end
%        SurfImmobileSTDs(end+1) = nanstd(srf(5).fish(fishidx).freq(:,2));
end

    SurfImmobileSTDs = SurfImmobileSTDs(~isnan(SurfImmobileSTDs));
    SurfImmobileSTDs = SurfImmobileSTDs(SurfImmobileSTDs ~= 0);

fprintf('Surface Immobile STDs: Mean = %2.8f, STD %2.8f, Nsamples=%i, Nfish=%i \n', mean(SurfImmobileSTDs), std(SurfImmobileSTDs), length(SurfImmobileSTDs), nSurfSolo);

%% Moving Surface Fish in the grid

SurfGroupSTDs = [];
nSurfGroup = 97;

idx = 1;
for fishidx = [1 2 3 4 5 6  8  10  12]
    for j = 1:2 % 0 to 600
        tt = srf(1).fish(fishidx).freq(:,1) > StepSize*(j-1) & srf(1).fish(fishidx).freq(:,1) < StepSize*j;
        SurfGroupSTDs(end+1) = nanstd(srf(1).fish(fishidx).freq(tt,2));
    end
%         SurfGroupSTDs(end+1) = nanstd(srf(1).fish(fishidx).freq(:,2));
end

% Surface recording #2
for fishidx = [1 2 3 4 5 6 7 8 9 10  12 13 14 15 16 17   20 21]
    for j = 1:3 % 0 to 900
        tt = srf(2).fish(fishidx).freq(:,1) > StepSize*(j-1) & srf(2).fish(fishidx).freq(:,1) < StepSize*j;
        SurfGroupSTDs(end+1) = nanstd(srf(2).fish(fishidx).freq(tt,2));
    end
%        SurfGroupSTDs(end+1) = nanstd(srf(2).fish(fishidx).freq(:,2));
end

% Surface recording #3
for fishidx = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21  23 24 25 26 27  29 30 31]
    for j = 1:2 % 0 to 600
        tt = srf(3).fish(fishidx).freq(:,1) > StepSize*(j-1) & srf(3).fish(fishidx).freq(:,1) < StepSize*j;
        SurfGroupSTDs(end+1) = nanstd(srf(3).fish(fishidx).freq(tt,2));
    end
%         SurfGroupSTDs(end+1) = nanstd(srf(3).fish(fishidx).freq(:,2));
end

% Surface recording #4
for fishidx = [1 2 3 4 5 6 7 8 9 10  12 13 14 15  17 18 19  21 22]
    for j = 1:2 % 0 to 600
        tt = srf(4).fish(fishidx).freq(:,1) > StepSize*(j-1) & srf(4).fish(fishidx).freq(:,1) < StepSize*j;
        SurfGroupSTDs(end+1) = nanstd(srf(4).fish(fishidx).freq(tt,2));
    end
%        SurfGroupSTDs(end+1) = nanstd(srf(4).fish(fishidx).freq(:,2));
end

% Surface recording #5
for fishidx = [1 2  4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22  24]
    for j = 1:3 % 0 to 900
        tt = srf(5).fish(fishidx).freq(:,1) > StepSize*(j-1) & srf(5).fish(fishidx).freq(:,1) < StepSize*j;
        SurfGroupSTDs(end+1) = nanstd(srf(5).fish(fishidx).freq(tt,2));
    end
 %       SurfGroupSTDs(end+1) = nanstd(srf(5).fish(fishidx).freq(:,2));
end

    SurfGroupSTDs = SurfGroupSTDs(~isnan(SurfGroupSTDs));
    SurfGroupSTDs = SurfGroupSTDs(SurfGroupSTDs ~= 0);

fprintf('Surface Swimming STDs: Mean = %2.8f, STD %2.8f, Nsample=%i, Nfish=%i \n', mean(SurfGroupSTDs), std(SurfGroupSTDs), length(SurfGroupSTDs), nSurfGroup);
 
%% Freely moving solitary fish in the cave

CaveSoloSTDs = [];
nCaveSolo = 3;

% Cave recording #1 - 1 fish
    for j = 1:3 % 0 to 900
        tt = cave(1).fish(1).freq(:,1) > StepSize*(j-1) & cave(1).fish(1).freq(:,1) < StepSize*j;
        CaveSoloSTDs(end+1) = nanstd(cave(1).fish(1).freq(tt,2));
    end
%        CaveSoloSTDs(end+1) = nanstd(cave(1).fish(1).freq(:,2));
        
% Cave recording #2 - 1 fish
    for j = 1:3 % 0 to 900
        tt = cave(2).fish(1).freq(:,1) > StepSize*(j-1) & cave(2).fish(1).freq(:,1) < StepSize*j;
        CaveSoloSTDs(end+1) = nanstd(cave(2).fish(1).freq(tt,2));
    end
%        CaveSoloSTDs(end+1) = nanstd(cave(2).fish(1).freq(:,2));
    
% Cave recording #9 - 1 fish
    for j = 1:3 % 0 to 900
        tt = cave(9).fish(1).freq(:,1) > StepSize*(j-1) & cave(9).fish(1).freq(:,1) < StepSize*j;
        CaveSoloSTDs(end+1) = nanstd(cave(9).fish(1).freq(tt,2));
    end
%        CaveSoloSTDs(end+1) = nanstd(cave(9).fish(1).freq(:,2));

    CaveSoloSTDs = CaveSoloSTDs(~isnan(CaveSoloSTDs));
    CaveSoloSTDs = CaveSoloSTDs(CaveSoloSTDs ~=0);

fprintf('Cave Solitary STDs: Mean = %2.8f, STD %2.8f, Nsample=%i, Nfish=%i \n', mean(CaveSoloSTDs), std(CaveSoloSTDs), length(CaveSoloSTDs), nCaveSolo);

%% Freely moving group fish in the cave

CaveGroupSTDs = [];
nCaveGroup = 0;

for k = [3, 4, 5, 6, 7, 8, 10, 12, 13, 14] % Cave group recordings 
    
    nCaveGroup = nCaveGroup + length(cave(k).fish);
            
    for nFish = 1:length(cave(k).fish) % For each fish in those recordings
        for j = 1:floor(cave(k).fish(nFish).freq(end,1)/StepSize)
            tt = cave(k).fish(nFish).freq(:,1) > StepSize*(j-1) & cave(k).fish(nFish).freq(:,1) < StepSize*j;
            CaveGroupSTDs(end+1) = nanstd(cave(k).fish(nFish).freq(tt,2));
        end
%            CaveGroupSTDs(end+1) = nanstd(cave(k).fish(nFish).freq(:,2));
    end
end

fprintf('Cave Group STDs: Mean = %2.8f, STD %2.8f, Nsamples=%i, Nfish=%i\n', nanmean(CaveGroupSTDs), nanstd(CaveGroupSTDs), sum(~isnan(CaveGroupSTDs)), nCaveGroup);


fprintf('###### Differences in STDs ##### \n');

[~,b,~,d] = ttest2(CaveGroupSTDs, SurfGroupSTDs);
fprintf('STDS: Cave group vs Surface group: p=%2.6f, df=%i, tstat=%2.4f \n', b, d.df, d.tstat);

[p,h,stats] = ranksum(CaveGroupSTDs, SurfGroupSTDs);
fprintf('STDS: Cave group vs Surface group: p=%2.6f, h=%2.6f \n', p, h);
stats


[~,b,~,d] = ttest2(SurfImmobileSTDs, SurfGroupSTDs);
fprintf('STDS: Surface tube vs Surface group: p=%2.6f, df=%i, tstat=%2.4f \n', b, d.df, d.tstat);

[~,b,~,d] = ttest2(CaveGroupSTDs, CaveSoloSTDs);
fprintf('STDS: Cave group vs Cave solo: p=%2.6f, df=%i, tstat=%2.4f \n', b, d.df, d.tstat);

[~,b,~,d] = ttest2(SurfImmobileSTDs, CaveSoloSTDs);
fprintf('STDS: Surface tube vs Cave solo: p=%2.6f, df=%i, tstat=%2.4f \n', b, d.df, d.tstat);

clear b d k j tt nFish fishidx StepSize


