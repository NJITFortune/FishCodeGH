function k_removercheckplot(inumb, out) 
% innumb determines whether the input is for the high or low frequency fish
% out = kg2(k);
% str = 'high frequency fish' etc.


% inumb = 6;
% out = kg2(k);
%% prep
 if inumb == 6
     in = out.hifish;
     str = 'high frequency fish';
     tto = out.hiidx.obwidx;
     ttpk = out.hiidx.pkidx;
 elseif inumb == 5
     in = out.lofish;
     str = 'low frequency fish';
     tto = out.loidx.obwidx;
     ttpk = out.loidx.pkidx;
 end
    
%%    

figure(457); clf;  hold on;


    ax(1) = subplot(411); title(str); hold on; %ylim([0,2]);
           
            plot([in.timcont]/3600, [in.pkAmp], 'ko');
            plot([in(ttpk).timcont]/3600, [in(ttpk).pkAmp], 'ro');
            
    ax(2) = subplot(412); title('obw'); hold on; %ylim([0,3]);        
            plot([in.timcont]/3600, [in.obwAmp], 'ko');
            plot([in(tto).timcont]/3600, [in(tto).obwAmp], 'bo');
         
            
    ax(3) = subplot(413); title('frequency'); hold on; %ylim([0,3]);
%
          
            plot([in.timcont]/3600, [in.freq], 'ko');
            plot([in(ttpk).timcont]/3600, [in(ttpk).freq], 'o');
    
    ax(4) = subplot(414); title('light cycle'); hold on;
            plot([out.s.timcont]/3600, [out.s.light]);
            

linkaxes(ax, 'x');
