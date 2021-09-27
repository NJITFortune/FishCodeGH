function k_multiplotter(out)
%% preparations
%indicies for fish/tube data
 
    hitube{1} = out.idx(1).Hiobw;
    hitube{2} = out.idx(2).Hiobw;
    
    lotube{1} = out.idx(1).Loobw;
    lotube{2} = out.idx(2).Loobw;
    
            
%% plots

figure(1); clf; 

    
    ax(1) = subplot(411); hold on; title('High frequency fish');
        plot([out(hitube{1}).timcont], [out(hitube{1}).e1hiamp], '.');
        plot([out(hitube{2}).timcont], [out(hitube{2}).e1hiamp], '.');
        
    
    ax(2) = subplot(412); hold on; title('Low frequency fish');
        plot([out(lotube{1}).timcont], [out(lotube{1}).e1loamp], '.');
        plot([out(lotube{2}).timcont], [out(lotube{2}).e1loamp], '.');
    
        
    ax(2) = subplot(412); hold on;
        yyaxis right; plot([out(Hisortidx).timcont], [out(Hisortidx).hifreq], '.'); 
        yyaxis left; plot([out(Losortidx).timcont], [out(Losortidx).lofreq], '.');
        
    
    ax(3) = subplot(413); hold on; 
            plot([out.timcont], [out.temp], '.');
    
    ax(4) = subplot(414); hold on;
        plot([out.timcont], [out.light]);
        ylim([-1, 6]);
        
linkaxes(ax, 'x');

