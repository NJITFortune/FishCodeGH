editfunction out = ritafixer(in)

out = in;

windw = 20;

   figure(1); clf; hold on;
        plot(out.fishx, out.fishy, 'm-', 'LineWidth', 3);
        plot(out.shutx, out.shuty, 'b-', 'LineWidth', 3);
    
    fprintf('Checking fish data. \n');     
    figure(2); clf;

    [out.fishx, out.fishy] = fixmaster(out.fishx, out.fishy, windw);
    figure(2); subplot(211); plot(out.fishx, '-k');
    figure(2); subplot(212); plot(out.fishy, '-k');
    
    figure(1); plot(out.fishx, out.fishy, 'k.', 'LineWidth', 2);

    fprintf('Checking Shuttle data. \n');
    figure(3); clf;
    [out.shutx, out.shuty] = fixmaster(out.shutx, out.shuty, windw);
    figure(3); subplot(211); plot(out.shutx, '-m');
    figure(3); subplot(212); plot(out.shuty, '-m');
    
    figure(1); plot(out.shutx, out.shuty, 'm.', 'LineWidth', 2);
    
    yn = 1;
    ny = input('Fix another range? 99 is no. \n');
    if isempty(ny); yn = 1; end
    if ny == 99; yn = 99; end

while yn ~= 99
    
    
    figure(2); clf;
    figure(2); subplot(211); plot(out.fishx, '-k');
    figure(2); subplot(212); plot(out.fishy, '-k');
   
    [xx, ~] = ginput(2);
        xx(1) = max([1, floor(xx(1))]);
        xx(2) = min([ceil(xx(2)), length(out.fishx)]);
    
    figure(4); clf;
        subplot(211); hold on;      
            plot(xx(1):xx(2), out.fishx(xx(1):xx(2)), '-o');
        subplot(212); hold on;
            plot(xx(1):xx(2), out.fishy(xx(1):xx(2)), '-o');
            
            subplot(211); [tmpx, tmpy] = ginput;
                out.fishx(round(tmpx)) = tmpy;
            subplot(212); [tmpx, tmpy] = ginput;
                out.fishy(round(tmpx)) = tmpy;
            
    figure(2); clf;
    figure(2); subplot(211); plot(out.fishx, '-k');
    figure(2); subplot(212); plot(out.fishy, '-k');
    
        ny = input('Fix another range? 99 is no: ');
        if ny == 99; yn = 99; end

end
   
   figure(1); clf; hold on;
        plot(out.fishx, out.fishy, 'm-', 'LineWidth', 3);
        plot(out.shutx, out.shuty, 'b-', 'LineWidth', 3);
    




function [outX, outY] = fixmaster(X,Y, win)
   
    ww = 20;
    
        subplot(211); hold on; plot(X, 'c-', 'LineWidth', 4);
        subplot(212); hold on; plot(Y, 'c-', 'LineWidth', 4);

        outX = X; outY = Y;
        
        tx = isoutlier(X, 'movmedian', win);
        ty = isoutlier(Y, 'movmedian', win);
        
        if sum(tx) + sum(ty) == 0
           fprintf('No outliers detected\n');
        end
        if sum(tx) > 0
            subplot(211); plot(find(tx), X(tx), 'k.', 'MarkerSize', 8);
        end
        if sum(ty) > 0
            subplot(212); plot(find(ty), Y(ty), 'k.', 'MarkerSize', 8);
        end
        
        drawnow;

        fixidxs = union(find(tx), find(ty));
        
        if ~isempty(fixidxs)
            for var = 1:length(fixidxs)
                figure(4); clf; 
                
                minIDX = max([1, fixidxs(var)-ww]);
                maxIDX = min([length(X), fixidxs(var)+ww]);
                currerr = fixidxs(fixidxs >= minIDX & fixidxs <= maxIDX);
                
                plot(outX, outY, 'c-');
                subplot(211); hold on;
                    plot(minIDX:maxIDX, outX(minIDX:maxIDX), 'k-o');
                    plot(currerr, outX(currerr), 'ro', 'MarkerSize', 16);
                    plot(max([1,fixidxs(var)-1]):min([fixidxs(var)+1, length(outX)]), outX(max([1,fixidxs(var)-1]):min([fixidxs(var)+1, length(outX)])), '-m');
                    plot(fixidxs(var), outX(fixidxs(var)), '.c', 'MarkerSize', 20);
                    plot(max([1,fixidxs(var)-1]), outX(max([1,fixidxs(var)-1])), '.g', 'MarkerSize', 16);
                    plot(min([fixidxs(var)+1, length(outX)]), outX(min([fixidxs(var)+1, length(outX)])), '.m', 'MarkerSize', 16);
                subplot(212); hold on;
                    plot(minIDX:maxIDX, outY(minIDX:maxIDX), 'k-o');
                    plot(currerr, outY(currerr),  'ro', 'MarkerSize', 16);
                    plot(max([1,fixidxs(var)-1]):min([fixidxs(var)+1, length(outY)]), outY(max([1,fixidxs(var)-1]):min([fixidxs(var)+1, length(outY)])),  '-m');
                    plot(fixidxs(var), outY(fixidxs(var)), '.c', 'MarkerSize', 20);
                    plot(max([1,fixidxs(var)-1]), outY(max([1,fixidxs(var)-1])), '.g', 'MarkerSize', 16);
                    plot(min([fixidxs(var)+1, length(outX)]), outY(min([fixidxs(var)+1, length(outX)])), '.m', 'MarkerSize', 16);
drawnow;
                fprintf('Click replacement point %i out of %i. \n', var, length(fixidxs));
                figure(4); subplot(211);
                [~, outX(fixidxs(var))] = ginput(1);
                figure(4); subplot(212);
                [~, outY(fixidxs(var))] = ginput(1);

            end
            
            figure(4); clf; hold on;
            plot(outX(minIDX:maxIDX), outY(minIDX:maxIDX), 'k-'); 

        end
                    
end
end