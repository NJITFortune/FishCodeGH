function fmvmidxingplotter(in)

%in = fm(k)
figure(50); clf; hold on;

    plot([in.timfo.timcont], [in.sx.midxings], '.', MarkerSize, 8);
    plot([in.timfo.lighttimes' in.timfo.lighttimes'], ylim, 'k-');


% figure(50); clf; hold on;
%     
%     plot([in.timfo.timcont], [in.ss.velstd], '.-');
%     plot([in.timfo.lighttimes' in.timfo.lighttimes'], ylim, 'k-');