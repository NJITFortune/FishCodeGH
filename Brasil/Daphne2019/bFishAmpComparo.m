function stts = bFishAmpComparo(cfish, sfish)
% Usage: stts = bFishAmpComparo(cfish, sfish) 
% For use with the 2016 Brasil Cave and Surface data

% There are Contaminated / Bad readings in surface data
% srf(1).fish(12), srf(2).fish(20), srf(3).fish(31), 
% srf(4).fish(22), srf(5).fish(4), srf(5).fish(23)

BadIDXs = [12,32,64,86,90,109];

CaveAmps = []; SurfaceAmps = []; 

for j=1:length(sfish) % Do it in this order or ruin the bad IDXs
    for k=1:length(sfish(j).fish) 
        SurfaceAmps(end+1) = sfish(j).fish(k).dipStrength; 
    end
end

for j=length(cfish):-1:1
    for k=1:length(cfish(j).fish)
        CaveAmps(end+1) = cfish(j).fish(k).dipStrength; 
    end
end

GoodIDXs = setdiff(1:length(SurfaceAmps), BadIDXs);

stts.meanSurfaceAmp = mean(SurfaceAmps(GoodIDXs));
stts.meanCaveAmp = mean(CaveAmps);
stts.stdSurfaceAmp = std(SurfaceAmps(GoodIDXs));
stts.stdCaveAmp = std(CaveAmps);

[stts.H, stts.P, stts.CI, stts.STATS] = ttest2(CaveAmps, SurfaceAmps(GoodIDXs), 'vartype', 'unequal');

    figure(1); clf; 
    
    % subplot(211); semilogy(CaveAmps, '.', 'MarkerSize', 2); hold on; plot(SurfaceAmps, '.', 'MarkerSize', 2);

    fprintf('Amplitudes different between cave and surface pVal = %1.5f, tstat = %1.5f \n', stts.P, stts.STATS.tstat);
    fprintf('Cave mean & std %1.4f %1.4f \n', stts.meanCaveAmp*100, stts.stdCaveAmp*100);
    fprintf('Surface mean & std %1.4f %1.4f \n', stts.meanSurfaceAmp*100, stts.stdSurfaceAmp*100);


    % figure(1); subplot(212); 
    hold on;
    
    numbins = 20;
    
    ctrs = 0:0.003/numbins:0.003;
    histogram(SurfaceAmps(GoodIDXs), ctrs, 'FaceColor', '[0 0.5 1]');
    histogram(CaveAmps, ctrs, 'FaceColor', '[1 0 0]'); 
    
    surfhist = histcounts(SurfaceAmps(GoodIDXs), ctrs);
    cavehist = histcounts(CaveAmps, ctrs);
    
    plotspots = ctrs(2:end) - 0.003/(2*numbins);
    plot(plotspots, surfhist, 'Color', '[0 0.5 1]');
    plot(plotspots, cavehist, 'Color', '[1 0 0]');
%    linkaxes(ax, 'xy');
    xlim([0 0.0022]);

end

