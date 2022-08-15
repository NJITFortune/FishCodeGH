function k_peakampmultiplotter(out)
%out = kg2(k).s
%make better variables to play with
%time
hitube1tim = [out([out.hitube]==1).timcont]/3600;
hitube2tim = [out([out.hitube]==2).timcont]/3600;
lotube1tim = [out([out.lotube]==1).timcont]/3600;
lotube2tim = [out([out.lotube]==2).timcont]/3600;
% %amp obw
% hitube1amp = [out([out.hitube]==1).hiAmpobw];
% hitube2amp = [out([out.hitube]==2).hiAmpobw];
% lotube1amp = [out([out.lotube]==1).loAmpobw];
% lotube2amp = [out([out.lotube]==2).loAmpobw];

%amp fft peak
hitube1amp = [out([out.hitube]==1).hipeakamp];
hitube2amp = [out([out.hitube]==2).hipeakamp];
lotube1amp = [out([out.lotube]==1).lopeakamp];
lotube2amp = [out([out.lotube]==2).lopeakamp];

%freq
hitube1freq = [out([out.hitube]==1).hifreq];
hitube2freq = [out([out.hitube]==2).hifreq];
lotube1freq = [out([out.lotube]==1).lofreq];
lotube2freq = [out([out.lotube]==2).lofreq];

%% plot 
%threshold for in-tube data


figure(452); clf; hold on;


    ax(1) = subplot(511); title('high frequency fish'); hold on; %ylim([0,2]);
            %raw amp
            plot(hitube1tim, hitube1amp, 'bo');
            plot(hitube2tim, hitube2amp, 'co');
            
    ax(2) = subplot(512); title('low frequency fish'); hold on; %ylim([0,3]);
            %raw amp
            plot(lotube1tim, lotube1amp, 'ro');
            plot(lotube2tim, lotube2amp, 'mo');
            
    ax(3) = subplot(513); title('combined chunks'); hold on; %ylim([300, 700]);
            plot(hitube1tim, hitube1freq,'b.'); 
            plot(hitube2tim, hitube2freq,'c.'); 

            plot(lotube1tim, lotube1freq,'r.'); 
            plot(lotube2tim, lotube2freq,'m.'); 
    
    ax(4) = subplot(514); title('temperature'); hold on;
            plot([out.timcont]/3600, [out.temp]);
            
    ax(5) = subplot(515); title('light cycle'); hold on;
            plot([out.timcont]/3600, [out.light]);
            

linkaxes(ax, 'x');
