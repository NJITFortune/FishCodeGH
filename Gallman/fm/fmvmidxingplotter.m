function fmvmidxingplotter(in)

%in = fm(k)
figure(55); title('midxings'); hold on;

    plot([in.timfo.timcont], [in.sx.midxings], '.-');
    plot([in.timfo.lighttimes' in.timfo.lighttimes'], ylim, 'k-');


% figure(50); clf; hold on;
%     
%     plot([in.timfo.timcont], [in.ss.velstd], '.-');
%     plot([in.timfo.lighttimes' in.timfo.lighttimes'], ylim, 'k-');