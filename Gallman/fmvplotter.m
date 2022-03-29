function fmvplotter(in)

%in = fm(k)
figure(49); clf; title('average velocity'); hold on;

    plot([in.timfo.timcont], [in.ss.velmean], '.-');
    plot([in.timfo.lighttimes' in.timfo.lighttimes'], ylim, 'k-');


figure(50); clf; title('velocity std') hold on;
    
    plot([in.timfo.timcont], [in.ss.velstd], '.-');
    plot([in.timfo.lighttimes' in.timfo.lighttimes'], ylim, 'k-');

figure(51); clf; title('velocity variance') hold on;
    
    plot([in.timfo.timcont], [in.ss.variance], '.-');
    plot([in.timfo.lighttimes' in.timfo.lighttimes'], ylim, 'k-');