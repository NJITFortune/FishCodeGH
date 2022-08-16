function maxval = k_normcheckplot(inumb, out) 
% innumb determines whether the input is for the high or low frequency fish
% out = kg2(k);
% str = 'high frequency fish' etc.

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
    
 maxval = max([in(ttpk).pkAmp]);
 %maxval = ;
%%    

figure(457); clf;  hold on;


    ax(1) = subplot(311); title(str); hold on; %ylim([0,2]);
           
           
            plot([in(ttpk).timcont]/3600, [in(ttpk).pkAmp], '.');
            
          %  plot([in(tto).timcont]/3600, [in(tto).obwamp], 'o');
          
            
    ax(2) = subplot(312); title('divided by max'); hold on; %ylim([0,3]);
%
            plot([in(ttpk).timcont]/3600, [in(ttpk).pkAmp]/max([in(ttpk).pkAmp]), '.');
    
    ax(3) = subplot(313); title('light cycle'); hold on;
            plot([out.s.timcont]/3600, [out.s.light]);
            

linkaxes(ax, 'x');
