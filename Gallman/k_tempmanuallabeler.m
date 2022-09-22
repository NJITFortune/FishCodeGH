%function out = k_tempemanuallabeler(in)
%in = kg(#).e
%out = kg(k).info.luz

clearvars -except hkg k xxkg 
in = xxkg(k);
%tempday = 6;


timcont = [in.e(1).s.timcont]/3600;
temp = [in.e(1).s.temp];
temptims = sort([in.info.temptims])';



figure(45); clf; hold on;
    plot(timcont, temp, 'LineWidth', 1);
    plot([temptims' temptims'], ylim, 'k-');

%separate rise from fall    
for j = 2:length(temptims)
    
    tempidx = find(timcont >= temptims(j-1) & timcont < temptims(j));

    if mean(temp(tempidx)) > mean(temp)
        tiz(j-1,:) = temptims(j-1);
        hotter(j-1,:) = temptims(j-1);
    else
        tiz(j-1,:) = -temptims(j-1);
        colder(j-1,:) = temptims(j-1);
    end

end    

colder = [colder(colder>0)];
hotter = hotter(hotter>0);


for j = 2:length(hotter)
    if tiz(1) > 0 %we start with hotter

        hotdurs(j-1,:) = colder(j-1) -  hotter(j-1);
        colddurs(j-1,:) = hotter(j) - colder(j-1);

    else    %we start with colder

        colddurs(j-1,:) = hotter(j-1) - colder(j-1);
        hotdurs(j-1,:) = colder(j) -  hotter(j-1);
        
    end

end


colddur = mean(colddurs);
hotdur = mean(hotdurs);
% colddur = 5.6;
% hotdur = 6.3;

tempdif = diff(temptims);
tidx = find(tempdif > tempday + 1);



for j = length(tidx):-1:1

    lineidx = find(temptims == temptims(tidx(j)));

    if tempdif(tidx(j)) < (tempday +1)*2


        if tiz(tidx(j)) < 0
            temptims = [temptims(1:lineidx -1), temptims(tidx(j)) + colddur, temptims(lineidx:end)];
        else
           temptims = [temptims(1:lineidx -1), temptims(tidx(j)) + hotdur, temptims(lineidx:end)]; 
        end

    end

    if tempdif(tidx(j)) < (tempday +1)*3 && tempdif(tidx(j)) > (tempday +1)*2


        if tiz(tidx(j)) < 0
            temptims = [temptims(1:lineidx -1), temptims(tidx(j)) + colddur, (temptims(tidx(j)) + colddur) + hotdur, temptims(lineidx:end)];
        else
           temptims = [temptims(1:lineidx-1), temptims(tidx(j)) + hotdur,(temptims(tidx(j)) + hotdur) + colddur, temptims(lineidx:end)]; 
        end

    end

end

    plot([temptims' temptims'], ylim, 'c-');


xxkg(k).info.temptims = temptims;

% 
%     figure(32); clf; hold on;
%          risetime(temp, timcont);
% 
%     figure(33); clf; hold on;
%        falltime(temp, timcont);
% 





