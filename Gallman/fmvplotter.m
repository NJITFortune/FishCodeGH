function fmvplotter(in)

%in = fm(k)
figure(49); clf; hold on;

    plot([in.timfo.timcont], [in.ss.velmean], '.-');
    plot([in.timfo.lighttimes' in.timfo.lighttimes'], ylim, 'k-');
