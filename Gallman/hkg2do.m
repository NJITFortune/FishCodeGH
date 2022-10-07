function out = hkg2do(in, fish)
%makes new data structure of individual multifish 

    out.info.luz = in.info.luz;
    out.info.folder = in.info.folder;
    out.info.fishid = in.info.fishid;
    out.info.ld = in.info.ld;

if fish == 6 %hi frequency fish

    out.idx = in.hiidx;
    out.info.poweridx = in.info.Hipoweridx;
    out.s = in.hifish;
    
   

end


if fish == 5 %low frequency fish

    out.idx = in.loidx;
    out.info.poweridx = in.info.Lopoweridx;
    out.s = in.lofish;
    

end