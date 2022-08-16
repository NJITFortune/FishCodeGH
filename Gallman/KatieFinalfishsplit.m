function sout = KatieFinalfishsplit(in)

%concatenate both tubes
PkAmp = [hi(1).pkamp, hi(2).pkamp];
ObwAmp = [hi(1).obwamp, hi(2).obwamp];

Tim = [hi(1).tim, hi(2).tim];
Freq = [hi(1).freq, hi(2).freq];

for j = 1:length(Tim)
    sout(j).pkAmp(:) = PkAmp;
    sout(j).obwAmp(:) = ObwAmp;
    sout(j).timcont(:) = Tim * 3600;
    sout(j).freq(:) = Freq;
end