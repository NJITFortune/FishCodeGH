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

    [~, fishidx] = ismember(fishtim, [in.s.timcont]);
    %hifish data
    for j = 1:length(in.hifish)
        out.s(j).obwAmp = kg2(k).hifish(j).obwAmp;
    end
    out.s.obwAmp = [in.hifish.obwAmp];
    out.s.
    out.s = in.hifish;
    
   

end


if fish == 5 %low frequency fish

    out.idx = in.loidx;
    out.info.poweridx = in.info.Lopoweridx;
    out.s = in.lofish;
    

end