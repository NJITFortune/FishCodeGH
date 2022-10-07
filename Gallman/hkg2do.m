function out = hkg2do(in, fish)
%makes new data structure of individual multifish 
%in = kg2(k)
%fish = hifish or lofish - from within kg2 struct

    out.info.luz = in.info.luz;
    out.info.folder = in.info.folder;
    out.info.fishid = in.info.fishid;
    out.info.ld = in.info.ld;

if fish == 6 %hi frequency fish

    out.idx = in.hiidx;
    out.info.poweridx = in.info.Hipoweridx;

    %find the times where the hifish and the general data points are the same
    [~, hifishidx] = ismember([in.hifish.timcont], [in.s.timcont]);
    
    %hifish data
    for j = 1:length(in.hifish)

        %from hifish data
        out.s(j).obwAmp = kg2(k).hifish(j).obwAmp;
        out.s(j).freq = kg2(k).hifish(j).freq;
        out.s(j).timcont = kg2(k).hifish(j).timcont;
        %from combined fish data 
        out.s(j).temp = kg2(k).s(hifishidx(j)).temp;
        out.s(j).light = kg2(k).s(hifishidx(j)).light;


    end
   
   

end


if fish == 5 %low frequency fish

    out.idx = in.loidx;
    out.info.poweridx = in.info.Lopoweridx;

    %find the times where the hifish and the general data points are the same
    [~, hifishidx] = ismember([in.hifish.timcont], [in.s.timcont]);
    
    %hifish data
    for j = 1:length(in.hifish)

        %from hifish data
        out.s(j).obwAmp = kg2(k).hifish(j).obwAmp;
        out.s(j).freq = kg2(k).hifish(j).freq;
        out.s(j).timcont = kg2(k).hifish(j).timcont;
        %from combined fish data 
        out.s(j).temp = kg2(k).s(hifishidx(j)).temp;
        out.s(j).light = kg2(k).s(hifishidx(j)).light;

 
    

end