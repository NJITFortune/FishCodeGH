% load SurfaceDataRev2018a.mat
% load CaveDataRev2018a.mat

% For use with the 2016 Brasil Cave and Surface data

% There are Contaminated / Bad readings in surface data
% srf(1).fish(12), srf(2).fish(20), srf(3).fish(31), 
% srf(4).fish(22), srf(5).fish(4), srf(5).fish(23)

CaveAmps = []; SurfaceAmps = []; 

SurfBadIDXs = [12,14,32,64,86,90,109];


for j=1:length(srf)
    for k=1:length(srf(j).fish)
        SurfaceAmps(end+1) = srf(j).fish(k).dipStrength; 
    end
end

for j=length(cave):-1:1
    for k=1:length(cave(j).fish)
        CaveAmps(end+1) = cave(j).fish(k).dipStrength; 
    end
end

GoodIDXs = setdiff(1:length(SurfaceAmps), SurfBadIDXs);

stts.meanSurfaceAmp = mean(SurfaceAmps(GoodIDXs));
stts.meanCaveAmp = mean(CaveAmps);
stts.stdSurfaceAmp = std(SurfaceAmps(GoodIDXs));
stts.stdCaveAmp = std(CaveAmps);

[stts.H, stts.P, stts.CI, stts.STATS] = ttest2(CaveAmps, SurfaceAmps(GoodIDXs), 'vartype', 'unequal');

figure(3); clf; hold on;

scatter(ones(1,length(CaveAmps)), CaveAmps, 'Jitter', 'On', ['JitterAmount'], 0.1);
scatter(2*ones(1,length(GoodIDXs)), SurfaceAmps(GoodIDXs), 'Jitter', 'On', ['JitterAmount'], 0.1);

xlim([0 3]);

tmp{1} = CaveAmps; tmp{2} = SurfaceAmps(GoodIDXs);
figure; violin(tmp)