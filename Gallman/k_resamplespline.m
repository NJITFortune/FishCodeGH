function k_resamplespline(in)

%in = kg

% Prepare the data

    tim = [in.e(1).sampl.timcont]/(60*60);

    obwdata = [in.e(1).sampl.obwAmp]; obwdata = obwdata(in.idx(1).obwidx);
        obwtim = tim(in.idx(1).obwidx);
%     zdata = [in.e(1).sampl.zAmp]; zdata = zdata(in.idx(1).zidx);
%         ztim = tim(in.idx(1).zidx);
%     sfftdata = [in.e(1).sampl.sumfftAmp]; sfftdata = sfftdata(in.idx(1).sumfftidx);
%         sffttim = tim(in.idx(1).sumfftidx);

    
    [~, obwredata] = k_cspliner(in.info.ld, obwtim, obwdata);
    
    specgram(obwredata)
        
        
        
        
        
% % Initialize the figure        
% 
% figure(1); clf; a = gcf; 
%     a.Position(3) = 1200; % Width 
%     a.Position(4) = 320; % Height
%     subplot(121); hold on; text(0.5, 0.075, 'LIGHT', 'Color', 'k');
%     subplot(122); hold on;
    
