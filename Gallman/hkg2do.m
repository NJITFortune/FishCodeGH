function out = hkg2do(in, fish)
% clearvars -except kg2 hkg2 hkg xxkg xxkg2
% in = kg2(32);
% fish = 6;

%makes new data structure of individual multifish 
%in = kg2(k)
%fish = hifish or lofish - from within kg2 struct

    out.info.luz = in.info.luz;
    out.info.folder = in.info.folder;
    out.info.fishid = in.info.fishid;
    out.info.ld = in.info.ld;
    out.info.temptims = in.info.temptims;
   
if fish == 6 %hi frequency fish

    out.idx = in.hiidx;
    out.info.poweridx = in.info.Hipoweridx;

    %find the times where the hifish and the general data points are the same
     [~, hifishidx, ~] = intersect([in.s.timcont], int32([in.hifish.timcont]));
 
    %hifish data
    for j = 1:length(in.hifish)

        %from hifish data
        out.s(j).obwAmp = in.hifish(j).obwAmp;
        out.s(j).freq = in.hifish(j).freq;
        out.s(j).timcont = in.hifish(j).timcont;
        %from combined fish data 
        out.s(j).temp = in.s(hifishidx(j)).temp;
        out.s(j).light = in.s(hifishidx(j)).light;


    end
   
   

end


if fish == 5 %low frequency fish

    out.idx = in.loidx;
    out.info.poweridx = in.info.Lopoweridx;

    %find the times where the lofish and the general data points are the same
    [~, lofishidx, ~] = intersect([in.s.timcont], int32([in.lofish.timcont]));

    %lofish data
    for j = 1:length(in.lofish)

        %from lofish data
        out.s(j).obwAmp = in.lofish(j).obwAmp;
        out.s(j).freq = in.lofish(j).freq;
        out.s(j).timcont = in.lofish(j).timcont;
        %from combined fish data 
        out.s(j).temp = in.s(lofishidx(j)).temp;
        out.s(j).light = in.s(lofishidx(j)).light;
    
    end
    

end