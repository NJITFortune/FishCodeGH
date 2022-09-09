function out = hkg2me(in, fish)
%makes new data structure of individual multifish 

    out.temp = in.s.temp;
    out.light = in.s.light;
    out.info.luz = in.info.luz;
    out.info.folder = in.info.folder;
    out.info.fishid = in.info.fishid;
    out.info.ld = in.info.ld;

if fish == 6 %hi frequency fish

    out.idx = in.hiidx;
    out.info.poweridx = in.info.Hipoweridx;
    out.obwAmp = in.hifish.obwAmp;
    out.timcont = in.hifish.timcont;
    out.peakAmp = in.hifish.pkAmp;
    out.freq = in.hifish.freq;

end


if fish == 5 %low frequency fish

    out.idx = in.loidx;
    out.info.poweridx = in.info.Lopoweridx;
    out.obwAmp = in.lofish.obwAmp;
    out.timcont = in.lofish.timcont;
    out.peakAmp = in.lofish.pkAmp;
    out.freq = in.lofish.freq;

end