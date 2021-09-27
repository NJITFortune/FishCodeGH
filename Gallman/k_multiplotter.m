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

    
    ax(1) = subplot(511); hold on; title('High frequency fish');
        plot([out(hitube{1}).timcont], [out(hitube{1}).e1hiamp], '.', 'Color', teal);
        plot([out(hitube{2}).timcont], [out(hitube{2}).e2hiamp], '.', 'Color', blue);
        
    
    ax(2) = subplot(512); hold on; title('Low frequency fish');
        plot([out(lotube{1}).timcont], [out(lotube{1}).e1loamp], '.','Color', orange);
        plot([out(lotube{2}).timcont], [out(lotube{2}).e2loamp], '.', 'Color', yellow);
    
        
    ax(3) = subplot(513); hold on; title('Frequency');
        plot([out.Hitimobw], [out.HIfreq], '.','Color', teal); 
        plot([out.Lotimobw], [out.LOfreq], '.','Color', orange); 
        
    
    ax(4) = subplot(514); hold on; title('Temperature');
            plot([out.timcont], [out.temp], 'r.');
    
    ax(5) = subplot(515); hold on;
        plot([out.timcont], [out.light]);
        ylim([-1, 6]);
        
linkaxes(ax, 'x');

