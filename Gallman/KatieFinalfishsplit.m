function sout = KatieFinalfishsplit(in)

%concatenate both tubes
PkAmp = [in(1).pkamp, in(2).pkamp];
ObwAmp = [in(1).obwamp, in(2).obwamp];

Tim = [in(1).tim, in(2).tim];
Freq = [in(1).freq, in(2).freq];

%reindex so that tim happens sequentially
[Tim, idxtmp] = sort(Tim);
Freq = Freq(idxtmp);
ObwAmp = ObwAmp(idxtmp);
PkAmp = PkAmp(idxtmp);


for j = 1:length(Tim)
    sout(j).pkAmp(:) = PkAmp(j);
    sout(j).obwAmp(:) = ObwAmp(j);
    sout(j).timcont(:) = Tim(j) * 3600;
    sout(j).freq(:) = Freq(j);
end