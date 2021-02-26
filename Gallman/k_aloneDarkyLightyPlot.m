function k_aloneDarkyLightyPlot(in)

%in = kg

% Prepare the data

    tim = [in.e(1).sampl.timcont]/(60*60);

    obwdata = [in.e(1).sampl.obwAmp]; obwdata = obwdata(in.idx(1).obwidx);
        obwtim = tim(in.idx(1).obwidx);
    zdata = [in.e(1).sampl.zAmp]; zdata = zdata(in.idx(1).zidx);
        ztim = tim(in.idx(1).zidx);
    sfftdata = [in.e(1).sampl.sumfftAmp]; sfftdata = sfftdata(in.idx(1).sumfftidx);
        sffttim = tim(in.idx(1).sumfftidx);

    lighttimes = abs(in.info.luz);
        
% Initialize the figure        

figure(1); clf; a = gcf; 
    a.Position(3) = 1200; % Width 
    a.Position(4) = 320; % Height
    subplot(121); hold on; text(0.5, 0.075, 'LIGHT', 'Color', 'k');
    subplot(122); hold on;
    
% Make the plots
    
    for j=1:length(lighttimes)-1
        
        if in.info.luz(j) > 0  % Light side
            
            subplot(121);            
        if ~isempty(find(tim > lighttimes(j) & tim <= lighttimes(j+1), 1))
            
            ott = find(obwtim > lighttimes(j) & obwtim <= lighttimes(j+1));
            plot(obwtim(ott) - lighttimes(j), movmean(obwdata(ott), 5), 'o-', 'MarkerSize', 2); 
            if length(ott) > 10
                [~, lighty(j,:)] = k_cspliner(in.info.ld, obwtim(ott), obwdata(ott));     
            end
        end
        
        else % Dark side
            
            subplot(122);            
        if ~isempty(find(tim > lighttimes(j) & tim <= lighttimes(j+1), 1))
            
            ott = find(obwtim > lighttimes(j) & obwtim <= lighttimes(j+1));
            plot(obwtim(ott) - lighttimes(j), movmean(obwdata(ott), 5), 'o-', 'MarkerSize', 2); 
            if length(ott) > 10
                [~, darky(j,:)] = k_cspliner(in.info.ld, obwtim(ott), obwdata(ott));     
            end
        end
            
            
            
        end
        
    end
%         tt = find(tim > abs(in.info.luz(k-1)) & tim <= abs(in.info.luz(k+1)));   
%         
%         if ~isempty(tt)
%             %subplot(122); hold on; plot(tim(tt) - tim(tt(1)), kg(j).Ch1obwAmp(tt), 'o-', 'MarkerSize', 2); text(0.5, 0.075, 'DARK', 'Color', 'k');
%             subplot(122); hold on; plot(tim(tt) - tim(tt(1)), movmean(alysis(tt), 5), 'o-', 'MarkerSize', 2); text(0.5, 0.075, 'DARK', 'Color', 'k');
% 
%             [~, darky(k/2,:)] = k_cspliner(in.info.ld*2, tim(tt) - tim(tt(1)), alysis(tt));
%         end
%         
%         tt = find(tim > in.info.luz(k) & tim <= in.info.luz(k+2));   
%         if ~isempty(tt)
%             %subplot(121); hold on; plot(tim(tt) - tim(tt(1)), kg(j).Ch1obwAmp(tt), 'o-', 'MarkerSize', 2); text(0.5, 0.075, 'LIGHT', 'Color', 'c');
%             subplot(121); hold on; plot(tim(tt) - tim(tt(1)), movmean(alysis(tt), 5), 'o-', 'MarkerSize', 2); text(0.5, 0.075, 'LIGHT', 'Color', 'c');
%             [xx, lighty(k/2,:)] = k_cspliner(in.info.ld*2, tim(tt) - tim(tt(1)), alysis(tt));
%         end
%     end
% end
% 
% %find where darky and lighty are zero and exclude from mean calculations
%     for j=1:length(darky(:,1))
%         a(j) = sum(darky(j,:)); 
%     end
%     darky = darky(a~=0);
%     clear a;
%     
%     for j=1:length(lighty(:,1))
%         a(j) = sum(lighty(j,:)); 
%     end
%     lighty = lighty(a~=0);
%     clear a;
% 
%  
%  
% mdark = median(darky);
% mlight = median(lighty);
% 
% figure(1); subplot(121); plot(xx,mlight, 'k-', 'LineWidth', 3);
% figure(1); subplot(122); plot(xx,mdark, 'k-', 'LineWidth', 3);
% 
% figure(2); clf;
% subplot(122); hold on; for j=1:length(darky(:,1)); plot(xx,darky(j,:)); end 
%     plot(xx,mdark, 'k-', 'LineWidth', 3);
% subplot(121); hold on; for j=1:length(lighty(:,1)); plot(xx,lighty(j,:)); end
%     plot(xx,mlight, 'k-', 'LineWidth', 3);
%     
% %find where darky == 0    
% % for j=1:length(darky(:,1)); a(j) = sum(darky(j,:)); end
% % a
% % 
% % a =
% % 
% %          0         0   34.3770   30.3625   31.3379   37.5726   34.2030   29.6845         0   11.7180   13.0345   19.4218   26.5841   19.3405
% 
% find(a==0)