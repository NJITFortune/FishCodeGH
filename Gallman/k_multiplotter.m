function k_multiplotter(out)

figure(1); clf; 

    
    ax(1) = subplot(411); hold on; 
        yyaxis right; plot([out(], [out.intubeHi], '.');
        yyaxis left; plot([out.Lotimcont], [out.intubeLo], '.');

        legend('High frequency fish', 'Low frequency fish');
        
    ax(2) = subplot(412); hold on;
        yyaxis right; plot([out(Hisortidx).timcont], [out(Hisortidx).hifreq], '.'); 
        yyaxis left; plot([out(Losortidx).timcont], [out(Losortidx).lofreq], '.');
        
    
    ax(3) = subplot(413); hold on; 
            plot([out.timcont], [out.temp], '.');
    
    ax(4) = subplot(414); hold on;
        plot([out.timcont], [out.light]);
        ylim([-1, 6]);
        
linkaxes(ax, 'x');

