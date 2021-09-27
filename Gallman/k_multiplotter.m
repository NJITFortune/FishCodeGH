function k_multiplotter(out)
%% preparations
%indicies for fish/tube data
 
    hitube{1} = out.idx(1).Hiobw;
    hitube{2} = out.idx(2).Hiobw;
    
    lotube{1} = out.idx(1).Loobw;
    lotube{2} = out.idx(2).Loobw;
    
%colors
teal = [0.2 0.8 0.8];
blue = [0 0.4470 0.7410];

orange = [0.8500 0.3250 0.0980];
yellow = [0.9290 0.6940 0.1250];
            
%% plots

figure(1); clf; 

    
    ax(1) = subplot(411); hold on; title('High frequency fish');
        plot([out(hitube{1}).timcont], [out(hitube{1}).e1hiamp], '.', 'Color', teal);
        plot([out(hitube{2}).timcont], [out(hitube{2}).e1hiamp], '.', 'Color', blue);
        
    
    ax(2) = subplot(412); hold on; title('Low frequency fish');
        plot([out(lotube{1}).timcont], [out(lotube{1}).e1loamp], '.','Color', orange);
        plot([out(lotube{2}).timcont], [out(lotube{2}).e1loamp], '.', 'Color', red);
    
        
    ax(2) = subplot(412); hold on;
        plot([out.Hitimobw], [out.HIfreq], '.'); 
        left; plot([out(Losortidx).timcont], [out(Losortidx).lofreq], '.');
        
    
    ax(3) = subplot(413); hold on; 
            plot([out.timcont], [out.temp], '.');
    
    ax(4) = subplot(414); hold on;
        plot([out.timcont], [out.light]);
        ylim([-1, 6]);
        
linkaxes(ax, 'x');

