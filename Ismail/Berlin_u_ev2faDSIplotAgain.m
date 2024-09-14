% Error velocity
mDSIev = [Penn4EV.dsi.spikes];
mDSIev = mDSIev + [Penn3EV.dsi.spikes];
%mDSIev = mDSIev + [f3n2EV.dsi.spikes];
%mDSIev = mDSIev + [f4n6EV.dsi.spikes];
mDSIev = mDSIev + [f3n1EV.dsi.spikes];
mDSIev = mDSIev + [f3n3EV.dsi.spikes];
%mDSIev = mDSIev + [f7n1EV.dsi.spikes];
mDSIev = mDSIev - [f3n4EV.dsi.spikes];
mDSIev = mDSIev - [f3n5EV.dsi.spikes];
%mDSIev = mDSIev - [f3n6EV.dsi.spikes];

mDSIev = mDSIev ./ 6;

% randomized EV
mrDSIev = [Penn4EV.dsi.randspikes];
mrDSIev = mrDSIev + [Penn3EV.dsi.randspikes];
%mrDSIev = mrDSIev + [f3n2EV.dsi.randspikes];
%mrDSIev = mrDSIev + [f4n6EV.dsi.randspikes];
mrDSIev = mrDSIev + [f3n1EV.dsi.randspikes];
mrDSIev = mrDSIev + [f3n3EV.dsi.randspikes];
%mrDSIev = mrDSIev + [f7n1EV.dsi.randspikes];
mrDSIev = mrDSIev - [f3n4EV.dsi.randspikes];
mrDSIev = mrDSIev - [f3n5EV.dsi.randspikes];
%mrDSIev = mrDSIev - [f3n6EV.dsi.randspikes];

mrDSIev = mrDSIev ./ 6;

% Error acceleration
mDSIea = [Penn4EA.dsi.spikes];
mDSIea = mDSIea + [Penn3EA.dsi.spikes];
%mDSIea = mDSIea + [f3n2EA.dsi.spikes];
%mDSIea = mDSIea + [f4n6EA.dsi.spikes];
mDSIea = mDSIea + [f3n1EA.dsi.spikes];
mDSIea = mDSIea + [f3n3EA.dsi.spikes];
%mDSIea = mDSIea + [f7n1EA.dsi.spikes];
mDSIea = mDSIea - [f3n4EA.dsi.spikes];
mDSIea = mDSIea - [f3n5EA.dsi.spikes];
%mDSIea = mDSIea - [f3n6EA.dsi.spikes];

mDSIea = mDSIea ./ 6;

% randomized EV
mrDSIea = [Penn4EV.dsi.randspikes];
mrDSIea = mrDSIea + [Penn3EA.dsi.randspikes];
%mrDSIea = mrDSIea + [f3n2EA.dsi.randspikes];
%mrDSIea = mrDSIea + [f4n6EA.dsi.randspikes];
mrDSIea = mrDSIea + [f3n1EA.dsi.randspikes];
mrDSIea = mrDSIea + [f3n3EA.dsi.randspikes];
%mrDSIea = mrDSIea + [f7n1EA.dsi.randspikes];
mrDSIea = mrDSIea - [f3n4EA.dsi.randspikes];
mrDSIea = mrDSIea - [f3n5EA.dsi.randspikes];
%mrDSIea = mrDSIea - [f3n6EA.dsi.randspikes];

mrDSIea = mrDSIea ./ 6;

figure(110); clf; hold on;

    plot(f3n2EV.dels(f3n2EV.dels >= 0), mDSIev(f3n2EV.dels >= 0), 'b-.', 'LineWidth', 3);
    plot(f3n2EV.dels(f3n2EV.dels <= 0), mDSIev(f3n2EV.dels <= 0), 'b-', 'LineWidth', 4);
    plot(f3n2EV.dels, mrDSIev, 'c', 'LineWidth', 1);

    plot(f3n2EA.dels(f3n2EA.dels >= 0), mDSIea(f3n2EA.dels >= 0), 'g-.', 'LineWidth', 3);
    plot(f3n2EA.dels(f3n2EA.dels <= 0), mDSIea(f3n2EA.dels <= 0), 'g-', 'LineWidth', 4);
    plot(f3n2EA.dels, mrDSIea, 'g', 'LineWidth', 1);
    
    xlabel('delay, seconds'); ylabel('selectivity index');
    text(0.15, -0.2, 'N = 10','FontSize', 18);
    title('error velocity, acceleration and fish acceleration')    
    plot(f3n2FA.dels(f3n2EV.dels <= 0), mDSIfa(f3n2EV.dels <= 0), 'r-.', 'LineWidth', 3);
    plot(f3n2FA.dels(f3n2EV.dels >= 0), mDSIfa(f3n2EV.dels >= 0), 'r-', 'LineWidth', 4);
    plot(f3n2FA.dels, mrDSIfa, 'm', 'LineWidth', 1);

xline(0); yline(0);
ylim([-0.25 0.25])
